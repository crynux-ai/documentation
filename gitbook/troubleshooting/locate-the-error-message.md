---
description: Find out what exactly goes wrong
---

# Locate the Error Message

## Locate the log file

{% tabs %}
{% tab title="Windows" %}
Go to the directory where you click `Crynux Node.exe`, there is a sub directory with name `logs`, the log file can be found inside with name `crynux-server.log`.
{% endtab %}

{% tab title="Mac" %}
Open a Finder window, go to the `Applications` folder, right click on the `Crynux Node.app`  and select `Show Package Content`, then go to the folder `Contents/Resources/logs`, and the log file is located inside as `crynux-server.log`.
{% endtab %}

{% tab title="Docker" %}
### Find the logs in the container output

Find the container name of the Crynux Node:

```bash
$ docker ps
```

The output should be similar to:



In a terminal, type in the following command:

```bash
$ docker logs {container_name}
```

If you want to save the logs to file, use the following command:

```bash
$ docker logs {container_name} >> crynux.log
```

### Find the log file inside the container


{% endtab %}

{% tab title="Linux" %}
If you downloaded the binary release version of Linux server, the config file `config.yml` can be found in the `config` folder of the project root.
{% endtab %}

{% tab title="Source Code" %}
The log file is located at `logs/crynux_server.log`, relative to the project root folder.
{% endtab %}
{% endtabs %}

## Locate the error message

