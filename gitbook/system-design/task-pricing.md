# Task Pricing

The capacity of the Crynux Network is limited by the total number of nodes (and the execution speed of the nodes). If there are more tasks than the network could handle, the tasks will have to wait in the queue for more available nodes.

Crynux Network gives an option to the task creator to pay more for its task to make the task executing earlier than the others.

When the user creates a task, the total fee he is willing to pay for the task is left as an argument. The user could freely set the task price to any value he likes. Roughly speaking, a shorter waiting time is expected if the task price is set to be higher.

However, the exact order of the task is not determined by the total price directly, but rather an estimated **task value**, which is calculated by dividing the task price by the estimated task execution time.

The method for calculating the task value allows for a more equitable distribution of resources, which is the available time of the nodes, across all tasks. Different tasks may have significant difference on the execution time, by dividing the task price by this estimated execution time, the system effectively identifies tasks that provide optimal value—those that contribute a significant amount without demanding an excessive portion of execution time. This method of calculation endeavors to maintain a balance, ensuring both efficient resource use and satisfaction for the task creators.

## Task Value

The task value $$V$$ is calculated by:

$$
V = \frac{P}{T}
$$

Where P is the task price given by the task creator in the task arguments. And $$T$$ is the estimated task execution time.

## Task Execution Time

The duration required to complete a task can greatly fluctuate based on the type of the task and the parameters involved. For example, generating 9 images in an SD task will take considerably longer than generating just 1 image. However, the increase in time is not directly proportional (i.e., not 9 times longer) because a significant portion of the processing time is devoted to network transportation, consensus protocol, and other non-image-generation activities.

The table below shows the calculation of task value if we take only image generation time into consideration, the first row is an SD task that generates 1 image, the task price is set to be 10 CNX by the user, and the second row is an SD task that generates 2 images, whose price is set to be 15 CNX:

<table><thead><tr><th>Task fee</th><th width="116">No. Images</th><th>Image time</th><th>Task Value</th></tr></thead><tbody><tr><td>10 CNX</td><td>1</td><td>20s</td><td>0.5 CNX/s</td></tr><tr><td>15 CNX</td><td>2</td><td>40s</td><td>0.375 CNX/s</td></tr></tbody></table>

Apparently the second task takes 2 times longer than the first one. According to the calculation, the first task will be chosen to execute first because its task value is higher.

However, if we take the non-image generation time into account, as shown in the table below, the second task will become more worthy to be executed first:

| Task fee | No. Images | Image time | Non-image time | Task Value  |
| -------- | ---------- | ---------- | -------------- | ----------- |
| 10 CNX   | 1          | 20s        | 30s            | 0.2 CNX/s   |
| 15 CNX   | 2          | 40s        | 30s            | 0.214 CNX/s |

To maximize the utilization of the node time, all the time consuming activities must be taken into account when estimating the task execution time.

The non-image-generation time consumed by a task can be divided into the following parts:

* Task arguments downloading
* Model preparation
* Waiting for the result verification
* Uploading result to the relay

We can see that the non-image-generation time is not related to the task arguments nor the task type. We will use a fixed number to estimate the time in task value calculation.

The estimation of the image-generation time is given by the multiplication of a fixed single-image generation time and the number of the images.

For the GPT tasks, however, the text-generation time is set to be a fixed value no matter how many tokens will be generated from the task. Since there won't be a big difference in text-generation time under the limitation of the maximum tokens allowed in a single task.

