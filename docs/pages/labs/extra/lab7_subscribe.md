---
title: Subscribe to the Accessories Product
toc: false
sidebar: labs_sidebar
folder: labs/lab7
permalink: /lab7_subscribe.html
summary: In this section, you will subscribe to a plan for the Think Accessories Product using the ThinkIBM Consumer application.
applies_to: [consumer]
---

## Launch your Developer Portal

1.  Launch the Developer Portal from your bookmarks if you have the link saved, otherwise follow the instructions to [Locate and Launch your Portal URL](http://localhost:4000/pot/lab2_portal_account.html#open-the-api-connect-service-on-bluemix){:target="_blank"} 

## Browse the Available API Products

1.  If you are logged in to the portal, log out to clear your session.

1.  Click the `API Products` link.

    ![](./images/labs/lab7/products-tab.png)

1.  Notice that only the **Think Inventory** product is listed, even though you just published the **Think Accessories** product. Recall that you assigned the Accessories product to be visible only by developers who are logged in to the portal.

1.  Log in with the Developer account for your portal. Remember that this account is different from the credentials you use to log in to Bluemix.

## Subscribe to the Accessories Product

1.  Click the `API Products` link after logging in.

1.  Select the **Think Accessories (1.0.0)** product.

    ![](./images/labs/lab7/think-accessories-product.png)

1.  You will be directed to the Product page which lists the available plans for subscription.

    Click on the `Subscribe` button under the `Silver` plan.
    
    ![](./images/labs/lab7/subscribe-silver.png)
    
    {% include note.html content="
        The **Gold** plan requires approval by the API provider for any subscription requests and allows unlimited requests for a given time period. The Silver plan is limited to 100 requests per hour and does not require approval by the API provider for subscription requests.
    " %}

1.  Select the `ThinkIBM Consumer` application and click the `Subscribe` button.

    ![](./images/labs/lab7/subscribe-select-app.png)

1.  The `ThinkIBM Consumer` application is now subscribed to the `Silver Plan` for the **Think Accessories** Product.

## Continue

Proceed to [Test APIs from the Developer Portal](lab7_test.html).