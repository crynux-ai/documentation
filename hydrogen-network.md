---
description: Decentralized Stable Diffusion Task Execution Engine
---

# Hydrogen Network

Hydrogen Network is the first testnet of the Crynux Network. Hydrogen Network implements an AI inference task execution engine that supports running the Stable Diffusion image generation tasks for the applications.

The computation power comes from a decentralized network of home computers and servers that are coordinated by a consensus protocol running on the Blockchain. The individuals who have the spared computation power could connect their devices to the network, exchanging the computation power for tokens by running the inference tasks for the applications.

## Inference API

To the applications, Hydrogen Network is an inference API service that could be used to generate images using the Stable Diffusion.

The application should prepare a wallet, to pay the tokens for the inference task. But other than that, the invocation of the API is no different than the invocation of a traditional API service.

If you are an application developer, get started from here:

{% content-ref url="application-development/application-workflow.md" %}
[application-workflow.md](application-development/application-workflow.md)
{% endcontent-ref %}

#### The Image Generator

## Consensus Protocol

The consensus protocol ensures that&#x20;

## Stable Diffusion Task Framework

#### Model Selection

All the components in the SD pipeline, such as the LoRA model, Controlnet model and textual inversion model, can be specified, either as a Huggingface ID, or an external download link.

## The Blockchain In Use

The Hydrogen Network is running on a private Blockchain whose node can be access using the RPC endpoint:

```url
https://block-node.crynux.ai/rpc
```

The Blockchain is built using the [Frontier project](https://paritytech.github.io/frontier/), which contains an EVM running on top of the [Substrate Blockchain](https://substrate.io/). The Blockchain is Ethereum compatible, most of the existing tools for the Ethereum can be used directly.

The Hydrogen Network is coordinated by three smart contracts on the Blockchain:

```
Token Contract: "0x95E7e7Ed5463Ff482f61585605a0ff278e0E1FFb"
Task Contract: "0xba2489a25A5f542877D3825Ab802651f28878C4a"
Node Contract: "0xB0E9A451Ce0CC181EA9888C7B42BB8Ad90b73C78"
```

The CNX token is just an standard ERC20 token. The tokens will be operated by the other contracts to implement the required functions.

The source code of the smart contracts is hosted on the GitHub:

{% embed url="https://github.com/crynux-ai/h-contracts" %}

To get the test tokens to start the node, or run an application, join the Discord of Crynux:

{% embed url="https://discord.gg/Ug2AHUbrrm" %}

## The Relay In Use

The relay server could be accessed at:

```url
https://relay.h.crynux.ai
```

The source code of the relay is hosted at:

{% embed url="https://github.com/crynux-ai/h-relay" %}
