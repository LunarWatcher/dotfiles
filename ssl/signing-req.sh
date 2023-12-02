sudo openssl req -new -nodes -out nova.crt -keyout nova.key -config config.conf
sudo openssl x509 -req -in nova.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out nova.cert -days 3650 -extensions v3_req -extfile config.conf
