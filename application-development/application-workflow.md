---
description: Connect the application to the Hydrogen Network
---

# Application Workflow

The Application could use the Hydrogen Network as an API service. The application sends the Stable Diffusion image generation task to the network, and get the result images back.

The application will be talking to 2 components in the Network: a Blockchain node, and the Relay.

The task is created on the Blockchain first. In order to create the task on-chain, the application must have a wallet filled with enough CNX tokens to pay for the task execution, and a little bit of ETH to pay the gas fee.

The high level workflow is illustrated in the sequential graph below:

<figure><img src="../.gitbook/assets/323730c0a33886b4f03a611b937c17c.png" alt=""><figcaption><p>Sequential Graph of the Application Workflow</p></figcaption></figure>

The application starts the workflow by invoking the `CreateTask` method of the smart contract using the prepared wallet. The hash of the task arguments is passed to the method, which is used by the Nodes to verify the actual task arguments received from the Relay.

The smart contract transfers the required amount of the CNX tokens from the application wallet to its own address. The tokens will be transferred to the Nodes after the task is completed, and will be returned to the application wallet if the task is not completed successfully.

The smart contract then selects 3 nodes randomly, and emits 3 `TaskCreated` events (each one with a different node address as the argument) to notify the nodes.

After the transaction is confirmed on-chain, the application sends the actual task arguments to the Relay. The task arguments will be fetched by the selected Nodes, and the task will be started on the Nodes.

From the application's perspective, it just waits for the `TaskSuccess` event from the Blockchain. When the event arrives, the application could get the images from the Relay, and the task workflow is completed.

## Prepare the Application Wallet



The wallet must have approved the "Task Contract" of the Hydrogen Network to spend the CNX tokens.

## Create the Stable Diffusion Task on the Blockchain

## Upload the Task Arguments to the Relay

## Wait for the Task to Finish

## Fetch the Images from the Relay

