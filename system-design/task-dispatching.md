# Task Dispatching

When a task is created on the Blockchain, the Blockchain will try to find the available nodes that are suitable to execute the task based on the task grading. The task is graded according to the task type and its VRAM requirement, all the nodes that are capable to execute the task will become the candidates for the random node selection.

If no suitable nodes are available, the task will be sent to the task queue to wait for more available nodes. When enough nodes are released from the last task, the task with the highest pricing will be selected from the task queue, and sent to the nodes.

The QoS score is also taken into account during the random node selection. If a node is not providing high quality service, i.e. frequently timeout on its tasks, the QoS score of the node will be low, and this node will have a low probability to be selected for the tasks.

## Task Grading based on the VRAM and Task Type

When the application creates a task, it must specify the minimum VRAM required to execute the task. The argument is later used by the network to select capable nodes. All the nodes that have enough VRAM to execute the task will become the candidates in the random selection.

If the VRAM is set too low in the task argument, the task might be sent to a node that is not able to execute the task, and the task will be aborted eventually.

## Task Pricing

## Task Queue

## QoS Penalization on the Node Selection Probability&#x20;

