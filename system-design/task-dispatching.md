# Task Dispatching

When a task is created on the blockchain, the blockchain will try to find the available nodes that are suitable to execute the task based on the task grading. The task is graded according to the task type and its VRAM requirement, all the nodes that are capable to execute the task will become the candidates for the random node selection.

If no suitable nodes are available, the task will be sent to the task queue to wait for more available nodes. When enough nodes are released from the last task, the task with the highest pricing will be selected from the task queue, and sent to the nodes.

The QoS scores are also taken into account during the random node selection. If a node is not providing high quality service, i.e. frequently timeout on its tasks, the QoS scores of the node will be low, and this node will have a low probability to be selected for the tasks.

<figure><img src="../.gitbook/assets/a94e3a399d5954d9bee2ea9e9dba36e (1).png" alt=""><figcaption><p>The overview of the task dispatching algorithm</p></figcaption></figure>

## Assigning Task to Nodes

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

The tasks in the same VRAM size group will be sorted according to the task value. Whenever a task will be took from the task group, it is always the task with the highest value that is took first. The task value used to sort the tasks is "CNX per second" which is calculated by dividing the task fee given by the task creator by the estimated task execution time. The details about task value estimation could be found in the following doc:

{% content-ref url="task-pricing.md" %}
[task-pricing.md](task-pricing.md)
{% endcontent-ref %}

### Select the Best Task from the Task Queue for the Newly Available Node

The blockchain will try to get a task from the task queue when one of the following situations happens:

* A running task is finished
* A new node joins the network

> When a new task is sent to the blockchain, the blockchain will try to dispatch the task immediately to the nodes regardless of whether the task queue is empty or not. There is only one possibility that the tasks are pending in the task queue: there are not enough **matching** nodes to execute the tasks. There might still be available nodes left in the network while the task queue is not empty, so that there is a chance that the new task could find matching nodes to execute first.

### &#x20;



