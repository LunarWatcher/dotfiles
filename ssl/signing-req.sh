#!/bin/bash

if [[ "$KEYNAME" == "" ]]; then
    echo "You must specify the name of the key using KEYNAME=example ./signing-req.sh"
    exit -1
fi

CA=${CANAME:-rootCA}
echo "Using CA file $CA"

openssl req -new -nodes -out $KEYNAME.csr -keyout $KEYNAME.key -config config.conf
openssl x509 -req -in $KEYNAME.csr -CA $CA.crt -CAkey $CA.key -CAcreateserial -out $KEYNAME.cert -days 3650 -extensions v3_req -extfile config.conf
