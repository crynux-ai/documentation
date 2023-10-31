---
description: Start a node to join the Hydrogen Network
---

# Join the Network

## 1. Prerequisite

### a. Hardware Requirements

<table><thead><tr><th width="187">Hardware</th><th>Requirements</th></tr></thead><tbody><tr><td>GPU</td><td>NVIDIA GPU with 8GB VRAM</td></tr><tr><td>Memory</td><td>16GB</td></tr><tr><td>Disk Space</td><td>60GB</td></tr><tr><td>Network</td><td>Public network access to Huggingface and Civitai</td></tr></tbody></table>

### b. Software Requirements

* Linux or Windows 11 with [WSL 2 enabled](https://pureinfotech.com/install-wsl-windows-11/).
* Latest version of the [NVIDIA driver](https://www.nvidia.com/Download/index.aspx?lang=en-us) corresponding to your hardware.
* Latest version of [Docker](https://docs.docker.com/get-docker/).

<details>

<summary>If you have 16GB of memory and use Docker with WSL2 on Windows</summary>

The memory limit for WSL is default to 8GB, which is not enough to run the Node. You will have to change the default settings using a [`.wslconfig`](https://learn.microsoft.com/en-us/answers/questions/1296124/how-to-increase-memory-and-cpu-limits-for-wsl2-win) file

</details>

### c. Token Requirements

{% hint style="info" %}
Hydrogen Network is deployed on an Ethereum compatible **private** Blockchain. **No real ETH and CNX tokens are used**. You could join the [Discord Server of Crynux](https://discord.gg/Ug2AHUbrrm) to get the test tokens using the faucet.
{% endhint %}

* the private key or keystore of an Ethereum wallet
* \~**0.1 ETH** Test Tokens
* **400 CNX** Test Tokens

## 2. Start the node using Docker image

### a. Pull the Docker image from GitHub

```sh
docker pull ghcr.io/crynux-ai/h-node:latest
```

### b. Start the Docker container

```sh
docker run -d -p 127.0.0.1:7412:7412 --gpus all ghcr.io/crynux-ai/h-node:latest
```

The port `7412` is exposed for the WebUI. And GPUs must be provided to the container.

### c. Visit the WebUI in the browser

Open the browser and go to [http://localhost:7412](http://localhost:7412)

## 3. Configure the wallet in the WebUI

## 4. Control the node in the WebUI

&#x20;
