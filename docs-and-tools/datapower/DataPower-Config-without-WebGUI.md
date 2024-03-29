# DataPower Config without WebGUI   
#### IBM DataPower: Migrate to Cloud  
>  Ravi Ramnarayan  
>  &copy; IBM v2.7  2023-10-13  


## DataPower Config   
The DataPower WebGUI makes it easy to customize domain configurations. When DataPower runs on Kubernetes (k8s), or Redhat Openshift (OCP) in conjunction with API Connect, we can create and manage configurations through k8s or OCP commands. This document posits use cases and details implementation steps for DataPower running on k8s/OCP. While Crypto objects kick started this document, other DataPower configurations can be controlled with the same approach. The document highlights the differences in implementation steps for k8s, OCP and CP4I installations.    

## Goals  
- Empower IBM API Connect clients to configure DataPower k8s/OCP as they would DataPower appliances, physical or virtual  
- Provide the flow of operations and commands (CLI) to implement CI/CD  
- Preserve the evidence with files in source control  

### Target audience  
- Experienced IT Professionals with in depth knowledge of IBM API Connect, DataPower, k8s/OCP  
- Specific items: k8s/OCP commands, DataPower commands, DataPower login k8s/OCP   

### Use cases  
The use cases address configurations for the `apiconnect` domain and the system wide `default` domain.  

- JWT Key in `apiconnect` domain  
  Almost all installations of IBM API Connect (APIC) use the JWT feature. Clients would like API to use a common JWT Key.  
- Enable `web-mgmt` in `default` domain  
- DataPower configurations in `default` and `apiconnect` domains  

