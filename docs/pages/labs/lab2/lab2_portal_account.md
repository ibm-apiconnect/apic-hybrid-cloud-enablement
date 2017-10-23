---
title: Create a Portal Account
toc: false
sidebar: labs_sidebar
folder: labs/lab2
permalink: /lab2_portal_account.html
summary: In order to test the live API, you first need to register as an API consumer in the Developer Portal.
applies_to: [administrator,consumer]
---

## Launch the Developer Portal from your Bookmark

1.  If you bookmarked your Portal URL already, open a new browser tab, launch the Portal website, and then proceed to the [Create a Portal Account](lab2_portal_account.html#create-a-portal-account) steps at the bottom of this page.

1.  Otherwise, continue with the instructions below to find your Portal URL.

## Open the API Connect Service on Bluemix

1.  Log in to [IBM Bluemix](https://console.ng.bluemix.net/){:target="_blank"}

1.  Locate and click on the API Connect service on your Bluemix dashboard to launch your SaaS instance of the API Manager.

    ![](./images/labs/lab2/apic-bluemix-svc.png)

## Locate and Launch your Portal URL

1.  Switch to the API Manager Dashboard view.

    ![](./images/labs/lab2/switch-apic-dashboard.gif)

1.  Click on the **Sandbox** catalog tile to open the catalog configuration screen.

1.  Click on the **Settings** tab, then click on the **Portal** menu option in the settings screen.

1.  Locate the `Portal URL` and click on it to launch your catalog's API Portal.

    {% include tip.html content="
        Bookmark the API Portal URL for quick access later.
    " %}

## Create a Portal Account

1.  Click on the `Create an account` link.

    ![](./images/labs/lab2/create-account-link.png)

1.  Complete the registration form to set up your API Portal account.

    {% include important.html content="
        The E-mail Address that you use for the API Portal account **must** be different from your IBM ID associated with your Bluemix account.
        <br/><br/>
        The IBM ID for your Bluemix account is already registered in the API Portal and associated with the API Portal's `admin` account, which you will use later to customize the look & feel of the portal site.
        <br/><br/>
        Also, take note of your Developer Organization. This organization name will be how API Administrators view your account. For example, admins have the ability to restrict visibility of products to certain consumer organizations.
    " %}

1.  Check the E-mail account that you used to sign up to the portal. After a few minutes, you will receive a registration link that you will need to click on to complete the account registration.

1.  Click on the registration link and use your E-Mail address and password to sign in to the API Portal.

## Continue

Proceed to [Register a Test App](lab2_register_app.html).