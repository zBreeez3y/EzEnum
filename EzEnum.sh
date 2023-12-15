#!/bin/bash

#Banner function
banner() {
	echo "========================================================================================="
	figlet -c -f slant "EzEnum"
	echo -e "				  By: ${bg}zBreeez3y${ec}" 
	echo -e "\n				 Version: ${blue}1.3.1 ${ec}"
	echo "========================================================================================="
}

#Main THM/HTB directory/sub-directory creation functions
mainDirectory() {
	if [ ! -d "/home/$USER/Documents/$site" ];then
			echo -e "${green}[+] Creating main ${blue}$site ${green}directory... ${ec}"
			sleep 1
			mkdir /home/$USER/Documents/$site
		fi
}

subDirectories() {
	if [ ! -d "/home/$USER/Documents/$1/$tn" ];then
			echo -e "${green}[+] Creating main ${blue}$tn${green} directory, and sub-directories under ${blue}/$1/${ec}"
			mkdir /home/$USER/Documents/$1/$tn
			mkdir /home/$USER/Documents/$1/$tn/enumeration
			mkdir /home/$USER/Documents/$1/$tn/exploitation
			mkdir /home/$USER/Documents/$1/$tn/post-exploitation
			sleep 1
	else
		echo -e "${green}[!] Directories for ${blue}$tn${green} already exist in ${blue}/$1${green} directory. Continuing...${ec}"
		sleep 1
	fi
}

#Nmap TCP/UDP scan function
nmapScan() {
	echo -e "${green}[+] Scanning for open ports on ${blue}$tn${green}...${ec}"
	sleep 1
	if [ ! -z $continue ] && [[ $continue == "Y" || $continue == "y" ]];then
		open=$(nmap -T4 --min-rate 1000 -p- -Pn $ntn | grep ^[0-9] | cut -d '/' -f 1 | sed -e '$!s/$/,/' | tr -d '\n')
		args="-sS -sV -A -T4 -p $open -Pn $ntn"
	else
		open=$(nmap -T4 --min-rate 1000 -p- $ntn | grep ^[0-9] | cut -d '/' -f 1 | sed -e '$!s/$/,/' | tr -d '\n')
		args="-sS -sV -A -T4 -p $open $ntn"
	fi
	echo -e "${green}[+] Starting Nmap SYN scan against open ports... ${ec}"
	nmap $args 1>/home/$USER/Documents/$site/$tn/enumeration/nmapresults.txt 2>&1
	echo -e "${green}[!] Nmap SYN scan results saved to ${red}/Documents/$site/$tn/enumeration/nmapresults.txt"
	sleep 1
	if [[ $answer == "Y" || $answer == "y" ]];then
		if [ ! -z $continue ] && [[ $continue == "Y" || $continue == "y" ]];then
			uargs="-sUV --top-ports 20 -Pn $ntn"
		else
			uargs="-sUV --top-ports 20 $ntn" 
		fi
		echo -e "${green}[+] Starting Nmap UDP Scan against top 20 ports... ${ec}"
		nmap $uargs 1>/home/$USER/Documents/$site/$tn/enumeration/nmapudpresults.txt
		echo -e "${green}[!] Nmap UDP results saved to ${red}/Documents/$site/$tn/enumeration/nmapudpresults.txt ${ec}"
		sleep 1
	else
		echo -e "${yellow}[!] Skipping UDP scan... ${ec}"
		sleep 1	
	fi
}

#Terminal color variables
green="\e[32;1m"
bg="\e[35;1m"
red="\e[31;1m"
blue="\e[34;1m"
yellow="\e[33;1m"
ec="\e[0m"

#Checking for root user
root=$(id -u)
if [  $root != 0 ];then
	banner
	echo -e "${red}[!] Must run script as root user.\n[!] Syntax: sudo ./EzEnum.sh ${ec}"
	exit
fi

