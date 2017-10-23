---
title: Adding a New OAuth 2.0 Provider API
toc: false
sidebar: labs_sidebar
folder: labs/lab3
permalink: /lab3_oauth_api.html
summary: |-
    API Connect is a full-featured OAuth 2.0 provider. The OAuth exchange works like any other API call, and thus we treat it as its own API.
    <br/><br/>
    In this section, you will create a new OAuth provider API and configure which grant type to use and how it will authenticate user credentials. 
applies_to: [developer]
---

## Create OAuth API

1.  Return to the [API Connect Toolkit](http://127.0.0.1:9000/#/design/apis){:target="_blank"} tab in your browser.

1.  Make sure you are still in the `inventory` project.

    Click on the menu icon in the upper left-hand corner of the screen, expand the `Projects` option and select `inventory`.

1.  Click the `+ Add` button and select `OAuth 2.0 Provider API` from the menu.

1.  Specify the following properties and click the `Create API` button to continue.

    > Title: `oauth`
    > 
    > Name: `oauth`
    > 
    > Base Path: `/`
    > 
    > Version: `1.0.0`
	
	{% include important.html content="
        Make sure the **Base Path** setting is correct.
    " %}
	
    ![](./images/labs/lab3/new-oauth-props.png)

1.  The API Editor will launch. If this is your first time using the API Editor, you will see an informational message. When you are ready to proceed, click the `Got it!` button to dismiss the message.  
	
    The API Editor opens to the newly created `oauth` API. The left hand side of the view provides shortcuts to various elements within the API definition: Info, Host, Base Path, etc. By default, the API Editor opens to the `Design` view, which provides a user-friendly way to view and edit your APIs.

1.  Use the palette on the left to navigate to the `OAuth 2` section.

    Over the next several steps, we will set up OAuth-specific options, such as client type (public vs confidential), valid access token scopes, supported authorization grant types, etc. The [OAuth 2.0 Specification](http://tools.ietf.org/html/rfc6749){:target="_blank"} has detailed descriptions of each of the properties we are configuring here.

1.  For the `Client type` field, click the drop down menu and select `Confidential`.

    ![](./images/labs/lab3/oauth2-client-type.png)

1.  Three scopes were generated for you when the OAuth API Provider was generated: `scope1`, `scope2`, `scope3`.

1.  Modify the values for `scope1`, set the following fields:

    > Name: `inventory`
    > 
    > Description: `Access to Inventory API`

    Delete `scope2` and `scope3` by clicking the trashcan icons to the right of the scope definitions.
    
    {% include important.html content="
        The scope defined here must be identical to the scope that we define later when telling the `inventory` API to use this OAuth config. A common mistake is around case sensitivity. To avoid running into an error later, make sure that your scope is set to all **lowercase**.
    " %}
    
    ![](./images/labs/lab3/oauth2-scopes.png)

1.  We want to configure this provider to *only* support the Resource Owner Password Credentials grant type. Deselect the `Implicit`, `Application` and `Access Code` Grants, but leave `Password` checked.

    ![](./images/labs/lab3/oauth2-grants.png)

1.  In the **Identity extraction** section, set the `Collect credentials using` drop-down menu to `Basic`.

    ![](./images/labs/lab3/oauth2-id-extraction.png)

1.  In the **Authentication** section, set the following fields:

    > Authenticate application users using: `Authentication URL`
    > 
    > Authentication URL: `https://thinkibm-services.mybluemix.net/auth`
    
    ![](./images/labs/lab3/oauth2-authentication.png)

1.  Scroll down to the **Tokens** section, turn off the `Enable revocation` option.
    
    ![](./images/labs/lab3/outh2-tokens.png)

1.  Click the `Save` icon in the top right corner of the editor to save your changes.

    ![](./images/common/save.png)

1.  Click on the `<- All APis` link to return to the draft API list.

## Continue

Proceed to [Create a New Version of the Inventory API](lab3_version_api.html).