---
title: Create a Data Source Connector
toc: false
sidebar: labs_sidebar
folder: labs/lab1
permalink: /lab1_items_db.html
summary: A data source is your backend data repository. In this case we will be using MySQL to store the inventory item information. There are two parts to this. First is downloading the actual loopback connector for MySQL. Then, you will configure the connector properties for the MySQL database.
applies_to: [developer]
---

## Create the MySQL Connector

1.  In the API Connect Toolkit, select the `Data Sources` tab.

    ![](./images/labs/lab1/datasources.png)

1.  Click on the `Add +` button, then give your new data source the name `inventory-items` and click on the `New` button:

    ![](./images/labs/lab1/new-db.png)

1.  In the `Connector` drop down menu, select `MySQL`.

    ![](./images/labs/lab1/mysql-connector.png)

1.  Click on the `Install Connector` link to download the connector module for MySQL data sources.

    ![](./images/labs/lab1/install-connector.png)
    
1.  Wait for the connector installation to complete, then click on the `Close` button.

1.  Complete the connector configuration properties form with the following values:

    > URL: _leave blank_
    > 
    > Host: `demo.apicww.cloud`
    > 
    > Port: `3306`
    > 
    > User: `student`
    > 
    > Password: `Passw0rd!`
    > 
    > Database: `think`

    ![](./images/labs/lab1/item-db-config.png)

1.  Click on the save icon to test connectivity to the MySQL data source.
    
    ![](./images/labs/lab1/save-db.png)
    
    ![](./images/labs/lab1/db-save-success.png)

## Continue

Proceed to [Create a Model for the Inventory Items](lab1_items_model.html)