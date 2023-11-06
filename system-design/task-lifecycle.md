---
description: From the task creation to the task success
---

# Task Lifecycle

The task is firstly created on the Blockchain, by the application. The Blockchain dispatches the task to 3 randomly selected nodes. The nodes execute the task, and report the results to the Blockchain. The Blockchain validates the results, if correct, pays tokens to the nodes. After the images are uploaded to the Relay, the task is finished.

The node joins the Hydrogen Network by staking certain amount of tokens. After the staking, the node will be in the candidate list to be selected by the Blockchain.

The task lifecycle could be divided into 3 parts:

## Task Creation

<figure><img src="../.gitbook/assets/8f55d035421c2914b4de11af5f9ca1a.png" alt=""><figcaption><p>The Sequential Graph of Task Creation</p></figcaption></figure>

The task creation is initiated by the application. The application signs a transaction, invoking the smart contract to create the task on the Blockchain.

The transaction might be reverted, due to several reasons:

* Not enough CNX tokens left in the application's wallet.
* Not enough CNX allowance left for the task contract to spend.
* Not enough nodes available in the network.

The Blockchain will transfer the required amount of CNX tokens from the application's wallet to the address of the task contract, which will be paid to the nodes, by the Blockchain, if the task is completed successfully.

The Blockchain then randomly selects 3 available nodes to execute the task. The transaction is completed with 3 emitted events to notify the selected nodes.

The application will upload the task arguments to the relay when the transaction is confirmed. The relay will allow the uploading only when it receives the task created event from the Blockchain, the application might have to wait for a short period before the uploading can be successful.

After the task arguments are uploaded to the relay, the task creation process is completed.

## Task Execution



## Result Retrieval
