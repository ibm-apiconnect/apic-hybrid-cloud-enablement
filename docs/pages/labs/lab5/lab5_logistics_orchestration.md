---
title: Create an Orchestration Assembly
toc: false
sidebar: labs_sidebar
folder: labs/lab5
permalink: /lab5_logistics_orchestration.html
summary: |-
    The <b>logistics</b> API provides resources for calculating shipping costs and locating the nearest store for pickup.
    <br/><br/>
    In this section you will configure the assembly for the shipping calulation resource. Your API assembly will call out to two separate shipping vendors and provide a consolidated response back to the consumer.
applies_to: [developer]
---

## Create the Logistics API Assembly

1.  Click on the `logistics 1.0.0` API to edit its definition.

1.  Switch to the `Assemble` tab and click the `Create assembly` button.

1.  Add an `activity-log` policy to the assembly pipeline.

1.  Configure the activity-log action to log the `payload` for the **Content** field.

1.  Add an `operation-switch` policy to the right of the activity-log step.

1.  The **operation-switch** editor will open with a single case, `case 0`, created by default.

1.  Next to `case 0`, click on `search operations...` to show the drop-down list of available operations.

1.  Select the `shipping.calc` operation.

1.  Click the `+ Case` button to add a second case for the `get.stores` operation.

1.  Click the `X` to close the operation switch configuration editor.

    You should see two new processing pipelines created on your `operation-switch` step - one for each case:  
    
    ![](./images/labs/lab5/log-operation-switch.png)

### Configure the `shipping.calc` Case:

This operation will end up invoking two separate back-end services to acquire shipping rates for the respective companies, then utilize a map action to combine the two separate responses back into a single, consolidated message for our consumers.

1.  Add an invoke policy to the `shipping.calc` case.

    ![](./images/labs/lab5/add-invoke-action.gif)

1.  Edit the **invoke** action with the following properties:

    > Title: `invoke_xyz`
    >
    > URL: `$(shipping_svc_url)?company=xyz&from_zip=90210&to_zip={zip}`
    >
    > Stop on error: `unchecked`
    >
    > Response object variable (scroll to the bottom): `xyz_response`
    
    ![](./images/labs/lab5/log-invoke-xyz-1.png)
    
    ![](./images/labs/lab5/log-uncheck-stop-on-error.png)
    
    ![](./images/labs/lab5/log-invoke-xyz-2.png)
    
    {% include note.html content="
        The `{zip}` parameter provided here is a reference to the `zip` parameter defined as input to the operation. The `{zip}` portion of the URL will get replaced by the actual zip code provided by the API consumers.
    " %}

1.  Hover over the `invoke_xyz` policy and click on the `clone` button to add another invoke action:

    ![](./images/labs/lab5/log-clone-invoke-action.png)

1.  Edit the new invoke policy with the following properties:

    > Title: `invoke_cek`
    >
    > URL: `$(shipping_svc_url)?company=cek&from_zip=90210&to_zip={zip}`
    >
    > Response object variable: `cek_response`
	
    ![](./images/labs/lab5/log-invoke-cek-1.png)
	
    ![](./images/labs/lab5/log-invoke-cek-2.png)

1.  Add a `map` policy after the last invoke, then click it to open the editor.

    ![](./images/labs/lab5/add-map-action.png)

1.  Click the pencil button at the top of the **Input** column, then click on the `+ input` button.

    Enter the following input configuration:
  
    > Context variable: `xyz_response.body`
    >
    > Name: `xyz`
    >
    > Content type: `application/json`
    >
    > Definition: `#/definitions/xyz_shipping_rsp`


1.  Click the `+ input` button again to add another input. Specify the following input configuration:
  
    > Context variable: `cek_response.body`
    >
    > Name: `cek`
    >
    > Content type: `application/json`
    >
    > Definition: `#/definitions/cek_shipping_rsp`

1.  Paste the same schema definition that was used for the previous input (for our lab purposes, the responses from the shipping service are in the same format, thus using the same schema)

1.  You now have two inputs assigned to the `map` policy:

    ![](./images/labs/lab5/log-map-responses-inputs.png)

1.  Click the `Done` button to return to the editor.

1.  Click the pencil icon at the top of the **Output** column, then click the `+ outputs for operation...` and choose the `shipping.calc` operation.

1.  Set the **Content type** parameter to `application/json`.

1.  Click the `Done` button to return to the editor.

1.  Complete the mapping. To map from an input field to an output field, click the circle next to the *source* element once, then click the circle next to the *target* element. A line will be drawn between the two, indicating a mapping from the source to the target.  

    ![](./images/labs/lab5/log-map-complete.png)

1.  Click the `X` to close the map editor.

    Your assembly policy for the `shipping.calc` operation is now complete.
      
    ![](./images/labs/lab5/log-shipping-calc-policy.png)
	
1.  Save your changes.

    ![](./images/common/save.png)

## Conclusion

Congratulations, you have just configured an assembly which calls two separate endpoints and aggregates data from each response into a single consolidated response!

Proceed to [Using GatewayScript in an Assembly](lab5_logistics_gws.html).