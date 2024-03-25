# Create LDAP users in OIDC


1. Save LDAP/LUR registry users for each Provider Organization to a file:
    
    ```yaml
    apic users:list -o ups -s apim.v10-cd-mgmt.rtp.raleigh.ibm.com --user-registry bluepages --fields username,email,first_name,last_name --format json > bluepages.json
    ```
    
2. File contents:
    
    ```json
    {
      "total_results": 2,
      "results": [
        {
          "username": "chris.veary@ibm.com",
          "email": "Chris.Veary@ibm.com",
          "first_name": "Chris",
          "last_name": "Veary"
        },
        {
          "username": "sila.kissuu@us.ibm.com",
          "email": "sila.kissuu@us.ibm.com",
          "first_name": "SILA",
          "last_name": "KISSUU"
        }
      ]
    }
    ```
    
3. Remove extra stuff (delete line 1,2 and last line; remove the string **“results”:**
4. Modified file
    
    ```json
    [
      {
        "username": "chris.veary@ibm.com",
        "email": "Chris.Veary@ibm.com",
        "first_name": "Chris",
        "last_name": "Veary"
      },
      {
        "username": "sila.kissuu@us.ibm.com",
        "email": "sila.kissuu@us.ibm.com",
        "first_name": "SILA",
        "last_name": "KISSUU"
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
    
    with open('/Users/sila/dev/apic/rest/bluepages.json', 'r') as file:
        users = json.load(file)
    
    output_dir = '/Users/sila/dev/apic/rest/output_files'    
    os.makedirs(output_dir, exist_ok=True)
    
    # Iterate over the array and process each object individually
    for obj in users:
        # Extract name for the filename
        filename = obj["email"].lower() + ".json"
        
        # Write each object to a separate file
        with open(os.path.join(output_dir, filename), 'w') as file:
            json.dump(obj, file)
    ```
    
6. Verify files were written. Number of files should equal number of users in the file obtained in Step 2 - see the value of the element "total_results" which in this case is 2.
    
    ```json
    ❯ tree output_files
    output_files
    ├── chris.veary@ibm.com.json
    └── sila.kissuu@us.ibm.com.json
    ```
    
7. Verify file contents.
    
    ```json
    cat output_files/sila.kissuu@us.ibm.com.json
    {"username": "sila.kissuu@us.ibm.com", "email": "sila.kissuu@us.ibm.com", "first_name": "SILA", "last_name": "KISSUU"
    ```
    
8. You can create each user in OIDC by passing their corresponding individual file to the **users:create** command.
    
    ```json
    ❯ apic users:create -o ups -s apim.v10-cd-mgmt.rtp.raleigh.ibm.com --user-registry azure-ad-id-secret output_files/sila.kissuu@us.ibm.com.json
    sila.kissuu-us.ibm.com    [state: enabled]   https://platform.v10-cd-mgmt.rtp.raleigh.ibm.com/api/user-registries/86441fe3-dfed-4fe6-99ef-6153b0d14afe/7311fdd9-8cee-4a34-8fdc-398ae61f9426/users/91e3a911-e687-4ae6-8867-0b31cbb85d04
    ```
    
9. You can loop through the files in the output directory to create all users in one command.