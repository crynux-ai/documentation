# Task Dispatching

When a task is created on the blockchain, the blockchain will try to find the available nodes that are suitable to execute the task based on the task grading. The task is graded according to the task type and its VRAM requirement, all the nodes that are capable to execute the task will become the candidates for the random node selection.

If no suitable nodes are available, the task will be sent to the task queue to wait for more available nodes. When enough nodes are released from the last task, the task with the highest value will be selected from the task queue, and sent to the nodes.

The QoS scores are also taken into account during the random node selection. If a node is not providing high quality service, i.e. frequently timeout on its tasks, the QoS scores of the node will be low, and this node will have a low probability to be selected for the tasks.

<figure><img src="../.gitbook/assets/a94e3a399d5954d9bee2ea9e9dba36e (1).png" alt=""><figcaption><p>The overview of the task dispatching algorithm</p></figcaption></figure>

## Assigning Task to the Nodes

The GPT task requires 3 nodes with the same model of cards, but the Stable Diffusion task requires only the minimum VRAM. To dispatch tasks efficiently, the nodes are graded according to both the card model and the VRAM size. The blockchain will then match the tasks and the nodes according to their grading.

If the VRAM requirement is set too low in the task argument, the task might be sent to a node that is not able to execute the task, and the task will be aborted eventually.

### Node Grading

The nodes are grouped based on their card model first, such as Nvidia RTX 4090 group and the 3080 group. Then the card model groups are grouped again according to their VRAM size. For example, the 16GB VRAM group may contain the RTX 4080 group, RTX 3080 group and the RTX 4000 Ada group. The blockchain will use the card groups to select candidates for a task.&#x20;

### Node Selection using the Groups

When the blockchain tries to select nodes for a task, it first selects the groups based on the VRAM sizes. All the node groups with a equal or larger VRAM size than the task requirement are selected.

If the task type is Stable Diffusion, the nodes could have already been randomly selected across all the candidate VRAM size groups. However, if the task type is GPT, a card model group should be further selected in the VRAM size groups randomly, and the nodes should then be selected in the card model group.

> The random selection of the card model group is designed to ensure the equal probabilities of selection among all the nodes across all the candidate groups, rather than equal probabilities among the groups. As a result, the group with more nodes will have a higher probability to be selected.

If there are not enough candidate nodes to be selected from, the task will be put into the task queue and wait for more nodes to become available.

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

If the max size is reached, the task sent to the blockchain will be aborted immediately rather than putting into the task queue.

