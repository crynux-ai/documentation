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

{% content-ref url="../application-development/execute-tasks/text-to-text-task.md" %}
[text-to-text-task.md](../application-development/execute-tasks/text-to-text-task.md)
{% endcontent-ref %}

## GPT Task Verification On-chain

The consensus protocol now supports the validation of the GPT tasks.

To support the validation of the GPT tasks, the network will select 3 nodes with the same card model to run a single task, which ensures the results will be exactly the same on all the 3 nodes.

The node selection for stable diffusion tasks remain the same, which does not require the same cards, which gives the task more candidates to use and makes the network safer.

## Task Queue & Task Pricing

The order of the task execution is now determined by the task price set by the task creator. In general, tasks with higher prices will be executed first. Task with a lower priority will be put into the task queue to be executed later.

The order is not simply determined by the total price of a task. Instead, the task execution time is also taken into account to maximize the total income of a node in a fixed time range. The network will estimate a unit value in "CNX per second" of the task to determine the actual order of the task. The details can be found in the following docs:

{% content-ref url="../system-design/task-dispatching.md" %}
[task-dispatching.md](../system-design/task-dispatching.md)
{% endcontent-ref %}

{% content-ref url="../system-design/task-pricing.md" %}
[task-pricing.md](../system-design/task-pricing.md)
{% endcontent-ref %}

## Quality of Service (QoS)

The Helium Network will calculate the Submission Speed score for each node. The score will be used in the following 2 scenarios:

* **Task fee distribution among the participating nodes**: the node that submits the result faster will get larger portion of the task fee.
* **Bad node kick out**: the node that has a lower score below the threshold will be forced to quit the network.

The details can be found in the following doc:

{% content-ref url="../system-design/quality-of-service-qos.md" %}
[quality-of-service-qos.md](../system-design/quality-of-service-qos.md)
{% endcontent-ref %}

## Mac Support

The Crynux Node could now be started on Mac with Apple Silicon Chips (m1, m2 and m3 series). Both the Stable Diffusion and GPT tasks are supported. All the mac users could now join the network to earn CNX tokens.

To start a node on Mac, just follow the tutorial below:

{% content-ref url="../node-hosting/start-a-node/start-a-node-mac.md" %}
[start-a-node-mac.md](../node-hosting/start-a-node/start-a-node-mac.md)
{% endcontent-ref %}

## The Blockchain In Use

Thanks to [Dymension](https://dymension.xyz/), the Helium Network is using a [testnet rollapp of Dymension](https://testnet.dymension.xyz/rollapp/crynux\_10000-1/metrics) as an L2 blockchain. An EVM is running on the rollapp to support the smart contracts of Crynux.

The base layer token (think of it as the ETH in the testnet rollapp) is now used as the Crynux token. The old ERC20 token is deprecated.

The block explorer of the testnet rollapp can be accessed at:

{% embed url="https://bb.dym.fyi/r/dev-crynux" %}

| Contract           | Address                                    |
| ------------------ | ------------------------------------------ |
| Node               | 0x662d296cae3f1Be2ed5803227dAd6435f1ffC438 |
| Task               | 0x07E149A0e372C2F54Df6358d021d700703D222D1 |
| Task Queue         | 0xeD4cbf24978AD18d73ee6190e361E71095E857A7 |
| QoS                | 0x95E7e7Ed5463Ff482f61585605a0ff278e0E1FFb |
| Network Statistics | 0xC2c060f8C46640394E0937D75Ea977207E6df130 |

The test CNX tokens are required to start a node, or call the inference API. To get the test tokens, using the bot inside the Discord server of Crynux.

## The Relay In Use

The relay server used is:

```url
https://dy.relay.crynux.ai
```

The source code of the relay is hosted at:

{% embed url="https://github.com/crynux-ai/crynux-relay" %}
