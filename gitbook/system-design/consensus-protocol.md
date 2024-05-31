---
description: Decentralize the Infrastructure
---

# Consensus Protocol

The consensus protocol in a decentralized system ensures the integrity of the network, allowing permissionless participation without the possibility of fraudulent activities. The consensus protocol is the most important component in any decentralized system, since it is where "decentralization" comes from.

The hardest part about the consensus protocol design is that **Everyone Could Be Malicious**. If a leader is selected, the leader could be malicious. If validators are chosen, the validators could be malicious. The goal of every participant is the same: maximizing the income while at the same time reducing the cost as much as possible. If vulnerability exists, even a minor one, it will be exploited, resulting in the losses for the honest participants. This situation can compel these participants to exit the network, potentially leading to a network downfall eventually.

For example, consider a scenario in Crynux Network, where a malicious node submits a random image to the network without actually performing any computation. If we rely on the user to detect this fraud, allowing them to withhold payment until they have verified the result, it opens a loophole. A dishonest user could exploit this by denying all payments, effectively using the network services without paying.

The consensus protocol in the Crynux Network aims to verify the correctness of a task's output based on its input arguments. Additionally, it ensures that the Node submitting the correct result gets the payment.

The consensus protocol must be enforced by the blockchain, which eliminates the need for a centralized authority. This decentralized approach safeguards against potential abuse of power by removing the temptation for any single party to cheat, given their control.

Before diving deep into the discussions of the design and choices of each part, make sure you have already familiar with the overall task lifecycle:

{% content-ref url="task-lifecycle.md" %}
[task-lifecycle.md](task-lifecycle.md)
{% endcontent-ref %}

## Result Validation by Multiple Result Comparison

{% hint style="success" %}
In the latest version of the Consensus Protocol, only a small portion of tasks will undergo the validation process. Most tasks will be executed by a single node, who will still be unable to cheat.&#x20;

This is achieved using our latest tech innovation: VRF Task Sampling. Detailed information can be found in the following documents:

[VRF Task Sampling](vrf-task-sampling.md)

The VRF Task Sampling significantly enhances network efficiency, rivaling centralized platforms while remaining decentralized and permissionless, effectively preventing fraudulent activities.
{% endhint %}

The result validation is simply implemented by comparing 3 results from 3 randomly selected nodes. When the task is submitted to the blockchain by the application, the blockchain randomly selects 3 available nodes, and notifies them to start the task. The nodes run the task locally, and submit the results to the blockchain. The blockchain will compare the results to find out whether the nodes are cheating or not.

### Similarity Comparison

#### Similarity Comparison of the Images

