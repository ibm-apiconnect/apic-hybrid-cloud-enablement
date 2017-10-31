---
title: Publish Application to Bluemix
toc: false
sidebar: labs_sidebar
folder: labs/lab2
permalink: /lab2_publish_app.html
summary: In this section, you will publish the <b>inventory</b> application to the Bluemix Cloud runtime environment, and also publish the API definition to your API Connect environment for management and enforcement.
applies_to: [developer]
---

## Configure the Developer Toolkit to Communicate with API Connect

1.  Click the `Publish` icon.

    ![](./images/labs/lab2/publish.png)

1.  Select `Add and Manage Targets` from the menu.

1.  Select `Add IBM Bluemix target`.

1.  If prompted, provide your IBM ID credentials to sign into Bluemix. 

1.  On the "Select an organization and catalog" screen, choose the `Sandbox` catalog and click the `Next` button.

    ![](./images/labs/lab2/config-target.png)
	
1.  Provide the name of your application. The name you provide here will be the name of the app inside of Bluemix once it's published.

    {% include important.html content="
        Ensure you click on the `+` button after entering the application name.
    " %}

    ![](./images/labs/lab2/app-name.png)

1.  Make sure your app name is selected and click the `Save` button.

## Publish the Application and API together

1.  Click `Publish` button once more and select our target catalog, indicated by the grey highlighting.

    ![](./images/labs/lab2/select-target.png)

1.  Click the check boxes to select `Publish application` and `Stage or Publish Products`, then click the `Publish` button.

    ![](./images/labs/lab2/publish-app-and-product.png)
	
	{% include note.html content="
	    The Developer Toolkit will package up our Node.js Microservice Application and deploy it to the IBM Cloud.
	    <br/><br/>
	    Once the application has been published, the toolkit will update our API definition with the runtime URL of the application in Bluemix, then separately publish the API definition into the API Connect Management Server.
    " %}

1.  Wait for the publish process to complete:

    ![](./images/labs/lab2/publish-success.png)

## Verify Application Runtime URL

1.  Return to your inventory API definition.

    If you need to find the drafts APIs section again, click on the menu icon in the top left hand corner of the screen and select the `inventory` project.

    Open the `inventory 1.0.0` API definition and navigate to the `Properties` section.

    ![](./images/labs/lab2/api-properties.png)

    {% include note.html content="
        Two properties have been added to the API definition: `runtime-url`, and `invoke-tls-profile`.
        <br/><br/>
        Properties are API-specific variables which can hold environment-specific data.
    " %}

1.  Expand the `runtime-url` property and notice that for our Sandbox environment, the URL has been set to a new route for our application running in the Bluemix Cloud.

    ![](./images/labs/lab2/runtime-url.png)
	
    {% include note.html content="
        Your application's runtime URL will be unique to you.
        <br/><br/>
        You will not be able to test your application on this URL directly. Your application running in Bluemix has been created with a protected endpoint that is only accessible from your API Gateway.
    " %}
    
## Continue

Proceed to [Create a Portal Account](lab2_portal_account.html).