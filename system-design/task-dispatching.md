# Task Dispatching

When a task is created on the blockchain, the blockchain will try to find the available nodes that are suitable to execute the task based on the task grading. The task is graded according to the task type and its VRAM requirement, all the nodes that are capable to execute the task will become the candidates for the random node selection.

If no suitable nodes are available, the task will be sent to the task queue to wait for more available nodes. When enough nodes are released from the last task, the task with the highest pricing will be selected from the task queue, and sent to the nodes.

The QoS score is also taken into account during the random node selection. If a node is not providing high quality service, i.e. frequently timeout on its tasks, the QoS score of the node will be low, and this node will have a low probability to be selected for the tasks.

<figure><img src="../.gitbook/assets/a94e3a399d5954d9bee2ea9e9dba36e (1).png" alt=""><figcaption><p>The overview of the task dispatching algorithm</p></figcaption></figure>

## Task Grading based on the VRAM and Task Type

The GPT task requires 3 nodes with the same model of cards, but the Stable Diffusion task requires only the minimum VRAM. To dispatch tasks efficiently, the nodes are graded according to the card model and the VRAM size, and the tasks are graded according to the minimum VRAM size required and the task type. The blockchain will then match the tasks and the nodes according to their grading.

If the VRAM requirement is set too low in the task argument, the task might be sent to a node that is not able to execute the task, and the task will be aborted eventually.

### Card Grading

The nodes are grouped based on their card model first, such as Nvidia RTX 4090 group and the 3080 group. Then the card model groups are grouped again according to their VRAM size. For example, the 16GB VRAM group may contain the RTX 4080 group, RTX 3080 group and the RTX 4000 Ada group. The blockchain will use the card groups to select candidates for a task.

### Task Grading

The tasks are grouped into the GPT tasks and the Stable Diffusion tasks first. Then based on the minimum VRAM specified in the task arguments, the tasks are grouped into several groups of common VRAM sizes, such as the 16GB group and the 24GB group. If the VRAM requirement specified in the task argument is different than any of the groups, the task will be put into the group with the minimum VRAM size that is larger than the task requirement.

The common VRAM sizes used for task groups will be the same as the ones used in the card groups for easy matching, if the corresponding card group of the same VRAM size does not exist (no nodes available), the group with the minimum VRAM size that is larger than the task group will be selected.&#x20;

## Task Queue



## Task Pricing

##

## QoS Penalization on the Node Selection Probability&#x20;

