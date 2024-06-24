---
description: From the task creation to the task success
---

# Task Lifecycle

## Overview

The task is initiated by the application. The details of the task, such as the prompt and the image sizes in the Stable Diffusion image generation, are all included in the `Task Parameters`.&#x20;

The `Task Parameters` are not sent to the blockchain due to size constraints. Instead, the application sends the task's consensus-related metadata to the blockchain to create the task. Once the task is dispatched to a node, the application encrypts the `Task Parameters` using the node's public key and sends them to the DA/relay.

To ensure successful cross-validation for the nodes, the blockchain may require the application to send two additional tasks with identical `Task Parameters`. The application will be unable to obtain the computation results if the additional tasks are not sent.

## Task Creation

```mermaid
sequenceDiagram
    Participant A as Application
    Participant B as Blockchain
    Participant R as DA/Relay

    A ->> B: Create Task
    activate B
    Note over A,B: Task ID Commitment<br/>Nonce<br/>Model ID<br/>Minimum VRAM<br/>Required GPU<br/>Task Parameters Hash<br/>Task Fee
    alt Task Fee == 0 or Nonce is not unique
        B -->> A: Tx Reverted
    else
        B -->> A: Tx Confirmed
        Note over A,B: Sampling Seed
        activate A
        A ->> A: Generate Sampling Number<br/>Using VRF
        opt Validation required
            loop Repeat 2 times
                A ->> B: Create Task
                deactivate A
            end
        end
        loop When TaskStarted event is received
            B ->> A: Event: TaskStarted
            deactivate B
            activate A
            Note over A,B: Task ID Commitment<br/>Selected Node
            loop Until success
                A ->> R: Send encrypted task parameters
                Note over A,R: Task ID Commitment<br/>Encrypted Task Parameters
                deactivate A
                activate R
                alt Task is ready on the Relay
                    R -->> A: Success
                else
                    R -->> A: Task not ready
                end
                deactivate R
            end
        end
    end
```

The application starts a task by signing a transaction, invoking the smart contract to create the task on the Blockchain.

The application must set the task fee it is willing to pay in the `value` field of the transaction.

The transaction might be reverted, due to several reasons:

* The transaction value is not set (task fee is not paid).
* The Nonce has already been used before.

For each of the tasks, the blockchain will attempt to locate a suitable node that is available to execute the task. If such a node is found, the task starts immediately. Otherwise, the task is added to the queue. When a new node becomes available, it will retrieve the task from the queue and begin execution. In both cases, the blockchain emits a `TaskStarted` event when the task begins, including the node's address.

Upon receiving the `TaskStarted` event, the application should encrypt the task parameters using the node's public key and send them to the DA/relay.

The relay permits uploading only upon receiving the `TaskStarted` event from the blockchain. The application might need to wait briefly for the upload to succeed. After the task arguments are uploaded to the relay, the task creation process is completed.

## Task Execution

```mermaid
sequenceDiagram
    Participant B as Blockchain
    Participant N as Node
    Participant R as DA/Relay

    B ->> N: Event: TaskCreated
    activate N
    N ->> R: Get task parameters
    Note over N,R: Task ID Commitment
    deactivate N
    activate R

    alt Task parameters not uploaded
        R -->> N: Error: task not ready
    else
        R -->> N: Send task parameters
        Note over N,R: Task Parameters
    end
    deactivate R
```

<figure><img src="../.gitbook/assets/b1d94c1193739faf6f29711eda1ec92.png" alt=""><figcaption><p>The Sequential Graph of Task Execution</p></figcaption></figure>

When the node receives the `TaskCreated` event, it will start to execute the task locally.

The execution starts by fetching the task arguments from the relay. The node will check the local existence of the models specified in the task arguments. If the models are not cached locally, they will be downloaded.

If the model download link or the Huggingface ID is **confirmed** to be invalid, such as a 404 response from Civitai, the node will report error to the Blockchain. If there are network issues during the download, the node will retry the download several times until the timeout period is reached. The task will be cancelled by the node if the timeout is reached.

The task is then sent to the execution engine. If the execution engine finds out that the task is misconfigured, such as an SDXL LoRA model combined with an SD1.5 base model, it will report the error to the Blockchain.

When the task has finished successfully, the node has the result images. It will calculate the pHash of the images, and then goes into a 2-phase result disclosure process to disclose the pHashes on the Blockchain.

The reason for this process is explained in the consensus protocol:

{% content-ref url="consensus-protocol.md" %}
[consensus-protocol.md](consensus-protocol.md)
{% endcontent-ref %}

The disclosure process for a node starts by submitting a hash of the combination of the pHash and a random number, and then disclosing the actual pHash to the Blockchain after receiving the `CommitmentsReady` events from the Blockchain, which will only be emitted when the Blockchain receives all the 3 commitments.

The Blockchain compares the pHashes from all the 3 nodes to determine whether the result is correct, and whether the nodes are cheating.

If one of the node have submitted a different pHash (the hamming distance is larger than a threshold) than the others, the node will be slashed. The staked tokens will be transferred to the incentivization pool, and the node will be kicked out of the network. But as long as there are two nodes that have submitted the same pHash, the task is a success to the Blockchain as well as to the applications. If all the 3 pHashes are different, the task is aborted with a `TaskAborted` event emitted.

The `TaskSuccess` event will be emitted to notify the relevant parties to continue the next steps.

Below is a state transition graph to list all the possible state of the task and the nodes:

<figure><img src="../.gitbook/assets/image.png" alt=""><figcaption><p>Task State Transition Graph</p></figcaption></figure>

The orange color indicates all the possible states and transitions of the task containing reported errors. The single-letter tag with blue background on the transition line indicates an emitted event.

&#x20;The `TaskSuccess` event selects one of the nodes to upload the images to the relay. The selected node, after receiving the `TaskSuccess` event, will upload the images to the relay, and then report to the Blockchain that the images have been uploaded. The Blockchain will mark the task as completed then, the state storage for the task on-chain will be cleared.

## Result Retrieval

<figure><img src="../.gitbook/assets/ce7d4b2201ae738da60128e058f5a1c.png" alt=""><figcaption><p>The Sequential Graph of Result Retrieval</p></figcaption></figure>

The application will monitor the Blockchain for the events, after the initial creation of the task on-chain. If the `TaskSuccess` event is received, the application could get the images from the relay.

{% hint style="info" %}
Since the images are uploaded by the node after the node receives the `TaskSuccess` event as well, there is a short delay between the event has been emitted and the images have been uploaded. Before the images are uploaded, the relay will return `400 File not found` to the application. The application should take it into consideration.&#x20;
{% endhint %}

If the `TaskAborted` event is received, the application could receive the abort reason as the argument in the event. The application will have to retry the task if needed.
