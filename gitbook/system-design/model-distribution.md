---
description: Distribute models across the nodes
---

# Model Distribution

## Model Hosting Service

Crynux will offer model hosting within the Lithium Network. Developers can upload their models to the network, enabling Model-as-a-Service for applications and other developers.

Upon upload, the model is initially stored on a few nodes. Tasks requiring the model are randomly distributed among these nodes. As demand grows, additional nodes are selected to store the model, enhancing service capabilities. Conversely, if demand decreases, the model is removed from some nodes to save disk space.

## Model Download Cache

In the pre-Lithium network setup, the model required by a task is specified as a Huggingface or Civitai link in the task parameters. Upon task arrival on the node, if the model isn't already stored locally, the node needs to download it. This downloading process often takes a considerable amount of time, significantly reducing task execution speed and potentially causing task timeout.

Before model hosting is implemented, the model distribution mechanism has already been applied in the Helium Network to solve this issue. When a task is initiated on the blockchain, it assesses overall demand and may notify certain nodes to download the model, in addition to selecting nodes to execute the tasks.

## Impact on the Network Consensus

The node to execute a task will only be selected from nodes with locally stored models, significantly limiting the number of candidates. This increases the risk of Sybil Attacks, especially for less popular models. To mitigate this risk, a relatively large number of nodes should be selected for a new model  initially.

In the Helium Network, when a task is initiated, 10 nodes are selected to implement a new model. If fewer than 3 nodes remain available for the model, the blockchain will notify 10 additional nodes to download the model.

## Built-in Model Storage V.S. External Decentralized Storage

Instead of storing the models on individual nodes, another option is to use a decentralized storage service to hold the models. Nodes can then retrieve the models as needed.

However, downloading the model takes significantly more time than executing tasks, as seen with the Helium Network. This highlights the "data locality" concept in computer science, which suggests moving computation (code) to the data because data is usually larger than the code.

Integrating model storage into nodes fosters a robust environment where tasks can be executed swiftly and reliably, aligning with the decentralized ethos of the Crynux Network:

1. **Increased Speed**: With models stored directly on nodes, the time taken to retrieve and execute the model is significantly reduced. This direct access minimizes latency and boosts overall network efficiency.
2. **Enhanced Data Locality**: By housing models on the nodes where computation occurs, the Crynux Network leverages data locality principles, reducing the need to move large model files across the network.
3. **Improved Reliability**: Storing models across multiple nodes increases redundancy. In the event of node failures, models remain accessible, ensuring continuous operation without interruptions.
4. **Cost Efficiency**: Eliminating the need for external storage services reduces operational costs. This built-in approach streamlines resource allocation and optimizes expenditures.

## Proof of Storage

In decentralized storage networks, ensuring nodes adhere to protocol rules is crucial for maintaining integrity and fairness. However, a situation may arise where nodes do not comply with the rules for retrieving model files and falsely claim compliance to obtain rewards.

For example, Filecoin addresses this issue by employing a consensus protocol known as "[Proof of Spacetime](https://docs.filecoin.io/storage-providers/filecoin-economics/storage-proving)," which utilizes zero-knowledge proofs.

In the Crynux Network, verifying model file storage does not require additional proof. The integrity of the model file is confirmed when a node successfully executes a task and produces the same result as other nodes. If a node delivers accurate computation results, it is assumed to have the correct model files.

If the node downloads the model file only when a task arrives, execution speed will be slower. This can lead to a [QoS penalty](quality-of-service-qos.md), reducing the likelihood of receiving rewards and future tasks, and may eventually result in the node being removed from the network.
