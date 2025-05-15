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

### API Key Management

The Crynux Bridge uses API keys for authentication and access control. Each API key is associated with specific roles and usage limits. Here's how to manage API keys:

#### Request Signing

Before diving into the API key management, it's important to understand the request signing mechanism. All API key management endpoints require signed requests for security. Here's how the signing works:

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
import Web3 from 'web3';

class Signer {
    constructor(privkey) {
        this.web3 = new Web3();
        this.account = this.web3.eth.accounts.privateKeyToAccount(privkey);
    }

    async sign(inputDict, timestamp = null) {
        if (timestamp === null) {
            timestamp = Math.floor(Date.now() / 1000);
        }

        // Sort keys and convert to JSON string
        const inputStr = JSON.stringify(inputDict, Object.keys(inputDict).sort());
        
        // Convert to bytes
        const inputBytes = new TextEncoder().encode(inputStr);
        const timestampBytes = new TextEncoder().encode(timestamp.toString());
        
        // Concatenate bytes
        const dataBytes = new Uint8Array([...inputBytes, ...timestampBytes]);
        
        // Calculate hash
        const dataHash = this.web3.utils.keccak256(dataBytes);
        
        // Sign the hash
        const signature = this.account.sign(dataHash);
        let sigBytes = Buffer.from(signature.signature.slice(2), 'hex');
        sigBytes[64] = sigBytes[64] - 27;
        
        return [timestamp, '0x' + sigBytes.toString('hex')];
    }
}
```
{% endtab %}
{% endtabs %}

#### Creating an API Key

To create a new API key, you need to sign a request with the account's private key. The API key will be associated with the account address (client_id). Here's an example:

{% tabs %}
{% tab title="Python" %}
```python
# Initialize the signer with your private key
signer = Signer(privkey)

# Prepare the request input
create_api_key_input = {"client_id": address}
timestamp, signature = signer.sign(create_api_key_input)

# Send the request
response = client.post(
    f"/v1/api_key/{address}",
    json={"timestamp": timestamp, "signature": signature}
)

api_key = response.json()["data"]["api_key"]
expires_at = response.json()["data"]["expires_at"]
```
{% endtab %}

{% tab title="JavaScript" %}
```javascript
// Initialize the signer with your private key
const signer = new Signer(privkey);

