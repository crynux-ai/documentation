# Quality of Service (QoS)

To encourage the nodes to provide better service to the network, i.e. faster response time, faster execution time and less timeouts, QoS (Quality of Service) score is introduced to evaluate the overall quality of the node:

The QoS score of a node is continuously updated while the node is executing tasks. The score is then directly utilized to influence several key aspects of the network's operation.

By giving more advantages to the nodes with higher QoS score, the nodes are encouraged to improve their hardware and network environment, thus improving the overall service quality of the whole network to the applications.

## QoS Score Usage

### Node Selection Probability

The total QoS score is used to decide the node selection probability. Nodes with consistently low QoS score will face penalization in terms of their probability of being selected for future tasks. This approach ensures that higher-performing nodes are given priority in task allocation, thereby maintaining the overall quality and efficiency of the network.

### Bad Node Kicking Out

If a node's performance falls below a certain threshold for a prolonged period, the network has mechanisms to remove (kick out) this node from participating further. This is crucial to prevent underperforming nodes from negatively impacting the network's performance and reliability.

For instance, if a node is shutdown without sending the transaction to inform the blockchain, it will still receive new tasks. However, all these upcoming tasks will be aborted, leading to a negative experience for the applications that issued the tasks.

Now that we have the Submission Speed score, which will drop dramatically during the first several aborts of the tasks, after the threshold is reached, the node will be forced to quit the network by the blockchain, and no more tasks will be sent to the node.

## QoS Score Calculation

The QoS score of a node at a certain time is calculated using the node data (mostly task execution related) in a time window.

There are quite a lot of factors that affect the submission speed of the node. Such as the network quality, the GPU frequency, the number of the tensor cores, and even the system memory speed. Crynux Network encourages faster submission of the tasks to improve the application's experience. By introducing competition between the nodes who are selected for the same task, giving different rewards to the nodes according to their submission order, Crynux Network rewards the improvement the node has made on all the submission speed related factors as a whole.

### Task Score

Within a validation task group, the Crynux Network measures the time each node takes to submit its result, and faster submissions earn a higher task score ($${ts}_i$$) for that task $$i$$, as visualized below:

<figure><img src="../.gitbook/assets/96ba525e88bb1faabe5d1c376193601.png" alt=""><figcaption><p>The task score of a node by its submission order and status</p></figcaption></figure>

### Node Score

the node score is calculated by averaging all the task scores the node gets for all the tasks it received in the time window:

$$
{ns}_i = \frac{\sum_{j=1}^n {ts}_j}{n}
$$

Where $$n$$ is the total number of the tasks the node has executed in the time window.

{% hint style="info" %}
Note that if there are no nodes that have submitted result in a task. It is highly likely that the task is itself misconfigured, and the task score is simply ignored, and will not be included in the average score calculation.
{% endhint %}

### QoS Score

Finally, the QoS score a node gets is calculated by normalizing the node score above to be a fraction between the max node score in the network and zero:

$$
Q_i = \frac{ {ns}_i} {max({ns}_j | j \in N )}
$$
