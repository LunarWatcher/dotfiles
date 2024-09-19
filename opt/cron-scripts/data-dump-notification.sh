#!/usr/bin/bash

COOKIES=/tmp/datadump-cookies.txt

rm $COOKIES

fkey=$(curl -s https://stackoverflow.com/users/login --cookie-jar $COOKIES --cookie $COOKIES | grep -Po '"fkey":"(\K[^"]+)')
curl -X POST --data-urlencode "email=$STACK_EMAIL" --data-urlencode "password=$STACK_PASSWORD" --data-urlencode "fkey=$fkey" \
    https://stackoverflow.com/users/login?returnurl=/ \
    --cookie $COOKIES --cookie-jar $COOKIES

cat $COOKIES | grep acct > /dev/null
if [[ "$?" != "0" ]]; then
    echo $page
    echo "Failed to log in"
    exit -1
fi

page=$(curl --fail -s https://stackoverflow.com/users/data-dump-access/current -L --cookie-jar $COOKIES --cookie $COOKIES)
if [[ "$?" != "0" ]]; then
    echo $page
    echo "Failed to get data dump status"
    exit -1
fi

upload=$(echo $page | grep -Po "Last uploaded: \K[^<]+")
if [[ "$(cat last-data-upload.txt)" != "$upload" ]]; then
    ntfy pub --tags rainbow_flag alerts "New data dump live; uploaded $upload"
    echo $upload > last-data-upload.txt
fi
