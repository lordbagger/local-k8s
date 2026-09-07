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

## Install Kubernetes (control plane, then worker nodes, then join):

ansible-playbook -i hosts.yaml site.yaml --become-password-file become_password

This runs install-kubernetes-control-plane-revised.yaml followed by
install-kubernetes-worker-nodes-revised.yaml in order, and automatically joins
each worker node to the cluster using a join token generated on the control
plane. No manual steps are required after this command finishes.

## Control plane addressing

The cluster is initialized with `--control-plane-endpoint=midgard:6443`, so worker
nodes register against the **hostname** `midgard`, never against its IP address.

- On the control plane, `midgard` maps to `127.0.0.1`, so its own kubectl keeps
  working no matter which network the laptop is on.
- On each worker, the playbook writes midgard's current routable IP into
  `/etc/hosts`.

When the control plane's IP changes, just re-run `site.yaml`. It rewrites the
worker `/etc/hosts` entries in place; no certificates and no re-initialization
are needed. See NETWORK-RECOVERY.md for recovering a cluster that was built
before this change.
