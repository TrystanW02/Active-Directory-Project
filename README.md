# *Active-Directory-Project*

## Table of Contents

1. [Project Overview](#project-overview)
   - [Project Topology](#project-topology)
   - [Technology Used](#technology-used)
2. [Purpose](#purpose)
3. [Getting Started](#getting-started)
   - [Changing IP Address](#changing-the-ip-address-of-our-windows-server-machine)
5. [Project Highlights](#project-highlights)

## Project Overview

### *Project Topology*
![Project Topology](https://github.com/TrystanW02/Active-Directory-Project/blob/main/Images/Screenshot%202025-04-14%20092523.png?raw=true)

### *Technology Used*
#### Hypervisor:
- Virtual Box

#### Software:
- Windows 10 Pro ISO
- Windows Server 2019
- Powershell
- Splunk
- Kali Linux

## Purpose
The purpose of this project is to get familiar with Windows Active Directory. This project shows how to setup AD and add the different functionalities to it (Domain Controller, DHCP, RAS/NAT, etc.), as well as adding users to the domain using Powershell scripting. This project starts off basic, with the intention of adding more on to it in the future and add additional security functionality.

## Getting Started
#### Changing the IP Address of our Windows Server machine
> :memo: **Note:** This step is being applied to the Windows Server 2019 machine

1. Navigate to "Network Connections" in the Control Panel
2. Identify which Ethernet connection is going to be for the "Internet" access and the "Internal" network access
3. The "Internet" connection will get addressed through the DHCP. The "Internal" connection will need to be assigned the IP address shown in the [Project Overview](#project-overview)

> :bulb: **Optional:** Change the name of the PC. This will just make things easier in the long run.
## Project Highlights