#Check for dependencies, exit if any aren't installed
fig=$(which figlet | wc -l)
nm=$(which nmap | wc -l)
sc=$(which smbclient | wc -l)
xt=$(which xterm | wc -l)
ovpn=$(which openvpn | wc -l)
sl=$(which seclists | wc -l)
go=$(which gobuster | wc -l)
oso=$(which onesixtyone | wc -l)

tools=( $fig $nm $sc $sl $xt $ovpn $go $oso )
for bin in ${tools[@]}; do
	while [[ $bin == 0 ]]; do
		banner
		echo -e "${red}[!] Error!${ec}"
		if [ $fig == 0 ];then
			echo -e "${red}[!] ${ec}Figlet${red} is not installed (sudo apt install figlet)...${ec}"					
		fi
		if [ $nm == 0 ];then
			echo -e "${red}[!] ${ec}Nmap${red} is not installed (sudo apt install nmap)...${ec}"							
		fi
		if [ $sc == 0 ];then
			echo -e "${red}[!] ${ec}SMBClient${red} is not installed (sudo apt install smbclient)...${ec}"			
		fi
		if [ $xt == 0 ];then
			echo -e "${red}[!] ${ec}XTerm ${red}is not installed (sudo apt install xterm)...${ec}"
		fi
		if [ $ovpn == 0 ];then
			echo -e "${red}[!] ${ec}OpenVPN ${red}is not installed (sudo apt install openvpn)...${ec}"
		fi
		if [ $go == 0 ];then
		 	echo -e "${red}[!] ${ec}Gobuster ${red}is not installed (sudo apt install gobuster)...${ec}"
		fi
		if [ $sl == 0 ];then
			echo -e "${red}[!] ${ec}Seclists ${red}is not installed (sudo apt install seclists)...${ec}"					
		fi
		if [ $oso == 0 ];then
			echo -e "${red}[!] ${ec}Onesixtyone ${red}is not installed (sudo apt install onesixtyone)...${ec}"		
		fi
		exit
	done
done

#Initial prompts
banner
read -p "[+] Which OS user will files/directories be created/saved for? (case-sensitive): " USER
while [[ -z $USER ]]; do
	read -p "Please input a user on this machine: " USER
	if [ ! -z $USER ];then
		ok=1
	fi
done
while  [[ ! -d "/home/$USER" ]]; do
	read -p "Please provide a user that exists in the HOME directory: " USER
	while [[ -z $USER ]]; do
		read -p "Please provide a user that exists in the HOME directory: " USER
		if [ ! -z $USER ];then
			ok=1
		fi
	done			
done

htbVpnPath="/path/to/hackthebox.ovpn" #<---- Change this path to your HackTheBox OVPN file's path.
thmVpnPath="/path/to/tryhackme.ovpn" #<---- Change this path to your TryHackMe OVPN file's path. 

read -p "[+] Are you doing a TryHackMe or HackTheBox machine? [HTB/THM]: " response
while true; do
	case $response in
		HTB) 
			break;;
		THM) 
			break;;
		htb)			
			break;;
		thm)
			break;;
		*) 
			read -p 'Please response with "HTB" or "THM": ' response
	esac
done

#Check if OVPN file for site has been updated from default
if [[ $response == "HTB" || $response == "htb" ]]; then
	if [ $htbVpnPath == "/path/to/hackthebox.ovpn" ]; then
		echo -e "${red}[!] The HackTheBox OVPN path has not been updated. Please update the path to your HTB VPN file on line ${ec}144"
		exit
	fi
elif [[ $response == "THM" || $response == "thm" ]]; then
	if [ $thmVpnPath == "/path/to/tryhackme.ovpn" ]; then
		echo -e "${red}[!] The TryHackMe OVPN path has not been updated. Please update the path to your THM VPN file on line ${ec}145"
		exit
	fi
fi

read -p "[+] What is the machines name?: " tn
while [[ -z $tn ]]; do
	read -p "Please provide a name for the machine: " tn
	if [ ! -z $tn ];then
		ok=1
	fi
done

read -p "[+] What is the machines IPv4 address?: " ti
while [[ -z $ti ]]; do
	read -p "Please provide an IPv4 address for the machine: " ti
	if [ ! -z $ti ];then
		ok=1
	fi
