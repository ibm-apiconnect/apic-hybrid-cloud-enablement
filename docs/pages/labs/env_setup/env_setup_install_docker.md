---
title: Install Docker
toc: false
sidebar: labs_sidebar
folder: labs/env_setup
permalink: /env_setup_install_docker.html
summary: |-
    The API Connect Toolkit comes packaged with a Docker version of the API Gateway (DataPower) for testing full-featured policies locally on your workstation.
    <br/><br/>
    In order for you to be able to run the local API Gateway, you need to install Docker and make sure it's running.
applies_to: [developer]
---

## Install Docker

1.  Follow the instructions on the Docker website for your operating system to install the latest Docker **Community Edition**.

    [https://docs.docker.com/engine/installation/](https://docs.docker.com/engine/installation/){:target="_blank"}
    
1.  Run the following command in a terminal window to verify that Docker is running:

    ```bash
    docker ps
    ```
    
    {% include troubleshooting.html content="
        The above command will list any running containers. It's okay if the command shows no containers running at this time, as long as you do not see an error.
        <br/><br/>
        If you receive an error stating that there was no response from the Docker engine, follow these instructions to <a href=\"https://docs.docker.com/engine/admin/\" target=\"_blank\">Configure and troubleshoot the Docker daemon</a>
    " %}
    
1.  Make sure you have at least 4 GB of RAM that is available for Docker Containers, otherwise the Datapower Gateway container running locally will not start.  Follow the documentation for your respective host OS running docker for more information.

## Install Docker Compose

### Linux

1.  Linux users will need to install the `docker-compose` tool in addition to the core docker engine.

1.  Follow the instructions starting at Step 3 to [Install Docker Compose on Linux](https://docs.docker.com/compose/install/){:target="_blank"}.

### macOS and Windows

1.  Docker Compose is already included in the latest versions of Docker for macOS and Windows. 

## Continue

1.  Once you have verified that Docker is running, proceed to [Install the APIC Toolkit](env_setup_install_apic_toolkit.html).