---
title: Register a Test App
toc: false
sidebar: labs_sidebar
folder: labs/lab2
permalink: /lab2_register_app.html
summary: API Connect enforces entitlement rules to ensure that consumers are allowed to access the API's that are being requested. The instructions below will guide you on registering your consumer application and subscribing it to an API Product.
applies_to: [consumer]
---

## Create a New Consumer Application

1.  Click on the `Apps` tab on the API Portal.

1.  Click on the `+ Create new App` button on the right side of the screen.

1.  Give your application the title `ThinkIBM Consumer`, then click on the `Submit` button.

    {% include note.html content="
        You do not have to provide a description or OAuth Redirect URI.
    " %}

## Save the Consumer Application Credentials

When your consumer application is registered in the IBM API Connect system, it is assigned a unique set of client credentials. These credentials are required to be provided on each API request in order for the system to validate your subscription entitlements.

1.  Click on the `Show Client Secret` button to reveal the secret code. Copy the code and save it to a text editor.

    ![](./images/labs/lab2/save-secret.png)

    {% include important.html content="
        The Client Secret is only provided to you once, at the time the consumer application is registered. You will need to keep the secret in a safe place. If it is lost, the only option is to reset the secret to obtain a new one.
    " %}

1.  Scroll down and find the Client ID. Click on the `Show` button next to the Client ID to reveal it.

    Copy the ID and save it to your text editor along side your Secret. Label them so you know which is which.

## Subscribe to the API Product

At this point, your registered consumer application has no entitlements. In order for it to be able to access an API resource, you must subscribe to a Product and Plan.

1.  Click on the `API Products` tab.

1.  Click on the `inventory 1.0.0` product.

1.  Click on the `Subscribe` button for the default plan that is listed.

1.  Select your application from the list and click on the `Subscribe` button.

## Continue

Now you have registered a new consuming application and subscribed it to an API Product.

Proceed to [Test the API](lab2_test_api.html).