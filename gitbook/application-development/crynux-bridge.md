---
description: Deploy Crynux Bridge for Applications
---

# Crynux Bridge

Crynux Bridge is middleware that connects traditional applications to the Crynux Network. It simplifies using the Crynux Network for applications by handling all complex interactions with the Crynux Network. The application only needs to interact with the Crynux Bridge by sending task parameters and waiting for the result images or texts.

More specifically, the Crynux Bridge:

1. Manages the application wallet, signs the underlying transactions and API requests.
2. Interacts with the blockchain and Relay to execute the entire task workflow.
3. Provides simpler APIs to the application to execute tasks using only the task parameters(no blockchain transactions or signatures).

Check out this simple webpage that lets users create images from text prompts. Tasks are sent to the Crynux Bridge API, and the generated image is returned:

{% embed url="https://codepen.io/Luke-Weber/pen/ExBqGrK" %}

The next sections provide step-by-step guide to deploy the Crynux Bridge and connect it to your application.

## Get the Docker Compose Files

The Docker Compose files are located in the `build` folder of the Crynux Bridge project:

{% embed url="https://github.com/crynux-ai/crynux-bridge/tree/main/build" %}

Download the folder to the deployment server, or clone the whole project:

```sh
$ git clone https://github.com/crynux-ai/crynux-bridge.git
$ cd build
```

## Application Wallet Configuration

The application wallet's private key will be loaded from a file in the build folder and stored as Docker secrets. For security, this file can be deleted once the container is created. Ensure to back up the private key, as it will be required again if the container needs to be recreated.

Create a file named `privkey.txt` and paste the private key into the file. The private key should be a hex string prefixed with `0x`.

```sh
# Inside the build folder

$ cat "0xabcd...23cd" >> privkey.txt
```

## Database Configuration

Crynux Bridge relies on a database to store data. A MySQL instance is configured in the Docker Compose file by default.

If the default configuration meets your needs, no further action is required. If you need to use another database instance, remove the service section of MySQL in the `docker-compose.yml` file, and modify `config/config.yml` to use another database instance:

```yaml
# config/config.yml

db:
  driver: "mysql"
  connection: "crynux_bridge:crynuxbridgepass@(mysql:3306)/crynux_bridge?parseTime=true"
  log:
    level: "info"
    output: "/app/data/logs/crynux_bridge_db.log"
    max_file_size: 100
    max_days: 30
    max_file_num: 5
```

## Start the Docker Container

In the build folder, run the following command to start the containers:

```sh
# Inside the build folder

$ docker compose up -d
```

## Use the Crynux Bridge APIs

### Getting Started

To start using the Crynux Bridge APIs, follow these steps:


#### 1. Creating an API Key

By sending requests to create an API key, you need to sign the request with your private key used to start the bridge. All API key management endpoints require signed requests for security. Here's how the signing works:

1. Create a request input object with required parameters
2. Convert the input object to a JSON string (with sorted keys)
3. Concatenate the JSON string with the timestamp
4. Calculate the keccak256 hash of the concatenated string
5. Sign the hash with your private key

Here's an example of the signing process:

{% tabs %}
{% tab title="Python" %}
```python
from eth_account import Account
from web3 import Web3
import json
import time

class Signer:
    def __init__(self, privkey: str):
        self.account = Account.from_key(privkey)

    def sign(self, input_dict, timestamp=None):
        if timestamp is None:
            timestamp = int(time.time())
            
        # Sort keys and convert to JSON string
        input_bytes = json.dumps(
            input_dict, 
            ensure_ascii=False, 
            separators=(",", ":"), 
            sort_keys=True
        ).encode("utf-8")
        
        # Convert timestamp to bytes
        t_bytes = str(timestamp).encode("utf-8")
        
        # Calculate hash
        data_hash = Web3.keccak(input_bytes + t_bytes)
        
        # Sign the hash
        signature = self.account.signHash(data_hash).signature
        signature = bytearray(signature)
        signature[-1] -= 27
        
        return timestamp, "0x" + signature.hex()
```
{% endtab %}

