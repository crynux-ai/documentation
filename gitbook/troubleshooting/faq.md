# FAQ

## Node Starting Questions

<details>

<summary>Where to get the test CNX tokens</summary>

Starting from v2.0.5, the test CNX tokens will be transferred to the wallet automatically when a new wallet is created or pasted into the Crynux Node. Just wait a minute or two for the token transfer.&#x20;

In case something goes wrong, go to the Discord server to ask for help:

[https://discord.gg/y8YKxb7uZk](https://discord.gg/y8YKxb7uZk)

</details>

<details>

<summary>Can I start multiple node instances on a single GPU</summary>

No one can stop you doing that.

If your GPU is powerful enough, the bottleneck becomes the consensus process (you will be waiting for other nodes to submit results), in such cases you could start multiple nodes to fully utilize the power of the GPU.

However, if your nodes are executing too many tasks simultaneously, the submission of each task will become slower (due to the bottleneck on GPU or network bandwidth), and there will be less tokens you can earn from a single task. Further more, slower tasks will increase the chance of task timeout, which will cause the node being kicked out of the network. It is not a slashing though, the staked tokens are still safe. The details can be found in the doc:

[Quality of Service (QoS)](../system-design/quality-of-service-qos.md)

Meanwhile, we are developing the new feature to support the concurrent task execution on powerful GPUs and multiple GPUs, which will fully utilize the local capabilities.

</details>

<details>

<summary>Can I use the same wallet on multiple node instances</summary>

No you can't do it.

The same wallet can only get one task from the network at the same time. If multiple nodes are started with the same wallet, they will be executing the same task at the same time, and the nodes who submit the result later will just fail.

After the hot/cold wallet architecture is implemented, [as described in this doc](../node-hosting/private-key-security.md), it can also be used to easily collect funds from multiple nodes to a single cold wallet.

</details>

## Node is not Working as Expected
