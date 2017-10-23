---
title: Create the Inventory App
toc: false
sidebar: labs_sidebar
folder: labs/lab1
permalink: /lab1_create_app.html
summary:
    To create your Inventory Application you will use LoopBack technology that comes with the API Connect Developer Toolkit. LoopBack enables you to quickly compose scalable APIs, runs on top of the Express web framework and conforms to the Swagger 2.0 specification. LoopBack is a highly-extensible, open-source Node.js framework that enables you to:<br/>
    <ul>
    <li>Create dynamic end-to-end REST APIs with little or no coding.</li>
    <li>Access data from Relational and NoSQL Databases, SOAP and other REST APIs.</li>
    <li>Incorporates model relationships and access controls for complex APIs.</li>
    </ul>
    <br/>
    For more information on LoopBack, browse the <a href="http://loopback.io/" target="_blank">http://loopback.io/</a> website.
applies_to: [developer]
---

## Launch the API Connect Toolkit

1.  From the command line terminal, launch the API Connect Toolkit by issuing the following command:

    ```shell
    apic edit
    ```

1.  If this is your first time launching the toolkit, you may be asked to accept the licensing terms and sign in with your Bluemix account.

1.  Click on the menu icon in the top left-hand corner of the screen to expand the menu.

1.  Locate the `Projects` option and click on the `+` icon to create a new project.

1.  Choose the `Create Loopback Project` option.

    ![](./images/labs/lab1/new-lb-project.png)

1.  Complete the form to name your new microservice application and set its project folder:

    > Project Template: `empty-server`
    > 
    > Loopback Version: `2.x - long term support`
    > 
    > Display Name: `inventory`
    > 
    > Name: `inventory`
    > 
    > Project Directory: `/home/student/apis`

1.  Click the `Add` button. At this point, the project builder will download and install the core dependencies for our Node.js microservice application.

    Please wait until the install completes and you are able to click on the `Finished` button.
    
    ![](./images/labs/lab1/new-lb-project-finished.png)

1.  Once finished, the toolkit will change into your `inventory` project and display your applications OpenAPI (Swagger) definition. Since we're working with a Loopback-based project, you also have two additional configuration sections available: `Models` and `Data Sources`.

    ![](./images/labs/lab1/drafts.png)

## Continue

Proceed to [Create a Data Source Connector](lab1_items_db.html).

