---
description: The Real Decentralized AI you can Join and Use
---

# Crynux Network

Crynux is the truly permissionless AI infrastructure everyone can join and use right away.

The key component of Crynux is a robust consensus protocol that enables the permissionless joining and using of the decentralized network by millions. The ability to identify and penalize all the malicious behaviors ensures the ecosystem's sustainability and facilitates healthy growth in a long term.

As the foundation layer, Crynux Network is composed of the decentralized nodes who contribute their spare AI computing power to the network in exchange for token rewards. The computing power is then grouped and dispatched to run the AI tasks from the developers and applications.

On top of the computing network, a decentralized model/dataset hosting service is provided to better support the various AI use cases.

The applications could easily connect to the Crynux Network using API, use Crynux Network to generate images or texts, and bring AI power to their users with no extra need for the hardware and development.

The developers could write codes to train/fine-tune their models on the dataset provided by the network, using the computing power of the network. The developed model could also be hosted on the network as a service for others.

By utilizing the Blockchain, Zero-knowledge Proofs and Privacy Preserving Computation technologies, Crynux aims to build a completely decentralized and trustless infrastructure that is always accessible to everyone.

## Helium Network

Helium Network is the latest testnet of the Crynux Network. Helium Network implements a decentralized AI task execution engine that supports running the Stable Diffusion image generation tasks and the GPT text generation tasks.

Although called a testnet, the featured consensus protocol is robust enough to allow everyone to join at this moment. Everyone has an Nvidia GPU, or Mac with the Apple Silicon chips (M1, M2 and M3 series), could have already joined the network using our node software.

### Stable Diffusion Image Generation

The applications could now send the Stable Diffusion image generation tasks to the network using the inference API, and get the images back instantly.

A showcase application has been developed to demonstrate the abilities. The app provides a web interface (just like [`stable-diffusion-webui`](https://github.com/AUTOMATIC1111/stable-diffusion-webui)) for the users to generate images in the browser. Thanks to the Helium Network, the users could use the application on any devices that do not have a capable GPU integrated.

The complexity of the blockchain and tokens are taken care of at the backend using [Crynux Bridge](https://github.com/crynux-ai/crynux-bridge). To the end users, this is just a traditional easy-to-use web application, nothing special.

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

### Start a Node

1. ~~Fill a form to tell us your GPU type, location, network bandwidth~~ \[<mark style="color:blue;">**No application form, no sign up, you don’t need to tell us**</mark>]
2. ~~Join waitlist and wait for the email from us~~ \[<mark style="color:blue;">**No waitlist, just install the Crynux Node app, you can start earning CNX tokens right away**</mark>]
3. Just download the package according to your platform, and follow the tutorials below:

<table>
    <thead>
        <tr>
            <th width="131">Platform</th>
            <th width="261">Requirements</th>
            <th data-type="content-ref">Download Link</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Windows</td>
            <td>Nvidia GPU with 8GB VRAM</td>
            <td>
                <a href="https://drive.google.com/uc?id=1gq6z_v_FRdKx29jxjLayO1edkkTSM5O4&export=download">crynux-node-helium-v2.0.5-windows-x64.zip</a>
            </td>
        </tr>
        <tr>
            <td>Mac</td>
            <td>M1/M2/M3 and later</td>
            <td>
                <a href="https://github.com/crynux-ai/crynux-node/releases/download/v2.0.5/crynux-node-helium-v2.0.5-mac-arm64-signed.dmg">crynux-node-helium-v2.0.5-mac-arm64-signed.dmg</a>
            </td>
        </tr>
        <tr>
            <td>Linux</td>
            <td>Nvidia GPU with 8GB VRAM</td>
            <td>
                <a href="https://drive.google.com/uc?id=1LwBV5hDP-0URMKsrswgeirh1ByFIVgZB&export=download">crynux-node-helium-v2.0.5-linux-bin-x64.tar.gz</a>
            </td>
        </tr>
        <tr>
            <td>Docker</td>
            <td>Nvidia GPU with 8GB VRAM</td>
            <td>
                {% content-ref url="node-hosting/start-a-node-docker.md" %}
                [start-a-node-docker.md](node-hosting/start-a-node-docker.md)
                {% endcontent-ref %}
            </td>
        </tr>
    </tbody>
</table>

To start a node on your Windows computer:

{% content-ref url="node-hosting/start-a-node-windows.md" %}
[start-a-node-windows.md](node-hosting/start-a-node-windows.md)
{% endcontent-ref %}

If you are using Mac with Apple Silicon Chips (M1/M2/M3 and later):

{% content-ref url="node-hosting/start-a-node-mac.md" %}
[start-a-node-mac.md](node-hosting/start-a-node-mac.md)
{% endcontent-ref %}

To start a node on Linux (such as Ubuntu):

{% content-ref url="node-hosting/start-a-node-linux.md" %}
[start-a-node-linux.md](node-hosting/start-a-node-linux.md)
{% endcontent-ref %}

You could also start the node on the cloud services using Docker, such as Vast.ai:

{% content-ref url="node-hosting/start-a-node-vast.md" %}
[start-a-node-vast.md](node-hosting/start-a-node-vast.md)
{% endcontent-ref %}

On other systems, you could start the node using Docker:

{% content-ref url="node-hosting/start-a-node-docker.md" %}
[start-a-node-docker.md](node-hosting/start-a-node-docker.md)
{% endcontent-ref %}

### Develop an application

If you are an application developer who want to utilize the AI abilities provided by the Crynux Network, follow the tutorial below:

{% content-ref url="application-development/application-workflow.md" %}
[application-workflow.md](application-development/application-workflow.md)
{% endcontent-ref %}

## Research

Checkout our latest research paper about Crynux Network here:

{% embed url="https://www.researchgate.net/publication/380564678_A_Review_on_Decentralized_Artificial_Intelligence_in_the_Era_of_Large_Models" %}

{% embed url="https://www.researchgate.net/publication/377567611_Crynux_Hydrogen_Network_H-Net_Decentralized_AI_Serving_Network_on_Blockchain" %}

## Links

Join the Crynux community on Discord:

{% embed url="https://discord.gg/y8YKxb7uZk" %}

All the codes are open sourced at GitHub, feel free to submit issues and PRs:

{% embed url="https://github.com/crynux-ai" %}

The Crynux Blog contains the technical explanations and our latest progress:

{% embed url="https://blog.crynux.ai" %}

And follow us on Twitter:

{% embed url="https://twitter.com/crynuxai" fullWidth="true" %}
