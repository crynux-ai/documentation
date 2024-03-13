---
description: Decentralized AI Infrastructure for Everyone
---

# Crynux Network

Crynux is an open and democratic AI Infrastructure.

As the foundation layer, Crynux Network is composed of the decentralized nodes who contribute their spare AI computing power to the network in exchange for token rewards. The computing power is then grouped and dispatched to run the AI tasks from the developers and applications.

On top of the computing network, a decentralized model/dataset hosting service is provided to better support the various AI use cases.

The applications could easily connect to the Crynux Network using API, bring AI power to their users with no extra need for the hardware and development.

The developers could write codes to train/fine-tune their models on the dataset provided by the network, using the computing power of the network. The developed model could also be hosted on the network as a service for others.

By utilizing the Blockchain, Zero-knowledge Proofs and Privacy Preserving Computation technologies, Crynux aims to build a completely decentralized and trustworthy infrastructure that is always accessible to everyone.

## Helium Network

Helium Network is the latest testnet of the Crynux Network. Helium Network implements a decentralized AI task execution engine that supports running the Stable Diffusion image generation tasks and the GPT text generation tasks.

Although called a testnet, the featured consensus protocol is robust enough to allow everyone to join at this moment. Everyone has an Nvidia GPU, or Mac with the Apple Silicon chips (M1, M2 and M3 series), could have already joined the network by starting a Docker container.

### Stable Diffusion Image Generation

The applications could now send the Stable Diffusion image generation tasks to the network using the inference API, and get the images back instantly.

A showcase application has been developed to demonstrate the abilities. The app provides a web interface (just like [`stable-diffusion-webui`](https://github.com/AUTOMATIC1111/stable-diffusion-webui)) for the users to generate images in the browser. Thanks to the Hydrogen Network, the users could use the application on any devices that do not have a capable GPU integrated.

The Blockchain and token stuff are handled at the application backend using [Crynux Bridge](https://github.com/crynux-ai/crynux-bridge). To the end users, this is just a traditional easy-to-use web application, nothing special.

Give it a try at [https://ig.crynux.ai](https://ig.crynux.ai)

### GPT Text Generation

The applications could also execute the GPT text generation tasks using most of the LLM models on Huggingface, such as [LLaMa 2](https://huggingface.co/meta-llama/Llama-2-7b-chat-hf), using the inference API of the Helium Network.

A chatbot web application has been developed as an example for the developers. The web application provides a simple chat UI in the browser, and connects to the [Crynux Bridge](https://github.com/crynux-ai/crynux-bridge) at the backend to interact with the Crynux Network.

The chatbot can be accessed at [https://chat.crynux.ai](https://chat.crynux.ai)

To read more about the Helium Network release, go to the following page:

{% content-ref url="releases/helium-network.md" %}
[helium-network.md](releases/helium-network.md)
{% endcontent-ref %}

## Getting Started

To join the network as a node, contributing the local computation power, check the [tutorial on starting the Docker container](node-hosting/start-a-node-win-linux.md).

To use the inference API, connect your application to the Hydrogen Network, go to the[ application workflow.](application-development/application-workflow.md)

## Research

Checkout our latest research paper about Crynux Network here:

{% embed url="http://dx.doi.org/10.13140/RG.2.2.32697.54884" %}

## Links

Join the Crynux community on Discord:

{% embed url="https://discord.gg/Ug2AHUbrrm" %}

All the codes are open sourced at GitHub, feel free to submit issues and PRs:

{% @github-files/github-code-block url="https://github.com/crynux-ai" %}

The Crynux Blog contains the technical explanations and our latest progress:

{% embed url="https://blog.crynux.ai" %}

And follow us on Twitter:

{% embed url="https://twitter.com/crynuxai" fullWidth="true" %}
