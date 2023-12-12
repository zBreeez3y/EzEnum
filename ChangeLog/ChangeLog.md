# Change Log
## v.1.3.0
- Created functions for the following features: 
	- Main THM/HTB directory creation
	- Subdirectory creation
	- Nmap TCP/UDP scans
- Updated the way the Nmap results txt file is parsed for HTTP servers to account for non-standard http(s) ports
- Reworked the Gobuster Directory/Virtual Host scanning code blocks
	- Added support to rerun Directory scan if server returns code that matches options for non-existing urls
- Reworked code block that checks if already connected to the sites VPN/connects you if you're not
- Changed Directory/Vhost scanning threads from 150 to 100
- Changed Nmap top UDP port scan from 50 to 20.
- Added support for SNMP detection via optional Nmap UDP scan
	- If SNMP detected on optional UDP scan, EzEnum will attempt to brute force the community string
	- New dependency - Onesixtyone
- Minor cosmetic/verbiage updates
## v1.2.2
- Updated dependency check for SecLists
- Created function for banner print, updated code to call banner function
- Updated "check if root user" code block to run when first executed
- Added checks to ensure OVPN file path has been updated from default
- Minor prompt verbiage updates
- Minor change to initial question order
## v1.2.1
- Appended ".thm" local domain if choosing TryHackMe machine
- Added another machine name variable for the local domain to be appended to
  - This prevents the folder names from having the domain included while having the scans call the variable with the domain
-  Added banner to dependency error messages
## v1.2.0
- Added support for FTP server detection
  - Added feature to check for anonymous login
  - Mirrors entire share to a local directory which will be created in the machines' "enumeration" directory if anonymous login is allowed
- Appended ".htb" local domain to hostname when selecting HackTheBox machine option
- Updated error handling logic to ensure a legitimate IP is specified when asked for the machines IP
- Replaced WFuzz with Gobuster for directory/subdomain (vhost) busting
  - Requires at least version 1.19 of Golang be installed
- Updated Nmap scan packets per second minimum rate to 1000
- Added feature to set permissions for all directories/files created during script to the user set in the initial prompts
- Various minor cosmetic changes
## v1.1.0
- What's New? 
      - Automatically connects to TryHackMe/HackTheBox VPN respectively if not connected prior to running EzEnum
      - First checks for active TUN interfaces with an ifconfig command
      - If one active interface is detected, EzEnum will automatically assume it's for the site (THM/HTB) you selected on the first prompt
      - If more than one active TUN interface is detected, EzEnum will ask you which TUN interface is running your sites VPN connection
          - Ex: tun0 or tun1
      - If no active TUN interfaces are detected, EzEnum will spawn an xterm terminal and use OpenVPN to connect to either your TryHackMe or HackTheBox OVPN file depending on your response to the first prompt.         
  - Will now display your VPN's IP address in the main functions banner
  - Now supports scanning devices that do not respond to ICMP requests
    - If target doesn't respond to any ICMP requests, you will have the option to continue anyways
      - If you choose to continue, the Nmap TCP/UDP scans will be ran with the no ping switch (-Pn) to skip host discovery
  - Port 8080 now included in enumeration scans
  - Automatically scans for subdomains on web-servers on hosted on port 80/8080**
- Improvements from 1.0.0
   - Nmap
      - TCP-Connect scans have been changed to TCP-SYN scans
      - TCP-SYN scans are now split into two processes to improve efficiency
        - Step 1:
          - Scans all 65,535 ports using the default SYN scan and no other options, with a minimum rate of 750 packets per second. 
        - Step 2:
          - Takes output from first scan and runs another SYN scan with OS & service version detection on the machines open ports. 
   - Nmap Result Variables
    - Changed the way EzEnum sets the Nmap result variables for ports 80,8080,443,445. 
      - Now searches only for lines starting with a number first before filtering out the exact port
    - When setting the variable for port 80 from the Nmap results, EzEnum will now perform an inverted search for "8080" to prevent an extra line being added to the output
  - WFuzz
    - Changed the number of concurrent connections from 20 to 30
    - Set a minimum request delay of 10 seconds (instead of the default, 90)
- New Dependencies
  - OpenVPN
    ```
    sudo apt install openvpn
    ```
  - Xterm
    ```
    sudo apt install xterm
    ```
### Note
I decided to remove version 1.0.0 from the repository due to the amount of bugs due it to being the first script I ever wrote. Version 1.1.0 will be the "first" version publicly available. :)
