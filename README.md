# I'm in the fast lane
```
git clone git@github.com:drewkhoury/docker-datacenter.git
cd docker-datacenter
touch docker_subscription.lic # add a valid docker_subscription.lic file https://hub.docker.com/enterprise/trial/
vagrant plugin install vagrant-proxyconf
vagrant plugin install vagrant-hostmanager
vagrant up
```

UCP=`https://docker1:8443/` (login details `admin/orca`).
DTR=`https://docker1:1337/` (login details `admin/adminadmin`).

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

All Guest VMs obtain thier IPs dynamically, and have hostname entries in `/etc/hosts` files. Your Host Machine will also have it's host file set due to the Vagrantfile config `config.hostmanager.manage_host = true` and you may be prompted to allow access to your hosts file.

Example Output:
```
==> docker1: INFO[0000] Verifying your system is compatible with UCP 
==> docker1: WARN[0000] Your system uses devicemapper.  We can not accurately detect available storage space.  Please make sure you have at least 3.00 GB available in /var/lib/docker 
==> docker1: INFO[0002] Pulling required images... (this may take a while) 
==> docker1: INFO[0094] Installing UCP with host address 172.28.128.3 - If this is incorrect, please specify an alternative address with the '--host-address' flag 
==> docker1: INFO[0004] Generating UCP Cluster Root CA               
==> docker1: INFO[0026] Generating UCP Client Root CA                
==> docker1: INFO[0031] Deploying UCP Containers                     
==> docker1: INFO[0037] UCP instance ID: HVJK:OULF:6TZT:BUM5:2X4Q:U44G:KFAK:NZOI:TCYH:52O2:YBSB:DWEE 
==> docker1: INFO[0037] UCP Server SSL: SHA1 Fingerprint=2E:4A:70:F6:E6:04:6A:49:91:35:BC:EA:0D:DE:E9:ED:16:4A:54:8F 
==> docker1: INFO[0037] Login as "admin"/"orca" to UCP at https://172.28.128.3:8443
```
In your browser you should now be able to open the following:

- UCP(primary)=`https://docker1:8443/` (login details `admin/orca`) && DTR=`https://docker1:1337/` (login details `admin/adminadmin`)
- UCP(replica)=`https://docker2:8443/` (login details `admin/orca`)
- UCP(replica)=`https://docker3:8443/` (login details `admin/orca`)

# But I want more!

See [extras](docs/EXTRAS.md) for configuration of DTR, Interlock and Vagrant tips.

There's also a [known issues](docs/KNOWN-ISSUES.md) that covers common proxy issues, vagrant/virtualbox image issues, and Windows rsync issues.