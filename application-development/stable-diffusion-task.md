# Stable Diffusion Task

The Stable Diffusion Task Framework has two components:

1. a generalized schema to define a Stable Diffusion task.
2. an execution engine that runs the task defined in the above schema.

The commonly used features, such as LoRA and Controlnet, are unified into a single task definition schema. The task definition is represented in the key-value pairs that can be transformed into a JSON string, among many other formats, which can be validated using a JSON schema.

The following is an intuitive look at a task definition:

```
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

## LoRA Models

## Controlnet

## Prompt

## Textual Inversion

## Task Config

## Examples



