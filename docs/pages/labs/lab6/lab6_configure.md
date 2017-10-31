---
title: Configure Secure Gateway Client
toc: false
sidebar: labs_sidebar
folder: labs/lab6
permalink: /lab6_configure.html
summary: Before we can communicate with our loopback service from Bluemix Cloud, we will need a Secure Gateway to access our service locally.
applies_to: [developer]
---

1.  Switch to the `Products` tab of the **accessories** project.

    ![](./images/labs/lab6/product-tab.png)

1.  Click the `Add +` button, then select the `New Product` option.

1.  Provide the following configuration for the new product:

    > Title: `Think Accessories`
    >
    > Name: `think-accessories`

1.  Click the `Create product` button.

1.  Edit the Description & Contact details:

    > Description: `The **Think Accessories** product will provide really awesome APIs to your application.`
    >
    > Contact Name: `Thomas Watson`
    >
    > Contact Email: `watson@think.ibm`
    >
    > Contact URL: `https://developer.ibm.com/apiconnect/`  
	
    {% include tip.html content="
        The API Designer supports markdown formatting in various fields, use the `Preview` toggle for the **Description** to see what the field will look like after formatting.
    " %}

1.  Specify a License and Terms of Service:

    > License Name: `The MIT License (MIT)`
    >
    > License URL: `https://opensource.org/licenses/MIT`
    >
    > Terms of Service: _paste the contents of the box below:_
    > 
    > ```text
    > Copyright (c) 2016 IBM
    > 
    > Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
    > 
    > The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
    > 
    > THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    > ```
	
1.  Modify the Visibility so that the product is only visible to `Authenticated users`:
  
    ![](./images/labs/lab6/product-visibility.png)
	
	{% include tip.html content="
        This ensures that only consumers who have registered accounts will see the Product.
        <br/><br/>
        Compared to Public, which allows anyone navigating the portal to see the Product.
    " %}
	
1.  Navigate to the APIs section. Click the `+` button to add your APIs to this product.

1.  Select the checkboxes next to `financing` and `logistics`.
	 
    ![](./images/labs/lab6/select-apis.png)

1.  Click the `Apply` button.

1.  Navigate to the Plans section. Click the `trashcan` button for the **Default plan** to remove it.

    Click the `OK` button to confirm.

1.  Click on the `+` button in the **Plans** section to add a new plan.

    Expand the `New Plan 1` entry that was added to the list and modify it with the following properties:

    > Title: `Silver`
    >
    > Name: `silver`
    >
    > Description: `Limited access to the Accessories APIs`
    >
    > Add rate limit of 100 with an interval of 1 hour
	
    ![](./images/labs/lab6/plan-silver.png)

1.  Click on the `+` button in the **Plans** section again to create a second plan with the following properties:

    > Title: `Gold`
    >
    > Name: `gold`
    >
    > Description: `Unlimited access to the Accessories APIs for approved users`
    >
    > Rate limit: `Unlimited`
    >
    > Approval: check `Require subscription approval`  
	
    ![](./images/labs/lab6/plan-gold.png)

1.  Save your changes.

    ![](./images/common/save.png)

## Continue

Proceed to [Testing API in Bluemix Cloud](lab6_testing.html).