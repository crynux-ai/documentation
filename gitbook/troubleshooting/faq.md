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

<summary>Can I start a node on multiple GPUs</summary>

No. The node can execute one task on one GPU at the same time. If you have Multiple GPUs, you can start multiple nodes on the device, and assign the GPUs to different nodes.

</details>

<details>

<summary>Can I use the same wallet on multiple node instances</summary>

No you can't do it.

The same wallet can only get one task from the network at the same time. If multiple nodes are started with the same wallet, they will be executing the same task at the same time, and the nodes who submit the result later will just fail.

After the hot/cold wallet architecture is implemented, [as described in this doc](../node-hosting/private-key-security.md), it can also be used to easily collect funds from multiple nodes to a single cold wallet.

</details>

<details>

<summary>Can I use AMD Radeon cards to run a node</summary>

Nope. The AMD GPUs are not supported at this moment. Only Nvidia GPU and Apple M1/M2/M3 are supported.

We will add support for AMD GPUs in a future release.

</details>

## Node is not Working as Expected

<details>

<summary>The node status shows <code>Stopped</code> after running for a while</summary>

If there is no other error messages shown, the node is probably kicked out of the network due to frequent timeout on tasks.

If the node has a slow GPU, or poor network, the task submission will be slow. If the time required to finish a task exceeds the timeout period, other nodes will abort the task since they do not want to waste more time on the waiting.

More timeout on the tasks will decrease the QoS score of the timeout node, which will eventually cause the node being kicked out of the network. It is not a slashing though, the staked tokens are still safe. The details can be found in the doc:

[Quality of Service (QoS)](../system-design/quality-of-service-qos.md)

</details>

<details>

<summary>Node error: Node manager init error: prefetch failed</summary>

"Prefetch" means to download all the popular models from Huggingface before task execution. Prefetch failure can only happen when the download is interrupted.

Make sure you could connect to Huggingface on the device running the node. If you are using a proxy, please provide the proxy config to the node according to the doc:

[Proxy Settings](../node-hosting/proxy-settings.md)

</details>

<details>

<summary>Failed to execute script 'main' ... 5 validation errors for Config</summary>

If the following popup shows when starting the node on Windows:

<img src="../.gitbook/assets/image (1).png" alt="" data-size="original">

Please check your anti-virus software for deletion or quarantine of the files of the Node. The config file might have be deleted.

</details>
