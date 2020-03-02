#!/bin/bash

echo "Node - Install and Setup"

echo "Adding k8s Apt Repository"

# echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
$File=/etc/apt/sources.list.d/kubernetes.list

if test -f "$File"; then
  echo "$File already exists, skipping..."
else
  echo "$File does not exist, adding"
  sudo sh -c 'echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >> /etc/apt/sources.list.d/kubernetes.list'
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
fi

# update apt data
sudo apt update && sudo apt upgrade -y

# Install kube cli tools
echo "Installing kubeadm kubectl kubelet"
sudo apt install kubeadm kubectl kubelet

# set iptables info
echo "Installing legacy version of iptables and updating rules"
sudo sysctl net.bridge.bridge-nf-call-iptables=1
sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
sudo iptables -w -P FORWARD ACCEPT

echo 'k8s install complete'
echo 'Use join script to join this node with the master node'

