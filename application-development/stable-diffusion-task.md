---
description: How to define a Stable Diffusion task
---

# Stable Diffusion Task

The Stable Diffusion Task Framework has two components:

1. A generalized schema to define a Stable Diffusion task.
2. An execution engine that runs the task defined in the above schema.

The task definition is represented in the key-value pairs that can be transformed into, among many other formats, a JSON string, which can be validated using a JSON schema. And the validation tools exist for most of the popular programming languages.

The execution engine is integrated into the Node of the Hydrogen Network, and the JSON string format of the task definition is used to send tasks in the Hydrogen Network.

The following is an intuitive look at a task definition:

```json
{
    "base_model": "emilianJR/chilloutmix_NiPrunedFp32Fix",
    "prompt": "a realistic portrait photo of a beautiful girl, blonde hair+++, smiling, facing the viewer",
    "negative_prompt": "low resolution++, bad hands",
    "task_config": {
        "num_images": 9,
        "safety_checker": False
    },
    "lora": {
        "model": "https://civitai.com/api/download/models/34562",
        "weight": 80
    },
    "controlnet": {
        "model": "lllyasviel/control_v11p_sd15_openpose",
        "weight": 90,
        "image_dataurl": "base64,image/png:...",
        "preprocess": {
            "method": "openpose_face"
        }
    }
}
```

## Base Models

The base model could be the original Stable Diffusion models, such as the Stable Diffusion 1.5 and the Stable Diffusion XL, or a checkpoint that is fine-tuned based on the original Stable Diffusion models.

The model can be specified in two ways: a Huggingface model ID, or a file download URL.

#### Huggingface Model ID

The Huggingface model ID for the original Stable Diffusion models are listed below:

* **Stable Diffusion 1.5**

```json
{
  "base_model": "runwayml/stable-diffusion-v1-5"
}
```

* **Stable Diffusion 2.1**

```json
{
  "base_model": "stabilityai/stable-diffusion-2-1"
}
```

* **Stable Diffusion XL**

```json
{
  "base_model": "stabilityai/stable-diffusion-xl-base-1.0"
}
```

* **Custom Fine-tuned Checkpoints**

Other custom fine-tuned checkpoints based on the original SD models can also be used, for example, the [ChilloutMix](https://huggingface.co/emilianJR/chilloutmix\_NiPrunedFp32Fix) model on the Huggingface:

```json
{
  "base_model": "emilianJR/chilloutmix_NiPrunedFp32Fix"
}
```

#### File Download URL

A URL can also be used as the base model. The execution engine will download the file before executing the task.

For example, if we want to use an SDXL fined-tuned checkpoint on Civitai. The webpage of the model is [https://civitai.com/models/169868/thinkdiffusionxl](https://civitai.com/models/169868/thinkdiffusionxl)the download link of the model file can be copied from the download button on the webpage: [https://civitai.com/api/download/models/190908](https://civitai.com/api/download/models/190908)

We could use the model in the task as following:

```json
{
  "base_model": "https://civitai.com/api/download/models/190908"
}
```

{% hint style="info" %}
Only `safetensors` format is supported in the download URL.

The execution engine treats the download URL as a binary stream of a model file in the `safetensors` format. If other formats are used, or the content of the link is not a model file at all, the execution engine will throw an exception during the execution.
{% endhint %}

## LoRA Models

LoRA models can be specified using the same format as the base model: the Huggingface model ID or the file download URL. The weight of the LoRA model can also be set in the arguments:

```json
{
   "lora": {
     "model": "https://civitai.com/api/download/models/31284",
     "weight": 80
   }
}
```

The weight should be an integer between 1 and 100.

If the LoRA model given is not compatible with the base model, for example, a LoRA model fine-tuned on the Stable Diffusion 1.5 is used, but the base model is set to be Stable Diffusion XL, the execution engine will also throw an exception.

## Controlnet

## Prompt

## Textual Inversion

## Task Config

## SDXL Refiner

## VAE

## Examples



