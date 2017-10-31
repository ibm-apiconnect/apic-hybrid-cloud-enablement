---
title: Create a New API Product
toc: false
sidebar: labs_sidebar
folder: labs/lab4
permalink: /lab4_new_product.html
summary: Before being published, APIs are packaged into Products. Products allow related APIs to be bundled together for subscribers. In Lab 1, when the inventory microservice application was generated, it also created a default product. In this section, you will create a new product from scratch and stage it to your API Manager in Bluemix.  
applies_to: [product-manager]
---

## Create a New Product

1.  Click on the `Products` tab in your API Connect Toolkit.

1.  Click on the `Add +` button and select `New Product`.

1.  Title this product `Think Inventory` and click on the `Create Product` button.

1.  Navigate to the APIs section. Click on the `+` button to add APIs to this Product.

1.  Select the `inventory 2.0.0` and `oauth 1.0.0` APIs, then click the `Apply` button.

    ![](./images/labs/lab4/product-add-apis.png)

1.  Save the Product.

## Stage the Product in your API Manager on IBM Bluemix

1.  Click on the `Publish` button and choose your Sandbox target.

1.  Select the option to `Stage or Publish products`.

    If the `Publish application` option is selected, un-check it.

1.  Select the options for `Stage only` and also `Select specific products`.

1.  Choose the `think-inventory` product, then click the `Publish` button.

    ![](./images/labs/lab4/stage-product.png)

## Continue

Proceed to [Replace the Old Product](lab4_replace_product.html).