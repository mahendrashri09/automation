#!/usr/local/bin/bash
# title            : hp-hardware-check.sh    
# description      : Hardware check Script For HP LOM Servers
#=============================================================

usage()
{
cat << EOF

Usage: sh $0 options

This script expects hostname and check name
eg. sh $0 -H <hostname> -c mem|raid|cpu|fan|temp|all
OPTIONS:
   -H <hostname>
   -c mem|raid|cpu|fan|temp|all
	   mem  => memory
	   raid => raid status
	   cpu  => cpu status 
	   fan  => fan status
	   temp => temperature
	   all  => Overall hardware health
   -h Help
EOF
}

while getopts ":hH:c:" OPTION
do
     case $OPTION in
         h)
             usage; exit 1 ;;
         H)
             HOST_NAME=$OPTARG ;;
	c)
	     check=$OPTARG ;;
         *)
             usage; exit 1 ;;
     esac
done

if [ "$1" = '' ] || [ "$2" = '' ]
then
    usage
    exit
fi


##### states 

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

# Array

mem=".1.3.6.1.4.1.232.6.2.14.4.0"
raid=".1.3.6.1.4.1.232.3.1.3.0"
cpu="1.3.6.1.4.1.232.6.2.6.8.1.4.0.2"
fan="1.3.6.1.4.1.232.6.2.6.4.0"
temp="1.3.6.1.4.1.232.6.2.6.8.1.4.0.1"
all=".1.3.6.1.4.1.232.6.1.3.0"

case "$check" in
   "mem") OID=$mem 
   ;;
   "raid") OID=$raid 
   ;;
   "cpu") OID=$cpu
   ;;
   "fan") OID=$fan
   ;;
   "temp") OID=$temp 
   ;;
   "all") OID=$all
   ;;
esac

# Checking Status 

/usr/lib64/nagios/plugins/check_snmp -H $HOST_NAME -o $OID  -C public >/dev/null

if [ $? -eq 0 ]
    then
    echo "OK - $check status fine"
    exit $STATE_OK

elif [ $? -eq 1 ]
    then
    echo "CRITICAL - $check status Not ok"
    exit $STATE_CRITICAL

else
    echo "UNKNOWN - Information Not Available"
    exit $STATE_UNKNOWN

fi