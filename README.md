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
![Project Topology](https://github.com/TrystanW02/Active-Directory-Project/blob/main/Images/Screenshot%202025-04-14%20092523.png?raw=true)

### *Project Breakdown*

#### *Host*
| *Hostname [project-ad-...]* | *IP Address* | *Function*                          |
|-----------------------------|--------------|-------------------------------------|
|-dc (corp.project-ad-dc.com  |              | Domain Controller (DNS, DHCP, etc.) |
|-splunk-svr                  |              | SIEM                                |
|-win-client                  |              | Windows Workstation                 |
| attacker                    |              | Attacker Envrionment                |

#### *Accounts & Passwords*
| *Account*                        | *Password* | *Host*         |
|----------------------------------|------------|----------------|
| Administrator                    | @password1 | ...-dc         |
|                                  | @password1 | ...-splunk-svr |
| twilliams@corp.project-ad-dc.com | @password1 | ...-win-client |
| attacker@attacker                | attacker   | attacker       |

#### *Virtual Box VMs*
| *VM Name*               | *Operating System*   | *Specs* | *Storage (Minimum)* |
|-------------------------|----------------------|---------|---------------------|
| [project-ad-dc]         | Windows Server 2022  |         |                     |
| [project-ad-splunk-svr] | Ubuntu Server 2022   |         |                     |
| [project-ad-win-client] | Windows 10 Pro       |         |                     |
| [project-ad-attacker]   | Kali Linux           |         |                     |

## Getting Started
