# Active Directory Project

# Table of Contents

1. [Project Overview](#project-overview)
   - [Purpose](#purpose)
   - [Project Topology](#project-topology)
   - [Project Breakdown](#project-breakdown)
2. [Getting Started](#getting-started)
   - [Provision Each Machine](#install-and-provision-each-os-needed-for-the-project)
3. [Project Highlights](#project-highlights)
   - [Adding New Organizational Units and Users via PowerShell Scripting](#1-adding-new-organizational-units-and-users-via-powershell-scripting)


***

# Project Overview

## Purpose
The purpose of this project is to get familiar with Windows Active Directory. This project shows how to setup AD and add the different functionalities to it (Domain Controller, DHCP, etc.), as well as adding users to the domain using different means (manual addition or Powershell scripting). This project starts off basic, with the intention of adding more on to it in the future and add additional security functionality.

## *Project Topology*
![Project Topology](https://github.com/TrystanW02/Active-Directory-Project/blob/main/Images/Screenshot%202025-04-14%20122830.png?raw=true)

## *Project Breakdown*

### Project Network
- **Nat Network:** project-ad-network
- **IPv4 Prefix:** 192.168.10.0/24

### *Host*
| *Hostname [project-ad-...]* | *IP Address*   | Subnet Mask   | Default Gateway | DNS Server   |*Function*                           |
|-----------------------------|----------------|---------------|-----------------|--------------|-------------------------------------|
|-dc (project-ad-dc.com)      | 192.168.10.7   | 255.255.255.0 | 192.168.10.1    | 8.8.8.8      | Domain Controller (DNS, DHCP, etc.) |
|-splunk-svr                  | 192.168.10.10  | 255.255.255.0 | 192.168.10.1    | 8.8.8.8      | SIEM/Logs                           |
|-win-client                  | 192.168.10.100 | 255.255.255.0 | 192.168.10.1    | 192.168.10.7 | Windows Workstation                 |
| attacker                    | 192.168.10.250 | 255.255.255.0 | 192.168.10.1    | 8.8.8.8      | Attacker Envrionment                |

### *Accounts & Passwords*
| *Account*                        | *Password* | *Host*         |
|----------------------------------|------------|----------------|
| Administrator                    | @password1 | ...-dc         |
| twilliams                        | @password1 | ...-splunk-svr |
| twilliams@project-ad-dc.com      | @password1 | ...-win-client |
| cwilliams@project-ad-dc.com      | @password1 | ...-win-client |
| kali                             | kali       | attacker       |

### *Virtual Box VMs*
| *VM Name*               | *Operating System*    | *Specs*         | *Storage (Minimum)* |
|-------------------------|-----------------------|-----------------|---------------------|
| [project-ad-dc]         | Windows Server 2022   | 1 CPU / 4096 MB | 50 GB               |
| [project-ad-splunk-svr] | Ubuntu Server 24.04.2 | 2 CPU / 8192    | 100 GB              |
| [project-ad-win-client] | Windows 10 Pro        | 1 CPU / 4096 MB | 50 GB               |
| [project-ad-attacker]   | Kali Linux            | Pre-Built       | Pre-Built           |

***

# Getting Started

## Install and provision each OS needed for the project
1. This step involves going and installing each of the necessary machines, as well as provision them according to the [Virtual Box VMs](#virtual-box-vms) section.
   - Windows Server 2022: https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2022
   - Ubuntu Server 24.04.2: https://ubuntu.com/download/server
   - Windows 10: https://www.microsoft.com/en-us/software-download/windows10
   - Kali Linux: https://www.kali.org/get-kali/#kali-virtual-machines

<br>

2. After each machine is installed and provisioned, make sure to connect all of the machines to the NAT network that you created.

<br>

For in depth setups and configurations of each machine, click [here](https://github.com/TrystanW02/Active-Directory-Project/tree/main/Setups-%26-Configurations)!

<br>

***

# Project Highlights

> :memo: This section is meant to show off what this project is capable of! Any new additions to this original project will be shown in this section!

## 1. Adding New Organizational Units and Users via PowerShell Scripting

> :bulb: The following images show how to add organizational units and users through powershell scripting. All of the original files are located [here](https://github.com/TrystanW02/Active-Directory-Project/tree/main/Powershell_Scripts/Create_OUs_%26_Users)!
 
## *Purpose*

The purpose of this addition is to have the ability to quickly provision new user accounts, without the need of having to go manually add every user in an organization to their respective unit. The goal is to eventually consolidate all of the code into 1 single script, and to eventually add GPO for each unit! Each of the organizational units is meant to have different levels of access to the organizations resources.

## Names for each of the accounts

Each of the scripts need a ".txt" file that has the names of the employees in the unit. Each one of these text files has 5 randomly generated names to be added to the units. Below is an example of what each text file looks like, specifically the `IT_Names.txt`:

```
Marvel Gallardo
Abbigail Aguirre
Olabode Ashton
Clemency Tennyson
Christabelle Crosby
```

## Organizational Units

For this portion, I chose to only add 5 different organizational units: `_IT`, `_HR`, `_ACCOUNTING`, `_MANAGEMENT`, `_CSUITE`. Instead of adding individual users first, then adding them to the units later, this script is made to do both with one run of the script.

## Powershell Script

Below is the code for one of the organizational units, the `_IT` unit.

```Powershell
﻿# ----- Edit these Variables for your own Use Case ----- #
$PASSWORD_FOR_USERS   = "Il0vePCs"
$USER_FIRST_LAST_LIST = Get-Content .\IT_Names.txt
# ------------------------------------------------------ #

$password = ConvertTo-SecureString $PASSWORD_FOR_USERS -AsPlainText -Force
New-ADOrganizationalUnit -Name _IT -ProtectedFromAccidentalDeletion $false

foreach ($n in $USER_FIRST_LAST_LIST) {
    $first = $n.Split(" ")[0].ToLower()
    $last = $n.Split(" ")[1].ToLower()
    $username = "$($first.Substring(0,1))$($last)".ToLower()
    Write-Host "Creating user: $($username)" -BackgroundColor Black -ForegroundColor Cyan

    New-AdUser -AccountPassword $password `
               -GivenName $first `
               -Surname $last `
               -DisplayName $username `
               -Name $username `
               -EmployeeID $username `
               -PasswordNeverExpires $true `
               -Path "ou=_IT,$(([ADSI]`"").distinguishedName)" `
               -Enabled $true
}
```

This code allows for the creation of the organizational unit, pulls the names of each employee from `IT_Names.txt`, and creates the username and password for each user!

## Images

1. **Active Directory Users and Computers *before* the addition of users** <br>

<br>

![Before Addition of Users](https://github.com/TrystanW02/Active-Directory-Project/blob/main/Images/Screenshot%202025-04-17%20135015.png?raw=true)

2. **Active Directory Users and Computers *after* the additon of users** <br>

<br>

![After Addition of Users](https://github.com/TrystanW02/Active-Directory-Project/blob/main/Images/Screenshot%202025-04-17%20135440.png?raw=true)

3. **_IT Organizational Unit w/ Users** <br>

<br>

![OU w/ Users](https://github.com/TrystanW02/Active-Directory-Project/blob/main/Images/Screenshot%202025-04-17%20135508.png?raw=true)

4. **Abbigail Aguirre Account** <br>

<br>

![Abbigail Aguirre Account](https://github.com/TrystanW02/Active-Directory-Project/blob/main/Images/Screenshot%202025-04-17%20135824.png?raw=true)
