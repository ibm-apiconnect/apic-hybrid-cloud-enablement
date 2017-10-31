---
title: Test the OAuth Configuration
toc: false
sidebar: labs_sidebar
folder: labs/lab3
permalink: /lab4_test_oauth.html
summary: In this section, you will test the new version of the API to ensure that OAuth is working properly.
applies_to: [consumer]
---

1.  Open your API Portal in a new browser tab and log in with your developer account.

    If you closed the tab from earlier and don't have it bookmarked, you can follow these steps to find your API Portal URL:
    
    [Locate and Launch your Portal URL](http://127.0.0.1:4000/pot/lab2_portal_account.html#locate-and-launch-your-portal-url){:target="_blank"}
    
1.  Click on the `API Products` tab.

1.  Notice that the old `inventory` product is no longer available. It has been replaced by your new `Think Inventory` product.

1.  Click on the `Think Inventory` product.

    {% include note.html content="
        There is no need to re-subscribe your application! Using the `Replace` state change control migrated your subscription for you, so you're already entitled to the API's contained in the new Product's Default Plan - including the `oauth` API.
    " %}

1.  Click on the `inventory` API from the palette menu on the left.

1.  Select the `GET /Items` operation. Notice that we now have an additional OAuth security requirement defined.

1.  Scroll down to browse the invocation form.

1.  Select your subscribed application from the `Client ID` drop-down menu.

1.  Paste your secret into the `Client secret` field.

1.  In the `Username` and `Password` fields, you can enter any text.

    {% include note.html content="
        Recall that when we configured the OAuth API, we provided an Authentication URL as the method for validating the user credentials. The URL that we provided will respond back OK with any credentials. 
    " %}

1.  Click on the `Authorize` button to obtain an OAuth token.

    The API Portal will call out to the OAuth Token URL with your client credentials and user credentials.
    
    The OAuth API which you built in lab 3 will intercept the request, validate the credentials, and generate a token.
    
1.  Click on the `Call operation` button to invoke the API. The request will include the OAuth bearer token in the `Authorization` header.

1.  To prove that the token is being validated, you can either remove or modify the contents of the `Access Token` field, then click the `Call operation` button again and see the `401 Unauthorized` error response.

## Continue

Proceed to [Lab 5 - Advanced API Assembly](lab5_overview.html).