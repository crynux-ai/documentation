---
description: Start the Node without Web UI
---

# Headless Deployment

The Hydrogen Network Node could be deployed on the server without using the WebUI. The node will automatically join the network at container startup, and quit the network before the container stops.

{% hint style="info" %}
If the Node is started in the headless mode, the integrated API server will not be started. Which means the WebUI will not be accessible at all.
{% endhint %}

{% hint style="info" %}
In headless mode, the Node will try to quit the network when the terminate signal is received. The operation needs some time. So try not to kill the running container directly,  and wait for it to gracefully shutdown.
{% endhint %}

#### 1. Create the deployment folder for Docker compose

```sh
$ mkdir h_node
$ cd h_node
```

#### 2. Create the config folder

```sh
$ mkdir config
$ ls .
config/
```

#### 3. Create the config file

An example config file could be found in the repository of the Node:

{% embed url="https://github.com/crynux-ai/crynux-node/blob/main/config/config.yml.example" %}

Create a file named `config.yml` inside the config folder, and copy the content of the example config file into it.

```sh
$ ls .
config/

$ ls config/
config.yml
```

#### 4. Edit the config file

The private key must be provided inside the ethereum section:

```yaml
...

ethereum:
  privkey: "0x2738....69cf"
  provider: "https://block-node.crynux.ai/rpc"
  chain_id: 42
  gas: 42949670
  gas_price: 1

...
```

The headless mode must be enabled:

```yaml
...
headless: true
...
```

#### 5. Create `docker-compose.yml`&#x20;

Create `docker-compose.yml` inside the working directory:

```
$ ls .
config/ docker-compose.yml
```

And mount the config folder to the local folder we just created:

```yaml
---
version: "3.8"
name: "h_node"

services:
  h_node:
    image: ghcr.io/crynux-ai/h-node:latest
    container_name: h_node
    restart: unless-stopped
    volumes:
      - "./config:/app/config"
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              capabilities: [gpu]
```

#### 6. Start the Docker container

```sh
docker compose up -d
```

Now the node should start and join the network automatically.
