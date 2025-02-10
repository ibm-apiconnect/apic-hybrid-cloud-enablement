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
FILENBR="222"
OUT_FILENAME="apic-cluster.yaml"
create_outfile
## -----------------------------------------------------
APIC_CLUSTER_NAME=$( $OC get APIConnectCluster | awk 'NR>1' | awk '{print $1}' )
# echo $APIC_CLUSTER_NAME
$OC get APIConnectCluster $APIC_CLUSTER_NAME -o yaml > $APIC_OUTPUT_DIR/$FILENBR-$OUT_FILENAME
echo "APIConnectCluster CR:" $APIC_OUTPUT_DIR/$FILENBR-$OUT_FILENAME
## -----------------------------------------------------
# get mgmt subsystem yaml
## -----------------------------------------------------
FILENBR="223"
OUT_FILENAME="apic-cluster-name-mgmt.yaml"
create_outfile
## -----------------------------------------------------
APIC_MGMT_NAME=$( $OC get mgmt | awk 'NR>1' | awk '{print $1}' )
$OC get mgmt $APIC_MGMT_NAME -o yaml >  $APIC_OUTPUT_DIR/$FILENBR-$OUT_FILENAME
echo "APIC mgmt subsystem:" $APIC_OUTPUT_DIR/$FILENBR-$OUT_FILENAME
## -----------------------------------------------------
# get mgmt subsystem ingress-ca
## -----------------------------------------------------
FILENBR="224"
OUT_FILENAME="management-ingress-ca.yaml"
create_outfile
## -----------------------------------------------------
MGMT_INGRESS_CA=$( $OC get secret | grep ingress-ca | awk '{print $1}' )
$OC get secret $MGMT_INGRESS_CA -o yaml > $APIC_OUTPUT_DIR/$FILENBR-$OUT_FILENAME
echo "APIC mgmt $MGMT_INGRESS_CA:" $APIC_OUTPUT_DIR/$FILENBR-$OUT_FILENAME
## -----------------------------------------------------
# prepare mgmt ingress-ca for apigw2
## -----------------------------------------------------
# Remove metadata .creationTimestamp, .namespace, .resourceVersion, .uid, .selfLink from YAML
# MUST have yq version 4.18.1 or later. Earlier versions do not have 'delete' feature
## -----------------------------------------------------
FILENBR="225"
OUT_FILENAME="ingress-ca.yaml"
IN_FILENAME="224-management-ingress-ca.yaml"
## -----------------------------------------------------
create_outfile
$YQ_TOOL 'del(.metadata.selfLink)' $APIC_OUTPUT_DIR/$IN_FILENAME | $YQ_TOOL 'del(.metadata.creationTimestamp)' | $YQ_TOOL 'del(.metadata.namespace)' | $YQ_TOOL 'del(.metadata.resourceVersion)' | $YQ_TOOL 'del(.metadata.uid)' | $YQ_TOOL 'del(.metadata.selfLink)'  > $APIC_OUTPUT_DIR/$FILENBR-$OUT_FILENAME
echo "APIC mgmt ingress-ca:" $APIC_OUTPUT_DIR/$FILENBR-$OUT_FILENAME
