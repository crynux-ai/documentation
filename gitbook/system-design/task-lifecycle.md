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
    Participant N as Node

    A ->> B: Create Task
    activate B
    Note over A,B: Task ID Commitment<br/>Nonce<br/>Model ID<br/>Minimum VRAM<br/>Required GPU<br/>Task Fee

    break Task Fee == 0 or Nonce is not unique
        B -->> A: Tx reverted
    end
    
    B -->> A: Tx confirmed
    Note over A,B: Sampling Seed

    par Upload task parameters

        loop Until node is selected
            B ->> B: Select node
            
            break No available node
                B ->> B: Enqueue task
            end

            B ->> A: Event: TaskStarted
            activate A
            Note over A,B: Task ID Commitment<br />Selected Node
            deactivate B
            A ->> R: Upload task parameters
            activate R
            note over A,R: Encrypted Task Parameters
            deactivate A
            R ->> B: Update Merkle Root
            R -->> A: Return hash and Merkle proof
            activate A
            note over A,R: Hash of Encrypted Task Parameters<br/>Merkle Proof
            deactivate R
            A ->> B: Notify task parameters uploaded
            activate B
            note over A,B: Task ID Commitment<br/>Hash of Encrypted Task Parameters<br/>Merkle Proof
            deactivate A
            break Validation failed
                B -->> A: Validation failed
            end
            B ->> N: Event: TaskParametersUploaded
            note over B,N: Task ID Commitment<br/>Hash of Encrypted Task Parameters<br/>Selected Node
            deactivate B
        end

    and Send validation tasks
        activate A
        A ->> A: Generate Sampling Number<br/>Using VRF
        opt Last digit of the Sampling Number is 0
            loop Repeat 2 times
                A ->> B: Create task and upload the task parameters
                deactivate A
            end
        end    
    end
```

The application starts a task by signing a transaction, invoking the smart contract to create the task on the Blockchain.

The application must set the task fee it is willing to pay in the `value` field of the transaction.

The transaction might be reverted, due to several reasons:

* The transaction value is not set (task fee is not paid).
* The Nonce has already been used before.

If the transaction is confirmed, the application receives a `Sampling Seed`. The application then uses the VRF algorithm with this `Sampling Seed` to generate a `Sampling Number`. If the last digit of the `Sampling Number` is 0, the application should create two additional tasks to form a task validation group. The details of the task validation are described in the following document:

{% content-ref url="verifiable-secret-sampling.md" %}
[verifiable-secret-sampling.md](verifiable-secret-sampling.md)
{% endcontent-ref %}

For each of the tasks, the blockchain will attempt to locate a suitable node that is available to execute the task. If such a node is found, the task starts immediately. Otherwise, the task is added to the queue. When a new node becomes available, it will retrieve the task from the queue and begin execution. In both cases, the blockchain emits a `TaskStarted` event when the task begins, including the node's address.

Upon receiving the `TaskStarted` event, the application should encrypt the task parameters using the node's public key and send them to the DA/Relay. The DA/Relay will update the `Merkle Root` to the blockchain for validation, and return the `Merkle Proof` to the application.

The application sends the hash and `Merkle Proof` to the blockchain. The blockchain verifies the proof against the `Merkle Root` submitted by the DA/Relay, ensuring the `Task Parameters` are uploaded. It then emits the `TaskParametersUploaded` event to notify the node to start execution.

## Task Execution

```mermaid
sequenceDiagram
    Participant A as Application
    Participant B as Blockchain
    Participant N as Node
    Participant R as DA/Relay

    B ->> N: Event: TaskParametersUploaded
    Note over B,N: Task ID Commitment<br/>Hash of Encrypted Task Parameters<br/>Selected Node
    activate N
    N ->> R: Get task parameters
    activate R
    Note over N,R: Hash of Encrypted Task Parameters
    deactivate N
    
    R -->> N: Return the encrypted task parameters
    Note over N,R: Encrypted Task Parameters

    deactivate R
    activate N
    N ->> N: Execute the task locally

    break Task not executable
        N ->> B: Report task error
    end

    break Retrying exceeds timeout
        N ->> B: Abort task
        activate B
        B ->> A: Event: TaskAborted
        deactivate B
    end
    
    N ->> N: Calculate the similarity score
    N ->> B: Submit the score
    activate B
    Note over N,B: Task ID Commitment<br/>Sim Hash
    B ->> A: Event: TaskResultReady
    Note over A,B: Task ID Commitment<br/>Sim Hash
    deactivate B

    break Waiting exceeds timeout
        N ->> B: Abort task
        activate B
        B ->> A: Event: TaskAborted
        deactivate B
    end

    deactivate N

