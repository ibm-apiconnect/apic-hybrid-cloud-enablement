# IBM API Connect  
> ## Generating an API Key for SSO Login
>  Sila Kissuu  
>  &copy; IBM v1.0  2023-01-18  

## Problem: 
It is common for APIC deployments to leverage existing enterprise Continuous Integration/Continuous Deployment (CI/CD) practices to automate code delivery. Typically, a pipeline is configured to log onto API Manager and execute a series of CLI commands.

However, when authentication is performed via an external provider, such as OIDC with Single Sing-On (SSO), the default CLI behavior requires the user to login via a browser in order to retrieve the required API key. 

For example:

```
apic login -s apic.lab.ibm.com -u pipelines@apic-cli.com -r provider/azure-oidc --context provider --sso login.microsoftonline.com

Please copy and paste the url https://apic.lab.ibm.com/manager/auth/manager/sign-in/?from=TOOLKIT to a browser to start the authentication process.
Do you want to open the url in default browser? [y/n]: y
API Key?
```
For purposes of CICD, this is not practical to automate due to the required human interaction. 

We provide a workaround.

## Solution:
Use the CLI command ```apic api-key:create``` to create a custom key with a custom TTL and other properties.

### Requirements:
-	An input file describing the API key metadata
-	User URL: this property is retrieved separately

## Procedure
1. Obtain the “user URL” for the userID that will be associated with this API key
    * Logon to APIM (provider realm) as org owner
 

    * List org members using ```apic members:list```
 
 

2.	Create a file to define API key metadata. For example:
 

    NOTE: The value for user_url is derived from Step 1(b). 
3.	Create the API key using ```api-keys:create``` API
 

4.	Verify by listing available API keys using ```api-keys:list```
 

    * Retrieve the API key you just created:
 

    * A yaml file name after the name of your new API key (in this example, JenkinsPipeline), is dumped into you current directory:
 

    * While yaml is the default, you could ask for a JSON format like this:
 

    * You get a json file:
 



5.	View the contents of the newly-created API key retrieved in Step 4.
 
    Your API key is highlighted above .

6.	Test the new API key
 

We have successfully logged into APIM and can now proceed with CICD operations.

## Conclusion
You are now able to automate Jenkins CICD operations using a pre-defined API key.



