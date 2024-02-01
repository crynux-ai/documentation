---
description: '[Jan 30, 2024] Decentralized GPT Task Execution Engine'
---

# Helium Network

Helium Network adds the support of the GPT text generation tasks. The Crynux Network now supports running both the Stable Diffusion image generation tasks and the GPT text generation tasks.

Now the applications could use the inference APIs to generate texts with [most of the LLM models on the Huggingface](https://huggingface.co/models?pipeline\_tag=text-generation\&sort=trending). AI Chatbot applications could have already been built on top of the Crynux Network. To get started, follow the guide below:

{% content-ref url="../application-development/application-workflow.md" %}
[application-workflow.md](../application-development/application-workflow.md)
{% endcontent-ref %}

## AI Chatbot Application

An AI chatbot application has been released to demonstrate the abilities. The app provides a simple chat UI in the browser, and the text generation task is sent to the [Crynux Bridge](https://github.com/crynux-ai/crynux-bridge) at the backend, and then sent to the Crynux Network for execution. The task fees are paid from the wallet inside the Crynux Bridge so that the users won't have to deal with the wallet themselves.

Try the application yourself at: [https://chat.crynux.ai](https://chat.crynux.ai)

The source code of the application is located on the GitHub:

[https://github.com/crynux-ai/chat-web](https://github.com/crynux-ai/chat-web)

## GPT Task Framework

A general framework to define and execute the GPT tasks is developed to be used in the Helium Network. A wide range of the common task types and configurations are supported. Just describe the task using JSON, and send it to the inference API:

* Unified task definition for various different large language model
* Apply model specific chat templates to input prompts automatically
* Model quantizing (INT4 or INT8)
* Fine grained control text generation arguments
* ChatGPT style response

To find out more about how to write a GPT task, go to the following page:

{% content-ref url="../application-development/gpt-task.md" %}
[gpt-task.md](../application-development/gpt-task.md)
{% endcontent-ref %}

## GPT Task Verification On-chain

The consensus protocol now supports the validation of the GPT tasks.

To support the validation of the GPT tasks, the network will select 3 nodes with the same card model to run a single task, which ensures the results will be exactly the same on all the 3 nodes.

The node selection for stable diffusion tasks remain the same, which does not require the same cards, which gives the task more candidates to use and makes the network safer.

## The Blockchain In Use

The Helium Network is still running on the [same private blockchain](hydrogen-network.md#the-blockchain-in-use) as the Hydrogen Network. The contracts used is listed below:

| Contract | Address |
| -------- | ------- |
| Token    |         |
| Node     |         |
| Task     |         |

Again, both the test ETH and CNX tokens are required to start a node, or call the inference API. To get the test tokens, join the Discord of Crynux:

{% embed url="https://discord.gg/Ug2AHUbrrm" %}

## The Relay In Use

The relay server used is also the same as the Hydrogen Network, which could be accessed at:

```url
https://relay.h.crynux.ai
```

The source code of the relay is hosted at:

{% embed url="https://github.com/crynux-ai/crynux-relay" %}
