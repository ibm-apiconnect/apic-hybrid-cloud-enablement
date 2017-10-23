// Require API Connect Functions
var apic = require('local:///isp/policy/apim.custom.js');

// Save the Google Geocode response body to variable
var mapsApiRsp = apic.getvariable('google_geocode_response.body');

// Get location attributes from geocode response body
var location = mapsApiRsp.results[0].geometry.location;

// Set up the response data object, concat the latitude and longitude
var rspObj = {
  "google_maps_link": "https://www.google.com/maps?q=" + location.lat + "," + location.lng
};

// Save the output
apic.setvariable('message.body', rspObj);