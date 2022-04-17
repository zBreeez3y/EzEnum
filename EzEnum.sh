#!/bin/bash

#Terminal color variables; ec=end color (white) 
green="\e[32;1m"
bg="\e[35;1m"
red="\e[31;1m"
blue="\e[34;1m"
yellow="\e[33;1m"
ec="\e[0m"

#Check for dependencies, exit if any aren't installed
fig=$(which figlet | wc -l)
nm=$(which nmap | wc -l)
wf=$(which wfuzz | wc -l)
sc=$(which smbclient | wc -l)
sl=$(ls /usr/share/SecLists 2>&1 > /dev/null | grep "cannot access" | wc -l)

if [ $sl == 1 ];then
	echo -e "${red}Error!${ec}"
	echo "SecLists is not in the /usr/share directory..."
	exit
fi

tools=( $fig $nm $wf $sc )
for bin in ${tools[@]}; do
	while [[ $bin == 0 ]]; do		
		echo -e "${red}Error!${ec}"
		if [ $fig == 0 ];then
			echo "Figlet is not installed (sudo apt install figlet)..."					
		fi
		if [ $nm == 0 ];then
			echo "Nmap is not installed (sudo apt install nmap)..."							
		fi
		if [ $wf == 0 ];then
			echo "WFuzz is not installed (sudo apt install wfuzz)..."					
		fi
		if [ $sc == 0 ];then
			echo "SMBClient is not installed (sudo apt install smbclient)..."			
		fi			
		exit
	done
done


#Banner
echo "========================================================================================="
figlet -c -f slant "EzEnum"
echo -e "				by: ${bg}D0p3B34t5${ec}"
echo "========================================================================================="

#Checking for root user
root=$(id -u)
if [  $root != 0 ];then
	echo -e "${red}Must run script as root user. ${ec}"
	exit
fi

