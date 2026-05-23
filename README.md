# Enterprise-active-directory-environment
Enterprise Windows infrastructure environment using Active Directory, Group Policy, PowerShell, DNS, DHCP, Sysmon, and Wazuh to simulate identity management, Windows administration, authentication monitoring, security hardening, and administrative automation within a domain-based enterprise environment.

## Security Hardening Decisions

- Enforced password complexity and account lockout policies
- Restricted unnecessary administrative privileges
- Configured Windows Defender protections through GPO
- Centralized authentication telemetry into Wazuh

## Configuration
In this lab I will be creating an active directory lab. The lab will have two servers, a switch, router, kali Linux machine, and a windows 10 machine.

First I will begin the lab by creating a diagram to display what network I intend to create. I will be using draw.io to create the diagram. Since this is an active directory lab I will have two servers on the network. The first server will be used as a splunk server to have logs, events, and metrics. The second server will be used used as an actve directory sever which is used for authentication, group policies, and computer management. I will then have a Windows 10 machine that is connected to the splunk server to forward data to the server as well as be connected to the switch. Then I will have a kali linux machine that is connected to the switch and used to simulate attacks. Then all of these devices will be connected to a switch and then to a router. Which will allow our system to connect to the internet while keeping information confidental through a switch.

<img width="728" height="707" alt="image" src="https://github.com/user-attachments/assets/b76efb2c-9f54-4df4-aedc-f2c3420c2de9" />

Since I have the kali linux machine downloaded I will create the windows 10 machine. To do this I naviagte to this link https://www.microsoft.com/en-ca/software-download/windows10 and download the Create Windows 10 installation media. 

<img width="1900" height="516" alt="image" src="https://github.com/user-attachments/assets/4bd9ce5f-2220-40e2-882a-492fc6b737f2" />

When finished downloading we open the file and accept the end-user license agreement. Then we want to create an installation media then select next. We want to use the recommended settings and then select create an iso file. 

Then we are going to create a new virtual machine with windows 10. To do this first we naviagte to virtualbox then select new. Select the iso image that we just created and select create.

<img width="800" height="707" alt="image" src="https://github.com/user-attachments/assets/e674fecc-1ac1-4df8-9473-5c5568fbc261" />

When the download has finished we then create a new machine and select the iso image that we have just created. Then select finish and we will have our Winodows 10 machine.

<img width="940" height="725" alt="image" src="https://github.com/user-attachments/assets/372d8493-cb32-4d5e-a7a1-f720c99ea996" />

Now I am going to create the Windows server. To do this search windows server 2022 iso and download the 64-bit version of the iso. 

<img width="1680" height="727" alt="image" src="https://github.com/user-attachments/assets/bee7de2c-7211-4da7-a243-570e8804c331" />

After it has finished downloading we are going to import it into VirtualBox. Then we are going to select create new machine and then select the iso image that we previously installed. We will check the unintended install box and then select finish.

<img width="947" height="728" alt="image" src="https://github.com/user-attachments/assets/5ee1016a-2a95-47e2-811f-d3898db6bb91" />

Then we will boot up the virtual machine and then select the defalut settings and select the operating system as shown below.

<img width="1025" height="847" alt="image" src="https://github.com/user-attachments/assets/fd5a5c99-92c2-4d95-9eb9-21f677832a18" />

Then when asked which installation we will like select custom installation and then wait for it to finish installing. 

Next we want to install a splunk server. To do this first we naviagte to ubuntu.com and then select servers. Then we download the ubuntu server. 

<img width="1617" height="653" alt="image" src="https://github.com/user-attachments/assets/77afdcd5-9f58-4cdb-b7c2-66100069cf4b" />

To import the server into virtualbox we select a new machine and use the iso file that we downloaded and create the Splunk server. Then we start the virtual machine and select continue and done until we reach the create account page. Enter in the information and then select install ubuntu server. The download is complete when the reboot now prompt appears. 

<img width="1317" height="917" alt="image" src="https://github.com/user-attachments/assets/401fd980-1821-42f3-8c6c-b02b76480a1b" />

When recieving the error prompt simply select enter and then let the server reboot. You will know that the server has been successfully configured when the login prompt is seen. After logging into the machine I will check for updates by using the command sudo apt-get update && sudo apt-get upgrade -y.

<img width="932" height="852" alt="image" src="https://github.com/user-attachments/assets/d0fa8728-8a43-4b76-8ea4-67ffca674f3c" />

