CA=${CANAME:-rootCA}

openssl genrsa -out $CA.key 4096
openssl req -x509 -new -nodes -key $CA.key -sha512 -days 3650 -out $CA.crt
