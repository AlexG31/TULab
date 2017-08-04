#!/bin/sh
#read word1
#echo "Here is your input: \"$word1\" \"$word2\""

# Require sudo
sudo echo 'Starting openvpn config...'
cd 
make-cadir ~/openvpn-ca
cd ~/openvpn-ca
echo "Please modify the default settings as you wish[Press any key...]"
read word1
vi vars
cd ~/openvpn-ca
source vars
./clean-all
./build-ca
./build-key-server server
./build-dh
openvpn --genkey --secret keys/ta.key
cd ~/openvpn-ca
source vars
./build-key client1
cd ~/openvpn-ca/keys
sudo cp ca.crt ca.key server.crt server.key ta.key dh2048.pem /etc/openvpn
gunzip -c /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz | sudo tee /etc/openvpn/server.conf

echo "I will replace the default server settings[Press any key...]"
read word1
sudo cp ./server.conf /etc/openvpn/server.conf

echo "Please set 'net.ipv4.ip_forward=1' [Press any key...]"
read word1
sudo vi /etc/sysctl.conf
sudo sysctl -p

echo '========== IP UFW =========='
ip route | grep default

echo
echo 'Please set IP forwarding rules:'
echo
echo '*nat'
echo ':POSTROUTING ACCEPT [0:0] '
echo '# Allow traffic from OpenVPN client to wlp11s0 (change to the interface you discovered!)'
echo '-A POSTROUTING -s 10.8.0.0/8 -o wlp11s0 -j MASQUERADE'
echo 'COMMIT'
echo
sudo vi /etc/ufw/before.rules
echo 
echo 'Please set DEFAULT_FORWARD_POLICY="ACCEPT"[Press any key...]'
read w1
sudo vi /etc/default/ufw
sudo ufw allow OpenSSH
sudo ufw disable
sudo ufw enable
sudo systemctl start openvpn@server
sudo systemctl status openvpn@server
sudo systemctl enable openvpn@server
sudo ufw allow 1194/udp

echo 'Client configurations:[Press any key...]'
read w1
mkdir -p ~/client-configs/files
chmod 700 ~/client-configs/files
cp /usr/share/doc/openvpn/examples/sample-config-files/client.conf ~/client-configs/base.conf

echo 
echo 'cipher AES-128-CBC'
echo 'auth SHA256'
echo 'key-direction 1'
read w1
vi ~/client-configs/base.conf

echo '=============***==============='
echo 'Config finished, please run ./make_config.sh to get client1.ovpn'
echo 'Hint: Do not use tls&ta.key'
