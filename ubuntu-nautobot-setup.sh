#!/bin/bash
sudo apt update
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt update && sudo apt install docker-ce docker-ce-cli containerd.io docker-compose -y

git clone https://github.com/nautobot/nautobot-docker-compose.git
cd nautobot-docker-compose
cp local.env.example local.env

# If you don't want to create "admin" user with default setting, comment out the following.
sed -i -e "s/NAUTOBOT_CREATE_SUPERUSER=false/NAUTOBOT_CREATE_SUPERUSER=true/g" local.env

# The following should be changed for proper security!
# vi local.env

chmod 0600 local.env

sudo docker-compose up -d
