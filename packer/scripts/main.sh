#!/bin/bash

sudo mv -v /tmp/openvpn_setup.sh /opt/openvpn_setup.sh

sudo apt-get upgrade -y
sudo apt-get update -y
sudo apt-get upgrade -y


sudo useradd -G sudo -m openvpn -s /bin/bash
sudo mkdir -p /home/openvpn
sudo chown openvpn:openvpn /home/openvpn
sudo chmod -R 755 /home/openvpn

# sudo mv -v /tmp/openvpn_setup.sh /opt/openvpn_setup.sh

#bash /tmp/openvpn_setup.sh

