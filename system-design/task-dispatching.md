# Task Dispatching

When the application creates a task, it must specify, as an argument, the minimum VRAM required to execute the task. The argument is later used by the network to select capable nodes. All the nodes that have enough VRAM to execute the task will become the candidates in the random selection.

If the VRAM is set too low in the task argument, the task might be sent to a node that is not able to execute the task, and the task will be aborted eventually.

## GPU Grading based on the VRAM and GPU Model

## Task Pricing

## Task Queue

## QoS Penalization on the Probability of Node Selection&#x20;

