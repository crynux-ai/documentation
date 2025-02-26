---
description: Distribute models across the nodes
---

# Model Distribution

## Model Hosting Service

Crynux will offer model hosting within the Lithium Network. Developers can upload their models to the network, enabling Model-as-a-Service for applications and other developers.

Upon upload, the model is initially stored on a few nodes. Tasks requiring the model are randomly distributed among these nodes. As demand grows, additional nodes are selected to store the model, enhancing service capabilities. Conversely, if demand decreases, the model is removed from some nodes to save disk space.

## Model Download Cache

In the pre-Lithium network setup, the model required by a task is specified as a Huggingface or Civitai link in the task parameters. Upon task arrival on the node, if the model isn't already stored locally, the node needs to download it. This downloading process often takes a considerable amount of time, significantly reducing task execution speed and potentially causing task timeout.

The model distribution mechanism used in the hosting service is applied to solve this issue. When a task is initiated on the blockchain, it assesses overall demand and may notify certain nodes to download the model before selecting nodes to execute the tasks.

## Impact on the Network Consensus

The node to execute a task will only be selected from nodes with locally stored models, significantly limiting the number of candidates. This increases the risk of Sybil Attacks, especially for less popular models. To mitigate this risk, a relatively large number of nodes should be selected for a new model  initially.

In the Helium Network, when a task is initiated, 10 nodes are selected to implement a new model. If fewer than 3 nodes remain available for the model, the blockchain will notify 10 additional nodes to download the model.

## Built-in Model Storage V.S. External Decentralized Storage



## Proof of Storage
