# Network Architecture

The Hydrogen Network is illustrated in the graph below:

<figure><img src="../.gitbook/assets/hydrogen-architecture.png" alt=""><figcaption><p>The Hydrogen Network Architecture</p></figcaption></figure>

The core participants in the network are the **Nodes** and the **Applications**. The nodes provide computing power to the network, executing the Stable Diffusion image generation tasks from the applications, and receive tokens as the reward. The applications send the tasks to the nodes, paying with tokens, and get the images back.

Each of the nodes and the applications will start a **Blockchain node**, and communicate with each other using it. The Blockchain executes a consensus mechanism to make sure no one is cheating: the nodes could never use the fake images to get rewards, and the applications could never get the images without paying.

Beside the Blockchain, the nodes and applications will also communicate through the **Relay**, to send data such as the task arguments and images, which are not recorded on-chain, but can be verified using the data hash on-chain. The relay solves two problems: the data availability problem and the network reachability problem.&#x20;

## The Node

## The Application

## The Blockchain

## The Relay

