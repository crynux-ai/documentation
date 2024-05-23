---
description: How to run multiple nodes on a single device with multiple GPUs
---

# Assign GPU to the Node

If you have multiple GPUs in a single computer, you can optimize performance by starting multiple nodes on the computer and assigning each GPU to a different node.

To enable GPU assignment, use the Docker version of Crynux Node. For a guide on the basics of starting a Crynux Node as a Docker container, please refer to the tutorial below:

{% content-ref url="start-a-node-docker.md" %}
[start-a-node-docker.md](start-a-node-docker.md)
{% endcontent-ref %}

## Find the ID of the specific GPU

If you want to assign a specific GPU to a node, you must find the ID of the GPU first. This can be done using the `nvidia-smi` toolkit. Start a terminal and run the following command:

```
$ nvidia-smi
```

And you will get the output similar to the following:

<figure><img src="../.gitbook/assets/image (2).png" alt=""><figcaption></figcaption></figure>

Find the ID as highlighted in the image above. In this case, we have a single GPU installed in the computer, the ID of the GPU is `0`.&#x20;

## GPU assignment using Docker Compose

In the `docker-compose.yml` file, find the following section:

```
deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              capabilities: [gpu]
```

And add another line below:

```
deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              capabilities: [gpu]
              device_ids: ["0"]
```

## GPU assignment using command line

The GPU id could also be given to the container in the starting command. If you are starting the container using the following command before:

```
docker run -p 7412:7412 --name crynux_node --gpus all ghcr.io/crynux-ai/crynux-node:latest
```

You could change it to:

```
docker run -p 7412:7412 --name crynux_node --gpus '"device=0"' ghcr.io/crynux-ai/crynux-node:latest
```

The change is on the `--gpus` argument, from `all`, which provides all the GPUs to the container, to `'"device=0"'`, which provides only the GPU with id `0`.
