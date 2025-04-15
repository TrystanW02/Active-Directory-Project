# Table of Contents

1. [Ubuntu Server 22.04.5 (Splunk)](#ubuntu-server-22.04.5-(splunk))
   - [Configure the network](#concfigure-the-network)
   - [Initial installation & configuration of Splunk](#initial-installation-&-configuration-of-Splunk)

# *Ubuntu Server 22.04.5 (Splunk)*

## Configure the network

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

8. Back at the command line, type `sudo reboot` and sign back in

<br>

9. Type the following command:
```
sudo apt-get install virtualbox-guest-utils
```

<br>

10. Type `sudo reboot`

<br>

11. Type the following command:
```
sudo adduser [yourusername] vboxsf
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
sudo dpkg -i [splunk-file-name]
```

<br>

15. Type `cd /opt/splunk` >> `ls -la` to confirm

<br>

16. Change to the user 'splunk' by typing `sudo -u splunk bask`

<br>

17. Type `cd bin` >> `./splunk start` to run installer

<br>

18. Type in your desired 'Administrator' username & password

<br>

19. To ensure Splunk starts everytime the machine starts, type `exit` >> `cd bin` >> `sudo ./splunk enable boot-start -user splunk`

<br>

***

### *Windows 10 Machine (Target)*
> :memo: **Optional:** You can change the name of the target machine to "Target" to better differenctiate the machines from each other
>
> :bulb: **Attention:** All of the following steps will be done on the WINDOWS 10 TARGET MACHINE.

1. Search for "cmd" in the search bar, then run `ipconfig` to see the IP address of the machine
2. Change the IP address to match the [project breakdown](#project-breakdown)
3. Go to https://www.splunk.com/ (**on windows target machine**) and navigate to "Trials & Downloads" >> Start downloading "Universal Forwarder" for Windows 10
4. Open the installer and follow the directions >> select a username and leave the "random password" box checked >> enter the IP address for the Splunk server in the "Receiving Indexer" box
5. Navigate to https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon and click "Download Sysmon" >> go to https://github.com/olafhartong/sysmon-modular/blob/master/sysmonconfig.xml and download the raw .xml file
6. Once sysmon is downloaded, "extract all" >> right click the top file manager bar, copy
7. Open Powershell and run as administrator >> type `cd` then paste in the file path >> type `.\Sysmon64.exe -i ..\sysmonconfig.xml`
8. Search notepad and run as administrator >> type the following:
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
9. Save the file to the following directory: C:\Program Files\SplunkUniversalForwarder\etc\system\local and save it as `inputs.conf`

> :memo: **Note:** 1) Any changes you make to this file will require you to restart Splunk Forwarder services
> 2) You will have to change the Log On to "Local System account"

***

### Finalize Splunk server configuration

> :bulb: **Attention:** All of the following steps will be done on the WINDOWS 10 TARGET MACHINE.

1. Navigate to Splunk Enterprise by typing the IP address into the web browser search
2. Type in the credentials you chose
3. Hover over Settings >> "Indexes" >> "New Index" >> Type in "endpoint", click Save
4. Hover over Settings >> "Forwarding and receiving" >> under "Receive data", click on "Configure receiving" >> "New Receiving Port" >> the default port for Splunk is *9997*
5. To confirm the setup was successful, click "Apps" >> "Search & Reporting" >> type in "index=endpoint" >> this screen should show the events that have been reported!
