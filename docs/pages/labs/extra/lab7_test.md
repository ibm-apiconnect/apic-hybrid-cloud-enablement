---
title: Test APIs from the Developer Portal
toc: false
sidebar: labs_sidebar
folder: labs/lab7
permalink: /lab7_test.html
summary: In this section, you will use the Developer Portal to test one of the Accessories APIs. This is useful for application developers to try the APIs before their application is fully developed or to simply see the expected response based on inputs they provide the API.
applies_to: [consumer]
---

## Browse and Test the APIs

1.  Click the `logistics` link on the left-hand navigation menu and then select the `GET /shipping` path.

    ![](./images/labs/lab7/get-shipping.png)

1.  Scroll down to the **Try this operation** section for the `GET /shipping` path. Enter any United States Zip Code (e.g., `90210`) and click the `Call Operation` button.

    ![](./images/labs/lab7/call-shipping.png)

1.  Scroll down below the `Call operation` button. You should see a `200 OK` and a response body as shown below.
  
    ![](./images/labs/lab7/shipping-response-ok.png)

1.  Go ahead and try out the **Logistics** `GET /stores` and the **Financing** `GET /calculate` APIs as well.

## Continue

Now that you have verified that all of your APIs are working properly, you can explore the results of your hard work from a true web application.

Proceed to [Try the ThinkIBM Consumer Web Application](lab7_consumer.html).