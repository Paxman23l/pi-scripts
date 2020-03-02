#!/bin/bash
if [ "$EUID" -e 0 ]
  then echo "Please run as sudoer without sudo, and not root"
  exit
fi

#https://stevenbreuls.com/2019/01/install-docker-on-raspberry-pi/
dockerVersion={ $1: -"5:19.03.2~3-0~raspbian-stretch"}
echo "Basic setup for docker"

#Update system
sudo apt update && sudo apt upgrade -y

# Change boot settings for Docker and K8s
echo 'Updating /boot/cmdline.txt'
$File = "/boot/cmdline.txt"
if grep -q "cgroup_enable=cpuset" "$File"; then
  echo 'Adding cgroup_enable=cpuset'
  sed -i ' 1 s/$/ cgroup_enable=cpuset/' $File
fi
if grep -q "cgroup_memory=1" "$File"; then
  echo 'Adding cgroup_memory=1'
  sed -i ' 1 s/$/ cgroup_memory=1/' $File
fi
if grep -q "cgroup_enable=memory" "$File"; then
  echo 'Adding cgroup_enable=memory'
  sed -i ' 1 s/$/ cgroup_enable=memory/' $File
fi

# Disable swap and uninstall
echo 'Disabling swap'
sudo dphys-swapfile swapoff
sudo dphys-swapfile uninstall
sudo apt purge dphys-swapfile

# Install Docker
echo 'Installing docker'
curl -sSL get.docker.com | sh
sudo usermod -aG docker $USER

# Update Docker Daemon
echo 'Updating /etc/docker/daemon.json'
sudo cp -R ./daemon.json /etc/docker/

echo "Completed Docker Install"
echo "Rebooting..."
echo "Run either the k8s-master-install.sh or the k8s-node-install.sh scripts after reboot depending on your needs"
sleep 3s

sudo reboot
