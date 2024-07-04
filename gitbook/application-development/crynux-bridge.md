---
description: Deploy Crynux Bridge for Applications
---

# Crynux Bridge

Crynux Bridge is middleware that connects traditional applications to the Crynux Network. It simplifies using the Crynux Network for applications by handling all complex interactions with the Crynux Network. The application only needs to interact with the Crynux Bridge by sending task parameters and waiting for the result images or texts.

More specifically, the Crynux Bridge:

1. Manages the application wallet, signs the underlying transactions and API requests.
2. Interacts with the blockchain and Relay to execute the entire task workflow.
3. Provides simpler APIs to the application to execute tasks using only the task parameters(no blockchain transactions or signatures).

This document provides a step-by-step guide to deploy the Crynux Bridge and connect it to your application.

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

The application can utilize the APIs of the Crynux Bridge to send tasks and receive results. The description of the APIs can be accessed as the OpenAPI Specification on the started Crynux Bridge instance. Assume the IP address of the instance is 192.168.1.2, the JSON schema of the specification can be accessed at:

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
