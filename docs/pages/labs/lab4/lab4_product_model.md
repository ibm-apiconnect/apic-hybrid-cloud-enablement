---
title: Create a Non Persisted Model
toc: false
sidebar: labs_sidebar
folder: labs/lab4
permalink: /lab4_product_model.html
summary: In this step, you will create the non persisted data model for our inventory items by creating a model called Product and connecting it to the already defined inventory items mdoel. LoopBack is a data model driven framework. Let's generate this model and a remote method to return the same data that GET /items returns.
applies_to: [developer]
---

 
## Generate a Non Persisted Model

{% include important.html content='
    Here is a helpful link to the Loopback CLI Guide that will give more information on all the possible CL options. <a href="https://loopback.io/doc/en/lb3/Command-line-tools.html" target="_blank">https://loopback.io/doc/en/lb3/Command-line-tools.html</a>
'%}

1.  For this step, let's drop down in the Command Line.  Open your Terminal/Command Prompt in the same folder as your loopback project.  

    ```shell
    apic edit
    ```

1.  On the bottom left-hand corner of the screen, locate and click on the `Run` button to start the `inventory` LoopBack application.

    ![](./images/labs/lab1/run.png)

1.  Wait a moment while the servers are started. Proceed to the next step when you see the following:

    ![](./images/labs/lab1/app-running.png)

1.  Once Started, click on the Application: link and it will spawn new browser window

    ![](./images/captures/designer-toolbar.png);
    
	
1.  The API Connect Toolkit will query the table structure of the MySQL data source and allow you to select the desired properties to build your data model from.

    Click on the `Select Properties` button.
    
    ![](./images/labs/lab1/select-model-properties.png)

1.  Keep the defaults and click on the `Select` button.

    ![](./images/labs/lab1/select-model-properties-2.png)

1.  Click on the `Generate` button to create a data model using the selected MySQL table properties.

## Continue

Proceed to [Verify the Microservice API](lab4_verify_api.html).