# VRF Task Sampling

## Task Creation

<figure><img src="../.gitbook/assets/bc14108f59f8164136fdd0d9cdf344e.png" alt=""><figcaption></figcaption></figure>

### Secret Selection of Tasks

The sampling process begins when the application sends a task to the blockchain. Upon receiving the task, the blockchain:

1. Generates a random number to be used as the `Sampling Seed` for the VRF.
2. &#x20;Randomly selects a qualified node to execute the task.

The application uses VRF locally to generate the `Sampling Number`, giving the `Sampling Seed` and its own private key as the VRF inputs.

With a 10% sampling probability, we could select the tasks for validation if their `Sampling Number` ends in 0.

{% hint style="info" %}
The `Sampling Number` is only known to the application, since no one else knows the private key.

The application can not cheat on the `Sampling Number` either, since the `Sampling Seed` is fixed on the blockchain, and the public key of the application is fixed prior to the task, and is known to the blockchain.
{% endhint %}

### Uploading Task Params to the DA/Relay

Knowing the node to execute the task, the application will encrypt the task params, such as the prompt and image sizes, using the public key of the node, and send the encrypted params to the DA/Relay service.

The task params could only be decrypted by the selected node. Neither could a node decrypt the params of other tasks, there is no chance a node could find out whether a task will be validated by comparing the task params.

{% hint style="info" %}
The DA/Relay will periodically update its Merkle Root to the blockchain, the smart contracts could then use it to validate the integrity of certain data on chain.&#x20;

Crynux will use the Merkle Root, together with Zero-Knowledge Proofs to validate the task params and task results. More on this later.
{% endhint %}

### Sending the validation tasks

