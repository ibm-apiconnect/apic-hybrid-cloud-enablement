---
title: Test the API
toc: false
sidebar: labs_sidebar
folder: labs/lab2
permalink: /lab2_test_api.html
summary: The API Connect Developer Portal allows consumers to test the API's directly from the website. This feature may be enabled or disabled per-API.
applies_to: [consumer]
---

## Browse the API Operations and Invoke a Test

1.  Open the `inventory 1.0.0` API to browse the API definition.

1.  Click on the `GET /Items` operation from the left-hand palette.

1.  In the middle column, you will find information about the request parameters and links to the response schemas.

1.  In the right-hand column, you will see example request options for various programming languages, as well as an example response payload.

1.  Scroll down and you will also have the ability to test the API operation.

1.  If you only have one application registered, it will be automatically selected in the `Client ID` drop-down menu.

    If you have more than one, select the application which is subscribed to this API Product.

1.  Paste your `Client Secret` into the provided field.

1.  Click on the `Call operation` button to invoke the API.

1.  Scroll down to see the call results.

## Continue

You have now successfully created an API using the developer toolkit and published it to the IBM Bluemix cloud runtime environment.

In the next lab, you will create a new version of the **inventory** API which requires OAuth security.

Proceed to [Lab 3 - Add OAuth Security to your API](lab3_overview.html).