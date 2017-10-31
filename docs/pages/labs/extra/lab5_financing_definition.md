---
title: Create the Financing API (REST to SOAP)
toc: false
sidebar: labs_sidebar
folder: labs/lab5
permalink: /lab5_financing_definition.html
summary: |-
    <b>ThinkIBM</b> wants to give their customers the ability to calculate financing payments. There is already a legacy SOAP-based application which will do the calculation, but it should be exposed to consumers as a modern RESTful API.
    <br/><br/>
    In this section, you will create a new OpenAPI definition for the financing API.
applies_to: [developer]
---

## Create the API Definition

1.  Click on the `+ Add` button and select `New API`.

    ![](./images/labs/lab5/new-api.png)

1.  Fill in the form values for the API, then click the `Create API` button to continue.

    > Title: `financing`
    >
    > Name: `financing`
    > 
    > Base Path: `/financing`
    > 
    > Version: `1.0.0`

1.  API Connect will generate a new OpenAPI definition file for the `financing` API and automatically load the API editor screen. Notice that the API does not contain any paths or data definitions. We will be adding these in the following steps.

1.  Next, we need to create the model definition for our new API. These definitions are used in a few places. Their primary role is to serve as documentation in the developer portal on expected input and output parameters; however, they can also be used for data mapping actions. Click on `Definitions` from the API Designer menu.

1.  Click the `+` icon in the **Definitions** section to create a new definition. Then, click on `new-definitions-1` to edit the new definition.

1.  Edit the `Name` of the definition, set it to `paymentAmount`. Leave the definition **Type** set to `object`.

1.  Scroll down to the definition **Properties** section. The new definition already adds in a sample property called `new-property-1`.

    Edit the property values:

    > Property Name: `paymentAmount`
    >
    > Description: `Monthly payment amount`
    >
    > Type: `float`
    >
    > Example: `199.99`
	
    ![](./images/labs/lab5/definition.png)

1.  Now that you have a definition, you need to create a path to attach it to. Click on `Paths` from the API Designer menu.

1.  Click on the `+` button to create a new path. The template will generate the path and a GET operation under the path. This is sufficient for our needs, but we could also add other operations and REST verbs to our path if needed.

1.  Edit the default path location to be `/calculate`.

    ![](./images/labs/lab5/calculate-path.png)

    {% include note.html content="
        Recall that our Base Path for this API is `/financing`. This new path will be appended to the base, creating a final path of `/financing/calculate`.
    " %}

1.  Click on the `GET /calculate` operation to expand its configuration options.

1.  Next, you have the option of adding request parameters to the operation. This defines the input to the API request. Since this is a GET request, add the required request parameters to the query component of the URI.

	Scroll down and find the `Parameters` section within the operation config.
	
	{% include note.html content="
        There are two `Parameters` sections. The top level section is for PATH parameters and would apply to all operations under the path. There is also a `Parameters` section for each operation. For this section, please use the parameters in the GET operation section.
    " %}
	
	Click on the `Add Parameter` link to create a new query parameter. Then, select `Add new parameter` from the sub-menu.

    ![](./images/labs/lab5/add-parameter.png)

1.  You are actually going to need three total parameters for this operation, so go ahead and click on the `Add Parameter` link two more times to add the parameter templates.

    ![](./images/labs/lab5/parameters.png)

1.  Edit the parameters to set the values:

    |Name    |Located In|Description             |Required|Type        |
    |--------|----------|------------------------|--------|------------|
    |amount  |Query     |amount to finance       |yes     |number-float|
    |duration|Query     |length of term in months|yes     |integer-32  |
    |rate    |Query     |interest rate           |yes     |number-float|
	
    ![](./images/labs/lab5/parameters-done.png)

1.  Set the schema for the response. Since we already defined the `paymentAmount` definition, we will select it from the drop down list. You will find the `paymentAmount` definition at the top of the list.

    ![](./images/labs/lab5/response-schema.png)

1.  Save the API definition.

    ![](./images/common/save.png)

## Continue

So far in this lab, you have built an API Definition which provides details to consumers on how to make an API request and what to expect as a response.

In the next step, you will create an API Assembly configuration which maps the REST calls into SOAP, and SOAP responses into JSON.

Proceed to [Map the API to a Service WSDL](lab5_financing_assembly.html).