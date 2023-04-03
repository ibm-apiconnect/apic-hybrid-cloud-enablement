# NB Leak playbook  


> Author: Derek Ross   

   
### Guide for NBLeak in K8's:   

- NBLeak is a monitoring tool that tracks allocations during the runtime and saves that information into a buffer.   
- It only records that information after it has been enabled and that information requires a command to dump the information from that buffer into a file.   
- That file is set to save to the temporary filesystem and that location is not modifyable (you can copy/save that file off which is usually the best approach).   
- The goal is to get an initial snapshot and then take further snapshots every 10-20% increase in memory growth.   
- The purpose of this is to get a view of the allocations growing over time as sometimes its not just a single large allocation that grows (could be many small ones).   
- The more captures and longer runtime we have inbetween; the better that data is for support to consume.   
- The only way you will know how long to wait in between capture intervals is to monitor the resources using a dashboard, CLI, or webgui status provider.   
- Last thing I will add here is that you ABSOLUTELY want to make sure you grab those files off of the temporary filesystem before you reload or before the pod terminates itself (for safe data recovery).   
   
   
### Recommendation:   

- Take an initial Snapshot to give us a base capture.   
- Take a snapshot every 10-20 % growth (depending on your growth that could be a few hours, day, e.t.c)   
- Save those captures off each time to make sure we retain them in case the box increases unexpectedly.   
- Once the box approaches ~70-80% memory lets plan to have you take one last capture, stake a screenshot of the Prometheus Dashboard, and Generate an Error-Report.   
- When the data is all captures plan to reload the box when applicable so you don't top the memory out unexpectedly (causing an outage).   
- Upload all of the files.   
   
### How to:


1. Attatch to the DataPower login:   
    ```   
    "attach -it"   
    ```   
1. Enable CLI Telnet by entering the following command into the shell you attatched to (you can change the port if needed):   
    ```   
    top;co;cli telnet 127.0.0.1 2300;write mem   
    ```   
   
1. Detach from that pod using cntrl p+q (DO NOT USE ctrl+c or you will kill the DataPower process).   
   
   
1. Access the container by running an exec command:   
    ```   
    "exec -it podname -- bash"   
    ```   
   
1. Verify the Telnet service by running a bash shell command   
    ```   
    "telnet 127.0.0.1 2300"   
    ```   
   
1. Login to DP using your credentials (it will be noisy with running logs popping up on screen ... thats a telnet thing)   
    > NOTE: You likely won't be able to copy paste into this shell and the password is going to be plain-text ... so fair warning.   
   
1. Once you confirm that this works (run a test command in one of the domains "show gateway-peering-status" for example) you can then exit the bash shell using "exit" (may need a few exit's to get back).   
   
   
1. At this point we are ready to run the CLI commands of interest which you can put them into a .txt file and run it through kubectl   
   
    Here's an example of what the file could/should look like (the ping part is just to make sure we don't exit before completing our previous command)   
    ```   
    admin   
    password   
    top;diag;set-memory nbleak immediate;set-tracing on memory;   
    ping 1.2.3.4;   
    exit;exit   
    ```   
   
1. Once this files created and uploaded to the machine > we can run that file using the following command:   
    ```   
    kubectl -n <namespace>  exec -it <pod name> --  nc 127.0.0.1 2300 < ourfile.txt |strings   
    ```   
    
    Some customers may need to get to kubectl first > then run the exec command (command can change depending on container such as adding oc in front).   
    - Its also worth noting that copying directly in may fail on some containers or it may not be read properly.   
    - You are better off manually typing these commands as there some of the hosts for the containers can replace/mis-read characters when consuming (slashes, dashes, e.t.c)   
    
   
   
1. Now the Previous step enabled the tool but in the case of say NBLeak you may still need to collect it:   
    - You can do this in another file or you can login directly to run the commands yourself.   
    - Here's an example of putting it into another file   
    ```   
    admin   
    password   
    top;diag;save memory usage;   
    ping 1.2.3.4;   
    exit;exit   
    ```   
    ```   
    kubectl -n <namespace>  exec -it <pod name> --  nc 127.0.0.1 2300 < secondfile.txt |strings   
    ```   
1. The last step once you are done capturing however many sets of data you need; is to disable the tool:   
    - You again can do this by running the commands directly or creating   
    ``` py    
    admin   
    password   
    top;diag;set-tracing off   
    ping 1.2.3.4   
    exit;exit   
    ```   
    > You may also want to kill off the pod (restart it) to make sure the NBLeak module is done   