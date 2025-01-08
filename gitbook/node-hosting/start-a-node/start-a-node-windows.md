---
description: Start a node to join the Crynux Network on Windows
---

# Start a Node - Windows

## 0. Overview

* ~~Fill a form to tell us your GPU type, location, network bandwidth~~ \[<mark style="color:blue;">**No application form, no sign up, you don’t need to tell us**</mark>]
* ~~Join waitlist and wait for the email from us~~ \[<mark style="color:blue;">**No waitlist, just install the Crynux Node app, you can start earning CNX tokens right away**</mark>]
* Follow the steps below:

## 1. Prerequisite

Before you start, make sure your device meets the following requirements:

<table><thead><tr><th width="187">Hardware</th><th>Requirements</th></tr></thead><tbody><tr><td>GPU</td><td>NVIDIA GPU with 8GB VRAM</td></tr><tr><td>Memory</td><td>16GB</td></tr><tr><td>Disk Space</td><td>60GB</td></tr><tr><td>Network</td><td>Public network access to Huggingface and Civitai</td></tr></tbody></table>

## 2. Install the software

### Install the latest NVIDIA driver

Make sure you have already installed the latest NVIDIA driver from the [NVIDIA official website](https://www.nvidia.com/Download/index.aspx?lang=en-us).

### Download the Crynux Node

Download the binary release version of the Crynux Node from the link below:

{% embed url="https://drive.google.com/file/d/1MVZEWiu7oa1xTAVYr3LIHUHQmKcApR_w/view?usp=drivesdk" %}

{% hint style="info" %}
Starting a node on Windows using the binary release package, as described here, is still in **beta testing**. If you have trouble running the downloaded package, please use [the Docker version](start-a-node-docker.md) instead.
{% endhint %}

## 3. Start the node

Unzip the downloaded package, double-click on the `Crynux Node.exe` to start the node:

<figure><img src="../../.gitbook/assets/Screenshot 2024-04-10 092150.png" alt=""><figcaption></figcaption></figure>

## 4. Prepare the wallet

A wallet with enough test tokens must be provided to the node. If this is the first time you start a node, click the "Create New Wallet" button and follow the instructions to create a new wallet and finish the backup of the private keys.

<figure><img src="../../.gitbook/assets/Screenshot 2024-04-10 092216.png" alt=""><figcaption></figcaption></figure>

### Get the test CNX tokens from the Discord Server

Some test CNX tokens are required to start the node. The test CNX tokens can be acquired for free in the Discord server of Crynux:

{% embed url="https://discord.gg/y8YKxb7uZk" %}

In the `happy-aigen-discussions` channel of the Discord server, type in the following command in the input bar, **DO NOT copy & paste the command, it only works when typed in using keyboard**:

```
/user join
```

Then bind the wallet address using the following command:

```
/node wallet {wallet_address}
```

Remember to replace `{wallet_address}` with the wallet address you just created in the Web UI.

<figure><img src="../../.gitbook/assets/f8d5a672e0b753ad9f6ce99ff85a0fb.png" alt=""><figcaption></figcaption></figure>

After a short while, the test CNX tokens should appear in your node wallet:

<figure><img src="../../.gitbook/assets/Screenshot 2024-04-10 093004.png" alt=""><figcaption></figcaption></figure>

## 5. Wait for the system initialization to finish

If this is the first time you start a node, it could take quite a long while for the system to initialize. The most time consuming step is to download \~40GB of the commonly used model files from the Huggingface. The time may vary depending on your network speed.

After the models are downloaded, a test image generation task will be executed locally to examine the capability of your device. If the device is not capable to generate images, or the generation speed is too slow, the node will not be able to join the network. If the task is finished successfully, the initialization is completed:

<figure><img src="../../.gitbook/assets/Screenshot 2024-04-10 093116.png" alt=""><figcaption></figcaption></figure>

## 6. Join the Crynux Network

The Crynux Node will try to join the network automatically every time it is started. After the transaction is confirmed on-chain, the node has successfully joined the network. When the node is selected by the network to execute a task, the task will start automatically, and the tokens will be transferred to the node wallet after the task is finished.

<figure><img src="../../.gitbook/assets/Screenshot 2024-04-10 093051.png" alt=""><figcaption></figcaption></figure>

Now you could just leave it there to execute the tasks. When you shutdown the Crynux Node app, it will try to quit the network before exiting, so that new tasks will not be sent to the node any more. And the next time the app is started, it will join the network to receive new tasks automatically.
