---
title: Using GatewayScript in an Assembly
toc: false
sidebar: labs_sidebar
folder: labs/lab5
permalink: /lab5_logistics_gws.html
summary: In this section, you will configure the assembly for the store locator resource. You will use GatewayScript to modify the response to your consumers, providing them a maps link to the nearest store location.
applies_to: [developer]
---
 
## Configure the `get.stores` Case:

This operation will call out to the Google Geocode API to obtain location information about the provided zip code, then utilize a simple gatewayscript to modify the response and provide a formatted Google Maps link.

1.  Add an invoke policy to the `get.stores` case.

    ![](./images/labs/lab5/add-invoke-action-2.gif)

1.  Edit the new **invoke** action with the following properties:

    > Title: `invoke_google_geolocate`
    >
    > URL: `https://maps.googleapis.com/maps/api/geocode/json?&address={zip}`
    >
    > Stop on error: `unchecked`
    >
    > Response object variable (scroll to the bottom): `google_geocode_response`  
	
    ![](./images/labs/lab5/log-invoke-geolocate-1.png)
	
	![](./images/labs/lab5/log-uncheck-stop-on-error.png)
	
    ![](./images/labs/lab5/log-invoke-geolocate-2.png)
    
1.  Click the `X` to close the invoke editor.

1.  Add a `gatewayscript` policy with the following properties:  
  
    > Title: `gws_format_maps_link`
    >
    > Copy the following GatewayScript snippet and paste it into the text area:
    > 
    > ```javascript
    > // Save the Google Geocode response body to variable
    > var mapsApiRsp = apim.getvariable('google_geocode_response.body');
    > 
    > // Get location attributes from geocode response body 
    > var location = mapsApiRsp.results[0].geometry.location;
    >
    > // Set up the response data object, concat the latitude and longitude  
    > var rspObj = {
    >   "google_maps_link": "https://www.google.com/maps?q=" + location.lat + "," + location.lng  
    > };
    > 
    > // Save the output  	
    > apim.setvariable('message.body', rspObj);
    > ```
	
    ![](./images/labs/lab5/log-gws.png)
	
	{% include note.html content="
	    Take a quick look at line 5. Notice how our gateway script file is reading the body portion of the `google_geocode_response` variable which was assigned to the output of the `invoke` action.
    " %}

1.  Click the `X` to close the gatewayscript editor.

1.  Your assembly for the `logistics` API will now include two separate operation policies:

    ![](./images/labs/lab5/log-assembly-complete.png)

1.  Save your changes.

    ![](./images/common/save.png)

1.  Click on the `<- All APIs` link to return to the draft APIs list.

## Conclusion

**Congratulations!** You have successfully configured two new API's with advanced assemblies. In the next lab, you will bundle the API's into a Product and publish it to the consumer portal.

Proceed to [Lab 6 - Working with API Products](lab6_overview.html).