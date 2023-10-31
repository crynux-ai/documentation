---
description: Connect the application to the Hydrogen Network
---

# Application Workflow

The Application could use the Hydrogen Network as an API service. The application sends the Stable Diffusion image generation task to the network, and get the result images back.

The application will be talking to 2 components in the Network: a Blockchain node, and the Relay.

The task is created on the Blockchain first. In order to create the task on-chain, the application must have a wallet filled with enough CNX tokens to pay for the task execution, and a little bit of ETH to pay the gas fee.

After the wallet is well prepared, the application could start the workflow by invoking the `CreateTask` method of the smart contract using the prepared wallet.

The workflow is illustrated in the sequential graph below:



## Prepare the Application Wallet

The wallet must have approved the "Task Contract" of the Hydrogen Network to spend the CNX tokens.

## Send the Stable Diffusion Task

## Wait for the Task to Finish

## Fetch the Images

