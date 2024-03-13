# Task Pricing

The capacity of the Crynux Network is limited by the total number of nodes (and the execution speed of the nodes). If there are more tasks than the network could handle, the tasks will have to wait in the queue for more available nodes.

Crynux Network gives an option to the task creator to pay more for its task to make the task executing earlier than the others.

When the user creates a task, the total fee he is willing to pay for the task is left as an argument. The user could freely set the task price to any value he likes. Roughly speaking, a shorter waiting time is expected if the task price is set to be higher.

However, the exact order of the task is not determined by the total price directly, but rather an estimated **task value**, which is calculated by dividing the task price by the estimated task execution time.

The method for calculating the task value allows for a more equitable distribution of resources, which is the available time of the nodes, across all tasks. By dividing the task price by this estimated execution time, the system effectively identifies tasks that provide optimal value—those that contribute a significant amount without demanding an excessive portion of execution time. This method of calculation endeavors to maintain a balance, ensuring both efficient resource use and satisfaction for the task creators.

## Task Value

The task value $$V$$ is calculated by:

$$
V = \frac{P}{T}
$$

Where P is the task price given by the task creator in the task arguments. And $$T$$ is the estimated task execution time.

## Task Execution Time