Though the use cases differ in complexity the solutions traverse the same trail.  

  - Create Secrets and ConfigMaps  
  - Apply `additionalDomainConfig` to the target domain   
    The configurations will propagate to all DataPower pods which support the `apiconnect` domain or all pods for the `default` domain. Reference: [Customizing a DataPower deployment](https://www.ibm.com/docs/en/api-connect/10.0.x?topic=subsystem-customizing-datapower-deployment).
  - Verify DataPower configurations  


## JWT DataPower Crypto Key in `apiconnect` domain
Any API published to the DataPower `apiconnect` domain could use JWT key. The API may belong to different API Connect Catalogs.

> *Pro*: No need to republish API when the Crypto Key is changed.  
> *Contra*: Creating a DataPower Crypto Key is more complex than creating an API Connect Catalog propery.  


### Secret & ConfigMap  

- Create secret  
  `kubectl create secret generic mycryptokey --from-file=./my-apic-privkey.pem -n dev`  
  The file `my-apic-privkey.pem` should contain a private key generated by `openssl`. The file contains encoded text sandwiched between `-----BEGIN RSA PRIVATE KEY-----` and `-----END RSA PRIVATE KEY-----`. In other words, it contains only the key and no meta data. Please consult documents for steps to generate certificates and keys. An example: [mkjwk - JSON Web Key Generator](https://mkjwk.org/).  

- Capture details of the k8s secret  
  `kubectl get secret mycryptokey -n dev -o yaml`  
  ```
  apiVersion: v1
  data:
    my-apic-privkey.pem: LS0tLS1CRUdJ<yada yada yada>U0EgUFJJVkFURSBLRVktLS0tLQo=
  kind: Secret
  metadata:
    creationTimestamp: "2021-10-12T20:38:31Z"
    managedFields:
    - apiVersion: v1
      fieldsType: FieldsV1
      fieldsV1:
        f:data:
          .: {}
          f:my-apic-privkey.pem: {}
        f:type: {}
      manager: kubectl-create
      operation: Update
      time: "2021-10-12T20:38:31Z"
    name: mycryptokey
    namespace: dev
    resourceVersion: "2434040"
    selfLink: /api/v1/namespaces/dev/secrets/mycryptokey
    uid: e4e41128-0410-4d48-9ae1-d14277d01540
  type: Opaque
  ```
  >***Note***: The secret contains a `Name-Value` pair.
  > - Name: `my-apic-privkey.pem`  
  > - Value: `LS0tLS1CRUdJ<yada yada yada>U0EgUFJJVkFURSBLRVktLS0tLQo=`

- Create file `111-apiconnect-mycryptokey.cfg` with the content:
  ```
  crypto
    key "mycryptokey" "cert:///my-apic-privkey.pem"
  exit
  ```  
  >***Note***: The Name from the previous step is the file which contains the crypto object.

- Create a k8s configmap  
  `kubectl create configmap 111-apiconnect-mycryptokey-cfg --from-file=./111-apiconnect-mycryptokey.cfg -n dev`  

- Ensure the configmap contains valid entries  
  `kubectl get configmap 111-apiconnect-mycryptokey-cfg -n dev -o yaml`  
  ```
  apiVersion: v1
  data:
    111-apiconnect-mycryptokey.cfg: |
      crypto
        key "mycryptokey" "cert:///my-apic-privkey.pem"
      exit
  kind: ConfigMap
  metadata:
    creationTimestamp: "2021-10-29T20:15:36Z"
    managedFields:
    - apiVersion: v1
      fieldsType: FieldsV1
      fieldsV1:
        f:data:
          .: {}
          f:111-apiconnect-mycryptokey.cfg: {}
      manager: kubectl-create
      operation: Update
      time: "2021-10-29T20:15:36Z"
    name: 111-apiconnect-mycryptokey-cfg
    namespace: dev
    resourceVersion: "3114805"
    selfLink: /api/v1/namespaces/dev/configmaps/111-apiconnect-mycryptokey-cfg
    uid: e85ea025-47d5-4bb8-aaee-409a5f961f12
  ```  


### Apply `additionalDomainConfig`   

  - **k8s**   
    Apply `additionalDomainConfig` to the GatewayCluster.  

    - Create file `251-apiconnect-k8s-additionalDomainConfig.yaml` with the following lines:
      ```
      # Add mycryptokey to apiconnect domain
      spec:
        additionalDomainConfig:
        - name: "apiconnect"
          certs:
          - certType: "usrcerts"
            secret: "mycryptokey"
          dpApp:
            config:
            - "111-apiconnect-mycryptokey-cfg"
      ```
    - Modify the DataPower Gateway Cluster in the namespace `dev`  
      `kubectl patch gatewaycluster gwv6 --type merge --patch-file='251-apiconnect-k8s-additionalDomainConfig.yaml' -n dev`  

  - **OCP**   
    Apply `additionalDomainConfig` to the `gateway` section of the APIConnectCluster.  

    - Create file `261-apiconnect-ocp-additionalDomainConfig.yaml` with the following lines:
      ```
      # Add mycryptokey to apiconnect domain
      spec:
        gateway:
          additionalDomainConfig:
          - name: "apiconnect"
            certs:
            - certType: "usrcerts"
              secret: "mycryptokey"
            dpApp:
              config:
              - "111-apiconnect-mycryptokey-cfg"
      ```  
      >***Note***: `spec.gateway.additionalDomainConfig`  

    - Determine the name of the APIConnectCluster:
      ```
      # oc project dev  
      # oc get apiconnectcluster  
      NAME      READY   STATUS   VERSION        RECONCILED VERSION   AGE
      apic-rr   4/4     Ready    10.0.1.5-eus   10.0.1.5-3440-eus    18h
      ```
    - Patch APIConnectCluster with `additionalDomainConfig`  
      `oc patch apiconnectcluster apic-rr --type merge --patch-file='261-apiconnect-ocp-additionalDomainConfig.yaml'`  

    - Determine the name(s) of the DataPower pod(s)  
      From the above we know that `apic-rr` is the prefix for installation.  
      ```
      # oc get pod | grep apic-rr-gw  
      apic-rr-gw-0                                                      1/1     Running     0          12m
      ```
      In the lab installation there is only one DataPower pod.  


### Verify DataPower crypto object   

Wait for the gateway pod(s) to restart and attach to any gateway pod.

- Log into DataPower  

    **k8s**: `kubectl attach -it gwv6-0 -c datapower -n dev `   
    **OCP**: `oc attach -it apic-rr-gw-0 -c datapower -n dev `   

    ```
    login: admin
    Password: *****

    Welcome to IBM DataPower Gateway console configuration.
    Copyright IBM Corporation 1999, 2021

    Version: IDG.10.0.3.0 build 333705 on Jun 16, 2021 9:06:57 PM
    Delivery type: CD
    Serial number: 0000001

    idg# switch apiconnect;co
    Global mode
    idg[apiconnect](config)# show key mycryptokey

    key: mycryptokey [up]
    ----------------
    admin-state enabled
    file-name cert:///my-apic-privkey.pem

    idg[apiconnect](config)# dir cert:
      File Name                    Last Modified                    Size
      ---------                    -------------                    ----
      my-apic-privkey.pem           Oct 12, 2021 8:56:03 PM          1679
      gwd/                         Oct 12, 2021 8:56:03 PM          44
    ```
    `mycryptokey` uses the private key in `file-name cert:///my-apic-privkey.pem` and its status is `[up]`.  

- Log out from DataPower (mind the P's & Q's):  
  `exit;exit`  
  `Ctrl-P Ctrl-Q`  





## Enable `web-mgmt` in `default` domain   

This is usually the first tweak to DataPower installations since the dawn of the WebGUI. No secrets needed. And yet, you will enable web-mgmt on all DataPower containers in the API Connect Cluster.    

- Create file `311-default-web-mgmt.cfg` with the content:
  ```
  web-mgmt
    admin enabled
  exit
  ```

- Create a ConfigMap  
  `kubectl create configmap 311-default-web-mgmt-cfg --from-file=./311-default-web-mgmt.cfg -n dev`  

### API Connect on OCP  
- File [361-default-ocp-additionalDomainConfig.yaml](./samples/dpg-cfg-no-webgui/361-default-ocp-additionalDomainConfig.yaml) contains:
  ```
  spec:
    gateway:
      additionalDomainConfig:
      - name: "default"
        dpApp:
          config:
          - "311-default-web-mgmt-cfg"
  ```
- Determine the name of the APIConnectCluster:
  ```
  # oc project dev  
  # oc get apiconnectcluster  
  NAME      READY   STATUS   VERSION        RECONCILED VERSION   AGE
  apic-rr   4/4     Ready    10.0.1.5-eus   10.0.1.5-3440-eus    18h
  ```
- Patch APIConnectCluster with `additionalDomainConfig`  
  `oc patch apiconnectcluster apic-rr --type merge --patch-file='361-default-ocp-additionalDomainConfig.yaml'`  

- Determine the name(s) of the DataPower pod(s)  
  From the above we know that `apic-rr` is the prefix for installation.  
  ```
  # oc get pod | grep apic-rr-gw  
  apic-rr-gw-0                                                      1/1     Running     0          12m
  ```
  In the lab installation there is only one DataPower pod.  

- Verify `web-mgmt` setting on DataPower   
  Most production installations have three DataPower pods. You could attach to any pod to verify the `apiconnect` domain configurations.  
  `oc attach -it apic-rr-gw-0 -c datapower `   

- Expose the WebGUI on OCP using an option below  
    - Step 2 in [Enable DataPower webgui in cp4i and OCP](https://www.ibm.com/support/pages/enable-datapower-webgui-cp4i-and-ocp)
    - Command line  
    `oc create route passthrough <route-name-webgui> --service='<gwy-datapower-service-name>' --hostname='<webgui-name>.<ocp-cp4i-installation>' --insecure-policy='None' --port='webgui-port'`
        - `<route-name-webgui>`: Should be unique within Routes, all lower case.
        - `--hostname`: `<ocp-cp4i-installation>` is the value common to all defined Routes. `<webgui-name>` should be unique.
        - `--insecure-policy`: The value `None` is case sensitive. `N` must be upper case.
        - `--port`: You could use `9090` or `webgui-port` which is defined in the DataPower Service.

### API Connect on CP4I  
There are a few settings which can be controlled from the CP4I Openshift console. For all other DataPower configurations, you will have to use `additionalDomainConfig`.  

- API Connect on CP4I offers an option to enable WebGUI in the Openshift console. [How to enable web-mgmt in cp4i?](https://www.ibm.com/support/pages/node/6496879) walks you through steps to enable WebGUI on CP4I. You will need to define a Route using:
  - Use Step 2 in [Enable DataPower webgui in cp4i and OCP](https://www.ibm.com/support/pages/enable-datapower-webgui-cp4i-and-ocp) to expose the WebGUI to a browser
  - Or use the command line (above) to expose the WebGUI  

- You could still use `additionalDomainConfig` on CP4I to enable WebGUI as described above for OCP.  

## Changes to `default` and `apiconnect` domains  
Let's combine [JWT DataPower Crypto Key in `apiconnect` domain](#jwt-datapower-crypto-key-in-apiconnect-domain) with [Enable `web-mgmt` in `default` domain](#enable-web-mgmt-in-default-domain).  

- Define the Secrets & ConfigMaps needed for both use cases  
- Create [411-default-apiconnect-combo-ocp-addlDomainCfg.yaml](./samples/dpg-cfg-no-webgui/411-default-apiconnect-combo-ocp-addlDomainCfg.yaml) with  
  ```
  # Combo default & apiconnect: web-mgmt & mycryptokey
  spec:
    gateway:
      additionalDomainConfig:
      - name: "default"
        dpApp:
          config:
          - "311-default-web-mgmt-cfg"
      - name: "apiconnect"
        certs:
        - certType: "usrcerts"
          secret: "mycryptokey"
        dpApp:
          config:
          - "111-apiconnect-mycryptokey-cfg"
  ```  

- Process the combined `additionalDomainConfig`  
  `oc patch apiconnectcluster apic-rr --type merge --patch-file='411-default-apiconnect-combo-ocp-addlDomainCfg.yaml'`  
  FYI... The API Connect Cluster CR will reformat the stanza   
  ```
  additionalDomainConfig:
    - dpApp:
        config:
          - 311-default-web-mgmt-cfg
      name: default
    - certs:
        - certType: usrcerts
          secret: mycryptokey
      dpApp:
        config:
          - 111-apiconnect-mycryptokey-cfg
      name: apiconnect
  ```


### Oops *!#^&  
`additionalDomainConfig` is a singleton within each DataPower domain. Every time you process an `additionalDomainConfig`, you will overwrite the previous. The moving finger having writ, cleans the slate.   

- You have modified a Single Domain `apiconnect` with `additionalDomainConfig`    
  Create an empty `additionalDomainConfig` as in sample oops file: [362-oops-apiconnect-ocp-additionalDomainConfig.yaml](./samples/dpg-cfg-no-webgui/362-oops-apiconnect-ocp-additionalDomainConfig.yaml). Process `oc patch` APIConnectCluster CR on OCP.  
  ```
  spec:
    gateway:                    <<---- for APIC on OCP
      additionalDomainConfig:
      - name: "apiconnect"    
  ```  

- You have modified Two Domains `default` & `apiconnect` with `additionalDomainConfig`   
  Let's assume you wish to remove all settings for `apiconnect` and retain the `web-mgmt` setting for the `default` domain. Create file similar to [415-oops-default-apiconnect-ocp-addlDomainCfg.yaml](./samples/dpg-cfg-no-webgui/415-oops-default-apiconnect-ocp-addlDomainCfg.yaml). Process `oc patch` APIConnectCluster CR on OCP.  
  ```
  # Keep default web-mgmt & remove apiconnect config
  spec:
    gateway:
      additionalDomainConfig:
      - name: "default"
        dpApp:
          config:
          - "311-default-web-mgmt-cfg"
      - name: "apiconnect"
  ```  
  FYI ... The API Connect Cluster CR will reformat the stanza   
  ```
  additionalDomainConfig:
    - dpApp:
        config:
          - 311-default-web-mgmt-cfg
      name: default
    - name: apiconnect
  ```

- If you wish to retain the existing `additionalDomainConfig` settings, weave them in with the new. Remember, the sequence of ConfigMaps in `dpApp.config` is critical.


## Develop DataPower `config` on your desktop  

The IBM Techcon 2022 session [Gateways in a container world - best practices](https://bzb.tools.ibm.com/TechCon2022/agenda/session/814332) explains steps to develop DataPower assemblies and configurations on your workstation.  

> ***Note***: You might have to register to access the recording or download slides.  

  Correction to slide #14  
  `docker run -it -e DATAPOWER_ACCEPT_LICENSE=true \`  
  `-e DATAPOWER_INTERACTIVE=true \ `  
  `-v $(pwd)/config:/opt/ibm/datapower/drouter/config \`  
  `-v $(pwd)/local:/opt/ibm/datapower/drouter/local \`  
  `-v $(pwd)/certs:/opt/ibm/datapower/root/secure/usrcerts \`  
  `-p 9090:9090 \                    <--- Add this line to expose WebGUI`  
  `--name dp-dev \`  
  `icr.io/integration/datapower/datapower-limited:10.0.4.0`  
  
Develop complex configurations like the TLS Sever Profile using the WebGUI and extract the `config` statements from the underlying file system.
