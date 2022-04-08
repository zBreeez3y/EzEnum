# EzEnum 
 

![image](https://user-images.githubusercontent.com/98996357/161857762-e3160fca-90b9-44be-9e85-153dbac475ce.png)



 ## What is EzEnum?
 EzEnum is a simple bash script to automate organization and repetetive tasks when doing TryHackMe or HackTheBox machines.
 
 ### Note: 
 - This is the first script I've ever written so I appreciate all feedback. I have only tested this on Kali Linux and Linux Mint, though most of the dependencies are in the default apt repository so it should work on most distributions that use apt as the package manger
 - EzEnum needs to be ran as the root user to allow the script to run it's course with no issues. When EzEnum asks which OS user you would like to use for this script, the user needs to be in the Home directory, with a 'Documents' folder present as this is where the Machines main, and sub-folders will be written to. 
 
 
## What EzEnum does...
EzEnum will perform the following:
- Will check to make sure all dependencies are installed and that SecLists is in the /usr/share directory
- Ask whether you're doing a TryHackMe or HackTheBox machine, create a main directory using the machines name, and sub-directories with that to provide organization to the files you may come across throughout the different stages of the machine
  - Sub-Folders:
    - Enumeration
    - Exploitation
    - Post-exploitation

- Will take the machines name and IP, and add it to the hosts file
- Will ping the machine to make sure it can communicate with it
- Will perform an Nmap TCP scan against all 65,535 ports on the machine, and output the results to a text file in the 'enumeration' directory
  - If port 80 or 443 is open, EzEnum will automatically fuzz either (or both, if both are open) port for hidden directories using GoBuster, and output the results to a text file in the 'eumeration' directory
  - If port 445 is open, EzEnum will automatically attempt to list the available shares using SMBClient, and outputs the results to a text file.
- Will perform an Nmap UDP scan, and output the results to a text file in the 'enumeration' directory
  - Optional; you get the decision at the beginning of the script to skip this if you want



## Dependencies:
  - **WFuzz**
     -     sudo apt install wfuzz
  - **SecLists** (for wordlist, SecLists directory should be in the /usr/share directory for this script)
     - I used Git to install SecLists
        -     sudo apt install git
              sudo git clone https://github.com/danielmiessler/SecLists.git
              sudo mv SecLists/ /usr/share/SecLists   
  - **Nmap**
     -     sudo apt install nmap

  - **SMBClient**
     -     sudo apt install smblcient
 
  - **Figlet** (for the banner)
    -     sudo apt install figlet
      

## Usage
  - EzEnum should be ran as the super user
      -     sudo ./EzEnum.sh


### Disclaimer
I am not responsible for the unlawful use of this tool. This tool is to be used for educational purposes only, and any indidividual using this tool is repsonsible solely for their own actions. 
