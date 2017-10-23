---
title: Create a Model for the Inventory Items
toc: false
sidebar: labs_sidebar
folder: labs/lab1
permalink: /lab1_items_model.html
summary: In this step, you will create the data model for our inventory items by inspecting the MySQL data source schema. LoopBack is a data model driven framework. The properties of the data model will become the JSON elements of the API request and response payloads.
applies_to: [developer]
---

## Generate a Data Model

1.  From the `inventory-items` data source configuration screen, click on the `Discover Models` button.

    ![](./images/labs/lab1/discover-db-model.png)
	
1.  The API Connect Toolkit will query the table structure of the MySQL data source and allow you to select the desired properties to build your data model from.

    Click on the `Select Properties` button.
    
    ![](./images/labs/lab1/select-model-properties.png)

1.  Keep the defaults and click on the `Select` button.

    ![](./images/labs/lab1/select-model-properties-2.png)

1.  Click on the `Generate` button to create a data model using the selected MySQL table properties.

## Continue

Proceed to [Verify the Microservice API](lab1_verify_api.html).