# Change Log
### v1.2.2
- Updated dependency check for SecLists
- Created function for banner print, updated code to call banner function
- Updated "check if root user" code block to run when first executed
- Added checks to ensure OVPN file path has been updated from default
- Minor prompt verbiage updates
- Minor change to initial question order
### v1.2.1
- Appended ".thm" local domain if choosing TryHackMe machine
- Added another machine name variable for the local domain to be appended to
  - This prevents the folder names from having the domain included while having the scans call the variable with the domain
-  Added banner to dependency error messages
### v1.2.0
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