{% tab title="JavaScript" %}
```javascript
class Signer {
    constructor(privkey) {
        if (!privkey.startsWith('0x')) {
            throw new Error("Private key must be a hex string prefixed with '0x'.");
        }
        this.signKey = new ethers.utils.SigningKey(privkey);
    }

    async sign(inputDict) {
        const timestamp = Math.floor(Date.now() / 1000);

        const sortedKeys = Object.keys(inputDict).sort();
        // Ensure separators are (",", ":") and ensure_ascii=false equivalent by default in JS
        const inputStr = JSON.stringify(inputDict, sortedKeys);

        const inputBytes = new TextEncoder().encode(inputStr);
        const tBytes = new TextEncoder().encode(String(timestamp));

        // Concatenate bytes
        const dataBytes = new Uint8Array([...inputBytes, ...tBytes]);
        
        // Convert bytes to hex string
        const dataHex = ethers.utils.hexlify(dataBytes);
        
        // Calculate keccak256 hash of the data
        const dataHash = ethers.utils.keccak256(dataHex);
        
        // Sign the data
        const signature = this.signKey.signDigest(dataHash);
        
        // Convert signature to Uint8Array and adjust the last byte
        const sigHex = ethers.utils.joinSignature(signature); // Remove '0x' prefix
        const sigBytes = ethers.utils.arrayify(sigHex);
        sigBytes[64] = sigBytes[64] - 27;
        
        return [timestamp, ethers.utils.hexlify(sigBytes)];
    }
}
```
{% endtab %}
{% endtabs %}

Only the root account (bridge account) can create new API keys. Here's how to create one:

{% tabs %}
{% tab title="Python" %}
```python
# Initialize the root signer with the root private key
root_signer = Signer(root_privkey)

# Create API key
create_api_key_input = {}
timestamp, signature = root_signer.sign(create_api_key_input)

response = client.post(
    "/v1/api_key",
    json={"timestamp": timestamp, "signature": signature}
)

api_key = response.json()["data"]["api_key"]
expires_at = response.json()["data"]["expires_at"]
```
{% endtab %}

{% tab title="JavaScript" %}
```javascript
// Initialize the root signer with the root private key
const rootSigner = new Signer(rootPrivkey);

// Create API key
async function createApiKey() {
    const createApiKeyInput = {};
    const [timestamp, signature] = await rootSigner.sign(createApiKeyInput);

    const response = await fetch('/v1/api_key', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            timestamp: timestamp,
            signature: signature
        })
    });

    const result = await response.json();
    const apiKey = result.data.api_key;
    const expiresAt = result.data.expires_at;
    
    return { apiKey, expiresAt };
}
```
{% endtab %}
{% endtabs %}

#### 2. Adding Roles to API Key

API keys can be assigned different roles to control access to different features:

- `chat`: Access to LLM APIs
- `image`: Access to image generation API

Only the root account (bridge account) can add roles to other API key.

{% tabs %}
{% tab title="Python" %}
```python
# Initialize the root signer
root_signer = Signer(root_privkey)

# Add chat role
role_input = {
    "api_key": api_key,
    "role": "chat"
}
timestamp, signature = root_signer.sign(role_input)

response = client.post(
    f"/v1/api_key/{api_key}/role",
    json={
        "timestamp": timestamp, 
        "signature": signature,
        "role": "chat"
    }
)
```
{% endtab %}

{% tab title="JavaScript" %}
```javascript
// Initialize the root signer
const rootSigner = new Signer(rootPrivkey);

// Add role to API key
async function addRole(apiKey, role) {
    const roleInput = {
        api_key: apiKey,
        role: role
    };
    const [timestamp, signature] = await rootSigner.sign(roleInput);

    const response = await fetch(`/v1/api_key/${apiKey}/role`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            timestamp: timestamp,
            signature: signature,
            role: role
        })
    });

    return response.json();
}

// Example: Add chat role
await addRole(apiKey, 'chat');
```
{% endtab %}
{% endtabs %}

#### 3. Setting Usage Limits

You can set two types of limits for API keys:

1. Use limit: Total number of requests allowed
2. Rate limit: Requests allowed per minute

Only the root account (bridge account) can set usage limits of other API keys.

{% tabs %}
{% tab title="Python" %}
```python
# Set use limit to 1000 requests
use_limit_input = {
    "api_key": api_key,
    "use_limit": 1000
}
timestamp, signature = root_signer.sign(use_limit_input)

response = client.post(
    f"/v1/api_key/{api_key}/use_limit",
    json={
        "timestamp": timestamp,
        "signature": signature,
        "use_limit": 1000
    }
)

# Set rate limit to 6 requests per minute
rate_limit_input = {
    "api_key": api_key,
    "rate_limit": 6
}
timestamp, signature = root_signer.sign(rate_limit_input)

response = client.post(
    f"/v1/api_key/{api_key}/rate_limit",
    json={
        "timestamp": timestamp,
        "signature": signature,
        "rate_limit": 6
    }
)
```
{% endtab %}

