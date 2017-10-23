# Instructions for Setting Up a MySQL DB using a Kubernetes Cluster on Bluemix

### Add the Kubernetes Cluster service to Bluemix

1.  Add a Kubernetes Cluster to your Bluemix Account.

    It takes about 20 minutes for the Cluster to finish deploying. Wait until the cluster is in a Ready state.

### Configure your workstation to connect to your Kubernetes Cluster in Bluemix

1.  In the Bluemix Cluster overview, click on the `Access` option to view the instructions for gaining access to your cluster. You need both the Bluemix CLI and the Kubernetes CLI installed on your workstation.

    ```bash
    bx plugin install container-service -r Bluemix
    ```
    
    ```bash
    bx login -a https://api.ng.bluemix.net
    ```

    ```bash
    bx cs init
    ```
    
    ```bash
    bx cs cluster-config <cluster-name>
    ```
    
    Run the `export KUBECONFIG` command from the output of the previous step to link your Kubernetes CLI to your Bluemix Cluster.

### Configure the required Kubernetes Secrets

1.  Run these commands to set up the pre-req's for your MySQL DB:

    ```bash
    echo -n "<super-secret-password>" > ./password.txt
    ```
    
    ```bash
    kubectl create secret generic mysql-pass --from-file=./password.txt
    ```
    
    ```bash
    kubectl create secret generic db-script --from-file=./db-script.sql
    ```
    
1.  Run this command to start the MySQL container on your Kubernetes Cluster:

    ```bash
    kubectl create -f ./mysql.yaml
    ```

### Verify your MySQL DB is running

1.  Find your public cluster IP:

    ```bash
    kubectl get nodes -o=custom-columns=NAME:.metadata.name
    ```
    
1.  Use a MySQL browser to connect to your DB.

    The password from the `./password.txt` file added to the `mysql-pass` secret belongs to the `root` user.
    
    The `./db-script.sql` file also creates a read-only user with these credentials:
    
    * Username:  `student`
    * Password:  `Passw0rd!`

    Lastly, the `mysql.yaml` deployment config will create a K8s listener service on port `30306`:
    
    <https://github.com/ibm-apiconnect/pot/blob/master/docs/assets/k8s-mysql/mysql.yaml#L14>