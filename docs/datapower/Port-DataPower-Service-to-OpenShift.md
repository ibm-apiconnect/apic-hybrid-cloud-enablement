# IBM DataPower  
> ## Port DataPower Services from Legacy Platforms to OpenShift   
>  Ravi Ramnarayan, Charlie Sumner    
>  &copy; IBM v1.33  2022-07-14      

## Goals  
- Demonstrate Proof of Technology (POT) to receive HTTP messages in DataPower and route them to the appropriate MQ queue.  
- Illustrate process to port DataPower configurations from legacy platforms to DataPower on OpenShift.

### Audience  
Experienced IT professionals who are experts in DataPower and OpenShift.   

### Acknowledgments  
Paul Faulkner contributed the MQ server, defined queues and helped setup the tool to verify message receipt.  

## Approach  
- Legacy solution  
  - An existing solution on DataPower (DPG) physical appliance, VMware or Linux  
    For this POT, the solution comprises MQ objects and an XSL file to route incoming messages to the appropriate queue. All configurations are in the domain **MQFYRE**.    
  - Validate the solution with messages and MQ queues    
  - Isolate configurations in `config`, `local` & `certs`  
    This POT does not use `certs`.   
- Deploy configurations on DataPower on OpenShift (OCP)  
  - Package configurations according to guidelines in [Customizing a DataPower deployment](https://www.ibm.com/docs/en/api-connect/10.0.x?topic=subsystem-customizing-datapower-deployment) and [Domain Configuration](https://www.ibm.com/docs/en/datapower-operator/1.6?topic=guides-domain-configuration)     
  - Inject configurations into DataPower through the APIConnectCluster CR  
  - Create an OCP Route to expose the DataPower MQ listener  

#### Legacy POT components    
MQFYRE domain contains the files we need to migrate the POT solution to OpenShift  
- MQ related configurations are in `config/MQFYRE.cfg`    
- Route logic is in `local/Route2qByURI.xsl`  

#### Diversion from the DataPower expert track
> ***Only for DataPower newbies***: [DataPower newbie track](#datapower-newbie-track)  

## Deploy MQFYRE domain objects for DataPower on OpenShift (OCP)  
The approach relies on features of `additionalDomainConfig` detailed in [Customizing a DataPower deployment](https://www.ibm.com/docs/en/api-connect/10.0.x?topic=subsystem-customizing-datapower-deployment):   
  - Modify configuration of an existing domain  
  - Create a new domain, if the domain does not exist  
    [Domain Configuration](https://www.ibm.com/docs/en/datapower-operator/1.6?topic=guides-domain-configuration) defines the constructs to inject `config`, `certs`, and `local` into DataPower OCP. This POT solution does not use `certs`.  

### Organize files in specific directories  
Place `MQFYRE.cfg` in `config` and `Route2qByURI.xsl` in `local` directories:

  ```
  cd <path>  
  $ tree
  .
  ├── config
  │   └── MQFYRE.cfg
  └── local
      └── Route2qByURI.xsl
  ```  

### Place MQFYRE configurations in `configMap`  

#### `local`  
The POT example is [Route2qByURI.xsl](./samples/dp-mq-flow/local/Route2qByURI.xsl).  

- Create tarball for files in `<path>/local`. The DataPower operator will deploy the files to DPG `local:///` within the MQFYRE domain.
  ```
  tar --directory=<path>/local -czf MQFYRE-local.tar.gz .
  ```  
  Ensure the tarball is correct:
  ```
  $ tar -tzf MQFYRE-local.tar.gz
  ./
  ./Route2qByURI.xsl

  ```
In this POT we have only one file in `local`. If your solution calls for multiple files, place all files in `local` and create the tarball.  

- Create the `configMap`    
```  
oc project <namespace>
oc create configmap mqfyre-local --from-file=<path>/MQFYRE-local.tar.gz
```
- Examine the `configMap`:  
```
oc get configmap mqfyre-local -o yaml  
apiVersion: v1
binaryData:
  MQFYRE-local.tar.gz: H4sIAAAAAAAAA+2UW2vbMBTH85pCv4MQhaQwW3Gua6hTGKxQaAdNW+geVfskMdiyK8m57NPvyE6cpNeXljKmX0IsonP/y3JZ7dNpIYNBzzy9Qa+1+9xQ87rtXr/fH+C31vK8bqdfI73PL61Wy5XmkpCalDwRXPLX7N7b/0dx2TjNNbQff6zuxhfuUsUfn8MI3O93X9O/3fHapf7ddsvreKh/t9Pt1Ujr40t5zn+u/+nZMonJHKSKUuFTz21RAiJIw0hMfXp3e+58p2ejw4NTPBlDpVcxqBmA3vc4PKhjFKGGaOTTmdbZkLHFYuEuOm4qp8w7OTlh9zeX7FZyoSapTCgpHcJszz7kmmfpAqQbpAmDpQZhsqhthjALUjGJpm+4ZahSwkqzTZ6lil4qrI0nkd1fXd4EM0i4Ewk8DCKA3YbC9/02SdBZ71lrSLJc8sLlBjdhksdsG1ylPAMxr1xUEU25uGu2CjezYGgEcZpB4VtNxYEYEhDaySRMoiUon4YZqrcM4jwER4LK4/1NspkeRUXrhaT48me5JgnoWYqtYurn+pNIhJjHpyKlhKGr+ZTupsMYGyMJ18HMp4wW2/U6IaQwmHMZ8YcYiOAJ+DSX0cUvShSWHmhTUmXQbODKDAHkPAqA4W3UODbpCDERSclLMSNxnUMO26gqf1BaYgMOn2iQzaMi67cGezR2rAxbdrENGk2IBmW8S9cYxFTPmgIPK4+jP+CojAfQPFpnOz4mI9KiRXVFkHrx+2aheNFMQW/rRC0CrpuNMEsesfOr6/Pf45/sbAxYp9JFGr/xrcpYVr2Oj4vtkBNQik8B5R1mMkplpFc4W3jIUejCIEizlZNOqsxH61LY6JTtBBiRKrrRsE5OMaIC7Txp5IlUEg+RGVku4wYlcx5j3VUKo+C66s24WTnvqpmqqfWqNNgcrUKp9X/bC2i064TFHh589U1qsVgsFovFYrFYLBaLxWKxWCwWi8VisVgsFsvX8ReVqO8sACgAAA==
kind: ConfigMap
metadata:
  creationTimestamp: "2022-07-12T12:29:45Z"
  managedFields:
  - apiVersion: v1
    fieldsType: FieldsV1
    fieldsV1:
      f:binaryData:
        .: {}
        f:MQFYRE-local.tar.gz: {}
    manager: kubectl-create
    operation: Update
    time: "2022-07-12T12:29:45Z"
  name: mqfyre-local
  namespace: cp4i
  resourceVersion: "122640556"
  uid: afd2d227-99ac-4b0a-a79f-47367a752755
```  

#### `config`  
The POT example is [MQFYRE.cfg](./samples/dp-mq-flow/config/MQFYRE.cfg).
> ***Note***:
  >- The comment line (starts with "#") has been removed from MQFYRE.cfg. Otherwise it will scramble the `configMap`.  
  >- You should replace the following lines in `mq-qm` object with an appropriate server & queue manager.  
    `hostname RAVIQM1.CHARLIE.XYZ.COM(1419)`  
    `queue-manager "RAVIQM"`  


  ```
  oc create configmap mqfyre-config --from-file=<path>/config/MQFYRE.cfg

  ```

Examine the `configMap`. It should have the contents of [MQFYRE.cfg](./samples/dp-mq-flow/config/MQFYRE.cfg) in plain text. If it looks scrambled, remove the comment line and try again.  
  ```
  oc get configmap mqfyre-config -o yaml  
  apiVersion: v1
  data:
    MQFYRE.cfg: |
      top; configure terminal;

      %if% available "domain-settings"

      domain-settings
        admin-state enabled
        password-treatment masked
        config-dir config:///
      exit

      %endif%
    ...
    ...
    ...
      %if% available "wsm-agent"

      wsm-agent
        admin-state disabled
        max-records 3000
        max-memory 64000
        capture-mode faults
        buffer-mode discard
        no mediation-enforcement-metrics
        max-payload-size 0
        push-interval 100
        push-priority normal
      exit

      %endif%
  kind: ConfigMap
  metadata:
    creationTimestamp: "2022-07-12T12:39:58Z"
    managedFields:
    - apiVersion: v1
      fieldsType: FieldsV1
      fieldsV1:
        f:data:
          .: {}
          f:MQFYRE.cfg: {}
      manager: kubectl-create
      operation: Update
      time: "2022-07-12T12:39:58Z"
    name: mqfyre-config
    namespace: cp4i
    resourceVersion: "122648530"
    uid: 303fea14-e911-4b3c-b1ff-51dbbbc15dc8
  ```  

### Inject MQFYRE into DataPower  


- Define `additionalDomainConfig` in file [`pot-additionalDomainConfig.yaml`](./samples/dp-mq-flow/pot-additionalDomainConfig.yaml)  
  The contents should include **all previous entries** and new definitions for `MQFYRE` domain. In this example, the only previous entries were to expose the WebGUI.  

  ```
  spec:
    gateway:
      additionalDomainConfig:
      - name: "default"
        dpApp:
          config:
          - "311-default-web-mgmt-cfg"
      - name: "MQFYRE"
        dpApp:
          config:
          - "mqfyre-config"
          local:
          - "mqfyre-local"
  ```

  > ***Note***: `spec.gateway.additionalDomainConfig` This POT was developed for an API Connect & Datapower deployment on OpenShift.   

- Determine the name of the APIConnectCluster:
    ```
    oc get apiconnectcluster  
    NAME           READY   STATUS   VERSION    RECONCILED VERSION   AGE
    apis-minimum   7/7     Ready    10.0.4.0   10.0.4.0-ifix1-54    105d
    ```
- Apply `additionalDomainConfig`  

  `oc patch apiconnectcluster apis-minimum --type merge --patch-file='<path>/pot-additionalDomainConfig.yaml'`  

- Examine the DataPower configuration  
  - Log into the DataPower pod with `admin/<secret>`:  
  `oc attach -it po/apis-minimum-gw-0 -c datapower`  

  - Display the following via CLI or use the WebGUI  
    Do you see the domains `default` and `MQFYRE`? The domain `apiconnect` will appear if, as in this POT, the DataPower hosts the API Connect Gateway Service. Drill down `local:///` and locate `Route2qByURI.xsl`.
    ```
    idg# show domains

     Domain     Needs save File capture Debug log Probe enabled Diagnostics Command Quiesce state Interface state Failsafe mode
     ---------- ---------- ------------ --------- ------------- ----------- ------- ------------- --------------- -------------
     MQFYRE     off        off          off       off           off                               ok              none          
     apiconnect off        off          off       off           off                               ok              none          
     default    off        off          off       off           off                               ok              none          

    idg# co
    Global mode
    idg(config)# dir local:
       File Name                    Last Modified                    Size
       ---------                    -------------                    ----
       MQFYRE/                      Jul 12, 2022 1:04:04 PM          30
       luna_config/                 Jul 12, 2022 1:04:05 PM          58
       apiconnect/                  Jul 12, 2022 1:07:03 PM          116

       176673.9 MB available to local:

    idg(config)# dir local:///MQFYRE
       File Name                    Last Modified                    Size
       ---------                    -------------                    ----
       Route2qByURI.xsl             Jul 12, 2022 1:04:04 PM          1226

       176673.2 MB available to local:///MQFYRE

    ```  
  - Logoff
    ```
    idg(config)# exit;exit  
    ```
  - Detach with `CTRL-P-Q` so that the pod stays alive.     



### Expose the DataPower MQ listening port   
Until now we have operated under the umbrella of the APIConnectCluster. We tweaked `spec.gateway` in the APIConnectCluster which rippled the changes to the GatewayCluster and the corresponding StatefulSet. The DataPower Service instance exposes ports such as `webgui-port: 9090`, `apic-gw-mgmt: 3000` and several others, but it is not under the control of the APIConnectCluster.

  >***Note***: Do NOT modify the DataPower Service created during API Connect installation.  

#### Define a new Service for the MQ listening port   
- Get DataPower `app.kubernetes.io/instance`  
  We need the value for the target GatewayCluster. In this case, the APIConnectCluster created the GatewayCluster instance as evidenced by the presence of the domain `apiconnect`. In other cases, the DataPower GatewayCluster might be independent from APIConnectCluster.   
  ```
  oc get pod | grep gw
  apis-minim-c20517ff-mtls-gw-7bd79cf7ff-h5hbl                      1/1     Running     0          11d
  apis-minimum-gw-0                                                 1/1     Running     0          3h

  oc get pod apis-minimum-gw-0 -o yaml | grep app.kubernetes.io/instance
    app.kubernetes.io/instance: cp4i-apis-minimum-gw
  ```
- Define Service [mqfyre-gw-datapower.yaml](samples/dp-mq-flow/mqfyre-gw-datapower.yaml)  
  Reference: *Service creation* in [Exposing DataPower Services](https://www.ibm.com/docs/en/datapower-operator/1.6?topic=guides-exposing-datapower-services).

  ```
  apiVersion: v1
  kind: Service
  metadata:
    name: mqfyre-gw-datapower
  spec:
    selector:
      app.kubernetes.io/component: datapower
      app.kubernetes.io/instance: cp4i-apis-minimum-gw    
    ports:
    - protocol: TCP
      port: 8181
      targetPort: 8181
      name: mqfyre
    ```

- Create the OpenShift Service   
  `oc apply -f mqfyre-gw-datapower.yaml`  

- Verify the Service  
  ```
  oc get service mqfyre-gw-datapower
  NAME                  TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
  mqfyre-gw-datapower   ClusterIP   172.30.66.221   <none>        8181/TCP   2m50s
  ```

#### Create an OpenShift Route to the MQ port 8181  
DataPower port 8181 is an HTTP port. Hence, [mqfyre-dp2-route.yaml](samples/dp-mq-flow/mqfyre-dp2-route.yaml) defines a Route without TLS. For an HTTPS port, you would modify the YAML to suit.  

Create the Route:  
  `oc apply -f <path>/mqfyre-dp2-route.yaml`


### Validate MQFYRE flow  
[mq-payload.xml](samples/dp-mq-flow/mq-payload.xml) contains a sample payload.  

`curl --data-binary @mq-payload.xml MQFYRE-Route-Name/queue/{queuename}`
where   
- `{queuename}` is the name of the queue  
- `@mq-payload.xml` contains the payload. `@` ensures that `curl` transmits the file as is  

Send a message to MQ.INPUT1:  
  `curl --data-binary @mq-payload.xml http://mqfyre-dp2-cp4i.ravi.charlie.rrcs.xyz.com/queue/MQ.INPUT1`  

And to MQ.INPUT2:  
  `curl --data-binary @mq-payload.xml http://mqfyre-dp2-cp4i.ravi.charlie.rrcs.xyz.com/queue/MQ.INPUT2`  



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

Enable WebGUI in `web-mgmt` of the `default` domain and restart the DataPower container. Develop complex configurations for this POT using the WebGUI and extract them from from the underlying file system. You could develop the POT solution on DataPower Docker using WebGUI, just as you would on other platforms.   

### DataPower newbie track  
As a DataPower newbie (like one of the authors), you could request the DataPower guru to export configurations of DataPower objects:

> ***Note***: The following DataPower objects are specific to this POT  

- MQ Queue Manager object - Connection to Queue Manager  - Specifies the MQ Manager Host name, Port, Queue Manager and Channel Name
- Multi-Protocol Gateway Service - Service object that accepts a transaction via HTTP, determines the backend endpoint by extracting the URI, and then performs a put to the backend queue
- HTTP Front Side Protocol Handler - Listens for HTTP traffic on Port 8181
- Custom XSL Stylesheet - Retrieves the specifed URI (/queue/{queue name}), extracts queue name with a string function  
  `<xsl:variable name="uriIN" select="dp:variable('var://service/URI')" />`  
  `<xsl:variable name="inQueue" select="substring-after($uriIN,'/queue/')" />`  
  and concatenates the protocol and MQ Queue Manageer name (created above) and sets the target service variable to the completed URL  
  `<xsl:variable name="target" select="concat('dpmq://MQFYRE/?RequestQueue=',$inQueue)" />`  
  `<dp:set-variable name="'var://service/routing-url'" value="$target" />`  

  Payload is sent to DataPower Gateway using the `hostname:port/queue/{queuename}`. If URI is not specified, the payload will be sent to default queue (specified in MPGW service configuration).  If `{queuename}` is incorrect or invalid, the transaction will be canceled as MQ Open will fail.  
- [DP-2-MQ-export.zip](./samples/dp-mq-flow/DP-2-MQ-export.zip) contains the POT configuration  

#### DataPower Docker   

- Create the domain MQFYRE (defaults for all settings)  
- Import configurations in [DP-2-MQ-export.zip](./samples/dp-mq-flow/DP-2-MQ-export.zip)  
- Examine the logic on WebGUI  
- Capture DataPower configurations in `certs`, `config` & `local`.  

  ```
  $ tree dp-dev/
  dp-dev/
  ├── certs
  │   ├── luna_cert
  │   ├── MQFYRE
  │   ├── webgui-privkey.pem
  │   └── webgui-sscert.pem
  ├── config
  │   ├── auto-startup.cfg
  │   ├── auto-user.cfg
  │   ├── default.cfg
  │   └── MQFYRE
  │       └── MQFYRE.cfg
  └── local
      ├── luna_config
      │   ├── Chrystoki.conf
      │   ├── configData
      │   │   └── token
      │   │       └── 001
      │   └── data
      │       ├── client_identities
      │       ├── partition_identities
      │       └── partition_policy_templates
      └── MQFYRE
          └── Route2qByURI.xsl

  15 directories, 8 files

  ```  

- MQ related configurations are in `config/MQFYRE/MQFYRE.cfg`  
- Route logic is in `local/MQFYRE/Route2qByURI.xsl`  

Return to [**Diversion from the DataPower expert track**](#diversion-from-the-datapower-expert-track).
