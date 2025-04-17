# Active Directory Project

# Table of Contents

1. [Project Overview](#project-overview)
   - [Purpose](#purpose)
   - [Project Topology](#project-topology)
   - [Project Breakdown](#project-breakdown)
2. [Getting Started](#getting-started)
   - [Provision Each Machine](#install-and-provision-each-os-needed-for-the-project)
3. [Project Highlights](#project-highlights)
   - [Viewing Telemetry](#viewing-telemetry)
   - [Attacking The Domain](#attacking-the-domain)
   - [Adding Users Via Powershell](#adding-users-via-powershell)
   - [Implementing A File Intergrity Monitor](#implementing-a-file-integrity-monitor)

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
