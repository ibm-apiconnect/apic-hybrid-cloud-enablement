#!/usr/bin/env bash

CLOUDANT="https://820923e0-be08-46f5-a34a-003f91f00f5c-bluemix:10d585c237c8d7b599b79cfcca39cb63356f2cea7d79abf27f284801b3c149d9@820923e0-be08-46f5-a34a-003f91f00f5c-bluemix.cloudant.com"

# Delete Databases
curl -X DELETE $CLOUDANT/item
curl -X DELETE $CLOUDANT/review

# Recreate Databases
curl -X PUT $CLOUDANT/item
curl -X PUT $CLOUDANT/review

# Populate item Database
for filename in ./data/*.json; do
  curl -H "Content-Type: application/json" -d @"$filename" $CLOUDANT/item
done

echo "Cloudant table refresh is complete. Restart your Inventory application in Bluemix to re-connect."