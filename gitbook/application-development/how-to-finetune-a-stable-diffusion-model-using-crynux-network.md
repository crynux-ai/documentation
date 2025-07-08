# How to Fine-tune a Stable Diffusion Model using Crynux Network

Fine-tuning Stable Diffusion models on the Crynux Network involves creating a training task and monitoring its progress. Unlike immediate inference tasks, fine-tuning is a long-running process that requires tracking the task status and downloading results upon completion. The example below demonstrates how to submit a fine-tuning task to the Crynux Network using HTTP requests:

{% tabs %}
{% tab title="Python" %}
```python
import time
import httpx

client = httpx.Client(
    base_url="https://bridge.crynux.io",
    timeout=180,
)

api_key = "q3hXHA_8O0LuGJ1_tou4_KamMlQqAo-aYwyAIDttdmI="  # For public demonstration only

# Fine-tuning configuration
data = {
    "model_name": "crynux-ai/stable-diffusion-v1-5",
    "model_variant": "fp16",
    "dataset_url": "https://gateway.irys.xyz/GivF5FBMdJVr6xHT7hi2aE7vH55wVjrtKLpRc2E86icJ",
    "validation_num_images": 4,
    "learning_rate": 0.0001,
    "batch_size": 1,
    "num_train_steps": 100,
    "max_train_steps": 200,
    "lr_scheduler": "cosine",
    "lr_warmup_steps": 0,
    "rank": 4,
    "init_lora_weights": "gaussian",
    "target_modules": ["to_k", "to_q", "to_v", "to_out.0"],
    "center_crop": True,
    "random_flip": True,
    "mixed_precision": "fp16",
    "seed": 42,
    "timeout": 1800,
}

headers = {
    "Authorization": f"Bearer {api_key}",
}

# Step 1: Create fine-tuning task
resp = client.post(
    "/v1/images/models",
    json=data,
    headers=headers,
    timeout=180,
)
resp.raise_for_status()
res = resp.json()
task_id = res["data"]["id"]
print(f"Task ID: {task_id}")

# Step 2: Monitor task status
success = False
while True:
    resp = client.get(f"/v1/images/models/{task_id}/status")
    resp.raise_for_status()
    res = resp.json()
    status = res["data"]["status"]
    
    if status == "success":
        print("Task completed successfully")
        success = True
        break
    elif status == "failed":
        print("Task failed")
        success = False
        break
    elif status == "running":
        print("Task is still running...")
    
    time.sleep(60)  # Check status every minute

# Step 3: Download results if successful
if success:
    with client.stream(
        "GET",
        f"/v1/images/models/{task_id}/result",
        headers=headers,
        timeout=180,
    ) as resp:
        resp.raise_for_status()
        with open("finetuned_model.zip", "wb") as f:
            for chunk in resp.iter_bytes():
                f.write(chunk)
    print("Fine-tuned model downloaded as finetuned_model.zip")
```
{% endtab %}