{% tab title="JavaScript" %}
```javascript
// Set use limit
async function setUseLimit(apiKey, useLimit) {
    const useLimitInput = {
        api_key: apiKey,
        use_limit: useLimit
    };
    const [timestamp, signature] = await rootSigner.sign(useLimitInput);

    const response = await fetch(`/v1/api_key/${apiKey}/use_limit`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            timestamp: timestamp,
            signature: signature,
            use_limit: useLimit
        })
    });

    return response.json();
}

// Set rate limit
async function setRateLimit(apiKey, rateLimit) {
    const rateLimitInput = {
        api_key: apiKey,
        rate_limit: rateLimit
    };
    const [timestamp, signature] = await rootSigner.sign(rateLimitInput);

    const response = await fetch(`/v1/api_key/${apiKey}/rate_limit`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            timestamp: timestamp,
            signature: signature,
            rate_limit: rateLimit
        })
    });

    return response.json();
}

// Example: Set limits
await setUseLimit(apiKey, 1000);
await setRateLimit(apiKey, 6);
```
{% endtab %}
{% endtabs %}

#### 4. Using the APIs

Once you have created and configured your API key, you can start using the APIs. Here are examples for both LLM and SD APIs:

##### Using the LLM API

{% tabs %}
{% tab title="Python" %}
```python
import requests
import json

# API configuration
API_URL = "https://bridge.crynux.ai/v1/llm/chat/completions"
API_KEY = "your-api-key-here"  # Replace with your API key

# Request headers
headers = {
    "Authorization": f"Bearer {API_KEY}",
    "Content-Type": "application/json"
}

# Request payload
payload = {
    "model": "Qwen/Qwen2.5-7B",
    "messages": [
        {
            "role": "user",
            "content": "What is the capital of France?"
        }
    ],
    "stream": False
}

# Make the request
response = requests.post(
    API_URL,
    headers=headers,
    json=payload,
    timeout=180
)

# Print the response
print(response.json())
```
{% endtab %}

{% tab title="JavaScript" %}
```javascript
async function getChatCompletion() {
    try {
        const API_URL = "https://bridge.crynux.ai/v1/llm/chat/completions";
        const API_KEY = "your-api-key-here";  // Replace with your API key

        const response = await fetch(API_URL, {
            method: "POST",
            headers: {
                "Authorization": `Bearer ${API_KEY}`,
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                model: "Qwen/Qwen2.5-7B",
                messages: [
                    {
                        role: "user",
                        content: "What is the capital of France?"
                    }
                ],
                stream: false
            })
        });

        const data = await response.json();
        console.log(data);
    } catch (error) {
        console.error("Error:", error);
    }
}

getChatCompletion();
```
{% endtab %}
{% endtabs %}

##### Using the SD API

{% tabs %}
{% tab title="Python" %}
```python
import requests
import json

# API configuration
API_URL = "https://bridge.crynux.ai/v1/sd/images/generations"
API_KEY = "your-api-key-here"  # Replace with your API key

# Request headers
headers = {
    "Authorization": f"Bearer {API_KEY}",
    "Content-Type": "application/json"
}

# Request payload
payload = {
    "model": "crynux-ai/sdxl-turbo",
    "prompt": "A beautiful sunset over a calm ocean",
    "n": 1,
    "size": "512x512"
}

# Make the request
response = requests.post(
    API_URL,
    headers=headers,
    json=payload,
    timeout=180
)

# Print the response
print(response.json())
```
{% endtab %}

{% tab title="JavaScript" %}
```javascript
async function generateImage() {
    try {
        const API_URL = "https://bridge.crynux.ai/v1/sd/images/generations";
        const API_KEY = "your-api-key-here";  // Replace with your API key

        const response = await fetch(API_URL, {
            method: "POST",
            headers: {
                "Authorization": `Bearer ${API_KEY}`,
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                model: "crynux-ai/sdxl-turbo",
                prompt: "A beautiful sunset over a calm ocean",
                n: 1,
                size: "512x512"
            })
        });

        const data = await response.json();
        console.log(data);
    } catch (error) {
        console.error("Error:", error);
    }
}

generateImage();
```
{% endtab %}
{% endtabs %}