## Splunk and Sysmon Configuration
In this part of the active directory lab I will install and configure sysmon and splunk onto the windows target machine and windows server.

First we want to configure a NAT network so all machines are able to connect to the internet. To do this first we want to navigate to tools, select network, and NAT networks. Select create and enter in a name for the network and enter the IP address of the network. Then for each of the virtual machines we are going to navigate to the network settings. then change the defalut NAT to the NAT network option that we just created. 

<img width="563" height="292" alt="image" src="https://github.com/user-attachments/assets/a2f3ce2d-d7bb-4ae3-9991-51b68bc6c573" />

<img width="957" height="592" alt="image" src="https://github.com/user-attachments/assets/3bb08ae4-cb7b-4c72-abbe-df47fec6975b" />

Then we are going to open the splunk server and use the command ip a. Then we should see that the splunk server is connected to the NAT network and has an ip in the range.

<img width="826" height="97" alt="image" src="https://github.com/user-attachments/assets/4af71222-eea7-4e2b-8f72-2f8e730b6c3d" />

Then we want to set a static IP address for the splunk server. To do this we enter the command sudo nano /etc/netplan/50-cloud-init.yaml and change the file to look like this.

<img width="277" height="197" alt="image" src="https://github.com/user-attachments/assets/44f549d6-c0df-4c62-a468-0e75f8f41708" />

Then we save the file and clear the screen. Enter in the command sudo netplan apply and this will apply the new changes. Then we are going to enter the command ip a and confirm that the ip address is 192.169.1.10 as shown below.

<img width="813" height="101" alt="image" src="https://github.com/user-attachments/assets/a0cac7f9-2a93-49d7-b763-ecda35a9b654" />

Then we will ping google.com to make sure that the file is configured correctly.

<img width="761" height="81" alt="image" src="https://github.com/user-attachments/assets/43dcda54-48dc-4a22-88d1-0a69f1a39f17" />

Next we want to install the splunk server to do this we will go to splunk.com and create an account. After that has been done naviagte to splunk.com and select splunk enterprise then download. When the download has been completed we open the ubuntu server and enter the command sudo apt-get install virtualbox then tab to view the options. We want the guest additions iso therefore, we will enter that in. 

<img width="912" height="83" alt="image" src="https://github.com/user-attachments/assets/ac7a5a8a-ee80-4446-9fd6-4daf458b5a88" />

When the download has been completed we are going to create a folder named shared folder and put in the downloaded splunk server DEB file. Then in virtualbox we will go to settings then shared folder and select add. Then select all of the boxes below and select ok. 

<img width="372" height="311" alt="image" src="https://github.com/user-attachments/assets/f9348fbb-e32c-43fc-9d63-706a32534024" />

Reboot the server with the command sudo reboot and login. We are going to add a new user to the vboxsf and we get the prompt vboxsf doesn't exist. we are going to again enter the command sudo apt=get install virtualbox with a tab to view the installations. We will select the -guest-utils.

<img width="920" height="192" alt="image" src="https://github.com/user-attachments/assets/73645394-96d4-4cf5-bded-bac7df80b1db" />

Then run the command sudo adduser andres vboxsf and then make a shared directory with the command mkdir share. Now we want to mount the shared folder to the share directory and to do this run the command sudo mount -t vboxsf -o uid=1000,gid=1000 <shared folder name> share/. Then cd into the share directory and la -la and we should be able to see the splunk download file. Run the command sudo dpkg -i <splunk server name>. 

<img width="1050" height="357" alt="image" src="https://github.com/user-attachments/assets/aeab454f-01f8-46ab-a388-d9e73a0a65b7" />

Now we want to check that splunk has been configured correctly. To do this we will cd into the /opt/splunk directory and the use ls -la to check the contents. 

<img width="798" height="372" alt="image" src="https://github.com/user-attachments/assets/d4ee2e87-5087-4c8b-8a34-d7450f739e5e" />

We can see that all of the files are owned by the splunk user, so we will switch to that user by using the command sudo -u splunk bash. To run the installer we will cd into the bin directory then run the command ./splunk start to start the installer. Now we want splunk to run everytime the virtual machine so we will exit. Cd into the bin directory and then run the command sudo ./splunk enable boot-start -user splunk. Now the splunk server will start.

