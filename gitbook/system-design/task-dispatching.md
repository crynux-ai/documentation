---
description: Find the best node to execute the task
---

# Task Dispatching

When creating a task, the application can specify criteria such as the minimum VRAM requirement or restrict the node selection to a specific GPU model. The blockchain will identify all eligible nodes that meet the criteria and then randomly select one from these candidates.

If no available nodes meet the criteria, the task will be added to the queue to await more nodes. When a node satisfying the criteria is freed, the highest-price task from the queue will be assigned to this available node.

To optimize task execution speed while maintaining consensus strength, nodes are selected randomly from candidates with different probabilities. Factors influencing a node's selection probability include its local model cache and QoS score. Nodes with faster GPUs, superior networks, fewer timeouts, or locally cached models needed for the task will have a higher likelihood of selection.

The details of the task dispatching algorithm are described in the following sections.

<figure><img src="../.gitbook/assets/fd705dac6f56dab6fcc30062a56561d.png" alt=""><figcaption><p>Task Dispatching Overview</p></figcaption></figure>

## Assigning Task to the Nodes

The nodes on the blockchain are first grouped by their card model, such as the Nvidia RTX 4090 group and the RTX 3080 group. These card model groups are then further grouped by their VRAM size. For example, the 16GB VRAM group may include the RTX 4080, RTX 3080, and RTX 4000 Ada groups. The blockchain will use these card groups to select candidates for a task.

If the application sets `Required GPU` in the task parameters, only the group with the required GPU model will be selected as the candidates. Otherwise, all the groups with VRAM equal to or larger than the task's requirement are chosen as candidates.

The node will then be randomly selected from all candidates based on their selection probability.

### Node Selection Probability

The selection probability of a node depends on the following factors:

#### Model Cache

If a node recently executed tasks using the same model as the current task, it is likely that the model is still stored locally on the disk or even better, cached in the memory. This prevents the need for downloading or reloading the model, significantly speeding up task execution. Such nodes are given higher probabilities for selection.

#### QoS Score

Newer GPUs with the same VRAM but higher frequencies execute tasks faster. To speed up task execution, Crynux Network prioritizes faster nodes by giving them higher selection probabilities.

To prevent nodes from reporting fake frequencies and GPU models, Crynux Network uses the Task Execution Speed score of the QoS instead of the reported frequencies. This score evaluates nodes by comparing their speed in executing the validation tasks. Nodes that complete the task faster receive a higher QoS score and are thus more likely to be selected for future tasks.

Details about the QoS scores can be found in the following document:

{% content-ref url="quality-of-service-qos.md" %}
[quality-of-service-qos.md](quality-of-service-qos.md)
{% endcontent-ref %}

If there are not enough candidate nodes to be selected from, the task will be added to the task queue and wait for more nodes to become available.

## Task Queue

When a task is put into the task queue, the task will be graded according to their VRAM requirements and the task type.

### Task Grading

The tasks are grouped into the GPT task group and the Stable Diffusion task group first. Then based on the VRAM requirements specified in the task arguments, the tasks are grouped into several groups of VRAM sizes, such as the 16GB group and the 24GB group.

The tasks in the same VRAM size group will be sorted according to the **task value**. Whenever a task is taken from the task queue, it is always the task with the highest value that is taken first. The task value is estimated as "CNX per second" which is calculated by dividing the task fee by the estimated task execution time. The details about task value estimation could be found in the following doc:

{% content-ref url="task-pricing.md" %}
[task-pricing.md](task-pricing.md)
{% endcontent-ref %}

### Select the Best Task from the Task Queue for the Newly Available Node

The blockchain will try to retrieve a task from the task queue when a new node becomes available. Which will happen when one of the following situations occurs:

* A running task is finished. Which will cause 3 nodes to be released.
* A new node joins the network.

> When a new task is sent to the blockchain, the blockchain will try to dispatch the task immediately to the nodes regardless of whether the task queue is empty or not. There is only one possibility that the tasks are pending in the task queue: there are not enough **matching** nodes to execute the tasks. There might still be available nodes left in the network while the task queue is not empty, so that there is a chance that the new task could still find matching nodes.

Considering the nature of the sequential execution of the blockchain, when a new node becomes available while the task queue is not empty:

* At most one task could be executed in the whole network.
* If a task can be executed, there are only 3 nodes available to execute the task, including the newly available one.

Given the observation above, the strategy to find the best task and the nodes to execute it could be simplified to the following two steps:

#### 1. Find the best combination of 3 nodes

Start from the newly available node, two types of the combination should be examined:&#x20;

**Three nodes in the same card model**

If 2 other nodes could be found which are in the same card model group of the newly available node, a new GPT task might be able to be executed.

**Three nodes that have the possibly largest VRAM**

Find the possible combination of 3 nodes, including the newly available node, that have the largest minimum VRAM. The largest minimum VRAM of the combination gives the best opportunity to find a matching Stable Diffusion task in the task queue.

#### 2.Find the best task to execute

Two steps are required to find the task with the highest value to execute:

**Firstly, find all the candidate VRAM size groups of the tasks that can be executed by the node combinations.**

If there is a combination of 3 nodes that are in the same card model, all the VRAM size groups that is equal or lower than the VRAM size of the node combination, in both the GPT group and the SD group, should be included in the candidate groups.

Additionally, if there is a combination of 3 nodes that are not in the same card model. Some VRAM size groups of the SD task group should be included in the candidate groups similarly.

**Secondly, find the task with the best value among the VRAM size groups selected above.**

In each VRAM size group, the tasks should have already been sorted by the task value, it is easy to find the task with the largest value inside the group. The task is then compared to the tasks that are taken from the other groups to find the best task among all the groups, which is the task that will be executed.

### Max Size of the Task Queue

The max size of the task queue is estimated dynamically using the total number of nodes of the network:

$$
S = \alpha * N
$$

Where $$N$$ is the number of nodes in the network, and $$\alpha$$ is a fixed multiplier that will be set as the network parameter.

If the max size is reached, when a new task is sent to the task queue, the task with the lowest task value in the queue will be removed and aborted. The task creator of the removed task will receive the `TaskAborted` event.

