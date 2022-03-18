#!/bin/bash -eu

# '-d' flag for debugging
if [[ ${1:-} = '-d' ]]; then
	set -x
fi

header() {
	echo "$@" '----------------------------'
	echo
}

header "CPU AND MEMORY RESOURCES"

load_average="CPU Load Average: "
load_average+=$(uptime | awk '{ for (i=8; i <= 10; ++i) printf $i" "; print""}')

free_ram="Free Ram: "
free_ram+=$(cat /proc/meminfo | sed -n '2p' | awk '{ for (i=2; i <=4; ++i) printf $i" "; print""}')

# now split the page at column 40 using printf formatting
printf "%-40s%s\n" "$load_average" "$free_ram"

exit

header "NETWORK CONNECTIONS"

echo "lo Bytes Received:"
ifconfig | sed -n 14p | awk '{print $5}'
echo "lo Bytes Transmitted:"
ifconfig | sed -n 16p | awk '{print $5}'
echo
echo "enp0s3 Bytes Received:"
ifconfig | sed -n 5p | awk '{print $5}'
echo "enp0s3 Bytes Transmitted:"
ifconfig | sed -n 7p | awk '{print $5}'
echo
echo "Internet Connectivity"
if ping -c 1 www.google.com > /dev/null
then
        echo "yes"
else
        echo "no"
fi
echo

header "ACCOUNT INFORMATION"

echo "Total Users:"
cat /etc/passwd | wc -l 
echo "Number Active:"
ps -eaho user | sort -u | wc -l
echo 'Shells'
echo "/sbin/nologin:"
cat /etc/passwd | grep /sbin/nologin | wc -l
echo "/bin/bash:"
cat /etc/passwd | grep /bin/bash | wc -l
echo "/bin/false:"
cat /etc/passwd | grep /bin/false | wc -l

header "FILESYSTEM iNFORMATION"

echo "Total Number of Files"
cd /
echo */ | wc | awk '{print $3}'
echo "Total Number of Directories"
echo */ | wc | awk '{print $2}'
