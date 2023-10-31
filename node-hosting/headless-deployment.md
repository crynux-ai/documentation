---
description: Start the Node without Web UI
---

# Headless Deployment

The Hydrogen Network Node could be deployed on the server without using the WebUI. The node will automatically join the network at container startup, and quit the network before the container stops.

#### 1. Create the deployment folder for Docker compose

```sh
$ mkdir h_node
$ cd h_node
```

#### 2. Create the model cache folder and the config folder

```sh
$ mkdir config data
$ ls .
config/ data/
```

#### 3. Create the config file

An example config file could be found in the repository of the Node:



Create a file named `config.yml` inside the config folder, and copy the content of the example config file into it.

```sh
$ ls .
config/ data/

$ ls config/
config.yml
```

#### 4. Edit the config file

#### 5. Create `docker-compose.yml`&#x20;

Create docker-compose.yml inside the working directory. And mount the config folder and model caching folder to the local folders we just created:

```
---
version: "3.8"
name: "h_node"

services:
  h_node:
    image: ghcr.io/crynux-ai/h-node:latest
    container_name: h_node
    restart: unless-stopped
    ports:
      - "127.0.0.1:7412:7412"
    volumes:
      - "./data:/app/data"
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
