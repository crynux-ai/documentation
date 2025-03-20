---
description: How Crynux Network handles user data
---

# Privacy Policy

\[**Last Updated: 2025-03-20]**

This document outlines how Crynux Network handle data within the decentralized AI infrastructure that provides inference and training services for LLM (Large Language Models), Stable Diffusion, and other AI models.

Crynux Network is designed as a decentralized infrastructure with permissionless nodes. This policy explains how your data is handled within this architecture.

### 1. Who's Data is Involved

The Crynux Network involves two types of participants whose data may be processed:

#### 1.1 Applications

Applications are services, platforms, or tools that utilize the Crynux Network for AI processing. When applications use the network:

* Their task inputs (prompts, images, etc.) are temporarily processed by the network
* They receive task outputs from the network
* Basic task statistics (completion, success/failure) are recorded for network operation
* No application identity information is collected beyond the wallet addresses

#### 1.2 Nodes

Nodes are providers of computational resources that execute AI tasks within the network. For node operators:

* Node performance metrics are collected (task completion, success rates)
* Node earnings and economic activity are recorded
* All node data is associated only with blockchain wallet addresses
* The GPU model is recorded for task distribution
* No personal identifiers, geographical information, or other system details are collected

#### 1.3 Types of Data Processed

In summary, the Crynux Network processes the following types of data:

* **Task Inputs:** Text prompts, images, or other inputs that applications send to the network for processing
* **Task Outputs:** Generated images, text responses, or other outputs created by the network
* **Network Statistics:** Aggregated data about tasks, success rates, task numbers, and node earnings. These statistics are only associated with blockchain wallet addresses and contain no personally identifiable information such as IP addresses, location, country, or time zone

The network does NOT collect or store:

* User personal information (names, email addresses, etc.)
* IP addresses or location information from applications
* IP addresses or location information from nodes
* Geographical data (country, time zone, etc.)

### 2. Where the Data is Processed

The Crynux Network processes data across different components of its architecture:

#### 2.1 For Applications:

* Application data (prompts, images, etc.) is first sent to the Relay component
* The Relay then distributes this data to the selected Nodes for processing
* Results are returned from the Nodes to the Relay, and then back to the Application

#### 2.2 For Nodes:

* Node performance statistics and metrics are collected and stored by the Relay
* Node earnings and economic activity are recorded by the Relay

#### 2.3 Blockchain Data:

* Both Applications and Nodes have certain public data recorded on the blockchain
* This includes wallet addresses, task hashes, consensus data, and transaction information
* Node specifications (such as GPU model) are publicly recorded on the blockchain

### 3. How the Network Handle Your Data

The Crynux Network operates with the following data handling principles:

* **Temporary Storage:** Task inputs and outputs are stored only on the Relay during task execution
* **Automatic Deletion:** All data is deleted from the Relay after task completion
* **Decentralized Processing:** Tasks are distributed to permissionless Nodes for execution
* **Node Data Cleanup:** Temporary task data is deleted from the Nodes after task execution is complete
* **Limited Analytics Collection:** The Relay collects network statistics such as total tasks, success rates, task numbers, and node earnings. These statistics are only associated with blockchain wallet addresses and contain no personally identifiable information such as IP addresses, location, country, or time zone

### 4. Data Storage Limitations

Our official implementation of the Crynux Node is designed to process task data without persistent storage. However, as a decentralized and permissionless network, we cannot technically prevent third-party node implementations from storing data processed during task execution.

Applications using the Crynux Network should be aware that while we provide guidelines and implementations that respect privacy, we cannot guarantee the behavior of all nodes in the network.

### 5. Blockchain Data

The Crynux Network uses blockchain technology to coordinate tasks and execute the consensus protocol. Information recorded on the blockchain is public and immutable, but is limited to:

* Task identifiers (hashes)
* Node participation information
* Consensus-related data (such as p-hash of images)

The actual content of tasks (prompts, images, etc.) is not stored on the blockchain.

### 6. Changes to This Policy

We may update this Privacy Policy from time to time. We will notify users of any changes by updating the "Last Updated" date at the top of this policy.
