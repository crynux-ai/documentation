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

```
{
  "base_model": "runwayml/stable-diffusion-v1-5"
}
```

* **Stable Diffusion 2.1**

```
{
  "base_model": "stabilityai/stable-diffusion-2-1"
}
```

* **Stable Diffusion XL**

```
{
  "base_model": "stabilityai/stable-diffusion-xl-base-1.0"
}
```

* **Custom Fine-tuned Checkpoints**

Other custom fine-tuned checkpoints based on the original SD models can also be used, for example, the ChilloutMix model:

```
{
  "base_model": "emilianJR/chilloutmix_NiPrunedFp32Fix"
}
```

#### File Download URL



## LoRA Models

## Controlnet

## Prompt

## Textual Inversion

## Task Config

## SDXL Refiner

## VAE

## Examples