{% tab title="JavaScript" %}
```javascript
import fetch from 'node-fetch';

const API_KEY = "q3hXHA_8O0LuGJ1_tou4_KamMlQqAo-aYwyAIDttdmI="; // For public demonstration only
const BASE_URL = "https://bridge.crynux.io";

async function finetuneStableDiffusion() {
    try {
        // Fine-tuning configuration
        const data = {
            model_name: "crynux-ai/stable-diffusion-v1-5",
            model_variant: "fp16",
            dataset_url: "https://gateway.irys.xyz/GivF5FBMdJVr6xHT7hi2aE7vH55wVjrtKLpRc2E86icJ",
            validation_num_images: 4,
            learning_rate: 0.0001,
            batch_size: 1,
            num_train_steps: 100,
            max_train_steps: 200,
            lr_scheduler: "cosine",
            lr_warmup_steps: 0,
            rank: 4,
            init_lora_weights: "gaussian",
            target_modules: ["to_k", "to_q", "to_v", "to_out.0"],
            center_crop: true,
            random_flip: true,
            mixed_precision: "fp16",
            seed: 42,
            timeout: 1800,
        };

        const headers = {
            "Authorization": `Bearer ${API_KEY}`,
            "Content-Type": "application/json",
        };

        // Step 1: Create fine-tuning task
        const createResponse = await fetch(`${BASE_URL}/v1/images/models`, {
            method: "POST",
            headers: headers,
            body: JSON.stringify(data),
        });

        if (!createResponse.ok) {
            throw new Error(`Failed to create task: ${createResponse.statusText}`);
        }

        const createResult = await createResponse.json();
        const taskId = createResult.data.id;
        console.log(`Task ID: ${taskId}`);

        // Step 2: Monitor task status
        let success = false;
        while (true) {
            const statusResponse = await fetch(`${BASE_URL}/v1/images/models/${taskId}/status`);
            if (!statusResponse.ok) {
                throw new Error(`Failed to get status: ${statusResponse.statusText}`);
            }

            const statusResult = await statusResponse.json();
            const status = statusResult.data.status;

            if (status === "success") {
                console.log("Task completed successfully");
                success = true;
                break;
            } else if (status === "failed") {
                console.log("Task failed");
                success = false;
                break;
            } else if (status === "running") {
                console.log("Task is still running...");
            }

            // Wait 60 seconds before checking again
            await new Promise(resolve => setTimeout(resolve, 60000));
        }

        // Step 3: Download results if successful
        if (success) {
            const downloadResponse = await fetch(`${BASE_URL}/v1/images/models/${taskId}/result`, {
                headers: headers,
            });

            if (!downloadResponse.ok) {
                throw new Error(`Failed to download results: ${downloadResponse.statusText}`);
            }

            const fs = require('fs');
            const fileStream = fs.createWriteStream('finetuned_model.zip');
            downloadResponse.body.pipe(fileStream);

            return new Promise((resolve, reject) => {
                fileStream.on('finish', () => {
                    console.log("Fine-tuned model downloaded as finetuned_model.zip");
                    resolve();
                });
                fileStream.on('error', reject);
            });
        }
    } catch (error) {
        console.error("Error:", error);
    }
}

finetuneStableDiffusion();
```
{% endtab %}
{% endtabs %}

## Fine-tuning Process Overview

The fine-tuning process on Crynux Network consists of three main steps:

1. **Task Creation**: Submit a POST request to `/v1/images/models` with your fine-tuning configuration. This returns a task ID that you'll use to track progress.

2. **Status Monitoring**: Poll the `/v1/images/models/{task_id}/status` endpoint to check if the task has completed, failed, or is still running. Fine-tuning can take anywhere from minutes to hours depending on your configuration.

3. **Result Download**: Once the task succeeds, download the fine-tuned model using the `/v1/images/models/{task_id}/result` endpoint. The result is typically a ZIP file containing your fine-tuned model weights.

## Configuration Parameters

The fine-tuning configuration includes various parameters that control the training process, such as learning rate, batch size, number of training steps, and LoRA-specific settings. For a comprehensive list of supported parameters and their descriptions, please refer to the [Crynux Bridge documentation](../crynux-bridge.md) and the [Fine-tuning Task documentation](../execute-tasks/fine-tuning-task.md).

The API Key in the example code is for public demonstration purposes only and has a strict rate limit, making it unsuitable for production environments. To use the Crynux Network for fine-tuning in production, choose one of the following methods:

## Method 1: Using the Official Crynux Bridge

You can request a separate API Key with a higher quota from the Crynux Discord server. Join the server and request new keys from an admin in the "applications" channel.

{% embed url="https://discord.gg/y8YKxb7uZk" %}

## Method 2: Hosting Your Own Crynux Bridge

You can host your own instance of the Crynux Bridge to provide private APIs for your application. This approach gives you greater control over various system aspects, including reliability and speed-related configurations.

Starting a Crynux Bridge is as straightforward as running a Docker container. An additional requirement is a wallet funded with sufficient (test) CNX to cover the tasks you run on the network. And at this moment, you can get test CNXs for free in the [Crynux Discord](https://discord.gg/y8YKxb7uZk) as well.

Crynux Bridge is fully open-sourced on [GitHub](https://github.com/crynux-ai/crynux-bridge). A step-by-step guide for starting a Crynux Bridge instance is available in the following document:

{% content-ref url="../crynux-bridge.md" %}
[crynux-bridge.md](../crynux-bridge.md)
{% endcontent-ref %}

## Method 3: Sending Tasks Directly to the Blockchain

You can bypass the Crynux Bridge entirely and interact directly with the blockchain and Crynux Relay to send fine-tuning tasks. Crynux SDKs are available in various languages and can be embedded directly into your code to run fine-tuning tasks. Please consult the Crynux SDK documentation for detailed usage instructions:

{% content-ref url="../crynux-sdk.md" %}
[crynux-sdk.md](../crynux-sdk.md)
{% endcontent-ref %} 