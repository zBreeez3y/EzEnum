# EzEnum 
 


![image](https://github.com/zBreeez3y/EzEnum/assets/98996357/0c9a7277-d47c-45dc-a4ed-f80dcbc9446f)




 ## What is EzEnum?
 EzEnum is a simple bash script to automate organization and repetetive tasks when doing TryHackMe or HackTheBox machines.
 
 ### Note: 
 - EzEnum needs to be ran as the root user to allow the script to run it's course with no issues. When EzEnum asks which OS user you would like to use for this script, the user needs to be in the Home directory, with a 'Documents' directory present as this is where the Machines main, and sub-directories will be written to. 
 
 
## What EzEnum does...
EzEnum will perform the following:
- Will automatically connect to your HackTheBox/TryHackMe VPN server respectively
  #### IMPORTANT: 
   - **You will have to edit the script to supply the path to your TryHackMe/HackTheBox OVPN file.**
   - Edit the path on line **144** and provide path to HackTheBox OVPN
   - Edit the path on line **145** and provide path to TryHackMe OVPN                   
- Will check to make sure all dependencies are installed
- Ask whether you're doing a TryHackMe or HackTheBox machine, create a main directory using the machines name, and sub-directories with that to provide organization to the files you may come across throughout the different stages of the machine
  - Sub-directories:
    - Enumeration
    - Exploitation
    - Post-exploitation
- Will take the machines name and IP, and add it to the hosts file
- Will ping the machine to make sure it can communicate with it
   - If the machine you're testing on doesn't respond to ICMP requests, you will have the option to continue and run your Nmap scans with the no ping switch 
- Will perform an Nmap TCP-SYN scan against all 65,535 ports on the machine, and output the results to a text file in the 'enumeration' directory
- Will perform an Nmap UDP scan against the top 20 ports, and output the results to a text file in the 'enumeration' directory
  - Optional; you get the decision at the beginning of the script to skip this if you want
- If any HTTP servers are detected, EzEnum will:
  - Will perform a directory scan using Gobuster and output the results to a text file in the 'enumeration' directory
    - If server returns code that matches options for non-existing urls, EzEnum will rerun the Gobuster command while excluding the returned code
  - Will perform a subdomain/vhost scan using Gobuster and output the results to a text file in the 'enumeration' directory
- Will attempt to list available shares using SMBClient if port 445/tcp is open, and output the results to a text file in the 'enumeration' directory
- Will grab all FTP files if port 21/tcp is open and anonymous login is enabled
- Will attempt to crack SNMP v1/2 community string if port 161/udp detected when optional Nmap UDP scan is ran.



## Dependencies:
  - **SecLists** 
     -     sudo apt install seclists  
  - **Nmap**
     -     sudo apt install nmap

  - **SMBClient**
     -     sudo apt install smbclient
 
  - **Figlet** (for the banner)
    -     sudo apt install figlet

  - **OpenVPN** 
    -     sudo apt install openvpn
   
  - **XTerm** 
    -     sudo apt install xterm
  - **Gobuster** 
    -     sudo apt install gobuster
  - **Onesixtyone**
    -     sudo apt install onesixtyone
## Usage
  - EzEnum should be ran as the super user
      -     sudo ./EzEnum.sh


### Disclaimer
Creator is not responsible for the unlawful use of this tool. This tool is to be used for educational purposes only.
