#!/bin/bash

echo "Master Node - Install and Setup Part 2"

# Add K8s apt repo
echo "Initializing Cluster"

read -p "Enter Pod Network CIDR [192.168.0.0/16]: " cidr
cidr=${cidr:-"192.168.0.0/16"}
echo "Using Pod CIDR: $cidr"

read -p "Enter apiserver-advertise-address (IP Address of your master node) [10.0.0.22]: " apiServerAddress
apiServerAddress=${apiServerAddress:-"10.0.0.22"}
echo "Using apiserver-advertise-address: $apiServerAddress"

sudo kubeadm init --pod-network-cidr=$cidr--apiserver-advertise-address=$apiServerAddress

# Make kubectl available for current user
echo 'Making kubectl available for current user'

mkdir -p ~.kube
sudo cp /etc/kubernetes/admin.conf ~/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Appling Flannel mesh network
echo 'Appling Flannel mesh network'
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# Applying metallb
echo 'Applying metallb (for loadbalancing services and assigning local network IP)'
echo 'See https://gist.githubusercontent.com/Shogan/d418190a950a1d6788f9b168216f6fe1/raw/ca4418c7167a64c77511ba44b2c7736b56bdad48/metallb.yaml for the original file'
kubectl apply -f ./metallb.yaml

# Apply configmap to configure metallb options
echo 'Applying configmap to configure metallb options'
kubectl apply -f metallbconfigmap.yaml

echo 'Waiting for containers to spin up...'
x=0
while [ $ -le 10]
do
  echo "."
  sleep 1
  x=$(( $x + 1))
done

echo 'Done waiting, checking to see if containers are deployed.'

kubectl get all --all-namespaces

echo 'Master node install complete'