```

When the node receives the `TaskStarted` event, it will start to execute the task locally.

The execution starts by fetching the `Encrypted Task Parameters` from the DA/Relay. After the parameters are received, the node decrypts them using its own private key, and starts the execution.

The first step is to download the models. The node will check the local existence of the models specified in the `Task Parameters`. If the models are not cached locally, they will be downloaded from the network.

If there are network issues during the download, the node will retry the download several times until the timeout period is reached. The task will be cancelled by the node if the timeout is reached.

If the model download link is confirmed to be invalid, such as a 404 response from Civitai, the node will report error to the blockchain.

The task is then sent to the execution engine of the node. If the execution engine finds out that the task is misconfigured, such as an SDXL LoRA model combined with an SD1.5 base model, it will report the error to the blockchain.

{% hint style="info" %}
The error reporting will also be cross validated in a validation task group to prevent malicious behaviors from the nodes. If one of nodes reports error while the other two nodes send the normal computation result, it will be penalized.

If all the nodes report error, the task will be cancelled, the task fee will still be charged and distributed to the nodes.
{% endhint %}

When the task has finished execution successfully, the node has the final computation result such as the images. It will calculate the similarity hash of the result, and then submit it to the blockchain.

The blockchain will emit `TaskResultReady` event to the application, and wait for the application to perform the validation process.

The node will also wait for the task validation. If validation isn't completed within the timeout period, the node might abort the task to accept new ones instead of waiting indefinitely.

## Result Validation

```mermaid
sequenceDiagram
    Participant A as Application
    Participant B as Blockchain
    Participant N as Node

    B ->> A: Event: TaskResultReady
    activate A
    Note over A,B: Task ID Commitment<br />Sim Hash

    alt Validation not required
        A ->> B: Finish task
        activate B
        Note over A,B: Task ID Commitment<br/>Sampling Number<br/>VRF Proof
        deactivate A
        B ->> B: Validate Sampling Number
        break Validation failed
            B -->> A: Validation error 
        end
        B ->> N: Event: TaskValidated
        Note over B,N: Task ID Commitment
        deactivate B
    else
        activate A
        activate B
        A ->> A: Wait for other validation tasks
        B ->> A: Event: TaskResultReady
        Note over A,B: Task ID Commitment<br />Sim Hash
        A ->> A: Wait for other validation tasks
        B ->> A: Event: TaskResultReady
        Note over A,B: Task ID Commitment<br />Sim Hash
        deactivate B

        A ->> B: Finish task
        activate B
        Note over A,B: Task ID Commitment<br/>Task GUID<br/>Sampling Number<br/>VRF Proof<br/>Hash of Task Parameters<br/>ZK Proof
        deactivate A
        B ->> B: Validate task
        break Validation failed
            B -->> A: Validation error 
        end
        B ->> N: Event: TaskValidated
        Note over B,N: Task ID Commitment
        deactivate B
    end
    
```

Upon receiving the `TaskResultReady` event, the application's response varies based on the need for task validation:

### Task does not Require Validation

If the task does not require validation, the application should send the "Complete Task" transaction directly to the blockchain, including proofs of the `Sampling Number`.

The blockchain will then validate the proofs. If the validation passes, the blockchain will emit `TaskValidated` event to the node to notify it to disclose the actual computation result. The transaction will fail if the validation does not pass.

For more information on the validation process, please see the following document:

{% content-ref url="verifiable-secret-sampling.md" %}
[verifiable-secret-sampling.md](verifiable-secret-sampling.md)
{% endcontent-ref %}

### Task Requires Validation

If validation is required, the application should wait for the `TaskResultReady` event from the other two tasks in the validation group. Once all three tasks have submitted their similarity hashes, the application will disclose their relationship for blockchain validation.

There are more validations to be performed by the blockchain, comparing to the validation of tasks that do not require validation. For more information on the validation process, please see the following document:

{% content-ref url="verifiable-secret-sampling.md" %}
[verifiable-secret-sampling.md](verifiable-secret-sampling.md)
{% endcontent-ref %}

If the validation passes, the blockchain will emit `TaskValidated` event to all the three nodes. The transaction will fail if the validation does not pass.

## Result Retrieval

```mermaid
sequenceDiagram
    Participant A as Application
    Participant B as Blockchain
    Participant N as Node
    Participant D as DA/Relay

    B ->> N: Event: TaskValidated
    activate N
    Note over B,N: Task ID Commitment
    N ->> D: Send task result
    activate D
    Note over N,D: Task ID Commitment<br/>Encrypted Task Result
    deactivate N
    D -->> N: Return Merkle Proof
    activate N
    Note over N,D: Merkle Proof
    deactivate D
    N ->> B: Report result uploaded
    activate B
    Note over B,N: Task ID Commitment<br/>Merkle Proof<br/>ZK Proof
    deactivate N
    B ->> B: Validate proofs
    break Validation failed
        B -->> N: Validation failed
    end
    B ->> B: Settle task fee
    B ->> A: Event: TaskSuccess 
    activate A
    Note over A,B: Task ID Commitment
    deactivate B
    A ->> D: Get task result
    deactivate A
    activate D
    D -->> A: Return task result
    note over A,D: Encrypted Task Result
    deactivate D

```

Upon receiving the `TaskValidated` event, the node can upload the computation result to the DA/Relay service and obtain the task fee by proving to the blockchain that the upload was correct. The proving is implemented using ZKP, the details are described in the following section of the documentation:

{% content-ref url="verifiable-secret-sampling.md" %}
[verifiable-secret-sampling.md](verifiable-secret-sampling.md)
{% endcontent-ref %}

The computation result is encrypted with the application's public key before being sent to the DA/Relay, ensuring that only the application can decrypt and access the actual result.

Once the node submits the proofs to the blockchain, and they are verified, the blockchain will transfer the task fee to the node and emit a `TaskSuccess` event to the application. The application can then retrieve the computation result from the DA/Relay service, completing the task.
