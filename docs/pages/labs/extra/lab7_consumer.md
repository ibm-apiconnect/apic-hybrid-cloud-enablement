---
title: Try the ThinkIBM Consumer Web Application
toc: false
sidebar: labs_sidebar
folder: labs/lab7
permalink: /lab7_consumer.html
summary: |-
    Now that you have browsed the API Portal and registered / tested the API's that <b>ThinkIBM</b> is providing, it's time to test them out from a real application.
    <br/><br/>
    You have been provided access to a sample consumer application which will be used to interact with the <b>ThinkIBM</b> API's. 
applies_to: [consumer]
---

## Launch the Web Application

1.  Open a new browser tab and navigate to:

    [https://thinkibm-consumer.mybluemix.net](https://thinkibm-consumer.mybluemix.net){:target="_blank"}

1.  In order to set up the consumer app to target your APIs and use your registered client credentials, a setup screen will be displayed asking for some application configuration parameters.

1.  Using the `Client ID`, `Client Secret` and `API Endpoint` values you saved earlier in your text editor, copy/paste them into their respective fields as shown below:

    ![](./images/labs/lab7/configure-app.png)

    {% include tip.html content="
        You should have saved the Catalog Gateway Endpoint to a text editor earlier in Lab 3. However, if you need to find it again, return to the API Manager on Bluemix and browse the Catalog Gateway Settings as shown below:
        <br/><br/>
        <img src=\"./images/labs/lab7/bmx-api-endpoint.png\"/>
    " %}

1.  Click the `Submit` button to complete the application configuration. The test application saves your settings in browser session variables.

1.  The home page is a simple landing page which does not invoke any of the API's. Recall that in [Lab 3](lab3_overview.html){:target="_blank"} you secured the `inventory` API by requiring an OAuth token. If you attempt to view the Item Inventory before logging in, you will be challenged for a username and password. Either click on the `Browse Item Inventory` button, or the `Log In` link to open the login prompt.

1.  Enter any Username and Password then click the `Log In` button. Our sample authentication service is a dummy repository that will accept any credentials provided.

    ![](./images/labs/lab7/oauth-login.png)

    {% include tip.html content="
        The consumer app will contact our OAuth Token URL and handle the token exchange using standard OAuth procedures. If you're interested in seeing the token, you can open your browser's developer tools and view the Console logs and Network trace:
        <br/><br/>
        <img src=\"./images/labs/lab7/browser-console.png\"/>
    " %}

1.  Once you are logged in, the consumer application will redirect you to the item inventory page. The data displayed on the page is being powered by your `inventory` API! The consumer application is calling to our API, which is then being sent to our LoopBack application which handles the connection to the MySQL data source where the inventory item data is persisted.

1.  Click around the pages to test the features of the consumer application. Try entering your home zip code to obtain shipping data. This feature is powered by the `logistics` APIs that were built using advanced assembly techniques in [Lab 5](lab5_logistics_orchestration.html){:target="_blank"}. Your quotes will vary based on the zip code provided.

    Notice how you are also provided a link to the nearest store. Clicking here will launch the Google Maps link which was also built in the [Lab 5](lab5_logistics_gws.html){:target="_blank"} assembly.

    ![](./images/labs/lab7/calculate-shipping.gif)

1.  Finally, try clicking on the `Calculate Monthly Payment` link. This feature is powered by the `financing` API that was created using our REST-to-SOAP assembly in Lab 5.

    ![](./images/labs/lab7/calculate-financing.gif)

1.  Repeat the steps on a few of products to drive data into the analytics database.

## Completion

**Congratulations!** You have completed Lab 7!

Proceed to [Lab 8 - Analytics in API Connect](lab8_overview.html)