---
description: Start a node to join the Hydrogen Network
---

# Join the Network

## Prerequisite

### Hardware Requirements

* NVIDIA GPU with at least **8GB of VRAM**.
* **16GB** of system memory.
* **60GB** of disk space.
* Public network access to Huggingface and Civitai.

### Software Requirements

* Linux or Windows 11 with [WSL 2 enabled](https://pureinfotech.com/install-wsl-windows-11/).
* Latest version of the [NVIDIA driver](https://www.nvidia.com/Download/index.aspx?lang=en-us) corresponding to your hardware.
* Latest version of [Docker](https://docs.docker.com/get-docker/).

### Token Requirements

{% hint style="info" %}
Hydrogen Network is deployed on an Ethereum compatible **private** Blockchain. **No real ETH and CNX tokens are used**. You could join the [Discord Server of Crynux](https://discord.gg/Ug2AHUbrrm) to get the test tokens using the faucet.
{% endhint %}

* the private key or keystore of an Ethereum wallet
* \~**0.1 ETH** Test Tokens
* **400 CNX** Test Tokens

### Docker / WSL Memory Limit

Make sure to adjust the default memory limit of Docker engine, either in the docker settings or in the WSL config file.

{% hint style="info" %}
If you are using WSL to start the Docker container, the default memory limit is set to be half of your physical memory. If you have 16GB of physical memory, then the memory limit for WSL is default to 8GB, which is not enough to run the Node. You will have to change the default settings using a [`.wslconfig`](https://learn.microsoft.com/en-us/answers/questions/1296124/how-to-increase-memory-and-cpu-limits-for-wsl2-win) file
{% endhint %}

## Start the node using Docker image

### Pull the Docker image from GitHub

### Start the Docker container

### Visit the WebUI in the browser

## Configure the wallet in the WebUI

## Control the node in the WebUI

&#x20;
