---
title: Verify the Microservice API
toc: false
sidebar: labs_sidebar
folder: labs/lab1
permalink: /lab1_verify_api.html
summary: In this step, you will confirm that the API for your Inventory Microservice Application is working correctly. You will run the microservice application locally, invoke the API and view the responses from the data source.
applies_to: [developer]
---

## Update the API Assembly to use DataPower as an enforcement gateway

Your API Connect environment in Bluemix uses IBM DataPower to enforce API policies. You can test the API with a local version of the DataPower gateway running in Docker prior to publishing the API to the cloud.
 
1.  Click on the menu icon in the top left hand corner of the screen and select the `inventory` project to return to the API definitions section.

1.  Open the `inventory 1.0.0` API definition.

1.  Click on the `Assemble` tab to switch views.

1.  Select `DataPower Gateway Policies` from the palette on the left.

1.  Save the API definition.

    ![](./images/common/save.png)

## Test the Application and API locally

1.  On the bottom left-hand corner of the screen, locate and click on the `Run` button to start the `inventory` LoopBack application.

    ![](./images/labs/lab1/run.png)

1.  Wait a moment while the servers are started. Proceed to the next step when you see the following:

    ![](./images/labs/lab1/app-running.png)
    
    {% include note.html content="
        The run process will start your Node.js microservice application and a local Docker container version of the API Gateway (DataPower).
        <br/><br/>
        If this is your first time starting an application with a DataPower Gateway policy, the toolkit will need to download the docker image. The image is approximately 750Mb, so it will take a few minutes before you see the gateway service started in the toolkit UI.
        <br/><br/>
        If you would like to see the status of the Gateway server, run the following commands from a new terminal window: `docker images` and `docker ps -a`.
    " %}

1.  Click the `Explore` button to review your APIs. 

    ![](./images/labs/lab1/explore.png)

1.  On the left side of the page, notice the list of paths for the `inventory` API. These are the paths and operations that were automatically created for you by the LoopBack framework simply by generating the `item` data model. The operations allow users the ability to create, update, delete and query the data model from the connected data source.

1.  Click the `Item.find` operation.

    ![](./images/labs/lab1/item-find.png)

1.  By clicking the `Item.find` operation, your screen will auto-focus to the correct location in the window. In the center pane you will see a summary of the operation, as well as optional parameters and responses.

    On the right side you will see sample code for executing the API in various programming languages and tools such as cURL and an example response.

1.  Click on the `Try it` link to view the API test configuration screen.

    ![](./images/labs/lab1/try-it.png)

1. Click the `Call operation` button to invoke the API, scroll down to see the response.
    
    ![](./images/labs/lab1/call-operation.png)
    
    {% include troubleshooting.html content="
        The first time you invoke the API, you may receive an error. The error occurs because the browser does not trust the self-signed certificate from the MicroGateway. To resolve the error, click on the link in the response window and accept the certificate warning.
        <br/><br/>
        <img src=\"./images/labs/lab1/cors.png\"/>
        <br/><br/>
        Once complete, return to the API explorer and click on the `Call operation` button again.
    " %}

1.  Scroll down to see the `Request` and `Response` headers. 

    ```text
    Request
    GET https://localhost:4002/api/Items Headers:
    Content-Type: application/json
    Accept: application/json
    X-IBM-Client-Id: default
    X-IBM-Client-Secret: SECRET
    ```

    ```text
    Response
    Code: 200 OK Headers:
    x-ratelimit-remaining: 99
    content-type: application/json; charset=utf-8
    x-ratelimit-limit: 100
    ```

1.  Scroll further and the payload returned from the GET request is displayed.

    ```json
    [
      {
        "id": 1,
        "name": "Dayton Meat Chopper",
        "description": "Punched-card tabulating machines and ...",
        "img": "images/items/meat-chopper.jpg",
        "price": "4599.99"
      },
      ...
    ]
    ```

1.  Test the `Item.count` operation by following the same process above. You should receive a count of inventory items.

    ```json
    {
      "count": 12
    }
    ```

1.  Click on the `Stop` button to shut down the running application.

    ![](./images/labs/lab1/stop-application.png)

1.  Click on the `X` in the top-right portion of the screen to leave the API Explorer view.

    ![](./images/labs/lab1/leave-explorer.png)

## Continue

Proceed to Proceed to [Lab 2 - Run and Test your API in the Cloud](lab2_overview.html).

