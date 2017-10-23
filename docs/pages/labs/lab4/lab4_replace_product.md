---
title: Replace the Old Product
toc: false
sidebar: labs_sidebar
folder: labs/lab3
permalink: /lab4_replace_product.html
summary: API Connect offers different types of API Lifecycle controls. In this section, you will explore how to replace a running version of an API Product with a new one.
applies_to: [administrator]
---

## Information about Lifecycle States

IBM API Connect provides capabilities for managing the lifecycle of your API Products. There are various states which an API Product can reside in, as well as controls around when you can move an API Product from one state to another.

The link below documents these states and how API Products flow from one state to another.

+  [The Product lifecycle](https://www.ibm.com/support/knowledgecenter/SSMNED_5.0.0/com.ibm.apic.apionprem.doc/capim_product_lifecycle.html){:target="_blank"}

## Open the API Connect Service on Bluemix

1.  Log in to [IBM Bluemix](https://console.ng.bluemix.net/){:target="_blank"}

1.  Locate and click on the API Connect service on your Bluemix dashboard to launch your SaaS instance of the API Manager.

    ![](./images/labs/lab4/apic-bluemix-svc.png)

## Replace the Old Product

1.  Switch to the **Dashboard** view:

    ![](./images/labs/lab4/switch-apic-dashboard.gif)

1.  Click on the **Sandbox** catalog tile to open the catalog configuration screen.

1.  The `Products` tab will list all of the API Products that this Catalog is currently managing.

    Notice that the `inventory 1.0.0` product is in a `Published` state. This product was built for you in Lab 1 when you generated your Node.js microservice application.
    
    Also notice that your new `Think Inventory` product is available in a Staged state.
    
1.  Click on the menu options for the `Think Inventory` product and select the `Replace an existing product` option.

    ![](./images/labs/lab4/replace-existing-product.png)

1.  Select the `inventory 1.0.0` product, since this is the one we are replacing. Then click the `Next` button.

1.  In order to maintain our consumers' entitlements, we need to migrate their plan subscriptions.

    Both of our Products have plans called `Default Plan`, here you will choose to move subscribers from the `inventory` Product's default plan to the `Think Inventory` Product's default plan.
    
    In the drop-down menu, select `Default Plan`, then click on the `Replace` button.
    
1.  The API Manager will take care of retiring the old product and publishing the new one.

## Continue

Proceed to [Test the OAuth Configuration](lab4_test_oauth.html).