# Table of Contents

1. [Project Overview](#project-overview)
   - [Purpose](#purpose)
   - [Project Topology](#project-topology)
   - [Project Breakdown](#project-breakdown)
2. [Getting Started](#getting-started)
   - [Provision Each Machine](#install-and-provision-each-os-needed-for-the-project)

# Project Overview

## Purpose
The purpose of this project is to get familiar with Windows Active Directory. This project shows how to setup AD and add the different functionalities to it (Domain Controller, DHCP, RAS/NAT, etc.), as well as adding users to the domain using Powershell scripting. This project starts off basic, with the intention of adding more on to it in the future and add additional security functionality.

## *Project Topology*
![Project Topology](https://github.com/TrystanW02/Active-Directory-Project/blob/main/Images/Screenshot%202025-04-14%20122830.png?raw=true)

## *Project Breakdown*

### Project Network
- **Nat Network:** project-ad-network
- **IPv4 Prefix:** 192.168.10.0/24

### *Host*
| *Hostname [project-ad-...]* | *IP Address*   | *Function*                          |
|-----------------------------|----------------|-------------------------------------|
|-dc (corp.project-ad-dc.com  | 192.168.10.7   | Domain Controller (DNS, DHCP, etc.) |
|-splunk-svr                  | 192.168.10.10  | SIEM                                |
|-win-client                  | Dynamic        | Windows Workstation                 |
| attacker                    | 192.168.10.250 | Attacker Envrionment                |

### *Accounts & Passwords*
| *Account*                        | *Password* | *Host*         |
|----------------------------------|------------|----------------|
| Administrator                    | @password1 | ...-dc         |
| twilliams                        | @password1 | ...-splunk-svr |
| twilliams@corp.project-ad-dc.com | @password1 | ...-win-client |
| attacker@attacker                | attacker   | attacker       |

### *Virtual Box VMs*
| *VM Name*               | *Operating System*    | *Specs*         | *Storage (Minimum)* |
|-------------------------|-----------------------|-----------------|---------------------|
| [project-ad-dc]         | Windows Server 2022   | 1 CPU / 4096 MB | 50 GB               |
| [project-ad-splunk-svr] | Ubuntu Server 22.04.5 | 2 CPU / 8192    | 100 GB              |
| [project-ad-win-client] | Windows 10 Pro        | 1 CPU / 4096 MB | 50 GB               |
| [project-ad-attacker]   | Kali Linux            | Pre-Built       | Pre-Built           |

# Getting Started

## Install and provision each OS needed for the project
1. This step involves going and installing each of the necessary machines, as well as provision them according to the [Virtual Box VMs](#virtual-box-vms) section.
   - Windows Server 2022: https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2022
   - Ubuntu Server 22.04.5: https://ubuntu.com/download/server
   - Windows 10: https://www.microsoft.com/en-us/software-download/windows10
   - Kali Linux: https://www.kali.org/get-kali/#kali-virtual-machines
2. After each machine is installed and provisioned, make sure to connect all of the machines to the NAT network that you created.

## Specific Machine Setups

> :memo: **Note:** This next section will be for any specific configurations needed for the machines. This section will not cover initial installation settings.

### *Ubuntu Server 22.04.5 (Splunk)*
### Configuring the network information
1. Assign the static IP address. To do this, type the following command
```
sudo nano /etc/netplan/00-installer-config-yaml
```
2. The configuartion file should look like this in order to work:
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
3. Save by hitting "Ctrl + X", type in "Y" <br>
4. Type the following command to apply the settings <br>
```
sudo netplan apply
```
### Installing and configuring Splunk
1. Navigate to https://www.splunk.com/ (**on host machine**) and create an account if you don't already have one.
2. Navigate to "Trials & Downloads" and scroll to find "Splunk Enterprise"
3. Select "Linux" and the ".deb" file path
4. Navigate back to the Ubuntu VM and type the following command:
```
sudo apt-get install virtualbox-guest-additions-iso
```
5. Hit "Enter" to install package
6. Navigate to the top navigation bar, click "Devices" >> "Shared Folders" >> "Shared Folders Settings" >> "Add new shared folder"
7. Select the folder you downloaded the Splunk installer and select all 3 checkboxes
8. Back at the command line, type `sudo reboot` and sign back in
9. Type the following command:
```
sudo apt-get install virtualbox-guest-utils
```
10. Type `sudo reboot`
11. Type the following command:
```
sudo adduser [yourusername] vboxsf
```
12. Type `mkdir share` >> `ls` to confirm the new folder was created
13. Type the following command:
```
sudo mount -t vboxsf -o uid=1000,gid=1000 [shared-folder-name] share/
```
14. Type `cd share` >> Type the following command to install Splunk:
```
sudo dpkg -i [splunk-file-name]
```
15. Type `cd /opt/splunk` >> `ls -la` to confirm
16. Change to the user 'splunk' by typing `sudo -u splunk bask`
17. Type `cd bin` >> `./splunk start` to run installer
18. Type in your desired 'Administrator' username & password
19. To ensure Splunk starts everytime the machine starts, type `exit` >> `cd bin` >> `sudo ./splunk enable boot-start -user splunk`