#Initial prompts
read -p "[+] Are you doing a TryHackMe or HackTheBox machine? [HTB/THM]: " response
while [ ${#response} != 3 ]; do
	read -p 'Please respond with "HTB" or "THM": ' response
	if [ ${#response} == 3 ];then
		ok=1
	fi
done
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

read -p "[+] Which OS user will files/directories be saved to? (case-sensitive): " USER
while [[ $USER == "" ]]; do
	read -p "Please input a user on this machine: " USER
	if [ $USER > 1 ];then
		ok=1
	fi
done
while  [[ ! -d "/home/$USER" ]]; do
	read -p "Please provide a user that exists in the HOME directory: " USER
	while [[ $USER == "" ]]; do
		read -p "Please provide a user that exists in the HOME directory: " USER
		if [ $USER > 1 ];then
			ok=1
		fi
	done			
done  

read -p "[+] What is the machines name?: " tn
while [[ $tn == "" ]]; do
	read -p "Please provide a name for the machine: " tn
	if [ $tn > 1 ];then
		ok=1
	fi
done

read -p "[+] What is the machines IPv4 address?: " ti
while [[ $ti == "" ]]; do
	read -p "Please provide an IPv4 address for the machine: " ti
	if [ $ti > 1 ];then
		ok=1
	fi
done
while [[ ${#ti} -gt 15 ]]; do
	read -p "Please provide a valid IPv4 address: " ti
	if [ ${#ti} -le 15 ];then
		ok=1
	fi
done
while [[ $ti =~ ^[a-zA-Z]+$ ]]; do
	read -p "Please provide a valid IPv4 addresss: " ti
	while [[ $ti == "" ]]; do
		read -p "Please provide a valid IPv4 address: " ti
		if [ $ti > 1 ]; then
			ok=1
		fi
	done	
done
read -p "[+] Would you like to run a UDP scan? [Y/N]: " answer
while [ $answer == "" ]; do
	read -p 'Please respond with "Y" or "N": ' answer
	if [ $answer > 1 ];then
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

#Setting site variable
if [[ $response == "HTB" || $response == "htb" ]];then
	site="HackTheBox"
elif
	[[ $response == "THM" || $response == "thm" ]];then
		site="TryHackMe"
fi

#Clear terminal for main function
clear -x


#New Banner with variable output displayed
echo "========================================================================================="
figlet -c -f slant "EzEnum"
echo -e "				by: ${bg}D0p3B34t5${ec}"
echo "========================================================================================="
echo "========================================================================================="
echo -e "[+] ${yellow}Site: ${ec}$site"
echo -e "[+] ${yellow}Machine: ${ec}$tn"
echo -e "[+] ${yellow}IP: ${ec}$ti"
echo -e "[+] ${yellow}User: ${ec}$USER"
echo -e "[+] ${yellow}Folders: ${ec}/home/$USER/Documents/$site/$tn/"
echo "========================================================================================="
echo "========================================================================================="


#Add to hosts file
echo -e "${green}[+] Adding IP to Hosts file...${ec}"
echo "$ti $tn"  >> /etc/hosts
sleep 1


#Test connection
echo -e "${green}[+] Pinging host...${ec}"
count=$(ping -c 4 $tn | grep icmp* | wc -l)
if [ $count != 4 ];then
	echo -e "${red}[+] Device responded to ${ec}$count ${red}out of 4 pings...${ec}" 
	sleep 1
	echo -e "${red}[+] Removing entry from hosts file... ${ec}"
	sleep 1
	grep -v "$tn" /etc/hosts > /tmp/tmp.txt && mv /tmp/tmp.txt /etc/hosts
	echo -e "${red}[+] Ending script... ${ec}"
	sleep 1
	exit 0
else
	echo -e "${green}[+] ${blue}$tn ${green}is reachable... ${ec}"
	sleep 1
fi

#Make main site directory 
echo -e "${green}[+] Checking for ${blue}$site ${green}directory... ${ec}"
sleep 1
if [[ $response == "HTB" || $response == "htb" ]];then
	if [ ! -d "/home/$USER/Documents/$site" ];then
		echo -e "${green}[+] Creating main HackTheBox directory... ${ec}"
		sleep 1
		mkdir /home/$USER/Documents/$site
	else
		echo -e "${green}[+] Main directory already exists. Continuing... ${ec}"
		sleep 1
	fi
elif 
	[[ $response == "THM" || $response == "thm" ]];then
		if [ ! -d "/home/$USER/Documents/$site" ];then
			echo -e "${green}[+] Creating main TryHackMe directory... ${ec}"
			mkdir /home/$USER/Documents/$site
			sleep 1
		else 
			echo -e "${green}[+] Main directory already exists. Continuing... ${ec}"
			sleep 1
		fi
fi
	
	
#make sub-folders	
if [[ $response == "HTB" || $response == "htb" ]];then
	if [ ! -d "/home/$user/Documents/HackTheBox/$tn" ];then
		echo -e "${green}[+] Creating main directory, and sub-directories in the ${blue}HTB ${green}directory... ${ec}"
		mkdir /home/$USER/Documents/HackTheBox/$tn
		mkdir /home/$USER/Documents/HackTheBox/$tn/enumeration
		mkdir /home/$USER/Documents/HackTheBox/$tn/exploitation
		mkdir /home/$USER/Documents/HackTheBox/$tn/post-exploitation
		sleep 1
	fi
elif 
	[[ $response == "THM" || $response == "thm" ]];then 
		if [ ! -d "/home/$USER/Documents/TryHackMe/$tn" ];then
			echo -e "${green}[+] Creating main directory, and sub-directories in the ${blue}THM ${green}directory... ${ec}"
			mkdir /home/$USER/Documents/TryHackMe/$tn
			mkdir /home/$USER/Documents/TryHackMe/$tn/enumeration
			mkdir /home/$USER/Documents/TryHackMe/$tn/exploitation
			mkdir /home/$USER/Documents/TryHackMe/$tn/post-exploitation
			sleep 1
		fi
fi
	
#Nmap TCP scan
echo -e "${green}[+] Starting Nmap TCP scan against ${blue}$tn${green}... ${ec}"
sleep 1

if [[ $response == "HTB" || $response == "htb" ]];then
	nmap -sT -sV -A -T4 -p- $tn 1>/home/$USER/Documents/$site/$tn/enumeration/nmapresults.txt	
	echo -e "${green}[+] Nmap results saved to ${red}/$site/$tn/enumeration/nmapresults.txt ${ec}"
	sleep 1
elif 
	[[ $response == "THM" || $response == "thm" ]];then 	
		nmap -sT -sV -A -T4 -p- $tn 1>/home/$USER/Documents/$site/$tn/enumeration/nmapresults.txt
		echo -e "${green}[+] Nmap results saved to ${red}/$site/$tn/enumeration/nmapresults.txt ${ec}"
		sleep 1
fi

#Nmap result variables
ws=$(grep "80/tcp" /home/$USER/Documents/$site/$tn/enumeration/nmapresults.txt | wc -l)
wss=$(grep "443/tcp" /home/$USER/Documents/$site/$tn/enumeration/nmapresults.txt | wc -l)
smb=$(grep "445/tcp" /home/$USER/Documents/$site/$tn/enumeration/nmapresults.txt | wc -l)


#Nmap UDP scan
if [[ $answer == "Y" || $answer == "y" ]];then
	echo -e "${green}[+] Starting Nmap UDP Scan against top 50 ports... ${ec}"
	if [[ $response == "HTB" || $response == "htb" ]];then
		nmap -sU --top-ports 50 $tn 1>/home/$USER/Documents/$site/$tn/enumeration/nmapudpresults.txt
		echo -e "${green}[+] Nmap UDP results saved to ${red}$site/$tn/enumeration/nmapudpresults.txt ${ec}"
		sleep 1
	elif
		[[ $response == "THM" || $response == "thm" ]];then 
			nmap -sU --top-ports 50 $tn 1>/home/$USER/Documents/$site/$tn/enumeration/nmapudpresults.txt
			echo -e "${green}[+] Nmap UDP results saved to ${red}$site/$tn/enumeration/nmapudpresults.txt ${ec}"
			sleep 1
	fi
elif
	[[ $answer == "N" || $answer == "n" ]];then
		echo -e "${green}[+] Skipping UDP scan... ${ec}"
		sleep 1
	
fi


#WFuzz scan
if [[ $ws == 1 || $wss == 1 ]];then
	if [ $ws == 1 ];then
		echo -e "${green}[+] Port 80 is open, starting WFuzz scan on ${blue}$tn${green}... ${ec}"
	#Change wordlist path to your desired wordlist
		wfuzz -t 20 -w /usr/share/SecLists/Discovery/Web-Content/directory-list-2.3-small.txt -u http://$tn:80/FUZZ --hc 404 1>/home/$USER/Documents/$site/$tn/enumeration/wfuzz80results.txt 2>&1
		echo -e "${green}[+] WFuzz results for port 80 saved in ${red}/$site/$tn/enumeration/wfuzz80results.txt ${ec}"
		sleep 1
	fi
	if [ $wss == 1 ];then
	echo -e "${green}[+] Port 443 is open, starting WFuzz scan on ${blue}$tn${green}... ${ec}"
		wfuzz -t 20 -w /usr/share/SecLists/Discovery/Web-Content/directory-list-2.3-small.txt -u http://$tn:443/FUZZ --hc 404 1>/home/$USER/Documents/$site/$tn/enumeration/wfuzz443results.txt 2>&1
		echo -e "${green}[+] WFuzz results for port 443 saved in ${red}/$site/$tn/enumeration/wfuzz443results.txt ${ec}"
		sleep 1
	fi		
else
	echo -e "${green}[+] Ports 80/443 do not appear to be open. Skipping directory fuzz ${ec}"
	sleep 1
fi
	

#SMBClient shares
if [ $smb == 1 ];then
	echo -e "${green}[+] Port 445 is open, listing shares... ${ec}"	 
	smbclient -L \\\\$tn\\ -N > /home/$USER/Documents/$site/$tn/enumeration/shares.txt 2>&1
	sleep 1
	echo -e "${green}[+] SMB list saved to ${red}/$site/$tn/enumeration/shares.txt${green}... ${ec}"
	sleep 1
else
	echo -e "${green}[+] Port 445 does not appear to be open, no shares to list... ${ec}"
	sleep 1
fi

echo -e "${blue}[+] Script Complete.... #EzLife ${ec}"