Now we want to install the universal forwarder on the Windows target machine we will start the virtual machine. Then we will search splunk.com and navigate to the splunk universal forwarder then download the Windows 64-bit version. 

<img width="1022" height="765" alt="image" src="https://github.com/user-attachments/assets/1a676eb4-8323-4bd0-a09f-27d700bd13ce" />

Open the file when it has finished downloading and select next until you reach recieveing indexer. Then enter in the IP address of the splunk server that we previously configured and enter in 9997 for the other field. Now we will download Sysmon search sysmon and then download it from the Microsoft website. 

<img width="1022" height="765" alt="image" src="https://github.com/user-attachments/assets/7ba87eb7-8928-4e51-aada-93fdd69d29ef" />

Then we want to use the olaf configuration of sysmon, so we are going to find this github repository and select sysmonconfig.xml.

<img width="1018" height="767" alt="image" src="https://github.com/user-attachments/assets/aabbb09e-fdef-4ece-b234-5020ad775811" />

After selecting the file we select raw and save it as an xml file. Next we navigate to fiel explorer and then select the sysmon zip file and click extract all. When it has finished extracting the contents then copy the file path and open powershell with administrative privlages. Now we are going to cd into the directory where sysmon was configured in and then enter the command shown below.

<img width="507" height="98" alt="image" src="https://github.com/user-attachments/assets/a8f195ac-17e4-433c-b85a-3de3bd3ea374" />

Now we are going to tell our splunk forwarder what to forward to the splunk server. To do this we go to the program files that are used for the splunk universal forwarder and create a input.conf file that is in the local directory. We open notepad in administrative mode and then enter whats shown below into the file. 

<img width="751" height="517" alt="image" src="https://github.com/user-attachments/assets/1dec5edc-640a-4fa2-a7ec-366ac74e1111" />

Then save it in the local directory as input.conf 

<img width="608" height="472" alt="image" src="https://github.com/user-attachments/assets/203f5e04-d8c0-45fd-9636-f35881198e11" />

Since we modified the inputs now we have to reset the universal forwarder and we do this by going to services and run as administrator. Then we find splunk forwarder and navigate to log on and change it to local system account. Right click the splunk forwarder and then select restart.  

<img width="801" height="586" alt="image" src="https://github.com/user-attachments/assets/59bda40a-fe6a-40d5-a9b4-46f3c403d6a8" />

This error screen appeared we will just select start service. Now we will look up the IP address of the splunk server and will login with out splunk server credentials. Then go to settings and indexes. We need to create a new index, so out input.conf file will start sending logs to the Splunk server. 

<img width="1018" height="850" alt="image" src="https://github.com/user-attachments/assets/c985bfdd-586a-46be-9fe9-4cc5bac7809e" />

Select new Index and name it endpoint and save. Then we navigate to settings again and then select forwarding and recieving. Then select configure recieving and new recieving port. Enter the 9997 default port. 
The configureation for the server is the same as the configuration of the target machine. Therefore, it will not be repeated or this will seem very redundant.

Now I will configure the active directory and promote domain controller on the Windows server. Which will allow the Windows PC to join the domain.

First we want to add role based features for our Windows server. To do this we naviagte to server manager and select manage, role based features, next, and select role-based or feature-based installation. Chose the Winodws server that we have configured and select Active Directory Domain Services as well as add features. 

<img width="1022" height="768" alt="image" src="https://github.com/user-attachments/assets/b4bdc922-b277-4abf-9e54-05eab64b8809" />

Keep selecting next until the installation button apears and select install. When finished you will recieve this prompt. 

<img width="787" height="561" alt="image" src="https://github.com/user-attachments/assets/66170b41-0709-48e7-8d18-46829959cfe2" />

close out the pop up screen and select the flag that has a yellow icon next to it. Then select promote this server to a domain controller.

<img width="1021" height="767" alt="image" src="https://github.com/user-attachments/assets/5d7729c1-572f-4ebc-a78a-c3c4d9a35fa1" />

Then select new forrest and enter a name of your choice followed by a . and a another name. Then select next until the installation button appears. When the installation has been completed it will tell the user that the computer will restart.

<img width="1023" height="767" alt="image" src="https://github.com/user-attachments/assets/1beb5965-789b-4ad9-96e3-e63474355575" />

Then login to the Windows server again. Go to the server manager and select Active Directory Users and Computrers. Now I want to create a new organizational unit and to do this I right click the name of the server and select new organizational unit. Then I will name it IT and select ok. 

