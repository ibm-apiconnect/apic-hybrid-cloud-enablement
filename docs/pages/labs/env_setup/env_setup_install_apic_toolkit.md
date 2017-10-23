---
title: Install the APIC Toolkit
toc: false
sidebar: labs_sidebar
folder: labs/env_setup
permalink: /env_setup_install_apic_toolkit.html
summary: Use the node package manager to install the API Connect Developer Toolkit.
applies_to: [developer]
---

## Install the API Connect Toolkit

1.  Install th API Connect Toolkit on to your workstation by running the following command in a terminal:

    ```bash
    npm install -g apiconnect
    ```
    
    {% include troubleshooting.html content="
        You may be required to run the above command with administrator privileges.
    " %}

1.  Once complete, start up a new terminal window and enter in `apic -v`.

    If it returns the version of the platform, and not an error message, then the toolkit should then be properly installed.

1.  Proceed to [Bluemix Account Setup](acct_setup_overview.html).