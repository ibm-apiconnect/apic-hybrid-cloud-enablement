# Create LDAP users in OIDC   
> Sila Kissuu  
>  &copy; IBM v0.1  2024-03-25   


1. Save LDAP/LUR registry users for each Provider Organization to a file:
    
    ```yaml
    apic users:list -o {yourProviderOrg} -s {yourMgmtServer} --user-registry {yourRegistry} --fields username,email,first_name,last_name --format json > ldap-users.json
    ```
    
    TIP: Use the `apic user-registries:list` command to get a list of registry names in your Provider Org

2. File contents:
    
    ```json
    {
      "total_results": 2,
      "results": [
        {
          "username": "user1@ibm.com",
          "email": "user1@ibm.com",
          "first_name": "User",
          "last_name": "One"
        },
        {
          "username": "user2@ibm.com",
          "email": "user2@ibm.com",
          "first_name": "User",
          "last_name": "Two"
        }
      ]
    }
    ```
    
3. Remove extra stuff. Delete line 1, 2 and the last line. Remove the string '_**“results”:**_'
4. Modified file:
    
    ```json
    [
      {
        "username": "user1@ibm.com",
        "email": "user1@ibm.com",
        "first_name": "User",
        "last_name": "One"
      },
      {
        "username": "user2@ibm.com",
        "email": "user2@ibm.com",
        "first_name": "User",
        "last_name": "Two"
      }
    ]
    ```
    
5. Here is python code that reads the file containing an array of multiple users and creates a separate JSON file for each user in the array. Why? The **user:create** command accepts a file with only 1 user in it.
    
    ```json
    #!/usr/bin/env python3
    """
    Created on Mon Mar 25 11:53:25 2024
    
    @author: sila
    """
    import json
    import os
    
    with open('/{pathTo}/ldap-users.json', 'r') as file:
        users = json.load(file)
    
    output_dir = '/{pathTo}/output_files'    
    os.makedirs(output_dir, exist_ok=True)
    
    # Iterate over the array and process each user individually
    for user in users:
        # Extract email for the filename
        filename = user["email"].lower() + ".json"
        
        # Write each user to a separate file
        with open(os.path.join(output_dir, filename), 'w') as file:
            json.dump(user, file, indent=4)
    ```
    
6. Verify files were written. Number of files should equal number of users in the file obtained in Step 2 - see the value of the element "total_results" which in this case is 2.
    
    ```json
    ❯ tree output_files
    output_files
    ├── user1@ibm.com.json
    └── user2@ibm.com.json
    ```
    
7. Verify file contents.
    
    ```json
    ❯ cat output_files/user2@ibm.com.json
    {
        "username": "user2@ibm.com",
        "email": "user2@ibm.com",
        "first_name": "User",
        "last_name": "Two"
    }
    ```
    
8. You can create each user in OIDC by passing their corresponding individual file to the **users:create** command.
    
    ```json
    ❯ apic users:create -o {yourProviderOrg} -s {yourMgmtServer} --user-registry {yourOIDCRegistry} output_files/user2@ibm.com.json
    user2-ibm.com    [state: enabled]   https://{yourMgmtServer}/api/user-registries/86441fe3-dfed-4fe6-99ef-6153b0d14afe/7311fdd9-8cee-4a34-8fdc-398ae61f9426/users/91e3a911-e687-4ae6-8867-0b31cbb85d04
    ```
    
9. Verify user exists:
    ```json
    ❯ apic users:list -o {yourProviderOrg} -s {yourMgmtServer} --user-registry {yourOIDCRegistry} | cut -d' ' -f1 | sed 's/-/@/'
    user1@ibm.com
    user2@ibm.com
    ```

10. You can loop through the files in the output directory to create all users in one **users:create** command.
    ```json
    ❯ for file in *; do echo "creating user " $file; apic users:create -o {yourProviderOrg} -s {yourMgmtServer} --user-registry {yourOIDCRegistry}$file; done 2>/tmp/error.log
    
    creating user  user1@ibm.com.json
    user1-ibm.com    [state: enabled]   https://{yourMgmtServer}/api/user-registries/86441fe3-dfed-4fe6-99ef-6153b0d14afe/7311fdd9-8cee-4a34-8fdc-398ae61f9426/users/00942444-66cd-463d-9a49-44c3223f426e
    creating user  user2@ibm.com.json
    user2-ibm.com    [state: enabled]   https://{yourMgmtServer}/api/user-registries/86441fe3-dfed-4fe6-99ef-6153b0d14afe/7311fdd9-8cee-4a34-8fdc-398ae61f9426/users/a0cb650a-d5b3-4929-8971-77606f9f90e3
    ```

    Note: errors encountered during user creation will be written to /tmp/error.log

    For example, attempting to create a user that already exists will result in the following:
    
    ❯ cat /tmp/error.log
    ```json
    Error: The user with username user1@ibm.com already exists in the {yourOIDCRegistry} identity provider.
    Error: The user with username user2@ibm.com already exists in the {yourOIDCRegistry} identity provider.
    ```


References:
1. APIC Toolkit Reference - https://www.ibm.com/docs/en/api-connect/10.0.5.x_lts?topic=information-toolkit-command-line-tool-reference


    