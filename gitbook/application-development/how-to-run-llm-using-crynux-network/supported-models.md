# Supported Models

Crynux theoretically supports any model that can be executed by the Hugging Face `transformers` library. To use a specific model, you simply need to specify its Hugging Face model ID in the task configuration. The Crynux Nodes will then automatically fetch the model from Hugging Face and execute the task.

The primary practical limitation on the number and size of models Crynux can support is the maximum available VRAM on the nodes within the Crynux Network. Currently, the nodes with the largest VRAM capacity offer 24GB.

For example, below is a list of popular models that can be used in the Crynux Network. Each entry includes the model name and a direct link to its Hugging Face repository.

{% hint style="success" %}
If a model isn't on this list, feel free to try it out as long as you're confident it's compatible with the `transformers` library and there's sufficient VRAM available on the network.
{% endhint %}

### DeepSeek Models

| Model ID                                  | Hugging Face Link                                                                                             |
| ----------------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B | [deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B](https://huggingface.co/deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B) |
| deepseek-ai/DeepSeek-R1-Distill-Qwen-7B   | [deepseek-ai/DeepSeek-R1-Distill-Qwen-7B](https://huggingface.co/deepseek-ai/DeepSeek-R1-Distill-Qwen-7B)     |
| deepseek-ai/DeepSeek-R1-Distill-Llama-8B  | [deepseek-ai/DeepSeek-R1-Distill-Llama-8B](https://huggingface.co/deepseek-ai/DeepSeek-R1-Distill-Llama-8B)   |

### Qwen Models

| Model ID                 | Hugging Face Link                                                           |
| ------------------------ | --------------------------------------------------------------------------- |
| Qwen/Qwen3-4B            | [Qwen/Qwen3-4B](https://huggingface.co/Qwen/Qwen3-4B)                       |
| Qwen/Qwen3-8B            | [Qwen/Qwen3-8B](https://huggingface.co/Qwen/Qwen3-8B)                       |
| Qwen/Qwen2.5-7B          | [Qwen/Qwen2.5-7B](https://huggingface.co/Qwen/Qwen2.5-7B)                   |
| Qwen/Qwen2.5-7B-Instruct | [Qwen/Qwen2.5-7B-Instruct](https://huggingface.co/Qwen/Qwen2.5-7B-Instruct) |

### NousResearch Models

| Model ID                           | Hugging Face Link                                                                               |
| ---------------------------------- | ----------------------------------------------------------------------------------------------- |
| NousResearch/Hermes-3-Llama-3.1-8B | [NousResearch/Hermes-3-Llama-3.1-8B](https://huggingface.co/NousResearch/Hermes-3-Llama-3.1-8B) |
| NousResearch/Hermes-3-Llama-3.2-3B | [NousResearch/Hermes-3-Llama-3.2-3B](https://huggingface.co/NousResearch/Hermes-3-Llama-3.2-3B) |
