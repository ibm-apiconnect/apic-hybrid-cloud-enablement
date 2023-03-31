# IBM API Connect  
> ## Generate an API Key for SSO Login in 7 Steps
>  Sila Kissuu  
>  &copy; IBM v1.0  2023-01-18  

## Problem: 
It is common for APIC deployments to leverage existing enterprise Continuous Integration/Continuous Deployment (CI/CD) practices to automate code delivery. Typically, a pipeline is configured to log onto API Manager and execute a series of CLI commands.

However, when authentication is performed via an external provider, such as OIDC with Single Sing-On (SSO), the default CLI behavior requires the user to authenticate via a browser in order to retrieve the required API key. 

Here is an example that uses Azure AD as the OIDC provider:

```
apic login -s apim.lab.company.com \
-u pipelines@company.com \ 
-r provider/azure-oidc --context provider \
--sso login.microsoftonline.com

Please copy and paste the url https://apim.lab.company.com/manager/auth/manager/sign-in/?from=TOOLKIT 
to a browser to start the authentication process.
Do you want to open the url in default browser? [y/n]: y
API Key?
```
For purposes of CICD, this is not practical to automate due to the required human interaction. 

We provide a solution.

## Solution:
Use the CLI command ```apic api-key:create``` to create a custom key with a custom TTL and other properties.

### Requirements:
-	An input file describing the API key metadata
-	User URL: this property is retrieved separately

## Procedure
1. Obtain the “user URL” for the userID that will be associated with this API key
    * Logon to APIM (provider realm) as using your OIDC user ID
    ```
    apic login -s apim.lab.company.com \
    -u pipelines@company.com \ 
    -r provider/azure-oidc --context provider \
    --sso login.microsoftonline.com

    Please copy and paste the url https://apim.lab.company.com/manager/auth/manager/sign-in/?from=TOOLKIT 
    to a browser to start the authentication process.
    Do you want to open the url in default browser? [y/n]: y
    API Key? <<paste your API key copied from the browser>>
    ```
    **NOTE: this is the only time you will have to interact with the browser.**

2. List org members using ```apic members:list```
    ```
    apic members:list -s apim.lab.company.com --scope catalog -c sandbox -o my-org

    pipelines-company.com-from-azure-oidc-of-type-standard    [state: enabled]   https://platform.lab.company.com/api/catalogs/84bce7eb-354e-49c9-8d6b-48e82ac45084/e0843be8-0beb-43d5-b304-e55861e45f2c/members/4c0764a9-a4d8-4926-9759-1d3d02334c52
    ```
 
    The output shows the definition for user ```pipelines@company.com``` enabled in  a Standard type OIDC configuration named ```azure-oidc```.

    Copy the URL from the output - you will need it in the next step.

3.	Create a JSON file (we will name it my-key-definition.json) to define metadata for your new API key. Paste in the URL from Step 2 into the ```user_url`` property. Here is a sample API key creation file:
    ```json
    {
        "type": "api_key",
        "api_version": "2.0.0",
        "name": "PipelineKey",
        "title": "PipelineKey",
        "summary": "Use this key for SSO login.",
        "client_type": "toolkit",
        "realm": "provider",
        "user_url": "https://platform.lab.company.com/api/catalogs/84bce7eb-354e-49c9-8d6b-48e82ac45084/e0843be8-0beb-43d5-b304-e55861e45f2c/members/4c0764a9-a4d8-4926-9759-1d3d02334c52",
        "description": "API Key for CI/CD operations",
        "ttl": 62294394
    }
    ```

    NOTE: The value for ```user_url``` is derived from Step 2. 

4.	Create the API key using the ```api-keys:create``` command, passing the file created in Step 3.
    ```
    apic api-keys:create -s apim.lab.company.com my-key-definition.json

    PipelineKey   https://platform.lab.company.com/api/cloud/api-keys/b6882e4a-4b8e-43b0-963f-0478b79c7948
    ```

5.	Verify the API key was created  
    * List API keys
    ```
    apic api-keys:list -s apim.lab.company.com

    PipelineKey   https://platform.lab.company.com/api/cloud/api-keys/b6882e4a-4b8e-43b0-963f-0478b79c7948
    ```
 

    * Retrieve the API key you just created:
    ```
    apic api-keys get KasovoniKey-3 -s apim.lab.company.com --format json

    PipelineKey   PipelineKey.json   https://platform.lab.company.com/api/cloud/api-keys/b6882e4a-4b8e-43b0-963f-0478b79c7948
    ```
    A json file named after the name of your new API key (in this example, PipelineKey), is dumped into you current directory.

    THis file represents your API key definition in API Manager.


6. Review the contents of the json file:
    ```json
    {
        "type": "api_key",
        "api_version": "2.0.0",
        "id": "3c0225f7-0aad-45ce-a199-ced575befb9c",
        "name": "PipelineKey",
        "title": "PipelineKey",
        "summary": "Use this key for SSO login.",
        "client_type": "toolkit",
        "realm": "provider/azure-oidc",
        "user_url": "https://platform.lab.company.com/api/catalogs/84bce7eb-354e-49c9-8d6b-48e82ac45084/e0843be8-0beb-43d5-b304-e55861e45f2c/members/4c0764a9-a4d8-4926-9759-1d3d02334c52",
        "id_token": "eyJhbGciOiJSUzI1Ni...bT4IX7w",
        "token_exp": 1674104837,
        "token_iat": 1674076037,
        "token_jti": "c73472c2-8c93-4fb6-bc8e-9b6a88775dfd",
        **_"api_key"_**: "14f27ecd-919a-41f5-a4f1-2a6012cb471c",
        "description": "API Key for CI/CD operations",
        "created_at": "2023-01-18T21:35:19.000Z",
        "updated_at": "2023-01-18T21:35:19.000Z",
        "url": "https://platform.lab.company.com/api/cloud/api-keys/b6882e4a-4b8e-43b0-963f-0478b79c7948"
    }
    ```
 
    Your new API key, ready for use, is highlighted above.
    ```
    "api_key": "14f27ecd-919a-41f5-a4f1-2a6012cb471c"
    ``` 

7.	Test the new API key
    ```
    apic login -s apim.lab.company.com \
    -u pipelines@company.com \
    -r provider/azure-oidc \
    --context provider \
    --sso login.microsoftonline.com \
    --apiKey 14f27ecd-919a-41f5-a4f1-2a6012cb471c

    Logged into apim.lab.company.com successfully
    ```

We have successfully logged into APIM and can now proceed with CI/CD operations.

## Conclusion
You are now able to automate CI/CD operations using a pre-defined API key.

### References
- CLI Tool Reference - https://www.ibm.com/docs/en/api-connect/10.0.5.x_lts?topic=reference-apic-api-keys
- Configuring an OIDC user registry - https://www.ibm.com/docs/en/api-connect/10.0.5.x_lts?topic=overview-configuring-oidc-user-registry
- API Connect Platform REST APIs - https://apic-api.apiconnect.ibmcloud.com/v10/#/documentation/introduction



