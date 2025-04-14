# *Active-Directory-Project*

## Table of Contents

1. [Project Overview](#project-overview)
   - [Purpose](#purpose)
   - [Project Topology](#project-topology)
   - [Project Breakdown](#project-breakdown)
2. [Getting Started](#getting-started)

## Project Overview

### Purpose
The purpose of this project is to get familiar with Windows Active Directory. This project shows how to setup AD and add the different functionalities to it (Domain Controller, DHCP, RAS/NAT, etc.), as well as adding users to the domain using Powershell scripting. This project starts off basic, with the intention of adding more on to it in the future and add additional security functionality.

### *Project Topology*
![Project Topology](https://github.com/TrystanW02/Active-Directory-Project/blob/main/Images/Screenshot%202025-04-14%20122830.png?raw=true)

### *Project Breakdown*

#### Project Network
**Nat Network:** project-ad-network
**IPv4 Prefix:** 192.168.10.0/24

#### *Host*
| *Hostname [project-ad-...]* | *IP Address*   | *Function*                          |
|-----------------------------|----------------|-------------------------------------|
|-dc (corp.project-ad-dc.com  | 192.168.10.7   | Domain Controller (DNS, DHCP, etc.) |
|-splunk-svr                  | 192.168.10.10  | SIEM                                |
|-win-client                  | Dynamic        | Windows Workstation                 |
| attacker                    | 192.168.10.250 | Attacker Envrionment                |

#### *Accounts & Passwords*
| *Account*                        | *Password* | *Host*         |
|----------------------------------|------------|----------------|
| Administrator                    | @password1 | ...-dc         |
| twilliams                        | @password1 | ...-splunk-svr |
| twilliams@corp.project-ad-dc.com | @password1 | ...-win-client |
| attacker@attacker                | attacker   | attacker       |

#### *Virtual Box VMs*
| *VM Name*               | *Operating System*   | *Specs*         | *Storage (Minimum)* |
|-------------------------|----------------------|-----------------|---------------------|
| [project-ad-dc]         | Windows Server 2022  | 1 CPU / 4096 MB | 50 GB               |
| [project-ad-splunk-svr] | Ubuntu Server 2022   | 2 CPU / 8192    | 100 GB              |
| [project-ad-win-client] | Windows 10 Pro       | 1 CPU / 4096 MB | 50 GB               |
| [project-ad-attacker]   | Kali Linux           | Pre-Built       | Pre-Built           |

## Getting Started
