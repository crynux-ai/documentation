---
description: The OpenAPI specifications
---

# API Specifications of the Relay

## Resources

The JSON schema of the OpenAPI Specifications of the Relay can be found at:

{% embed url="https://relay.h.crynux.ai/openapi.json" %}

The rendered documents of the specifications can also be accessed at:

{% embed url="https://relay.h.crynux.ai/static/api_docs.html" %}

## API List

#### Upload the task arguments to the Relay:

{% swagger src="https://relay.h.crynux.ai/openapi.json" path="/v1/inference_tasks" method="post" %}
[https://relay.h.crynux.ai/openapi.json](https://relay.h.crynux.ai/openapi.json)
{% endswagger %}

#### Get the the task arguments from the Relay:

{% swagger src="https://relay.h.crynux.ai/openapi.json" path="/v1/inference_tasks/{task_id}" method="get" %}
[https://relay.h.crynux.ai/openapi.json](https://relay.h.crynux.ai/openapi.json)
{% endswagger %}

#### Upload the images to the Relay:

{% swagger src="https://relay.h.crynux.ai/openapi.json" path="/v1/inference_tasks/{task_id}/results" method="post" %}
[https://relay.h.crynux.ai/openapi.json](https://relay.h.crynux.ai/openapi.json)
{% endswagger %}

#### Get the images from the Relay:

{% swagger src="https://relay.h.crynux.ai/openapi.json" path="/v1/inference_tasks/{task_id}/results/{image_num}" method="get" %}
[https://relay.h.crynux.ai/openapi.json](https://relay.h.crynux.ai/openapi.json)
{% endswagger %}

