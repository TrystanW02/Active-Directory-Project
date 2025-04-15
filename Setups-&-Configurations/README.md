# Table of Contents

1. [Ubuntu Server 22.04.5 (Splunk)](#ubuntu-server-22045-splunk)
   - [Configure the network](#configure-the-network-ubuntu)
   - [Initial installation & configuration of Splunk](#initial-installation--configuration-of-Splunk)
   - [Finalize Splunk server configuration](#finalize-splunk-server-configuration)
2. [Windows 10 (Target)](#windows-10-target)
   - [Configure the network](#configure-the-network-windows)
   - [Install & configure Universal Forwarder and Sysmon](#install--configure-universal-forwarder-and-sysmon)
   - [Add PC to the domain](#add-pc-to-the-domain)
   - [Enable Remote Desktop Protocol (RDP)](#enable-remote-desktop-protocol-rdp)
   - [Install & configure Atomic Red Team](#install--configure-atomic-red-team)
3. [Windows Server 2022 (Active Directory & Domain Controller)](#windows-server-2022-active-directory--domain-controller)
   - [Configure the network](#configure-the-network-server)
   - [Add domain services and promote to domain controller](#add-domain-services-and-promote-to-domain-controller)
   - [Add users to the domain](#add-users-to-the-domain)
4. [Kali Linux (Attacker)](#kali-linux-attacker)
   - [Configure the network](#configure-the-network-attacker)
   - [Update & upgrade](#update--upgrade)
   - [Install "Crowbar"](#install-crowbar)

# *Ubuntu Server 22.04.5 (Splunk)*

## Configure the network (Ubuntu)

<br>

1.   Assign the static IP address. To do this, type the following command
```
sudo nano /etc/netplan/00-installer-config-yaml
```

<br>

2.   The configuartion file should look like this in order to work:
```
network:
   ethernets:
      enp0s3:
         dhcp4: no
         addresses: [192.168.10.10/24]
         nameservers:
            addresses: [8.8.8.8]
         routes:
            - to: default
              via: 192.168.10.1
   version: 2
```

<br>

3.   Save by hitting "Ctrl + X", type in "Y" <br>

<br>

4.   Type the following command to apply the settings <br>
```
sudo netplan apply
```

<br>

## Initial installation & configuration of Splunk

<br>

> :memo: **Note:** Steps 1-3 are done on your ***HOST MACHINE***

1. Navigate to https://www.splunk.com/ (**on host machine**) and create an account if you don't already have one.

<br>

2. Navigate to "Trials & Downloads" and scroll to find "Splunk Enterprise"

<br>

3. Select "Linux" and the ".deb" file path

<br>

4. Navigate back to the Ubuntu VM and type the following command:
```
sudo apt-get install virtualbox-guest-additions-iso
```

<br>

5. Hit "Enter" to install package

<br>

6. Navigate to the top navigation bar, click "Devices" >> "Shared Folders" >> "Shared Folders Settings" >> "Add new shared folder"

<br>

7. Select the folder you downloaded the Splunk installer and select all 3 checkboxes

<br>

8. Back at the command line, run the following command to reboot, then sign back in:
```
sudo reboot
```

<br>

9. Type the following command:
```
sudo apt-get install virtualbox-guest-utils
```

<br>

10. ```
    sudo reboot
    ```

<br>

11. Type the following command:
```
sudo adduser [USER-NAME] vboxsf
```

<br>

12. Type `mkdir share` >> `ls` to confirm the new folder was created

<br>

13. Type the following command:
```
sudo mount -t vboxsf -o uid=1000,gid=1000 [shared-folder-name] share/
```

<br>

14. Type `cd share` >> Type the following command to install Splunk:
```
sudo dpkg -i [SPLUNK-FILE-NAME]
```

<br>

15. Type `cd /opt/splunk` >> `ls -la` to confirm

<br>

16. Change to the user 'splunk' by typing the following command:
```
sudo -u splunk bash
```

<br>

17. Type `cd bin` >> `./splunk start` to run installer

<br>

18. Type in your desired 'Administrator' username & password

<br>

19. To ensure Splunk starts everytime the machine starts, type `exit` >> `cd bin` >> then type the following command:
```
sudo ./splunk enable boot-start -user splunk
```

<br>

## Finalize Splunk server configuration

<br>

> :warning: **Attention:** All of the following steps will be done on the WINDOWS 10 TARGET MACHINE.
>
> :warning: **Attention:** The following steps CANNOT be completed until the inital installation and configuration of Splunk and Sysmon.

<br>

1. Navigate to Splunk Enterprise by typing the IP address into the web browser search

<br>

2. Type in the credentials you chose

<br>

3. Hover over Settings >> "Indexes" >> "New Index" >> Type in "endpoint", click Save

<br>

4. Hover over Settings >> "Forwarding and receiving" >> under "Receive data", click on "Configure receiving" >> "New Receiving Port" >> the default port for Splunk is *9997*

<br>

5. To confirm the setup was successful, click "Apps" >> "Search & Reporting" >> type in "index=endpoint" >> this screen should show the events that have been reported!

<br>

***

# *Windows 10 (Target)*

<br>

> :memo: **Optional:** You can change the name of the target machine to "Target" to better differenctiate the machines from each other
>
> :bulb: **Attention:** All of the following steps will be done on the WINDOWS 10 TARGET MACHINE.

<br>

## Configure the network (Windows)

<br>

1. Search for "cmd" in the search bar, then run `ipconfig` to see the IP address of the machine

<br>

2. Change the IP address to match the [project breakdown](https://github.com/TrystanW02/Active-Directory-Project?tab=readme-ov-file#project-breakdown)

<br>

3. Ensure the DNS server is pointing to the Domain Controllers IP address

<br>

## Install & configure Universal Forwarder and Sysmon

<br>

1. Go to https://www.splunk.com/ (**on windows target machine**) and navigate to "Trials & Downloads" >> Start downloading "Universal Forwarder" for Windows 10

<br>

2. Open the installer and follow the directions >> select a username and leave the "random password" box checked >> enter the IP address for the Splunk server in the "Receiving Indexer" box

<br>

3. Navigate to https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon and click "Download Sysmon" >> go to https://github.com/olafhartong/sysmon-modular/blob/master/sysmonconfig.xml and download the raw .xml file

<br>

4. Once sysmon is downloaded, "extract all" >> right click the top file manager bar, copy

<br>

5. Open Powershell and run as administrator >> type `cd` then paste in the file path >> type `.\Sysmon64.exe -i ..\sysmonconfig.xml`

<br>

6. Search notepad and run as administrator >> type the following:
```
[WinEventLog://Application]
index = endpoint
disabled = false

[WinEventLog://Security]
index = endpoint
disabled = false

[WinEventLog://System]
index = endpoint
disabled = false

[WinEventLog://Microsoft-Windows-Sysmon/Operational]
index = endpoint
disabled = false
renderXml = true
source = XmlWinEventLog:Microsoft-Windows-Sysmon/Operational
```

<br>

7. Save the file to the following directory: C:\Program Files\SplunkUniversalForwarder\etc\system\local and save it as `inputs.conf`

> :memo: **Note:** 1) Any changes you make to this file will require you to restart Splunk Forwarder services
> 2) You will have to change the Log On to "Local System account"

<br>

## Add PC to the domain

> :warning: **Attention:** Steps 1 & 2 CANNOT be completed until the Domain Controller is fully configured and functional

<br>

1. Search "PC" in the search bar, click on "Properties" >> click "Advanced system settings" >> click the "Computer Name" tab >> select "Domain" >> type your domain into the box >> login with the credentials to the server >> restart the machine

<br>

2. Sign in with the newly created users

<br>

## Enable Remote Desktop Protocol (RDP)

1. Search "PC" in the search bar, click on "Properties" >> click "Advanced system settings", login with the administrator credentials

<br>

2. Click the "Remote" tab >> select "Allow remote connections to the computer", click "Select Users" >> add the 2 users that were created earlier

<br>

## Install & configure Atomic Red Team

1. Open Powershell with admin privileges

<br>

2. Type `Set-ExecutionPolicy Bypass CurrentUser` >> type "Y", hit "Enter"

<br>

3. Navigate to Windows Security >> click "Virus & threat protection", "Manage settings" >> under "Exclusions", click "Add or remove exclusions" >> Add an exclusion and select "Folder" >> select the "C:" drive >> login as administrator

<br>

4. Run the following commands to install ATR:
```
IEX (IWR https://raw.githubusercontent.com/redcanaryco/invoke-atomicredteam/master/install-atomicredteam.ps1 -UseBasicParsing);
```
```
Install-AtomicRedTeam -getAtomics
```

<br>

5. Hit "Y" when prompted to install dependencies

<br>

6. Navigate to the "C:" drive, click into the "AtomicRedTeam" >> "atomics"

<br>

7. These tactics match with the MITRE ATT&CK framework. To use any of them, type the following command:
```
Invoke-AtomicTest [TECHNIQUE-TO-TEST]
```

<br>

***

# Windows Server 2022 (Active Directory & Domain Controller)

## Configure the network (Server)

<br>

1. Change the IP address to match the [project breakdown](https://github.com/TrystanW02/Active-Directory-Project?tab=readme-ov-file#project-breakdown)

<br>

## Add domain services and promote to domain controller

<br>

1. Navigate to Server Manager >> "Add Roles and Features" >> "Role based or feature based installation" >> select "Active Directory Domain Services" >> click through the windows and install

<br>

2. Click the flag icon at the top of the screen, click "Promote this server to a domain controller" >> "Add a new forest" and type what you want the domain to be >> type in a password for DSRM >> click through the windows and install

<br>

## Add users to the domain

<br>

1. In Server Manager, hover over "Tools" and select "Active Directory Users and Computers" >> right click the domain, "New" then select "Organizational Unit" >> name it "IT" >> right click within the unit, "New" then select "User" >> type the first and last name of the user, as well as the username >> create a password >> uncheck "User must change password at next logon"

<br>

2. Repeat the same process, but change the Organizational Unit to "HR"

<br>

***

# Kali Linux (Attacker)
>:warning: **Warning:** The use of this OS is for educational purposes only. I do not condone, nor encourage the use of unauthorized attacks on any machine. Always practice safe, ***AND ETHICAL***, hacking.
>
>:memo: **Note:** The default username and password is ***kali***

<br>

## Configure the network (Attacker)

1. Assign the IP address from the [project breakdown](https://github.com/TrystanW02/Active-Directory-Project?tab=readme-ov-file#project-breakdown)

<br>

## Update & upgrade

1. Update all of the repositories with the following command:
```
sudo apt-get update && sudo apt-get upgrade -y
```

<br>

## Install "Crowbar"

1. Make a new directory called "ad-project"
```
mkdir ad-project
```

<br>

2. Type the following command to install the application "Crowbar":
```
sudo apt-get intall -y crowbar
```

<br>

3. Type `cd /usr/share/wordlists` >> `sudo gunzip rockyou.txt.gz` to unzip the textfile

<br>

4. Copy the textfile to the new project folder `cp rockyou.txt ~/Desktop/ad-project` >> change into the directory now `cd ~/Desktop/ad-project`

<br>

5. Just to use the first 20 lines, use the following command:
```
head -n 20 rockyou.txt > passwords.txt
```

<br>

6. To see the contents of the file, use:
```
cat passwords.txt
```

<br>

7. To edit the file in order to target a specific password, use `nano passwords.txt` >> add the password you've been using to the list >> Ctrl + X to save

<br>

8. To execute the tool, type the following command:
```
crowbar -b rdp -u [TARGET-USER] -C passwords.txt -s [TARGET-IP/32] 
```
