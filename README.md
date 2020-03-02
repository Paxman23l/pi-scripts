# Docker and K8s on RPI 3/4

_Dont use the scripts in the scripts folder to install docker and k8s, they're outdated, use the ones in /docker-and-k8s-setup_

# *Prerequisites*
- Rasbian Stretch installed and updated
- Hosts and hostname updated to be unique for each rpi

1. Run /docker-and-k8s-setup/docker-install.sh on all rpi's

if installing on Master Node:
  2.1 Run /docker-and-k8s-setup/k8s-master-install-part1.sh on master rpi
  2.2 Run /docker-and-k8s-setup/k8s-master-install-part2.sh on master rpi

if installing on regular node:
  3. Run /docker-and-k8s-setup/k8s-node-install.sh on node rpi
  
  
# Other Hints and Tips
- Running local scripts using ansible
  - https://blog.programster.org/ansible-run-a-local-script-on-remote-server
