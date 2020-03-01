#!/bin/bash

echo "Set up system for K8s"

sudo dphys-swapfile swapoff && \
  sudo dphys-swapfile uninstall && \
  sudo update-rc.d dphys-swapfile remove

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
sudo apt-get update -q && \
sudo apt-get install -qy kubeadm

echo Adding " cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory" to /boot/cmdline.txt

sudo cp /boot/cmdline.txt /boot/cmdline_backup.txt
orig="$(head -n1 /boot/cmdline.txt) cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory"
echo $orig | sudo tee /boot/cmdline.txt

#Apply mesh network
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

#set global env variable for kubectl and kubeadm use
sudo cp /etc/kubernetes/admin.conf $HOME/
sudo chown $(id -u):$(id -g) $HOME/admin.conf
echo "export KUBECONFIG=$HOME/admin.conf" | tee -a ~/.bashrc

echo "installed k8s >> /home/joel/installations/installed-k8s.txt"

#instructions for troubleshooting
echo "#If you run into cannot connect to localhost:8080, connection refused.  Set up kuberetes so we can use it from the local directory"
echo "sudo cp /etc/kubernetes/admin.conf $HOME/"
echo "sudo chown $(id -u):$(id -g) $HOME/admin.conf"
echo "export KUBECONFIG=$HOME/admin.conf"
echo ""
echo "To generate join token command run:"
echo "kubeadm token create --print-join-command"

#echo "Rebooting"
#sudo reboot -n