## My K8s cluster

Environment:

1 Control Plane: Fedora 43 KDE Plasma

4 Worker Nodes:

1 Lenovo laptop:

- 8GB RAM
- 1 TB SSD

3 KVM Debian 13 Trixie nodes running locally:

- 4GB RAM
- 4 CPUs

## Prequisites:

1. SSH key pair generated and store in ~/.ssh/ on master node:

ssh-keygen -t ed25519 -f ~/.ssh/sindri

2. Terraform and Ansible installed

## Create and start Worker Nodes

1. Navigate to the directory ./terraform/

2. Run "terraform init"

3. Run "terraform plan"

4. Have a look at the output written by the previous command. If everything is ok, run "terraform apply"

5. After the VMs are up and running, add a configuration for each one of them in your ~/.ssh/config file:

```
Host jotunheim
  HostName 192.168.122.152
  User sindri
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/sindri
Host nilfheim
  HostName 192.168.122.112
  User sindri
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/sindri
Host vanaheim
  HostName 192.168.122.133
  User sindri
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/sindri
```

## TODO: automate step 5

## Install Kubernetes (control plane, then worker nodes, then join):


ansible-playbook -i hosts.yaml site.yaml --ask-become-pass

OR (in case you have a file with your sudo password):

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
