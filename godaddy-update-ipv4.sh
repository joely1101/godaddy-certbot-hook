#!/bin/bash

mydomain="jumper.digital"
myhostname="$1"
if [ -z "${myhostname}" ];then
	echo "usage:$0 your_hostname"
	exit 0
fi
. .env

key="$GODADDY_KEY"
secret="$GODADDY_SECRET"
gdapikey="${key}:${secret}"

#echo "$gdapikey"
myip=`curl -s "https://api.ipify.org"`
dnsdata=`curl -s -X GET -H "Authorization: sso-key ${gdapikey}" "https://api.godaddy.com/v1/domains/${mydomain}/records/A/${myhostname}"`
gdip=`echo $dnsdata | cut -d ',' -f 1 | tr -d '"' | cut -d ":" -f 2`
echo "`date '+%Y-%m-%d %H:%M:%S'` - Current External IP is $myip, GoDaddy DNS IP is $gdip"

if [ "$gdip" != "$myip" -a "$myip" != "" ]; then
  echo "IP has changed!! Updating on GoDaddy"
    curl -s -X PUT "https://api.godaddy.com/v1/domains/${mydomain}/records/A/${myhostname}" -H "Authorization: sso-key ${gdapikey}" -H "Content-Type: application/json" -d "[{\"data\": \"${myip}\"}]"
  [ $? -eq 0 ] && echo "curl update success" || echo "Error on curl update"
fi
