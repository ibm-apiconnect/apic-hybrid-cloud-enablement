---
title: Map the API to a Service WSDL
toc: false
sidebar: labs_sidebar
folder: labs/lab5
permalink: /lab5_financing_assembly.html
summary: Import the legacy Financing SOAP service WSDL and map it to the RESTful API definition.
applies_to: [developer]
---

## Attach a Service WSDL

1.  From the `financing 1.0.0` API Design screen, click on the `Services` option in the left column menu palette.

1.  Click the `+` icon in the **Services** section to import web service from WSDL.

1.  Click the `Load from URL` icon and enter the WSDL URL below and then click `Next`:

    [https://thinkibm-services.mybluemix.net/financing/calculate?wsdl](https://thinkibm-services.mybluemix.net/financing/calculate?wsdl)

    ![](./images/labs/lab5/import-wsdl.png)

1.  Click the `Show operations` to see the available operations in the WSDL end point. Select `financingService` then click `Done`.

    ![](./images/labs/lab5/wsdl-service.png)

## Build the Financing API Assembly

1.  Click on the `Assemble` tab to access the assembly editor.

    ![](./images/labs/lab5/assemble-tab.png)

1.  Select the `DataPower Gateway policies` filter.

    ![](./images/labs/lab5/dp-policies.png)

1.  In the processing pipeline, mouse over the `invoke` policy and click the trash icon to delete it.

    ![](./images/labs/lab5/fin-delete-invoke.png)

1.  Scroll down to the bottom of the policy menu, drag and drop the `financing` web service operations to processing pipeline.

    ![](./images/labs/lab5/fin-add-service-assembly.gif)

1.  Now you are going to modify the input and output `map` policy for mapping your REST API into SOAP.

1.  In order to consume a SOAP-based service from your REST-based API, you need to map the query parameter inputs that were defined as part of the `GET /calculate` operation to a SOAP payload. To do so, click on the `financing: input` map policy on our pipeline to open the map editor.

    {% include tip.html content="
        Click on the `+` icon to make the editor window fill the screen.
    " %}

1.  Click on the `pencil` icon in the **Input** column.

    ![](./images/labs/lab5/edit-input-icon.png)

1.  Click on the `+ parameters for operation...` option and select the `GET Calculate` operation.

    The Map editor will automatically pull in the request parameters that you defined earlier.

1.  Click on the `Done` button to return to the map editor.

1.  For each of the `Input` query parameters, map them to their respective SOAP `Output` elements.

	To map from an input field to an output field, click the circle next to the *source* element once, then click the circle next to the *target* element. A line will be drawn between the two, indicating a mapping from the source to the target.

    ![](./images/labs/lab5/fin-assembly-map.png)

1.  Click the `X` button in the map editor to return to the policy pipeline.

1.  Click the `invoke` policy to open its editor.

1.  The SOAP service `URL` has already been set for you during the service import when we create the API.

    ![](./images/labs/lab5/fin-invoke.png)

1.  Click the `X` button to return to the policy pipeline.

1.  After the Financing Web Service is invoked, you need to map the SOAP response into a JSON object.

    You already defined the response object called `paymentAmount`.  To do the map, click on the `financing: output` map policy on our pipeline to open the map editor.

1.  Click on the pencil icon to create a set the output object schema.

1.  Click on the `+ outputs for operation...` option and select the `GET /calculate` operation.

1.  Set the **Content type** configuration option to `application/json`.
		
    ![](./images/labs/lab5/fin-output-content-type.png)

1.  Click on the `Done` button to return to the map editor.

1.  Click the circle next to the `paymentAmount` *source* element once, then click the circle next to the *target* element. A line will be drawn between the two, indicating a mapping from the source to the target.

    ![](./images/labs/lab5/fin-map-output.png)

1.  Click the `X` button in the map editor to return to the policy pipeline.

1.  Save the API definition.

    ![](./images/common/save.png)

1.  Click on the `<- All APIs` link to return to the draft APIs list.

## Continue

You are now finished building the `financing` API. The assembly takes the following actions:

+ Maps the REST query parameters into a SOAP body.
+ Invokes the SOAP service.
+ Transforms the SOAP service's response into JSON.

Proceed to [Import Logistics API](lab5_import_logistics.html).