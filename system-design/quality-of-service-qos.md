# Quality of Service (QoS)

To encourage the nodes to provide better service to the network, i.e. faster response time, faster execution time and shorter timeout period, several QoS (Quality of Service) scores are introduced to evaluate the overall quality of the node. The QoS score of a node is continuously updated when the node is executing tasks. The blockchain will then use the QoS score to adjust several strategies that will affect the task distribution among the nodes and the income of the nodes.

By giving more advantages to the nodes with higher QoS scores, the nodes are encouraged to improve their hardware and network environment, thus improving the overall service quality of the whole network to the applications.

## QoS Scores Calculation

There are 3 QoS scores that are calculated for each node: the VRAM size, the timeout setting and the submission speed. The scores are calculated using the data collected in a time window. The size of the time windows vary among different use cases.

Some of the use cases require the scores exist even if no task has been executed in the whole time window. To support such use cases, the Blockchain will randomly send system generated tasks to the nodes at random times, to ensure that every node gets at least 1 task at each time window.

<figure><img src="../.gitbook/assets/1f6e4c9f394ff73bc25e07b4940003f.png" alt=""><figcaption><p>QoS Score Calculation</p></figcaption></figure>

### The VRAM Size

The VRAM size is a critical factor that determines how many types of the AI tasks a node could support. For example, an SDXL image generation task will require roughly 12GB of VRAM. If running on an NVIDIA graphic card that has only 6GB of VRAM, the task will fail with a CUDA OOM error.

Comparing to the VRAM, the GPU frequency (and bandwidth) affects only the speed of the execution. For example, both NVIDIA RTX 4060 and RTX 3060 have the same VRAM size of 8GB. They will be able to run the same set of the tasks in the Crynux Network, it is just the execution time will be longer for the old 3060 card.

By including the VRAM size in the QoS score, Crynux Network will give more rewards to the nodes who have spent more money on the larger cards, which will allow the Crynux Network to run the larger tasks.

The VRAM size score $$R_i$$ is calculated by dividing the VRAM size of the node by the max VRAM size in the network:

$$
R_i = \frac{V_i}{max(V_j | j \in N )}
$$

Where $$V_i$$ is the VRAM size of the $$i$$th node in bytes, and $$N$$ is the collection of all the nodes in the network.

### The Timeout Setting

According to the [Consensus Protocol](consensus-protocol.md), the nodes could perform the Timeout Attack to earn tokens for free. The solution is to limit the interest rate by increasing the timeout period and the staking amount.

However, longer timeout period makes the applications wait longer if something is wrong with the task,   which is bad for the user experience. And the nodes will also be hurt since they could run less tasks in the same time range.

By staking more tokens, the node could decrease its timeout period while still maintaining a safe interest rate that is acceptable by the network. Crynux Network encourages the nodes to set a shorter timeout by giving more incentives to them, thus increasing the overall responsiveness of the whole network.

The timeout settings score $$P_i$$ is calculated by normalizing the timeout period between the minimum timeout period allowed in the network, and the maximum timeout period set by the node in the network.

$$
P_i = 1 - \frac{O_i-O_{min}}{max(O_j | j \in N) - O_{min}} = \frac{max(O_j | j \in N) - O_i}{max(O_j | j \in N) - O_{min}}
$$

$$O_i$$ is the timeout period in seconds, and $$O_{min}$$ is the minimum timeout period allowed by the network.

### The Submission Speed

There are quite a lot of factors that affect the submission speed of the node. Such as the network quality, the GPU frequency, the number of the tensor cores, and even the system memory speed. Crynux Network encourages faster submission of the tasks to improve the application's experience. By introducing competition between the nodes who are selected for the same task, giving different rewards to the nodes according to their submission order, Crynux Network rewards the improvement the node has made on all the submission speed related factors as a whole.

**Round score:** There are two rounds of submission in a single task: result commitment and result disclosure. For each round, the Crynux Network records the order of submission of the nodes, and assigns higher score to the nodes who have submitted earlier. The round score $${rs}_i$$ a node could get in a round $$i$$ can be visualized as:&#x20;

<figure><img src="../.gitbook/assets/96ba525e88bb1faabe5d1c376193601.png" alt=""><figcaption><p>The round score of a node by its submission order and status</p></figcaption></figure>

**Task score:** the task score a node gets for the $$i$$th task $${ts}_i$$ is calculated simply by summing up the scores the node gets for all the rounds in the task:

$$
{ts}_i = {rs}_c + {rs}_d
$$

where $${rs}_c$$ is the round score of the commitment round, and $${rs}_d$$ is the round score of the disclosure round.

**Node score:** the node score is calculated by averaging all the scores the node gets for all the tasks it received in the month:

$$
{ns}_i = \frac{\sum_{j=1}^n {ts}_j}{n}
$$

Where $$n$$ is the total number of the tasks the node has executed in this month.

{% hint style="info" %}
Note that if there are no nodes that have submitted result in a task. It is highly likely that the task is itself misconfigured, and the task score is simply ignored, and will not be included in the average score calculation.
{% endhint %}

Finally, the score a node gets for the submission speed factor is calculated by normalizing the node score above to be a fraction between the max node score in the network and zero:

$$
B_i = \frac{ {ns}_i} {max({ns}_j | j \in N )}
$$

## QoS Scores Usage

### Incentivization

### Penalization on the Node Selection Probability&#x20;

### Bad Node Kicking Out&#x20;