done
regex='^([0-9]{1,3}\.){3}[0-9]{1,3}$'
while ! [[ $ti =~ $regex  ]]; do
	read -p "Please provide a valid IPv4 addresss: " ti
	while [[ -z $ti ]]; do
		read -p "Please provide a valid IPv4 address: " ti
		if [ ! -z $ti ]; then
			ok=1
		fi
	done	
done
read -p "[+] Would you like to run a UDP scan? [Y/N]: " answer
while [ -z $answer ]; do
	read -p 'Please respond with "Y" or "N": ' answer
	if [ ! -z $answer ];then
		ok=1
	fi
done
while true; do	
	case $answer in
		Y)
			break;;
		y)
			break;;
		N) 
			break;;
		n)
			break;;
		*)
			read -p 'Please respond with "Y" or "N": ' answer
	esac
done

#Append .htb or .thm local TLD to hosts' name
if [[ $response == "HTB" || $response == "htb" ]];then
	ntn=$tn.htb
elif 
	[[ $response == "THM" || $response == "thm" ]];then
		ntn=$tn.thm
fi

#Setting site variable
if [[ $response == "HTB" || $response == "htb" ]];then
	site="HackTheBox"
elif
	[[ $response == "THM" || $response == "thm" ]];then
		site="TryHackMe"
fi


#Checking if connected to VPN, connect if not. Also check for multiple connections
clear -x 
banner
interface=$(ifconfig | grep "tun" | cut -d ":" -f 1 | wc -l)
if [ $interface -ge 2 ];then
	read -p "[!] More than 1 VPN interface detected. Which TUN interface is running your $site OVPN file? [0-2]: " int
	while true; do 
		case $int in
			0)
				break;;
			1)
				break;;
			2)
				break;;
			*)
				read -p "Please respond with 0-2: " int
		esac
	done
	vpn=$(ifconfig | grep "tun$int" | cut -d ":" -f 1 | wc -l)
else
	tun=$(ifconfig | grep "tun" | cut -d ":" -f 1 | wc -l)
	if [ $tun == 0 ];then
		vpn=0
	else
		vpn=$tun
	fi
fi

