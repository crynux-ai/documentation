---
description: The OpenAPI specification of the Relay
---

# API Specification of the Relay

## Resources

The JSON schema of the OpenAPI Specification of the Relay can be found at:

{% embed url="https://dy.relay.crynux.ai/openapi.json" %}

The rendered document of the specification can be accessed at:

{% embed url="https://dy.relay.crynux.ai/static/api_docs.html" %}

## API List

### Task Related APIs

{% swagger src="https://dy.relay.crynux.ai/openapi.json" path="/v1/inference_tasks" method="post" %}
[https://dy.relay.crynux.ai/openapi.json](https://dy.relay.crynux.ai/openapi.json)
{% endswagger %}

{% swagger src="https://dy.relay.crynux.ai/openapi.json" path="/v1/inference_tasks/{task_id}" method="get" %}
[https://dy.relay.crynux.ai/openapi.json](https://dy.relay.crynux.ai/openapi.json)
{% endswagger %}

{% swagger src="https://dy.relay.crynux.ai/openapi.json" path="/v1/inference_tasks/{task_id}/results" method="post" %}
[https://dy.relay.crynux.ai/openapi.json](https://dy.relay.crynux.ai/openapi.json)
{% endswagger %}

{% swagger src="https://dy.relay.crynux.ai/openapi.json" path="/v1/inference_tasks/{task_id}/results/{image_num}" method="get" %}
[https://dy.relay.crynux.ai/openapi.json](https://dy.relay.crynux.ai/openapi.json)
{% endswagger %}

### Network Stats Related APIs

{% swagger src="https://dy.relay.crynux.ai/openapi.json" path="/v1/network" method="get" %}
[https://dy.relay.crynux.ai/openapi.json](https://dy.relay.crynux.ai/openapi.json)
{% endswagger %}

{% swagger src="https://dy.relay.crynux.ai/openapi.json" path="/v1/network/nodes/data" method="get" %}
[https://dy.relay.crynux.ai/openapi.json](https://dy.relay.crynux.ai/openapi.json)
{% endswagger %}

{% swagger src="https://dy.relay.crynux.ai/openapi.json" path="/v1/network/nodes/number" method="get" %}
[https://dy.relay.crynux.ai/openapi.json](https://dy.relay.crynux.ai/openapi.json)
{% endswagger %}

{% swagger src="https://dy.relay.crynux.ai/openapi.json" path="/v1/network/tasks/number" method="get" %}
[https://dy.relay.crynux.ai/openapi.json](https://dy.relay.crynux.ai/openapi.json)
{% endswagger %}

### Other APIs

{% swagger src="https://dy.relay.crynux.ai/openapi.json" path="/v1/now" method="get" %}
[https://dy.relay.crynux.ai/openapi.json](https://dy.relay.crynux.ai/openapi.json)
{% endswagger %}
