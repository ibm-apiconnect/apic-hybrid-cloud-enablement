---
title: Starting Existing Loopback Service
toc: false
sidebar: labs_sidebar
folder: labs/lab6
permalink: /lab6_starting.html
summary: We will start this exercise by leveraging an existing loopback service.  Let's start the service from our Node & Loopback Services Lab.
applies_to: [developer]
---
 
## Start the Existing Loopback Service

 1.  For this step, let's drop down in the Command Line.  Open your Terminal/Command Prompt in the same folder as your loopback `inventory` project.  

        ```shell
            apic edit
        ```

1.  On the bottom left-hand corner of the screen, locate and click on the `Run` button to start the `inventory` LoopBack application.

    ![](./images/labs/lab1/run.png)

1.  Wait a moment while the servers are started. Proceed to the next step when you see the following:

    ![](./images/labs/lab1/app-running.png)

1.  Once Started, click on the Application: link and it will spawn new browser window

    ![](./images/captures/designer-toolbar.png);

1. Test the following endpoint in the browser and ensure it is running properly. 

    ![](./images/captures/mysql-results.png);


## Continue

Proceed to [Configuring Secure Gateway Client](lab6_configure.html)