## My K8s cluster

Environment:

1 Control Plane: Fedora 43 KDE Plasma

3 Worker Nodes:

Debian 13 Trixie running locally as Virtual Machines:

- 4GB RAM
- 4 CPUs

## Prequisites:

1. SSH key pair generated and store in ~/.ssh/ on master node:

ssh-keygen -t ed25519 -f ~/.ssh/brokk

2. Nodes up and running with OpenSSH server installed and the following entries in sshd_config:

PermitRootLogin yes
PasswordAuthentication yes

## Configure SSH for user "brokk" and disable SSH connectivity for root user

The playbook configure-ssh.yaml will:

- Create an user (brokk)
- Configure ssh access via public key
- Disable remote login for user 'root'

Command: ansible-playbook -i hosts.yaml configure-ssh.yaml --connection-password-file password_file

After the playbook exits successfully, all ssh connectivity is done with the created user and its public key

## Install Kubernetes on Worker Nodes:

ansible-playbook -i hosts.yaml install-kubernetes-worker-nodes.yaml --become-password-file password_file

## Join the Worker Node in the Cluster:

bash kubeadm.bash
