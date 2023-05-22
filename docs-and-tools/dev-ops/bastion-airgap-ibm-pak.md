# Bastion for IBM Cloud Pak on Airgap OpenShift   
> Ravi Ramnarayan  
>  &copy; IBM v3.89  2023-05-22     


## Goals
For IBM clients who operate disconnected (airgap) IT, the bastion host and registry are long term investments. This document provides steps to build and maintain the bastion host and container registry for IBM Cloud Pak for Integration (CP4I) products.  

- Build *insecure* or *secure* image registries  
- Update the registry  
- Rebuild the registry   

### Target Audience  
- IT Professionals with in depth knowledge of Linux, Kubernetes (k8s) and Openshift (OCP)   
  The skills to build the bastion host and the private container registry.  
- Experience with IBM Cloud Paks, API Connect and DataPower    
  If you wish to install IBM API Connect (APIC) after building the bastion and registry.  

## Configure Linux Bastion
Our focus is [**Mirroring images with a bastion host**](https://www.ibm.com/docs/en/SSGT7J_22.2/install/install_airgap_bastion.html). For the larger context, please see [Mirroring images for an air-gapped cluster](https://www.ibm.com/docs/en/cloud-paks/cp-integration/2022.2?topic=images-mirroring-air-gapped-cluster).   

### Bastion OS & tools    
- RHEL 8.6, 9.x work okay    
- `root` user  
  For expedience, it is convenient to run as `root`. Not good practice.  
- Verify `openssl version >= 1.1.1`  
- Install `podman` & `httpd-tools`  
  `dnf install podman`  
  `dnf install httpd-tools`  

### Install OCP/CP4I bastion tools  

- OpenShift `oc` command  
  Get it from your OCP installation.  
  ```
  mv oc /usr/local/bin/
  $ oc version
  Client Version: 4.8.36
  ```  

- Install `ibm-pak`  
  Download the latest version from [IBM/ibm-pak/releases](https://github.com/IBM/ibm-pak/releases).
  ```
  tar -xf oc-ibm_pak-linux-amd64.tar.gz  
  mv oc-ibm_pak-linux-amd64 /usr/local/bin/oc-ibm_pak  
  ```
  Confirm `ibm-pak` installation:  
    `oc ibm-pak --help` 

- Set color ouptut (optional)  
  `oc ibm-pak config color --enable true`  


### ENV Variables for APIC images    

- Environment variables   
  [Mirroring images with a bastion host](https://www.ibm.com/docs/en/cloud-paks/cp-integration/2022.4?topic=cluster-mirroring-images-bastion-host) section ***Set environment variables and download CASE files*** specifies `env` settings. [Operator, operand, and CASE versions](https://www.ibm.com/docs/en/api-connect/10.0.5.x_lts?topic=installation-operator-operand-case-versions) contains appropriate values for the desired APIC version.  
  ```
  # For APIC  
  export CASE_NAME=ibm-apiconnect
  export CASE_VERSION=4.0.2
  export ARCH=amd64

  export TARGET_REGISTRY=`hostname -f`:5000

  # File to hold cp.icr.io authentication
  # *** Do NOT set this env at the start ***
  # Follow the steps in this document  
  # export REGISTRY_AUTH_FILE=/opt/registry/auth/cp-auth.json

  ```  

- Activate & verify environment variables 
  ```
    $ echo $CASE_VERSION
    4.0.2
  ```  

## Private container registry  
  
Your enterprise might have an existing private container registry. You could:  

- Use the existing corporate registry for IBM Cloud Pak images  
- Create a new registry for IBM Cloud Pak images  
  You can make the private container registry *insecure* or *secure*, depending on your corporate standards. The *insecure* registry is the main flow of the document. Two tables contrast simple steps for *Insecure* & *Secure* registries. Complex *Secure* registry steps are in **call out** segments.     

### Create local repositories for authentication, certificates & data  
> ***Note***: instead of `/opt`, choose a base directory which is under your (non-root user) control.       

  ```
  mkdir -p /opt/registry/{auth,certs,data}
  ```  

- Generate basic auth credentials  
  ```
  podman run --entrypoint htpasswd \
    docker.io/library/httpd:2 -Bbn <user> <paswd> > /opt/registry/auth/htpasswd
  ```
    <!-- docker.io/library/httpd:2 -Bbn mycoadmin mycoadmanure > /opt/registry/auth/htpasswd -->
    - b provides the password via command  
    - B stores the password using Bcrypt encryption  
    - n display in standard output    


### Create an *insecure* container registry  

```
podman run -d --name apic-registry -p 5000:5000 \
  -v /opt/registry/data:/var/lib/registry \
  -v /opt/registry/auth:/auth \
  -e "REGISTRY_AUTH=htpasswd" \
  -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
  -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
  --restart=always \
  docker.io/library/registry:2
```  

> ### [*Call Out 1*: Create a *secure* container registry](#create-a-secure-container-registry)  
> #### Return from Call Out 1  

## Mirror images to your private container registry  

### Setup `ibm-pak`

- Configure the plug-in to download CASEs as OCI artifacts from IBM Cloud Container Registry (ICCR).  
  ```
  oc ibm-pak config repo 'IBM Cloud-Pak OCI registry' \
    -r oci:cp.icr.io/cpopen --enable  
  ```

- Download the API Connect image inventory
  ```
  oc ibm-pak get $CASE_NAME \
    --version $CASE_VERSION
  ```  
  The files will be placed in `$HOME/.ibm-pak`.  


- Generate mirror manifests  
  ```  
  oc ibm-pak generate mirror-manifests \
    $CASE_NAME $TARGET_REGISTRY --version $CASE_VERSION  
  ```  
  The command creates files to configure OCP in `~/.ibm-pak/data/mirror/$CASE_NAME/$CASE_VERSION`:  
    `catalog-sources.yaml`  
    `catalog-sources-linux-<arch>.yaml` (arch specific catalog sources)  
    `image-content-source-policy.yaml`  
    `images-mapping.txt`  

- ***Preemptive fix*** for CASE_NAME `ibm-apiconnect`  
  Apply the fix described in [Airgap install failure due to `unable to retrieve source image docker.io`](https://www.ibm.com/docs/en/datapower-operator/1.6?topic=issues-airgap-unable-retrieve) to `~/.ibm-pak/data/mirror/$CASE_NAME/$CASE_VERSION/images-mapping.txt`. Please use the workaround as long as the link [Airgap install failure due to 'unable to retrieve source image docker.io'](https://www.ibm.com/docs/en/datapower-operator/1.6?topic=issues-airgap-unable-retrieve) is active.  
  >***Note***: Include this step in your dev-ops process.

- Configure credentials for the IBM Entitled Registry on Bastion
    - Define `$REGISTRY_AUTH_FILE` file to hold credentials  

      ```
      # File to hold cp.icr.io authentication for APIC
      export REGISTRY_AUTH_FILE=/opt/registry/auth/cp-auth.json
      ```
    
    - Populate `$REGISTRY_AUTH_FILE` with *IBM Entitlement Key* credentials for `cp.icr.io`  

      ```
      # podman login cp.icr.io
      Username: cp
      Password: <IBM Entitlement Key>
      Login Succeeded!
      ```  

    - Populate `$REGISTRY_AUTH_FILE` with `apic-registry` credentials  

      | Insecure Registry | Secure Registry |
      | ----------------- | --------------- |
      | `# podman login $TARGET_REGISTRY --tls-verify=false`  | `# podman login $TARGET_REGISTRY`  |
      | `Username: <user>` |  `Username: <user>`  |
      | `Password: <password>` |  `Password: <password>`  |
      | `Login Succeeded!` | `Login Succeeded!` |
      


    - Confirm $REGISTRY_AUTH_FILE contains both credentials  
      ```
      cat $REGISTRY_AUTH_FILE
      ```

>***Note***: Backup specific files and folders from `~/.ibm-pak`, as detailed in [Rebuild bastion repository](#rebuild-bastion-repository).  



### Populate bastion with images    

Fork the job to the background, as it could run for hours.

#### Redable version of `oc image mirror` command  

| Insecure Registry | Secure Registry |
| ----------------- | --------------- |
| `nohup oc image mirror \` | `nohup oc image mirror \`  |
| `  -f ~/.ibm-pak/data/mirror/$CASE_NAME/$CASE_VERSION/images-mapping.txt \` |   `-f ~/.ibm-pak/data/mirror/$CASE_NAME/$CASE_VERSION/images-mapping.txt \`  |
| `  -a $REGISTRY_AUTH_FILE \` |   `-a $REGISTRY_AUTH_FILE \`  |
| `  --insecure  \` |   `--filter-by-os '.*'  \`   |
| `  --filter-by-os '.*'  \` |   `--skip-multiple-scopes \`  |
| `  --skip-multiple-scopes \` |  `--max-per-registry=1 \`  |
| `  --max-per-registry=1 \` |  `--continue-on-error=true > my-mirror-progress.txt  2>&1 &`    |
| `  --continue-on-error=true > my-mirror-progress.txt  2>&1 &  ` |  |


#### Copy/paste friendly version of `oc image mirror` command   

| Insecure Registry | Secure Registry |
| ----------------- | --------------- |
| `nohup oc image mirror -f ~/.ibm-pak/data/mirror/$CASE_NAME/$CASE_VERSION/images-mapping.txt -a $REGISTRY_AUTH_FILE --insecure --filter-by-os '.*' --skip-multiple-scopes --max-per-registry=1 --continue-on-error=true > my-mirror-progress.txt  2>&1 &  ` | `nohup oc image mirror -f ~/.ibm-pak/data/mirror/$CASE_NAME/$CASE_VERSION/images-mapping.txt -a $REGISTRY_AUTH_FILE --filter-by-os '.*' --skip-multiple-scopes --max-per-registry=1 --continue-on-error=true > my-mirror-progress.txt  2>&1 &  `  |


#### Rinse & repeat  
Observe progress with `ps <pid>`, `top` and `tail my-mirror-progress.txt`. When the job completes, search `my-mirror-progress.txt` for "`error`".   

- If the job fails with "`too many requests`", run it again.   
  Rinse & repeat until it completes with "`info: Mirroring completed in 8m33.3s (12.65MB/s)`".    
- If you see "`unable to retrieve source image docker.io/ibmcom/`":  
  Apply the fix described in [Airgap install failure due to 'unable to retrieve source image docker.io'](https://www.ibm.com/docs/en/datapower-operator/1.6?topic=issues-airgap-unable-retrieve) to `~/.ibm-pak/data/mirror/$CASE_NAME/$CASE_VERSION/images-mapping.txt`. And run the `oc image mirror` command again.  



## Configure the OCP cluster   
  
Login to OCP CLI   

```
oc login --token=sha256~ejwjQ79...nvFbQYYyOc --server=https://api.rr4.cp.myco.com:6443
Logged into "https://api.rr4.cp.myco.com:6443" as "kube:admin" using the token provided.

You have access to 63 projects, the list has been suppressed. You can list all projects with 'oc projects'  

Using project "default".  
```  


### Configure the OCP *pull-secret* for the APIC registry  
Steps are from [Updating the global cluster pull secret](https://www.ibm.com/docs/en/openshift?source=https%3A%2F%2Fdocs.openshift.com%2Fcontainer-platform%2F4.10%2Fopenshift_images%2Fmanaging_images%2Fusing-image-pull-secrets.html%23images-update-global-pull-secret_using-image-pull-secrets&referrer=SSGT7J_22.2%2Finstall%2Finstall_airgap_bastion.html)

You may use the steps below or use OCP GUI.  

- Download the OCP `pull-secret`  
  ```  
  export PULL_SECRET_LOCATION="pull_secret_location.json"  
  oc get secret/pull-secret -n openshift-config \
    --template='{{index .data ".dockerconfigjson" | base64decode}}' > \
    $PULL_SECRET_LOCATION  
  ```
- Append your registry credentials to $PULL_SECRET_LOCATION   
  The command will NOT change existing credentials.
  ```
  oc registry login --registry="$TARGET_REGISTRY" \
    --auth-basic="<user>:<paswd>" --to=$PULL_SECRET_LOCATION   
  ```  

- Update the OCP `pull-secret`   
  >***Note***: The command will **replace** the *pull-secret* with the file's contents.  
  
    ```
    oc set data secret/pull-secret -n openshift-config \
      --from-file=.dockerconfigjson=$PULL_SECRET_LOCATION
    ```  

- Verify the OCP `pull-secret` using the OCP GUI  

### Create the OCP ImageContentSourcePolicy (ICSP)  

- Is ImageContentSourcePolicy defined for $CASE_NAME in OCP?
  ```
  oc get ImageContentSourcePolicy $CASE_NAME -o yaml  
  ```  
- Examine the file generated in [Mirror images to your private container registry](#mirror-images-to-your-private-container-registry)  
  ```
  view ~/.ibm-pak/data/mirror/$CASE_NAME/$CASE_VERSION/image-content-source-policy.yaml  
  ```  
  The settings should be appropriate, unless you have special reasons to modify ImageContentSourcePolicy for `ibm-apiconnct`.  
  ```
  oc apply -f  \
    ~/.ibm-pak/data/mirror/$CASE_NAME/$CASE_VERSION/image-content-source-policy.yaml  
  ```

### Connect your registry to OCP

#### *Insecure* Registry  

Recommend defining insecure registries manually in OCP. Edit the `image.config.openshift.io/cluster` and insert the bastion docker registry. You might find more than one insecure docker registries in use. For example, the client might use a different registry for OCP images. Slide the current registry into the mix.  

- Examine existing insecure registries in OCP   
  ```   
  oc get image.config.openshift.io/cluster -o yaml | grep -i -B2 -A4 insecureRegistries  
  spec:
    registrySources:
      insecureRegistries:
      - already-here.myco.com:5000
  status:
    internalRegistryHostname: image-registry.openshift-image-registry.svc:5000  
  ```   
  In this case, there is an insecure registry. Edit the YAML manually on the OCP GUI, the interactive CLI `oc edit` or by downloading the YAML file. Alternatively, you could use `oc patch` with carefully composed JSON which specifies current and additonal registries. 


- The following command will result in a single insecure registry, even if there were others in the list.  
  ***For lab use only***:
  ```
  oc patch image.config.openshift.io/cluster --type=merge \
    -p '{"spec":{"registrySources":{"insecureRegistries":["'$TARGET_REGISTRY'"]}}}'  
  ```

> #### [*Call Out 2* *Secure* Registry](#connect-your-secure-registry-to-ocp)     
> #### Return from Call Out 2


### Install Catalog Sources  

> ***Note***: Ensure all **Nodes** & **MachineConfigPools** are Ready.  

[Adding catalog sources to a cluster](https://www.ibm.com/docs/en/cloud-paks/cp-integration/2022.4?topic=images-adding-catalog-sources-cluster), section ***Adding specific catalog sources for each operator***:  

  - Apply catalog sources  
    ```
    # oc apply -f ~/.ibm-pak/data/mirror/${CASE_NAME}/${CASE_VERSION}/catalog-sources.yaml
    catalogsource.operators.coreos.com/cloud-native-postgresql-catalog created
    catalogsource.operators.coreos.com/ibm-apiconnect-catalog created
    catalogsource.operators.coreos.com/opencloud-operators created
    ```

  - Apply **\$ARCH** specific catalog sources, if such files exist:
    ```
    # oc apply -f \
      ~/.ibm-pak/data/mirror/${CASE_NAME}/${CASE_VERSION}/catalog-sources-linux-${ARCH}.yaml
    catalogsource.operators.coreos.com/ibm-datapower-operator-catalog created
    ```  
  - List catalog sources defined in OCP:  
    ```
    # oc get catalogsource -n openshift-marketplace
    NAME                              DISPLAY                                             TYPE   PUBLISHER   AGE
    certified-operators               Certified Operators                                 grpc   Red Hat     5h39m
    cloud-native-postgresql-catalog   ibm-cloud-native-postgresql-4.8.0+20221102.113620   grpc   IBM         2m48s
    community-operators               Community Operators                                 grpc   Red Hat     5h39m
    ibm-apiconnect-catalog            ibm-apiconnect-4.0.2                                grpc   IBM         2m48s
    ibm-datapower-operator-catalog    ibm-datapower-operator-1.6.5-linux-amd64            grpc   IBM         70s
    opencloud-operators               ibm-cp-common-services-1.17.0                       grpc   IBM         2m48s
    redhat-marketplace                Red Hat Marketplace                                 grpc   Red Hat     5h39m
    redhat-operators                  Red Hat Operators                                   grpc   Red Hat     5h39m
    ```

### Install Operators & API Connect
You can proceed to create a namespace, storage classes, install the IBM API Connect operator in the desired namespace and create an instance of APIC.

****     
****     
## Update APIC with new release  

<!-- >***To Do***: Validate update. ***Done***    -->

When there is new release of APIC, you can update the existing registry. For example, the registry was built with `CASE_NAME=ibm-apiconnect` & `CASE_VERSION=4.0.2`.

- Tweak the environment variables 
  Set `CASE_VERSION=4.0.3`. The other environment variables stay the same. Verify values with:   
  ```
  # echo $CASE_NAME
  ibm-apiconnect
  # echo $CASE_VERSION
  4.0.3
  ``` 

- Download the API Connect image inventory  
  ```
  oc ibm-pak get $CASE_NAME \
    --version $CASE_VERSION  
  ```

- Generate mirror manifests
  ```
  oc ibm-pak generate mirror-manifests \
    $CASE_NAME $TARGET_REGISTRY --version $CASE_VERSION  
  ```

- Mirror images to the TARGET_REGISTRY  
  > ***Note***: We presume that credentials and entitlement keys have not changed.  
  ```
  export REGISTRY_AUTH_FILE=/opt/registry/auth/cp-auth.json  
  ```  
  Use the `nohup oc image mirror` command appropriate for your ***insecure*** or **secure** bastion registry from  [Populate bastion with images](#populate-bastion-with-images)


- Image Content Source Policy (ICSP)   
  Apply the new ICSP (might not have changed).
    ```
    oc apply -f  \
      ~/.ibm-pak/data/mirror/$CASE_NAME/$CASE_VERSION/image-content-source-policy.yaml  
    ```

- Install Catalog Sources  
  > ***Note***:  Examine `~/.ibm-pak/data/mirror/${CASE_NAME}/${CASE_VERSION}` to determine if there any **\$ARCH** specific `catalog-sources` files.  

    - Apply catalog sources  
      ```
      oc apply -f ~/.ibm-pak/data/mirror/${CASE_NAME}/${CASE_VERSION}/catalog-sources.yaml
      ```

    - Apply **\$ARCH** specific catalog sources  
      ```
      oc apply -f \
        ~/.ibm-pak/data/mirror/${CASE_NAME}/${CASE_VERSION}/catalog-sources-linux-${ARCH}.yaml
      ```  
    - List catalog sources defined in OCP:  
      ```
      oc get catalogsource -n openshift-marketplace
      ```  

- Update APIC on OCP web console  
  Subscribe to APIC Operator Channel v3.2 and Operator Version 3.2.1, which corresponds to CASE_VERSION 4.0.3. Reference: [Operator, operand, and CASE versions](https://www.ibm.com/docs/en/api-connect/10.0.5.x_lts?topic=installation-operator-operand-case-versions).
- Follow upgrade steps in the IBM API Connect document  

*********    
*********    
## Rebuild bastion repository  
In case you need to **rebuild** the bastion repository, follow the steps below to build a replica of the images in the old registry.  

### Prerequisites  
- Setup OS & OCP/CP4I bastion tools  
  [Configure Linux Bastion](#configure-linux-bastion)
- Use the same values for:  
  CASE_NAME  
  CASE_VERSION  
  ARCH  
- Files from the old bastion  
  Assuming the old bastion was built with `ibm-pak`:  
    - Config   
      Transfer the file `.ibm-pak/config/config.yaml` to the same path in the new bastion.  
    - CASE files  
      Transfer files in `~/.ibm-pak/data/cases` to the new bastion using the same directory path.  

    >***Note***: Backup `~/.ibm-pak` as safety net.


### Build the new bastion  
- Create the podman registry  
  Follow the recipe in [Create your private container registry](#create-your-private-container-registry).   
- [Mirror images to your private container registry](#mirror-images-to-your-private-container-registry)   
    - Section [Setup ibm-pak](#setup-ibm-pak)  
      Start at **Generate mirror manifests** .   
      >***Note***: The prior steps, especially `oc ibm-pak get $CASE_NAME --version $CASE_VERSION` will create a new manifest which is likely to lead to a different set of images, not a replica of the old bastion.  
    - Section [Populate bastion with images](#populate-bastion-with-images)   
      Run all steps.  
    - Section [Configure the OCP cluster](#configure-the-ocp-cluster)  
      Run all steps.  
- Verify installation  
  IBM API Connect, DataPower & Common (Foundational) Services should be unaffected as the podman registry contains the same imagess as the old bastion.  

*********    
*********    
## Call Outs for Secure Registry  


### Create a *secure* container registry   

If your enterprise requires secure communications, you should obtain TLS *.crt* & *.key* files appropriate for the bastion host. Self signed certificates do not result in *secure* registries unless you define trusts on the bastion server and on OCP. This document provides steps to create and use self signed TLS. For corporate TLS, you might not need to prime trust settings on the bastion server.    

Please see [How to implement a simple personal/private Linux container image registry for internal use](https://www.redhat.com/sysadmin/simple-container-registry) section ***Start the registry*** for details. This document details steps to create and use self signed TLS.    

<!-- >***To Do*** Validate self signed certs  ***Done*** -->
If you really wish to use self signed certificates, see [Setting up additional trusted certificate authorities for builds ](https://docs.openshift.com/container-platform/4.10/cicd/builds/setting-up-trusted-ca.html).  

#### *MyCA* Authority   
  - Generate the private key  
    `openssl genrsa -out my-ca-privkey.pem 2048`   
  - Create *MyCA* certificate   
    The *subject* parameters are in [**ca-cert.conf**](./scripts/airgap/ca-cert.conf)  
      ```
      openssl req -new -x509 -days 3650 -key my-ca-privkey.pem \
        -out my-ca-cert.pem -config ca-cert.conf 
      ```  
  - Make *MyCA* a trusted authority on bastion server  
    ```
    cp my-ca-cert.pem /etc/pki/ca-trust/source/anchors/ 
    update-ca-trust  
    ```  
  - Verify #1  
    ```  
    trust list --filter=ca-anchors | grep Ravi -i -A 2 -B 3
    ```  
    ```  
    pkcs11:id=%1D%4C%1C%66%06%A7%2D%D7%9B%B9%C9%90%4B%3A%3E%0D%62%75%E3%F6;type=cert
        type: certificate
        label: Ravi CA
        trust: anchor
        category: authority
    ```
  - Verify #2  
    ```  
    awk -v cmd='openssl x509 -noout -subject' '/BEGIN/{close(cmd)};{print | cmd}' \
      < /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem | grep Ravi
    ```  
    ```  
    Could not read certificate from <stdin>
    Unable to load certificate
    subject=C = US, ST = NY, L = Ether, O = MyCA, OU = MyCAOrg, CN = Ravi CA  
    ```

#### Bastion TLS key & cert     
  - Generate the private key & certificate signing request  
    The *subject* parameters are in [**bastion.conf**](./scripts/airgap/bastion.conf):   
    ```
    openssl genrsa -out bastion-privkey.pem 2048  
    openssl req -new -key bastion-privkey.pem -out bastion.csr -config bastion.conf 
    ```
  - Create the bastion certificate  
    ``` 
    openssl x509 -req -in bastion.csr -CA my-ca-cert.pem -CAkey my-ca-privkey.pem \
      -out bastion-cert.pem -CAcreateserial -days 265 -sha256 \
      -extensions v3_req -extfile bastion.conf  
      ```
  - Examine the bastion certificate  
    ```
    openssl x509 -noout -text -in bastion-cert.pem   
    ```
    An alternate approach to examine Subject Alternate Name (SAN):  
    ```
    openssl x509 -text -noout -certopt \
      no_subject,no_header,no_version,no_serial,no_signame,no_validity\
      -certopt no_issuer,no_pubkey,no_sigdump,no_aux \
      -ext subjectAltName -in bastion-cert.pem   
    ```
    ```
            X509v3 extensions:
                X509v3 Subject Alternative Name: 
                    DNS:onyx1.myco.com
    X509v3 Subject Alternative Name: 
        DNS:onyx1.myco.com
    ```

  - Place the files in `/opt/registry/certs/`  
    ```  
    cp bastion-privkey.pem /opt/registry/certs/
    cp bastion-cert.pem /opt/registry/certs/
    ```  

#### Start the *secure* registry  
  ```
  podman run -d --name apic-registry -p 5000:5000 \
    -v /opt/registry/data:/var/lib/registry \
    -v /opt/registry/auth:/auth \
    -e "REGISTRY_AUTH=htpasswd" \
    -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
    -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
    -v /opt/registry/certs:/certs:z \
    -e "REGISTRY_HTTP_TLS_CERTIFICATE=/certs/bastion-cert.pem" \
    -e "REGISTRY_HTTP_TLS_KEY=/certs/bastion-privkey.pem" \
    --restart=always \
    docker.io/library/registry:2  
  ```   

#### Verify the registry's certificate      
  ```  
  # echo | openssl s_client -connect $TARGET_REGISTRY -servername `hostname -f` \
    | grep -B6 "Verification"  
  depth=1 C = US, ST = NY, L = Ether, O = MyCA, OU = MyCAOrg, CN = Ravi CA
  verify return:1
  depth=0 C = US, ST = FL, L = Gainesville, O = MyCo, OU = APIC, CN = onyx1.myco.com
  verify return:1
  No client certificate CA names sent
  Peer signing digest: SHA256
  Peer signature type: RSA-PSS
  Server Temp Key: X25519, 253 bits
  
  SSL handshake has read 1391 bytes and written 386 bytes
  DONE
  Verification: OK
  ```  
#### Verify access to secure registry   
>***Note***: Do not use the `-k` option to bypass TLS.  

  ```
  # curl --user <username:pswd> https://$TARGET_REGISTRY/v2/_catalog
  {"repositories":[]}
  ```

>[***Return to Call Out 1***](#return-from-call-out-1)  


****

### Connect your *secure* registry to OCP      

#### *Secure* Registry  
You need to provide OCP with TLS credentials to trust the bastion image registry. [Setting up additional trusted certificate authorities for builds](https://docs.openshift.com/container-platform/4.10/cicd/builds/setting-up-trusted-ca.html) provides the steps.  

- Create a ConfigMap in the `openshift-config` namespace containing the trusted certificates for the registries that use self-signed certificates. For each CA file, ensure the key in the ConfigMap is the hostname of the registry in the `hostname[..port]` format:  
  ```
  oc create configmap registry-cas -n openshift-config \
  --from-file=`hostname -f`..5000=/etc/pki/ca-trust/source/anchors/my-ca-cert.pem 
  ```   

  If you have multiple registries, place them all in `registry-cas` with multiple `--from-file` entries.  

- Modify in the cluster image configuration in `image.config.openshift.io/cluster`:    
    Recommend editing the `image.config.openshift.io/cluster` manually through the OCP GUI or CLI:  
    `oc edit image.config.openshift.io/cluster`  
    ```
    spec:
      additionalTrustedCA:
        name: registry-cas
      allowedRegistriesForImport:
        - domainName: '<$TARGET_REGISTRY>'
          insecure: false
    ```
    Define additional `- domainName` entries for each *secure* registry.  
  
    The image configuration entries in your installation might contain more entries. For an example, see **`image.config.openshift.io/cluster CR`** in **Procedure Item 1** of [9.2.4. Adding registries that allow image short names](https://access.redhat.com/documentation/en-us/openshift_container_platform/4.10/html/images/image-configuration#images-configuration-shortname_image-configuration)


>[***Return to Call Out 2***](#return-from-call-out-2)



*********    
*********    

## References  

#### Docker / Podman Registries  

- [How to implement a simple personal/private Linux container image registry for internal use](https://www.redhat.com/sysadmin/simple-container-registry)   
  Explains `podman` command to create a secure image registry. If you have a corporate TLS,this is all you need. If you need to create self signed TLS, there are other reference documents.  
- [Setting up additional trusted certificate authorities for builds ](https://docs.openshift.com/container-platform/4.10/cicd/builds/setting-up-trusted-ca.html)   
  Provides steps to define TLS trust in OCP whether you have a corporate or self signed TLS.  
- [htpasswd - Manage user files for basic authentication](https://httpd.apache.org/docs/trunk/programs/htpasswd.html)  



#### General Interest  
- [Is your Operator Air-Gap Friendly?](https://cloud.redhat.com/blog/is-your-operator-air-gap-friendly)
- [Disconnected installation mirroring](https://docs.openshift.com/container-platform/4.10/installing/disconnected_install/index.html)
- [Making CA certificates available to Linux command-line tools](https://www.redhat.com/sysadmin/ca-certificates-cli)
- [SSL Certificate Verification](https://curl.se/docs/sslcerts.html)
- [Add X.509 extensions to Certificate Signing Request (CSR)](https://www.golinuxcloud.com/add-x509-extensions-to-certificate-openssl/#Scenario-2_Add_X509_extensions_to_Certificate_Signing_Request_CSR)
- [Using SSL to protect connections to Red Hat Quay](https://access.redhat.com/documentation/en-us/red_hat_quay/3/html/manage_red_hat_quay/using-ssl-to-protect-quay)