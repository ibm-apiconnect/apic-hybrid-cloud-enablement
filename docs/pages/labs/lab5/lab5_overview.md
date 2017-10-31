---
title: Lab 5 - Publishing Loopback Services
toc: false
sidebar: labs_sidebar
folder: labs/lab5
permalink: /lab5_overview.html
applies_to: [developer]
---

## Lecture PDF

 <iframe style="overflow:hidden;height:500;width:100%" height="500" width="100%" src="./assets/lectures/Lecture-Publishing_Loopback_Services.pdf"> </iframe>

## Objective

In the previous lab, we created a node loopback service.  This lab will work with you doing the following activities:

+ How to debug your node appication
+ How to profile your loopback service in API Designer
+ Publishing to Bluemix Cloud Foundry

## Assignment

Use the existing slide deck to Debug and Profile the loopback application.  Here are 3 easy steps to follow. 

1. View all debugs from your existing loopback inventory application. make an api call via the browser window ( http://localhost:3000/api/items ) and view the logs. Hit CTRL + C to stop the server after your view everything.

    ```shell
    DEBUG=* npm start
    ```
1. Restart the service with the command below.  This will view the DEBUG logs to just view the mysql connector. Make an API call via http://localhost:3000/api/items and view the logs.  Hit CTRL + C to stop the server after your view everything.

    ```shell
    DEBUG=*mysql npm start
    ```
1. Start the API Designer in this folder by typing the following:

    ```shell
    apic edit
    ```
1. Start the Gateway with the project by pressing the *Play* Button at the bottom.  It doesn't matter whether it is the MicroGateway or the DataPower Gateway.  Both will start the loopback application.  

1.  Once Started, click on the Application: link and it will spawn new browser window

    ![](./images/captures/designer-toolbar.png);

1. Append /appmetrics-dash to the address URL like below. While you have the Metrics Dashboard running, please open a new tab and hit both endpoints to see the effect they both have on the application.  http://localhost:3000/api/items  and http://localhost:3000/api/product/quote 

    ![](./images/captures/url.png);

1. Hit Control + C when you are done and close the browser.  Use this method in the future to debug and profile your applications before final publishing. 


## Continue

Proceed to [Secure Gateway](lab6_overview.html)
 