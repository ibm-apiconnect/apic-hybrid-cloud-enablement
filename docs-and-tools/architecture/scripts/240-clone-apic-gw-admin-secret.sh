#!/bin/bash
## ================================================
# Goal: Retrieve APIC Mgmt ingress-ca and tailor it for the new Gateway
## ================================================
# This tool is NOT a SOLUTION. You may use this script to develop your
# dev-ops processes.
## ================================================
# The user should have logged into OCP before running this script
# Additionally user should run "oc project <APIC Namespace>"
## -----------------------------------------------------
APIC_OUTPUT_DIR="cp-out"
YQ_TOOL=~/tools/yq_linux_amd64
OC=oc
APIC_CR_PROJECT="apic"
APIGW_GWY_PROJECT="apigw2"
## -----------------------------------------------------
# function to remove & recreate output file
## -----------------------------------------------------
FILENBR=""
OUT_FILENAME=""
## -----------------------------------------------------
create_outfile()
{
  if [[ -f $APIC_OUTPUT_DIR/$FILENBR-$OUT_FILENAME ]];
  then
    rm $APIC_OUTPUT_DIR/$FILENBR-$OUT_FILENAME
  fi
  touch $APIC_OUTPUT_DIR/$FILENBR-$OUT_FILENAME
}
## -----------------------------------------------------
# Extract the password for apic gw admin
## -----------------------------------------------------
GW_ADMIN_SECRET_NAME=$( $OC -n $APIC_CR_PROJECT get secret | grep gw-admin | awk '{ print $1 }'  );
echo "GW_ADMIN_SECRET_NAME:" $GW_ADMIN_SECRET_NAME

GW_ADMIN_PSWD=$( $OC -n $APIC_CR_PROJECT get secret $GW_ADMIN_SECRET_NAME -o yaml | $YQ_TOOL '.data.password' | base64 -d )
echo "GW_ADMIN_PSWD:" $GW_ADMIN_PSWD
## -----------------------------------------------------
# Create gw admin secret in APIGW_GWY_PROJECT
## -----------------------------------------------------
# $OC -n $APIGW_GWY_PROJECT create secret generic $GW_ADMIN_SECRET_NAME --from-literal=password=$GW_ADMIN_PSWD

# GW_ADMIN_PSWD2=$( $OC -n $APIGW_GWY_PROJECT get secret $GW_ADMIN_SECRET_NAME -o yaml | $YQ_TOOL '.data.password' | base64 -d  )
# echo "GW_ADMIN_PSWD2:" $GW_ADMIN_PSWD2