if [ $vpn == 1 ];then
	if [ $interface -ge 2 ];then
		tun="tun$int"
	else
		tun=$(ifconfig | grep "tun" | cut -d ":" -f 1)
	fi	
	myip=$(ifconfig $tun | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
	echo -e "${green}[!] VPN already connected...${ec}"
	sleep 1
	echo -e "${green}[!] Your ${blue}$site${green} VPN IP address is: ${blue}$myip ${ec}"
	sleep 3
elif
	[ $vpn == 0 ];then
		echo -e "${green}[+] Attempting to connect to ${blue}$site${green} VPN... ${ec}"
		if [[ $response == "HTB" || $response == "htb" ]];then
			args="$htbVpnPath"
			line="144"
		elif [[ $response == "THM" || $response == "thm" ]];then
			args="$thmVpnPath"
			line="145"
		fi
		xterm -e openvpn $args&
		sleep 5
		vpn=$(ifconfig | grep "tun0" | wc -l)
		if [ $vpn == 1 ];then
			echo -e "${green}[!] Successfully connected to VPN...${ec}"
			sleep 1
			myip=$(ifconfig tun0 | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
			echo -e "${green}[!] Your ${blue}$site${green} VPN IP address is: ${blue}$myip ${ec}"
			sleep 5					
		elif [ $vpn == 0 ];then
			echo -e "${red}[!] Unable to connect to VPN..." 
			echo -e "[!] Check and make sure you have the correct path for your ${blue}$site${red} OVPN file on line ${ec}$line${red}..."
			echo -e "[+] Exiting script...${ec}" 
			exit
		fi 		
fi

#Clear terminal for main function
clear -x

#New Banner with variable values displayed
banner
echo "========================================================================================="
echo -e "[+] ${yellow}Site: ${ec}$site"
echo -e "[+] ${yellow}Machine: ${ec}$tn"
echo -e "[+] ${yellow}Machine IP: ${ec}$ti"
echo -e "[+] ${yellow}User: ${ec}$USER"
echo -e "[+] ${yellow}Folders: ${ec}/home/$USER/Documents/$site/$tn/"
echo -e "[+] ${yellow}Your VPN IP: ${blue}$myip ${ec}"
echo "========================================================================================="
echo "========================================================================================="

#Add to hosts file
echo -e "${green}[+] Adding IP to Hosts file...${ec}"
echo "$ti $ntn"  >> /etc/hosts
sleep 1

#Test connection
echo -e "${green}[+] Pinging host...${ec}"
count=$(ping -c 4 $ntn | grep icmp* | wc -l)
if [ $count != 4 ];then
	echo -e "${red}[!] Device responded to ${ec}$count ${red}out of 4 ICMP requests...${ec}" 
	sleep 1
	read -p "Would you like to continue anyways? (Select 'Y' if device won't respond to ICMP requests) [Y/N]: " continue
	while [[ $continue == "" ]]; do
		read -p 'Please respond with "Y" or "N": ' continue
		if [ $continue > 1 ];then
			ok=1
		fi		
	done
	while true; do	
		case $continue in
			Y)
				break;;
			y)
				break;;
			N) 
				break;;
			n)
				break;;
			*)
				read -p 'Please respond with "Y" or "N": ' continue
		esac
	done
	if [[ $continue == "Y" || $continue == "y" ]];then
		echo -e "${blue}[+] Continuing... ${ec}"
		sleep 2
		echo -e "${blue}[+] Will attempt an Nmap TCP/UDP scan with the ${ec}-Pn ${blue}switch... ${ec}"
		sleep 1
	elif 
		[[ $continue == "N" || $continue == "n" ]];then
			echo -e "${red}[+] Removing entry from hosts file... ${ec}"
			sleep 1
			grep -v "$tn" /etc/hosts > /tmp/tmp.txt && mv /tmp/tmp.txt /etc/hosts
			echo -e "${red}[+] Ending script... ${ec}"
			sleep 1
			exit 0
	fi
elif
	[ $count == 4 ];then
		echo -e "${green}[+] ${blue}$tn ${green}is responding to ICMP requests... ${ec}"
		sleep 1
fi

#Make main THM/HTB site directory if it doesn't exist
echo -e "${green}[+] Checking for ${blue}$site ${green}directory... ${ec}"
sleep 1
mainDirectory
	
#Make sub-directories	
if [[ $response == "HTB" || $response == "htb" ]];then
	subDirectories "HackTheBox"
elif 
	[[ $response == "THM" || $response == "thm" ]];then 
		subDirectories "TryHackMe"
fi

#Run Nmap scans
nmapScan

#Nmap result variables
httpPorts=()
http=$(grep ^[0-9] /home/$USER/Documents/$site/$tn/enumeration/nmapresults.txt | grep "/tcp" | grep "http" | cut -d "/" -f 1)
while IFS=$'\n' read -r line; do httpPorts+=("$line"); done <<< "$http"
smb=$(grep ^[0-9] /home/$USER/Documents/$site/$tn/enumeration/nmapresults.txt | grep "445/tcp" | wc -l)
ftp=$(grep ^[0-9] /home/$USER/Documents/$site/$tn/enumeration/nmapresults.txt | grep "21/tcp" | wc -l)
if [ -f /home/$USER/Documents/$site/$tn/enumeration/nmapudpresults.txt ];then
	snmp=$(grep ^[0-9] /home/$USER/Documents/$site/$tn/enumeration/nmapudpresults.txt | grep "open" | grep "161/udp" | wc -l)
fi

