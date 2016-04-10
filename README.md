# I'm in the fast lane
```
git clone git@github.com:drewkhoury/docker-datacenter-demo.git
cd docker-datacenter-demo
touch docker_subscription.lic # add a valid docker_subscription.lic file https://hub.docker.com/enterprise/trial/
vagrant plugin install vagrant-proxyconf
vagrant plugin install vagrant-hostmanager
vagrant up
```

UCP=`https://docker1:4431/` (login details `admin/orca`).
DTR=`https://docker1:4430/`.

# This Demo

This demo Installs Commercially Supported Docker in a [High Availability](https://docs.docker.com/ucp/understand_ha/) configuration. Included in this demo is UCP (Universal Control Plane), DTR (Docker Trusted Registry) and docker-compose.

- docker1 :: controller node (ucp+ca) + DTR containers
- docker2 :: replica node (ucp)
- docker3 :: replica node (ucp)

# Requirments

Before you attempt to run this demo ensure you have the following:

- A valid dockerdatacenter licence file for the demo (very limited functionaily without it) 
- VirtualBox
- Vagrant
- Vagrant Plugins `vagrant-proxyconf` and `vagrant-hostmanager`
- Around 5.5GB memory free on your workstation
- Around 20GB disk space free on your workstation (more when you pull images)
- If you require a proxy on your workstation (e.g cntlm), review `LOCAL_PROXY` in the Vagrantfile.

# Steps

Before you begin obtain a docker_subscription.lic by visiting https://hub.docker.com/enterprise/trial/. Put your docker_subscription.lic file in the root of this repo.

The `vagrant up` command will bring up all 3 VMs and provision them with Docker Datacenter.

```
git clone git@github.com:drewkhoury/docker-datacenter-demo.git
cd docker-datacenter-demo
vagrant plugin install vagrant-proxyconf
vagrant plugin install vagrant-hostmanager
vagrant up
```

All Guest VMs obtain thier IPs dynamically, and have hostname entries in `/etc/hosts` files. Your Host Machine will also have it's host file set due to the Vagrantfile config `config.hostmanager.manage_host = true` though you can change this accordingly.

In your browser you should now be able to open the following:

- UCP(primary)=`https://docker1:4431/` (login details `admin/orca`) && DTR=`https://docker1:4430/`
- UCP(replica)=`https://docker2:4432/` (login details `admin/orca`)
- UCP(replica)=`https://docker3:4433/` (login details `admin/orca`)

# But I want more!

See [extras](EXTRAS.md) for configuration of DTR, Interlock and Vagrant tips.

There's also a [known issues](KNOWN-ISSUES.md) that covers common proxy issues, vagrant/virtualbox image issues, and Windows rsync issues.