For detailed information about available parameters and models, refer to the OpenAPI specification at `/openapi.json` or browse the interactive documentation at `/static/api_docs.html`.


### LLM API

The Crynux Bridge provides OpenAI-compatible LLM APIs that support both chat completions and text completions. These APIs allow you to interact with various Large Language Models (LLMs) in a conversational manner.

#### Chat Completions API

The chat completions API (`/v1/llm/chat/completions`) supports the following key parameters:

- `model`: The model to use (e.g., "Qwen/Qwen2.5-7B")
- `messages`: An array of message objects with `role` and `content`
- `temperature`: Controls randomness in the output (range: 0.0 to 2.0)
- `max_tokens`: Maximum number of tokens to generate
- `top_p`: Nucleus sampling parameter (range: 0.0 to 1.0)
- `top_k`: Top-k sampling parameter (range: 1 to Infinity)
- `min_p`: Minimum probability threshold (range: 0.0 to 1.0)
- `repetition_penalty`: Penalty for repeating tokens (range: 0.0 to 2.0)
- `frequency_penalty`: Penalty for frequent tokens (range: -2.0 to 2.0)
- `presence_penalty`: Penalty for token presence (range: -2.0 to 2.0)
- `seed`: Seed for deterministic outputs
- `n`: Number of completions to generate (default: 1)
- `stream`: Whether to stream the response (default: false)
- `stop`: Array of strings that stop generation when encountered


The response includes:
- `id`: Unique identifier for the completion
- `created`: Timestamp of when the completion was created
- `model`: The model used for generation
- `choices`: Array of generated completions, each containing:
  - `message`: The generated message with role and content
  - `index`: The index of the completion
  - `finish_reason`: Why the generation stopped
  - `tool_calls`: Optional array of tool calls if tools were used
- `usage`: Token usage statistics

#### Text Completions API

The text completions API (`/v1/llm/completions`) provides a simpler interface for non-chat use cases. It's ideal for tasks like text completion, summarization, or single-turn text generation. The API supports the following key parameters:

- `model`: The model to use (e.g., "Qwen/Qwen2.5-7B")
- `prompt`: The text prompt to generate a completion for
- `temperature`: Controls randomness in the output (range: 0.0 to 2.0)
- `max_tokens`: Maximum number of tokens to generate
- `top_p`: Nucleus sampling parameter (range: 0.0 to 1.0)
- `top_k`: Top-k sampling parameter (range: 1 to Infinity)
- `min_p`: Minimum probability threshold (range: 0.0 to 1.0)
- `repetition_penalty`: Penalty for repeating tokens (range: 0.0 to 2.0)
- `frequency_penalty`: Penalty for frequent tokens (range: -2.0 to 2.0)
- `presence_penalty`: Penalty for token presence (range: -2.0 to 2.0)
- `seed`: Seed for deterministic outputs
- `n`: Number of completions to generate (default: 1)
- `stream`: Whether to stream the response (default: false)
- `stop`: Array of strings that stop generation when encountered


The response includes:
- `id`: Unique identifier for the completion
- `created`: Timestamp of when the completion was created
- `model`: The model used for generation
- `choices`: Array of generated completions, each containing:
  - `text`: The generated text
  - `index`: The index of the completion
  - `finish_reason`: Why the generation stopped
- `usage`: Token usage statistics

### SD API

The Crynux Bridge provides an OpenAI-compatible image generation API that uses Stable Diffusion models. The API (`/v1/sd/images/generations`) supports the following key parameters:

- `model`: The model to use (default: "crynux-ai/sdxl-turbo")
- `prompt`: Text description of the desired image
- `n`: Number of images to generate (default: 1)
- `size`: Image dimensions (default: "512x512", options: "256x256", "512x512", "1024x1024")
- `response_format`: Response format (default: "b64_json")
- `output_format`: Image format (default: "png")


The response includes:
- `created`: Timestamp of when the image was generated
- `data`: Array of generated images, each containing:
  - `b64_json`: Base64-encoded image data
  - `url`: URL to the generated image (if response_format is "url")
  - `revised_prompt`: The prompt after any automatic modifications
- `usage`: Token usage statistics

### The OpenAPI Specification

The description of the APIs can be accessed as the OpenAPI Specification on the started Crynux Bridge instance. Assume the IP address of the instance is 192.168.1.2, the JSON schema of the specification can be accessed at:

```
http://192.168.1.2/openapi.json
```

And a human readable documentation can be accessed at:

```
http://192.168.1.2/static/api_docs.html
```

As an example, the URLs of the Crynux Bridge used by the showcase applications online are:

{% embed url="https://api_ig.crynux.ai/openapi.json" %}

{% embed url="https://api_ig.crynux.ai/static/api_docs.html" %}

### API List

#### Chat completions API

{% swagger src="https://api_ig.crynux.ai/openapi.json" path="/v1/llm/chat/completions" method="post" %}
[https://api_ig.crynux.ai/openapi.json](https://api_ig.crynux.ai/openapi.json)
{% endswagger %}

{% swagger src="https://api_ig.crynux.ai/openapi.json" path="/v1/llm/completions" method="post" %}
[https://api_ig.crynux.ai/openapi.json](https://api_ig.crynux.ai/openapi.json)
{% endswagger %}

#### Image generation API

{% swagger src="https://api_ig.crynux.ai/openapi.json" path="/v1/sd/images/generations" method="post" %}
[https://api_ig.crynux.ai/openapi.json](https://api_ig.crynux.ai/openapi.json)
{% endswagger %}

#### API key related API

{% swagger src="https://api_ig.crynux.ai/openapi.json" path="/v1/api_key/{client_id}" method="post" %}
[https://api_ig.crynux.ai/openapi.json](https://api_ig.crynux.ai/openapi.json)
{% endswagger %}

{% swagger src="https://api_ig.crynux.ai/openapi.json" path="/v1/api_key/{client_id}" method="delete" %}
[https://api_ig.crynux.ai/openapi.json](https://api_ig.crynux.ai/openapi.json)
{% endswagger %}

{% swagger src="https://api_ig.crynux.ai/openapi.json" path="/v1/api_key/{client_id}/role" method="post" %}
[https://api_ig.crynux.ai/openapi.json](https://api_ig.crynux.ai/openapi.json)
{% endswagger %}

{% swagger src="https://api_ig.crynux.ai/openapi.json" path="/v1/api_key/{client_id}/use_limit" method="post" %}
[https://api_ig.crynux.ai/openapi.json](https://api_ig.crynux.ai/openapi.json)
{% endswagger %}

{% swagger src="https://api_ig.crynux.ai/openapi.json" path="/v1/api_key/{client_id}/rate_limit" method="post" %}
[https://api_ig.crynux.ai/openapi.json](https://api_ig.crynux.ai/openapi.json)
{% endswagger %}

#### Others

{% swagger src="https://api_ig.crynux.ai/openapi.json" path="/v1/application/wallet/balance" method="get" %}
[https://api_ig.crynux.ai/openapi.json](https://api_ig.crynux.ai/openapi.json)
{% endswagger %}

{% swagger src="https://api_ig.crynux.ai/openapi.json" path="/v1/inference_tasks" method="post" %}
[https://api_ig.crynux.ai/openapi.json](https://api_ig.crynux.ai/openapi.json)
{% endswagger %}

{% swagger src="https://api_ig.crynux.ai/openapi.json" path="/v1/inference_tasks/{client_id}/{task_id}" method="get" %}
[https://api_ig.crynux.ai/openapi.json](https://api_ig.crynux.ai/openapi.json)
{% endswagger %}

{% swagger src="https://api_ig.crynux.ai/openapi.json" path="/v1/inference_tasks/{client_id}/{task_id}/images/{image_num}" method="get" %}
[https://api_ig.crynux.ai/openapi.json](https://api_ig.crynux.ai/openapi.json)
{% endswagger %}

{% swagger src="https://api_ig.crynux.ai/openapi.json" path="/v1/models/base" method="get" %}
[https://api_ig.crynux.ai/openapi.json](https://api_ig.crynux.ai/openapi.json)
{% endswagger %}

{% swagger src="https://api_ig.crynux.ai/openapi.json" path="/v1/models/lora" method="get" %}
[https://api_ig.crynux.ai/openapi.json](https://api_ig.crynux.ai/openapi.json)
{% endswagger %}

{% swagger src="https://api_ig.crynux.ai/openapi.json" path="/v1/network/nodes" method="get" %}
[https://api_ig.crynux.ai/openapi.json](https://api_ig.crynux.ai/openapi.json)
{% endswagger %}