#GoBuster directory scan
if [ ! -z $httpPorts ]; then
	for i in ${httpPorts[@]}
	do 
		echo -e "${green}[*] HTTP server detected on port ${ec}$i${green}, starting GoBuster directory scan on ${blue}$tn${green}:${ec}$i"
		gobuster dir -t 100 -u http://$ntn:$i/ -w /usr/share/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt 1>/home/$USER/Documents/$site/$tn/enumeration/godir$i.txt 2>&1
		error=$(cat /home/$USER/Documents/$site/$tn/enumeration/godir$i.txt | grep "Error:" | wc -l)
		if [ $error == 1 ];then
			errorCode=$(cat /home/$USER/Documents/$site/$tn/enumeration/godir$i.txt | grep "Error:" | cut -d ">" -f 2 | cut -d " " -f 2)
			echo -e "${red}[!] The server on port ${ec}$i${red} returns status code ${ec}$errorCode${red} which matches the provided options for non existing urls. Attempting to rerun directory scan while excluding this response code ${ec}"
			gobuster dir -t 100 -u http://$ntn:$i/ -w /usr/share/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt 1>/home/$USER/Documents/$site/$tn/enumeration/godir$i.txt -b $errorCode 2>&1
		fi
		echo -e "${green}[!] GoBuster results for port ${ec}$i${green} saved in ${red}/Documents/$site/$tn/enumeration/godir$i.txt ${ec}"
		sleep 1
	done
fi

#GoBuster subdomain scan
if [ ! -z $httpPorts ]; then
	for i in ${httpPorts[@]}
	do 
		echo -e "${green}[+] Scanning for subdomains on ${blue}$tn${green}:${ec}$i"
		gobuster vhost -t 100 -u http://$ntn:$i/ -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-20000.txt 1>/home/$USER/Documents/$site/$tn/enumeration/govhost$i.txt --append-domain 2>&1
		echo -e "${green}[!] Subdomain results for port ${ec}$i${green} saved in ${red}/Documents/$site/$tn/enumeration/govhost$i.txt ${ec}"
		sleep 1
	done
fi
	
#If SMB is open, attempt to list SMB shares
if [ $smb == 1 ];then
	echo -e "${green}[*] SMB service is running, attempting to list available shares... ${ec}"	 
	smbclient -L \\\\$ntn\\ -N > /home/$USER/Documents/$site/$tn/enumeration/shares.txt 2>&1
	sleep 1
	echo -e "${green}[!] SMB list results saved to ${red}/$site/$tn/enumeration/shares.txt ${ec}"
	sleep 1
fi


#If FTP open, check for anonymous login. If anon login, mirror all ftp share
anon=$(grep -i "Anonymous FTP login allowed" /home/$USER/Documents/$site/$tn/enumeration/nmapresults.txt | wc -l)
if [ $ftp == 1 ];then
	if [ $anon == 1 ];then
		echo -e "${blue}[*] FTP server detected and anonymous login is allowed. Creating FTP directory and mirroring files from server...${ec}"
		mkdir /home/$USER/Documents/$site/$tn/enumeration/ftp
		cd /home/$USER/Documents/$site/$tn/enumeration/ftp
		wget -m ftp://anonymous@$ntn/ 1>ftplog.txt 2>&1 
		cd $OLDPWD
	elif [ $anon == 0 ];then
   		echo -e "${blue}[!] FTP is open, but anonymous login does not appear to be allowed...${ec}"
	fi 
fi

#If SNMP is open, attempt to brute force community string
if [ ! -z $snmp ];then
	if [ $snmp == 1 ];then
		echo -e "${green}[*] SNMP detected. Attempting to brute-force SNMP community string...${ec}"
		onesixtyone $ti -c /usr/share/seclists/Discovery/SNMP/snmp-onesixtyone.txt 1> /home/$USER/Documents/$site/$tn/enumeration/osoCS.txt 2>&1
		sleep 1
		echo -e "${green}[!] Onesixtyone results saved to ${red}/home/$USER/Documents/$site/$tn/enumeration/osoCS.txt${ec}"
		sleep 1
	fi
fi

#Setting permissions to user set in initial prompts
echo -e "${green}[+] Setting permissions on all directories/files created to ${blue}$USER${ec}"
chown -R $USER:$USER /home/$USER/Documents/$site/$tn/
sleep 1

echo -e "${blue}[+] Script Complete.... #EzLife ${ec}" 