Due to some technical limitations, such as [this](https://github.com/pytorch/pytorch/issues/87992) ,and [this](https://pytorch.org/docs/stable/notes/randomness.html). It is currently impossible to generate two exactly same images on two different devices.

Luckily, we don't need the images to be exactly the same. If we could compute a similarity score between two results, and the score is high, the results are already **satisfied** to the application.

And yes, there will be some lower cost methods to generate a similar image than performing the actual Stable Diffusion computation, but as long as the result is similar enough to be accepted by the application, it is fine to the network.

The Crynux Network uses the [Perceptual Hash](https://apiumhub.com/tech-blog-barcelona/introduction-perceptual-hashes-measuring-similarity/), or pHash, to calculate the image similarity. The node submits the pHash of the images to the blockchain, and the blockchain calculates the [Hamming Distance](https://en.wikipedia.org/wiki/Hamming\_distance) between two pHashes as the similarity score.

#### Similarity Comparison of the Texts

In GPT text generation tasks, the words are generated one after another. Each output word will be used as the input for the next word. If two different words are generated on two different cards in the middle of a text sequence, the rest parts of the sequence will highly likely to be completely different.

To make the texts comparison work, the same GPT task must be executed on 3 cards that are exactly the same, such as 3 of the RTX 4090s, rather than two of the 4090s and one of the 3090s. The text generation result will be exactly the same when running on cards that are in the same model, given the same random seed.

The Crynux Network will randomly choose 3 nodes that are equipped with the same cards when distributing a GPT task. The node will have to report the card model when joining the network. Note that there is no benefit to report a different card model to the network other than the one the node possesses, which will cause nothing else but the node being slashed when executing tasks.

### Two Phases Result Disclosure On-Chain

The similarity hash should not be submitted to the blockchain directly, since a malicious node might intercept the result from other nodes, and submit it to the blockchain as it is generated by himself.

A two-phase commitment-disclosure process is used to tackle this problem.

#### **Phase 1 - Submit the commitment on-chain**

The node should generate a random number locally, calculate the hash of the similarity hash, concatenated by the random number, as the commitment, and then submit the commitment and the random number on-chain.

```javascript
random_number = generate_random_number()
commitment = hash(p_hash + random_number)
submit_to_the_blockchain(commitment, random_number)
```

The commitment will not leak any information about the plain text result. And the blockchain will wait for all the 3 nodes to submit their commitments and the corresponding random numbers on-chain, and then go into phase 2. If the same random number is submitted again by a node, the submission will be rejected.

#### **Phase 2 - Disclose the similarity hash on-chain**

The honest nodes could safely submit their similarity hash to the blockchain now.&#x20;

The blockchain will validate the similarity hash using the commitment and the random number  submitted before. If the validation passes, the blockchain goes into the next step to compare the pHashes between the Nodes, otherwise, the blockchain will reject the pHash.

The malicious node could not learn anything about the pHashes of other nodes in the last step, before it has to submit a wrong commitment on-chain. Now that the malicious node has already submitted a wrong commitment, even if the malicious node could intercept a correct pHash from another node at phase 2, it is too late since he can not use the correct pHash to pass the validation with the wrong commitment on-chain.

### Random Number Generation on the Blockchain

Generating random numbers on the blockchain is then a critical step to the security of the whole network. Ethereum 2.0 has `prevrando`, which can be used as the source of the random number. On the other blockchains, the block hash of the last confirmed block is usually used. More advanced (and complex) methods exist such as the [Verifiable Random Functions](https://en.wikipedia.org/wiki/Verifiable\_random\_function). Strictly speaking, however, none of these methods are safe enough in our scenario.

The attack one could perform, given that the result validation is effective, is for an attacker to host more nodes by himself, and try to have two or more of his own nodes selected for a single task. In which case the attacker could submit two identical fake results to cheat the blockchain.

If an attacker is hosting the blockchain node (and producing the blocks) himself, the last block hash, or `prevrando`, or the selection of the VRF, is known to him before the `CreateTask` transaction has been confirmed by the next block.  This leaves a chance for the attacker to find out if his nodes are selected for a task ahead of time.

The attacker could then reject the `CreateTask` transactions in which it can not cheat, i.e. not having two or more of his own nodes selected in the task.

By carefully constructing and organizing more adjacent blocks, the attacker could even control who will be selected in the next task. Note that this does not apply to the VRF method, where the source of the randomness is not from the blockchain. Which is immune to this kind of attack, but introduces other risks which we will not cover in this article.

Considering that to make this attack **practical**, the attacker must control a significant large number of nodes in the whole network by himself. The Crynux Network chooses to ignore this problem and uses the `prevrando` on the supported blockchains, and uses the last block hash on other blockchains.

## Staking based Penalization

After the malicious behaviors could all be identified using the validation schema above, it is now time to panelize the malicious behaviors.

The penalization is implemented by asking the nodes to stake certain amount of tokens on the blockchain before joining the network. If the malicious behavior of a node is identified, the tokens will be slashed.

If the malicious behaviors are not penalized, there will always be nodes that are submitting fake results to the network. Even if the behaviors could be identified and handled by the blockchain, it will increase the chances of the task failure, reducing the efficiency of the network.

And more importantly, if not panelized properly, the attackers could still attack the system from a statistical perspective.

### Attack based on the Probability

Now that the attacker can not do anything malicious that is undiscoverable in a single task, he can still perform attacks by starting as many nodes as he could. All the malicious nodes will do one thing: submitting the same fake result to the network. There will always be chances that two malicious nodes have been selected in a same task, in which case the attacker wins regardless of the validation method used on the blockchain.

Let's call this a success of the attacker. It is then the number of the probability of success that should be considered. If the probability is high, even if the malicious behavior is panelized, there will still be room for the attacker to make profit.

### Expectation of the Income

The probability of a successful attack (an attacker getting more than 2 nodes of himself selected in a task) could be calculated as:

$$
p(h, d) = \frac{ C_d^2 * C_h^1 + C_d^3}{C_{d+h}^3}
$$

Where _**h**_ is the number of the honest nodes, and _**d**_ is the number of the dishonest nodes the attacker possesses.

And the expectation of the income from cheating is given by:

$$
E = p * k - (1-p) * s
$$

Where _**k**_ is the price of the task, and _**s**_ is the number of the staked tokens for a node.

By increasing the number of the staked tokens _**s**_, we could decrease the expectation _**E**_ down to zero or even below. If _**E**_ is below zero, there is no benefit to attack the system by starting more fake nodes. The attacking is highly likely to cause the attacker to loose money rather than earn.

The safety of the network now depends on the calculated value of the amount of the staked tokens _**s**_. Given a network size (the number of the total nodes in the network), and a target ratio of the malicious nodes (under which the network is safe), the probability of a successful attack _**p**_ is then fixed. Setting _**E**_ to zero, the amount of the staked tokens required for a single node _**s**_ is determined by:

$$
s = \frac{p * k}{1-p}
$$

## Task Error and Timeout

Since the network is a loosely coupled P2P network formed by the home computers and even the laptops, we can not put any assumptions on the reliability of the nodes. A node could lost contact to the network at any minute, while on the blockchain, it is still marked as available, or executing a task.

Neither are the applications reliable. The tasks submitted by the applications might not be executable at all, such as a mismatched combination of the SD1.5 base model and a LoRA model for the SDXL.

### Task Error Reporting

When an exception occurred during the task execution on the node, if the exception is not recoverable, the node will report the error to the blockchain.

The error reporting is treated as a normal task result on the blockchain. If more than 2 nodes has reported the error to the blockchain, the task is aborted. If a node reported the error while the other 2 nodes submitted the computation results correctly, the node will be slashed.

Crynux Network allows the model to be downloaded from an external link. However, there might be network issues during the downloading of the model. It is hard to tell whether the network issue is common to all the 3 nodes, or whether the network issue is temporary.

To avoid the slashing of the honest nodes by mistake, reporting error should be used only when the node is 100% sure it is the error of the task arguments, rather than the network issue. The rest of the cases should be taken care of by the timeout mechanism.

If the task is aborted due to error reporting, the tokens will not be returned to the application, since  the nodes have already spend some resources on the task, and it is the application to blame for the task error.

### Task Cancellation on Timeout

The consensus protocol requires the submission of the commitments of all the 3 nodes. If a selected node goes offline before submitting the commitment to the blockchain, the other 2 nodes will have to wait for an unlimited time, which is not tolerable for both the nodes and the applications.

The timeout mechanism is introduced to solve this problem. After a pre-defined period, all the 3 nodes, and the application, are allowed to submit the request to cancel the task on the blockchain. Once submitted, the blockchain will abort the task immediately.

### Expectation of the Income by Timeout Attack

The timeout mechanism introduces a new vulnerability to the network. The attacker, starting as many nodes as he could, will wait for the timeout if he finds out that he has no more than two nodes of his own selected in a task, to escape from the penalization, and submit fake results in other cases.

We can never tell between an intended offline and an accidental one. As long as the timeout mechanism exists, we can not eliminate this behavior technically. What we can do is to limit the intention economically.

By controlling the length of the timeout period, we could limit the maximum number of the tasks a malicious node could receive in a fixed range of time.

Under a fixed probability $$p$$ of a successful attack (i.e. a fixed number of the honest and the dishonest nodes), and given a value of the timeout period $$t$$ in seconds, assume the total number of the tasks a malicious node could execute in a day is $$n$$, we have:

$$
\hat{t} * n * p + t * n * (1-p) = 86400
$$

Where $$\hat{t}$$ is an estimated constant of the time required for a normal task execution. Since the attacker will have to wait for the other honest node to submit commitment when he has only two nodes selected in the task. And if all the three nodes are from the attacker in a task, the blockchain confirmation still requires time.

The maximum number of the malicious tasks $$n_m$$ a malicious node could cheat successfully in a day is then:

$$
n_m = n * p = \frac{86400 * p}{\hat{t} * p + t * (1-p)}
$$

The total income an attacker could get in a day, by starting $$d$$ nodes, is then:

$$
I_{max}(p, t) = n_m * k * d = \frac{86400 * p * k * d}{\hat{t} * p + t * (1-p)}
$$

Recall that $$k$$ is the price of a single task, and $$d$$ is the number of the malicious nodes the attacker has to start to reach the probability $$p$$.

For each of the $$d$$ nodes the attacker has to stake $$s$$ tokens. The total amount of tokens the attacker has to stake, for one day, is:

$$
T(p) = s * d = \frac{p * k * d}{1-p}
$$

We could then treat the income as the interest of staking so many tokens for a day. The daily percentage rate is given by:

$$
{DPR}_{max}(p, t) = \frac{ I_{max}(p,t) }{ T(p) } = \frac{86400*(1-p)}{\hat{t} * p + t * (1-p)}
$$

Where _**t**_ is the period of timeout in seconds. By increasing the period _**t**_, we could decrease the percentage rate to a value that no one will ever be interested.

#### Add more staking to decrease the timeout

A longer timeout period gives a lower percentage rate, which makes the network safer, but the applications and the honest nodes will have to wait longer.

By increasing the required amount of staking, we can further reduce the timeout period.

Let's introduce a number $$s_t$$ , which will be added to the staking amount. The total amount of tokens the attacker has to stake, for one day, becomes:

$$
T(p) = (s + s_t) * d = \frac{p * k * d}{1-p} + s_t * d
$$

We can then choose a fit $$s_t$$ value to balance between the attacking risk and the network efficiency.

According to our calculation (see the figure below), the number of tokens required to stake to prevent the timeout attack is magnitudes larger than the number required to prevent the attack we mentioned above of submitting fake results regardless of the node selection result.

#### Conspiracy between the attackers

The malicious nodes must be controlled by a single attacker to increase the success probability. Two attackers can not easily conspire to perform the timeout attack together, which requires one attacker to know if a selected node is honest, or a malicious node of another attacker for sure, who will submit the same fake result as his own. The safe choice is of course to assume that it is an honest node.

That's a good news to us. The malicious nodes of one attacker can be seen as the honest nodes to another attacker. The probability of successful attack decreases as the number of attackers rises.

Below is an example of the calculated numbers on different network sizes and malicious nodes:

The settings are given as:

| Item                               | Value       |
| ---------------------------------- | ----------- |
| Task price                         | 3 CNX       |
| Estimated execution time of a task | 60 seconds  |
| Timeout period                     | 300 seconds |
| No. of staking for timeout attack  | 5,000 CNX   |

The staking required and the corresponding APR are listed below, assuming all the malicious nodes belong to the single attacker:

<table><thead><tr><th width="107" align="right">No. honest</th><th width="123" align="right">No. malicious</th><th width="161" align="right">No. staking for timeout</th><th width="183" align="right">No. staking total (T)</th><th width="175" align="right">APR (%)</th></tr></thead><tbody><tr><td align="right">7</td><td align="right">3</td><td align="right">15,000</td><td align="right">15,000.67</td><td align="right">451.67</td></tr><tr><td align="right">70</td><td align="right">3</td><td align="right">15,000</td><td align="right">15,000.01</td><td align="right">7.15</td></tr><tr><td align="right">700</td><td align="right">30</td><td align="right">150,000</td><td align="right">150,000.14</td><td align="right">10.09</td></tr><tr><td align="right">7000</td><td align="right">30</td><td align="right">150,000</td><td align="right">150,000.00</td><td align="right">0.11</td></tr><tr><td align="right">9970</td><td align="right">30</td><td align="right">150,000</td><td align="right">150,000.00</td><td align="right">0.05</td></tr><tr><td align="right">9900</td><td align="right">100</td><td align="right">500,000</td><td align="right">500,000.03</td><td align="right">0.62</td></tr><tr><td align="right">9700</td><td align="right">300</td><td align="right">1,500,000</td><td align="right">1,500,000.80</td><td align="right">5.56</td></tr><tr><td align="right">9500</td><td align="right">500</td><td align="right">2,500,000</td><td align="right">2,500,003.65</td><td align="right">15.30</td></tr></tbody></table>

As the figure shows, when the network reaches 10,000 total nodes, under the settings of the 5-minute timeout, and the required 5,000 CNX staking, the network is safe when an attacker starts \~ 300 nodes, which will cost him 1,500,000 CNX tokens.

And the APR can be reached only when the network is running at its maximum capacity, i.e. every node is running tasks one after another without idle time. The APR will drop if we do not have so many tasks to execute.
