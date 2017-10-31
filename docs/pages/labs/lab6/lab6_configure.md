---
title: Configure Secure Gateway Client 
toc: false
sidebar: labs_sidebar
folder: labs/lab6
permalink: /lab6_configure.html
summary: Before we can communicate with our loopback service from Bluemix Cloud, we will need a Secure Gateway to access our service locally.
applies_to: [developer]
---
 

## Within the Bluemix Cloud Manager

1. We first log into our Bluemix Region where API Connect is provisioned and navigate to the Admin section. From there we will select the Secure Gateways tab and click the “Add” link to created our first Secure Gateway.

    ![](./images/captures/sg-admin.png)

1. Click the “Add” link to create our first Secure Gateway.

    ![](./images/captures/cloud-admin.png)

1. Give it a name and click Save

![](./images/captures/create-sg.png)

1. After creating the gateway we need to set up the Secure Gateway client. This will be our connection between the on-premise API and API Connect. From the Secure Gateway Tab we will select the “Set Up” link.

    ![](./images/captures/secure-gateway.png)

1. This will bring up the page to download the Secure Gateway Client. Select the installer you wish to use and copy the ID and token for the gateway.

    ![](./images/captures/setup-gateway.png)


## Install Client Locally on your Machine

Follow the following guides to complete the installation of the Secure Gateway Client for the following Platforms. 

+ [Using Linux as client](https://console.bluemix.net/docs/services/SecureGateway/sg_025.html#sg_025){:target="blank"}
+ [Using Mac OS X as client](https://console.bluemix.net/docs/services/SecureGateway/sg_047.html#sg_047){:target="blank"}
+ [Using Microsoft Windows as client](https://console.bluemix.net/docs/services/SecureGateway/sg_053.html#sg_053){:target="blank"}
+ [Using Docker as client](https://console.bluemix.net/docs/services/SecureGateway/sg_003.html#sg_003){:target="blank"}

## Configure the ACL 

Once the install of the client is finished, you’ll need to ensure the hostname and port for the on-premise API is added to the Access Control List of the Secure Gateway Client. This can be accomplished via the Secure Gateway Client’s UI:

![](./images/captures/sg-dashboard.png)

Enter the ACL to allow localhost and the port for the local running loopback service. 

![](./images/captures/acl-client.png)

{% include warning.html content="Mac OS X Users may experience inactivity with the UI Dashboard.  Enter your acl in the terminal window where you started the service.
" %}

If you are on a Mac OSx, you may have to enter the following command in the terminal window if the UI is unresponsive.

```shell
    acl allow :
```
or 

```shell
    acl allow localhost:4001
```

## Continue

Proceed to [Testing API in Bluemix Cloud](lab6_testing.html).