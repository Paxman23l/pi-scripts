#!/bin/bash
#https://stevenbreuls.com/2019/01/install-docker-on-raspberry-pi/
dockerVersion={ $1: -"5:19.03.2~3-0~raspbian-stretch"}
echo "Basic setup for docker"

#Update system
sudo apt update && sudo apt upgrade -y

#docker setup
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common

curl -fsSL https://download.docker.com/linux/raspbian/gpg | sudo apt-key add -

echo "deb [arch=armhf] https://download.docker.com/linux/raspbian stretch stable" | sudo tee /etc/apt/sources.list.d/docker.list

sudo apt update

echo "Installing docker-ce"
#sudo apt install docker-ce="5:19.03.2~3-0~raspbian-stretch"
sudo apt install docker-ce=$dockerVersion --no-recommends

echo "Lock docker-ce version"
sudo apt-mark hold docker-ce
#sudo apt-mark unhold docker-ce to upgrade

sudo usermod -aG docker $USER

echo "installed docker" >> /home/$USER/installations/installed-docker.txt

# sudo reboot -n


