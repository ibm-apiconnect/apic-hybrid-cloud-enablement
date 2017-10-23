---
title: Create a New API Project
toc: false
sidebar: labs_sidebar
folder: labs/lab5
permalink: /lab5_create_new_project.html
summary: Keep your new APIs separate from the inventory application by creating a new working project folder.
applies_to: [developer]
---

## Open the API Designer

1.  Return to the API Designer tab in your browser.

    +  If you closed the tab and the API Designer server is still running, you can access the designer at [http://127.0.0.1:9000/#/design/apis](http://127.0.0.1:9000/#/design/apis){:target="_blank"}
    
    +  If you need to re-launch the API Designer, issuing the following command in your terminal window:

        ```bash
        cd ~ && apic edit
        ```
    
        You may be asked to sign in with your registered Bluemix account.

1.  Otherwise, click the `All APIs` link to return to the main Designer screen.

## Create a New Project

1.  Using the menu button in the top left-hand corner of the screen, expand the `Projects` section to view your active projects.

1.  Click on the `+` button and `Create OpenAPI Project`.

    ![](./images/labs/lab5/create-new-project.png)
    
1.  Call the new project `accessories` and set the project directory to your `$HOME_DIR/apis` folder.

    ![](./images/labs/lab5/new-project-info.png)

1.  Click on the `Add` button to create the new project and switch into the project's design view.

## Continue

Proceed to [Create the Financing API (REST to SOAP)](lab5_financing_definition.html).