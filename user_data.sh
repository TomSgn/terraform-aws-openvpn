#!/bin/bash

# Mettre à jour les paquets
sudo yum update -y

# Installer OpenVPN et easy-rsa
sudo yum install -y openvpn easy-rsa

# Configurer OpenVPN
sudo mkdir -p /etc/openvpn/easy-rsa/keys
sudo cp -r /usr/share/easy-rsa/3/* /etc/openvpn/easy-rsa/
cd /etc/openvpn/easy-rsa

# Initialiser PKI
sudo ./easyrsa init-pki
echo -e "yes" | sudo ./easyrsa build-ca nopass
sudo ./easyrsa gen-req server nopass
echo -e "yes" | sudo ./easyrsa sign-req server server
sudo ./easyrsa gen-dh
sudo openvpn --genkey --secret /etc/openvpn/ta.key

# Configuration OpenVPN Server
sudo bash -c 'cat <<EOF > /etc/openvpn/server.conf
port 1194
proto udp
dev tun
ca /etc/openvpn/easy-rsa/pki/ca.crt
cert /etc/openvpn/easy-rsa/pki/issued/server.crt
key /etc/openvpn/easy-rsa/pki/private/server.key
dh /etc/openvpn/easy-rsa/pki/dh.pem
server 10.8.0.0 255.255.255.0
keepalive 10 120
persist-key
persist-tun
status /var/log/openvpn-status.log
log /var/log/openvpn.log
verb 3
EOF'

# Démarrer OpenVPN
sudo systemctl enable openvpn@server
sudo systemctl start openvpn@server