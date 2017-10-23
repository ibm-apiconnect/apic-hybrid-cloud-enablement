---
title: Import Logistics API
toc: false
sidebar: labs_sidebar
folder: labs/lab5
permalink: /lab5_import_logistics.html
summary: |-
    In this lab section, we will be adding a new API called <b>logistics</b> which will provide helper services around calculating shipping rates and locating nearby stores.
    <br/><br/>
    Rather than require you to build the entire API from scratch again, you will see how you can import and modify an existing OpenAPI definition.
applies_to: [developer]
---

{% comment %}
## Import an API from URL

1.  Click on the `+ Add` button to `Import API from a file or URL`.

    ![](./images/labs/lab5/import-api.png)

1.  Click on the `Or import from URL...` link, enter the `logistics` API definition template URL below and click the `Import` button:

    [https://raw.githubusercontent.com/ibm-apiconnect/pot/master/docs/assets/lab5/logistics_1.0.0.yaml](https://raw.githubusercontent.com/ibm-apiconnect/pot/master/docs/assets/lab5/logistics_1.0.0.yaml)
{% endcomment %}

## Download the OpenAPI Definition

1.  An existing OpenAPI definition is available to download here:

    [https://raw.githubusercontent.com/ibm-apiconnect/pot/master/docs/assets/lab5/logistics_1.0.0.yaml](https://raw.githubusercontent.com/ibm-apiconnect/pot/master/docs/assets/lab5/logistics_1.0.0.yaml){:target="_blank"}

1.  Save the `logistics_1.0.0.yaml` file to your `~/apis/accessories/` project folder.

    ![](./images/labs/lab5/save-logistics-yaml.png)

## Refresh the Designer

1.  Refresh your API Designer page to view the `logistics 1.0.0` draft API.

    ![](./images/labs/lab5/logistics-api-imported.png)

## Conclusion

Proceed to [Create an Orchestration Assembly](lab5_logistics_orchestration.html).