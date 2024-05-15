# Proxy Settings

Sometimes a proxy is required to access Huggingface and Civitai in your network environment. Crynux Node supports to specify the proxy in the config file.

## Locate the config file

{% tabs %}
{% tab title="Windows" %}
Go to the directory where you click `Crynux Node.exe`, there is a sub directory with name `config`, the config file can be found inside with name `config.yml`.
{% endtab %}

{% tab title="Mac" %}
Open a Finder window, go to the `Applications` folder, right click on the `Crynux Node.app`  and select `Show Package Content`, then go to the folder `Contents/Resources/config`, and the config file is located inside as `config.yml`.
{% endtab %}

{% tab title="Docker" %}
**If you have mounted the config directory outside of the container**

find the config file `config.yml` in the mounted config directory on the host machine. Which should be `config` folder inside the project root, if you have followed the tutorial [Start a Node - Docker](start-a-node-docker.md).

**If you have not mounted the config directory**

the config file can be found inside the container as `/app/config/config.yml`.
{% endtab %}

{% tab title="Linux" %}
If you downloaded the binary release version of Linux server, the config file `config.yml` can be found in the `config` folder of the project root.
{% endtab %}

{% tab title="Source Code" %}
The config file is located at `config/config.yml`, relative to the project root folder.
{% endtab %}
{% endtabs %}

## Fill in the proxy settings

Open the `config.yml` file with a text editor, and find the section below:

```
---
task_config:
  proxy:
    host: '127.0.0.1'
    password: 'pass'
    port: 8080
    username: 'user'
```

Just fill in your proxy settings as shown, save the file, and restart the node.
