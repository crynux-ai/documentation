# Inference Task Validation

## Stable Diffusion Image Generation

Stable Diffusion image generation tasks are allowed to be executed using a combination of all types of GPU models.

The non-deterministic behavior in the Stable Diffusion pipeline is minimized to keep the result images as close as possible. There will still be minor differences when executed on different GPU models due to technical limitations, such as [this](https://github.com/pytorch/pytorch/issues/87992).

The [Perceptual Hash](https://apiumhub.com/tech-blog-barcelona/introduction-perceptual-hashes-measuring-similarity/), or pHash, is further adopted to calculate the image similarity. The node submits the pHash of the images to the blockchain, and the blockchain calculates the [Hamming Distance](https://en.wikipedia.org/wiki/Hamming\_distance) between two pHashes as the similarity score. Two images with the similarity score under a given threshold are considered the same image.

Raising the threshold heightens the likelihood of successful attacks with counterfeit images. This risk can be mitigated by increasing the amount of tokens required for staking.

## LLM Text Generation

LLM text generation tasks are limited to be execute on the same GPU models.&#x20;

In LLM text generation tasks, the words are generated one after another,  each output word will be used as the input for the next word. This means the error will be accumulated during the whole generation process. If two different words are generated on two different cards in the middle of a text sequence, the rest parts of the sequence will highly likely to be completely different. As a result, no differences could be tolerated in the LLM tasks.

By managing the random number generation and swapping out the non-deterministic algorithms in the text creation process, Crynux ensures consistent execution of LLM tasks across identical GPU models.

When joining the network, nodes will declare their card models to the blockchain, which will then pair nodes with identical card models for specific LLM tasks. It's important to note that submitting false card model information to the blockchain offers no advantage to the nodes and will result in penalties.

&#x20;