<img width="750" height="527" alt="image" src="https://github.com/user-attachments/assets/cbd07f53-6440-4fe8-a810-f7d3bf7607da" />

Then we can add a user to the newly created organization by selecting new and user. give them a name and password and add them to the system.

<img width="431" height="377" alt="image" src="https://github.com/user-attachments/assets/ca2d4092-9276-4e34-82b0-343824b72ff2" />

Now we want to add the Windows machine to the domain, so login to the Windows 10 machine. Then search this PC and properties. Select advanced system settings and the computer name tab. Then select domain and eneter in the domain name of the server. 

<img width="797" height="632" alt="image" src="https://github.com/user-attachments/assets/850e66e8-9321-48c3-a164-17dda37fb911" />

We get this error because our target machine does not know how to resolve ACTIVEDIRECTORY.LOCAL. We are going to fix this be heading to the network adapter and change adapter options. Select properties and choose ip v4 properties and change the DNS to the IP address of the domain controller which is 192.168.1.7. Then exit and check that it has been correctly configured by using the command ipconfig /all in command prompt. 

<img width="660" height="512" alt="image" src="https://github.com/user-attachments/assets/9dd26611-3449-42bd-be6b-f9087cd8179e" />

You should see that the DNS server is set to the IP address of the domain controller and we will ping google.com to check if there is still internet connection. Now we will attempt to join the domain another time
and we will recieve this prompt.

<img width="1022" height="856" alt="image" src="https://github.com/user-attachments/assets/1b7ff40a-c76d-4732-b934-235dd2e9a045" />

Use the login for the Windows server and the computer will be restarted. Now we want to login as the other user that we created which was john smith. To do this we select other user and enter in the credentials that we created. Now it has been finished the Active Directory server has been configured and deployed. 

<img width="1016" height="855" alt="image" src="https://github.com/user-attachments/assets/bf2a1049-1976-4071-bc05-1d6f6a34d60d" />

## Attack Simulation
In this part of the lab I will be exploiting a system vulnerability and checking the logs that it creates in splunk. I will be performing a brute force attack that will expose the windows 10 machines and allow access.

The fist thing we will do is turn on the Kali Linux virtual machine. Then we are going to open the terminal and make a directorty with mkdir <directory-name>. Then we will install crowbar with the command sudo apt-get install -y crowbar and type in the defalut Kali Linux password. Now we are going to get a list of common passwords from our newly downloaded crowbar software. To do this we will enter in the command cd /usr/share/wordlists/ 

<img width="641" height="252" alt="image" src="https://github.com/user-attachments/assets/3ef90290-40f5-411e-830b-b4b45f2153a6" />

Then we will unzip the rockyou.txt.gz with gunzip. The command is sudo gunzip rockyou.txt.gz and the output will be rockyou.txt. Moreover, we will copy the rockyou.txt file to our newly created directory using the command cp rockyou.txt ~/Desktop/ad/. Now we will cd into our newly created directory with the command cd ~/Desktop/ad. Then we will take the first 20 entries in the file and copy it over to password.txt with the command head -n 20 rockyou.txt > password.txt. 

<img width="642" height="515" alt="image" src="https://github.com/user-attachments/assets/31e07e75-075f-4322-ae3f-feef11a6785a" />

Now add the insecure password to the password.txt file. Then we will enable RDP on the Windows 10 endpoint mahine. To do this navigate to PC -> properties -> advanced settings -> remote -> Allow remote connections for these users and add the user on the Windows 10 endpoint machine. Since Windows has a firewall we will have to disable the rule that drops ICMP packets and blocks port 53(DNS). This is done by entering command prompt as an administrator and entering the command ```netsh advfirewall set allprofiles state off```. In Kali Linux we have to change the nameserver. This is because the DNS server that is currently being used is google's DNS server 8.8.8.8. The google DNS server does not know of the existence of our LAN and the ACTIVEDIRECTORY.local domain that we have created. Therefore, we have to change the nameserver to the ip address of the Active Directory server. After that step has been done now we will use Hydra to brute force into the Windows 10 virtual machine. To do this enter this command as follows: 
```hydra -l jsmith -P password.txt rdp://192.168.1.6 ```

<img width="621" height="277" alt="image" src="https://github.com/user-attachments/assets/586c5fbf-3f5b-48d3-83ac-b089f414df26" />

Make sure that the Splunk server is running while the brute force attack is occuring. 