// Create API key
async function createApiKey(address) {
    const createApiKeyInput = { client_id: address };
    const [timestamp, signature] = await signer.sign(createApiKeyInput);

    const response = await fetch(`/v1/api_key/${address}`, {
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

#### Adding Roles to API Key

API keys can be assigned different roles to control access to different features. The available roles are "chat" for LLM API access and "image" for image generation API access. Only the bridge account (root account) can add roles:

{% tabs %}
{% tab title="Python" %}
```python
# Initialize the root signer
root_signer = Signer(root_privkey)

# Add chat role
role_input = {
    "client_id": address,
    "role": "chat"
}
timestamp, signature = root_signer.sign(role_input)

response = client.post(
    f"/v1/api_key/{address}/role",
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
async function addRole(address, role) {
    const roleInput = {
        client_id: address,
        role: role
    };
    const [timestamp, signature] = await rootSigner.sign(roleInput);

    const response = await fetch(`/v1/api_key/${address}/role`, {
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
await addRole(address, 'chat');
```
{% endtab %}
{% endtabs %}

#### Setting Usage Limits

You can set two types of limits for API keys:

1. Use limit: The total number of times an API key can be used
2. Rate limit: The number of requests allowed per minute

Both limits can only be set by the bridge account:

{% tabs %}
{% tab title="Python" %}
```python
# Set use limit to 1000 requests
use_limit_input = {
    "client_id": address,
    "use_limit": 1000
}
timestamp, signature = root_signer.sign(use_limit_input)

response = client.post(
    f"/v1/api_key/{address}/use_limit",
    json={
        "timestamp": timestamp,
        "signature": signature,
        "use_limit": 1000
    }
)

# Set rate limit to 6 requests per minute
rate_limit_input = {
    "client_id": address,
    "rate_limit": 6
}
timestamp, signature = root_signer.sign(rate_limit_input)

response = client.post(
    f"/v1/api_key/{address}/rate_limit",
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
async function setUseLimit(address, useLimit) {
    const useLimitInput = {
        client_id: address,
        use_limit: useLimit
    };
    const [timestamp, signature] = await rootSigner.sign(useLimitInput);

    const response = await fetch(`/v1/api_key/${address}/use_limit`, {
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
async function setRateLimit(address, rateLimit) {
    const rateLimitInput = {
        client_id: address,
        rate_limit: rateLimit
    };
    const [timestamp, signature] = await rootSigner.sign(rateLimitInput);

    const response = await fetch(`/v1/api_key/${address}/rate_limit`, {
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
await setUseLimit(address, 1000);
await setRateLimit(address, 6);
```
{% endtab %}
{% endtabs %}

The API key will be rejected when either the use limit is exceeded or the rate limit is reached. Make sure to set appropriate limits based on your application's needs.

### Using the APIs

The Crynux Bridge provides OpenAI-compatible APIs for both chat completions and image generation. This means you can use these APIs with the OpenAI SDK or make direct HTTP requests. Below are examples of both approaches.

#### Chat Completions API

The chat completions API allows you to interact with Large Language Models (LLMs) in a conversational manner. Here's how to use it:

{% tabs %}
{% tab title="Python" %}
```python
from openai import OpenAI

# Initialize the client
client = OpenAI(
    base_url="https://bridge.crynux.ai/v1/llm",
    api_key="your-api-key-here",  # Replace with your API key
    timeout=180,
    max_retries=1,
)

# Make a chat completion request
response = client.chat.completions.create(
    model="Qwen/Qwen2.5-7B",  # Specify the model to use
    messages=[
        {
            "role": "user",
            "content": "What is the capital of France?",
        },
    ],
    stream=False
)

print(response)
```
{% endtab %}

{% tab title="JavaScript" %}
```javascript
import OpenAI from "openai";

async function getChatCompletion() {
    try {
        // Initialize the client
        const client = new OpenAI({
            baseURL: "https://bridge.crynux.ai/v1/llm",
            apiKey: "your-api-key-here",  // Replace with your API key
            timeout: 180000,  // 180 seconds
            maxRetries: 1,
        });

        // Make a chat completion request
        const completion = await client.chat.completions.create({
            model: "Qwen/Qwen2.5-7B",  // Specify the model to use
            messages: [
                {
                    role: "user",
                    content: "What is the capital of France?",
                },
            ],
            stream: false,
        });

        console.log(completion);
    } catch (error) {
        console.error("Error:", error);
    }
}

getChatCompletion();
```
{% endtab %}
{% endtabs %}

#### Image Generation API

The image generation API allows you to create images from text descriptions using Stable Diffusion models. Here's how to use it:

{% tabs %}
{% tab title="Python" %}
```python
from openai import OpenAI

# Initialize the client
client = OpenAI(
    base_url="https://bridge.crynux.ai/v1/sd",
    api_key="your-api-key-here",  # Replace with your API key
    timeout=180,
    max_retries=1,
)

# Generate images
response = client.images.generate(
    model="crynux-ai/sdxl-turbo",  # Specify the model to use
    prompt="A beautiful sunset over a calm ocean",
    n=1,  # Number of images to generate
    size="512x512"  # Image dimensions
)

print(response)
```
{% endtab %}

{% tab title="JavaScript" %}
```javascript
import OpenAI from "openai";

async function generateImage() {
    try {
        // Initialize the client
        const client = new OpenAI({
            baseURL: "https://bridge.crynux.ai/v1/sd",
            apiKey: "your-api-key-here",  // Replace with your API key
            timeout: 180000,  // 180 seconds
            maxRetries: 1,
        });

        // Generate images
        const response = await client.images.generate({
            model: "crynux-ai/sdxl-turbo",  // Specify the model to use
            prompt: "A beautiful sunset over a calm ocean",
            n: 1,  // Number of images to generate
            size: "512x512"  // Image dimensions
        });

        console.log(response);
    } catch (error) {
        console.error("Error:", error);
    }
}

generateImage();
```
{% endtab %}
{% endtabs %}

Both APIs support various parameters and options to customize the output. For detailed information about available parameters and models, refer to the OpenAPI specification at `/openapi.json` or browse the interactive documentation at `/static/api_docs.html`.

