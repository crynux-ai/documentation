---
description: Reduce the Task Validation Overhead
---

# VRF Task Sampling

## Task Creation

<figure><img src="../.gitbook/assets/2ebea41961ea30e6c0ceca38448f724.png" alt=""><figcaption></figcaption></figure>

### Secret Selection of Validation Tasks

The sampling process begins when the application sends a task to the blockchain. Upon receiving the task, the blockchain:

1. Generates a random number to be used as the `Sampling Seed` for the VRF.
2. &#x20;Randomly selects a qualified node to execute the task.

The application uses VRF locally to generate the `Sampling Number`, giving the `Sampling Seed` and its own private key as the VRF inputs.

With a 10% sampling probability, we could select the tasks for validation if their `Sampling Number` ends in 0.

The `Sampling Number` is only known to the application, since no one else knows the private key.

The application can not cheat on the `Sampling Number` either, since the `Sampling Seed` is fixed on the blockchain, and the public key of the application is fixed prior to the task, and is known to the blockchain.

### Uploading Task Parameters to the DA/Relay

Knowing which node will execute the task, the application encrypts the task parameters, like the prompt and image size, using the node's public key. It then sends the encrypted parameters to the DA/Relay service.

The task parameters can only be decrypted by the assigned node. Nodes cannot decrypt the parameters of other tasks, making it impossible to determine if a task will be validated by comparing task parameters.

{% hint style="info" %}
The DA/Relay will periodically update its Merkle Root on the blockchain. Smart contracts can then use this to validate the integrity of specific off-chain data.

Crynux will leverage the Merkle Root and Zero-Knowledge Proofs to validate task parameters and results. More details will follow.
{% endhint %}

### Sending the Validation Tasks

If the task is not selected for validation, the application will simply stop and await the computing results. However, if the task is selected, the application must send two additional tasks with the same parameters for validation purposes.

{% hint style="info" %}
The application will not get the computing result if the following validation tasks are not submitted or if they are submitted with inconsistent parameters. More details are provided in the next section.
{% endhint %}

The Task ID for each task is obscured by generating a `Task ID Commitment`. This commitment is a hash of the real task ID combined with a random number. For three tasks, each `Task ID Commitment` is derived from the same task ID but uses different random numbers, making them appear unrelated in public data. After execution, the application can reveal the real task ID on the blockchain so that the blockchain can find the related tasks and compare the results.

## Tasks Require Validation

<figure><img src="../.gitbook/assets/c57bb3f5b043e3fd5b96afa3f5386b7.png" alt=""><figcaption></figcaption></figure>

### Task Execution

Upon receiving a task from the blockchain, the node retrieves the task parameters from the DA/Relay service, decrypts them, and executes the task on the local GPU.

After the computation is finished, the node will calculate the `SimHash` of the result, and send the `SimHash` to the blockchain. Then the node should wait for a future notification from the blockchain. If the wait exceeds the timeout period, the node may abort the task. The task fee will then be refunded to the application.

The node cannot send the task result to the DA/Relay service at this stage. If the result is transmitted, the application could retrieve it prematurely and disrupt subsequent processes. The blockchain lacks mechanisms to identify and penalize the application in such scenarios.

### Task Validation On-Chain

The application will wait for the submission of all the 3 `SimHash` on the blockchain, and then disclose the relationship of the tasks, and the relevant proofs for the blockchain to validate:

#### Sampling Number Validation

#### Task Relationship Validation

#### Task Parameters Validation

#### Task Result Validation

### Task Result Disclosure

## Tasks Do Not Require Validation
