# I'm in the fast lane
```
git clone git@github.com:drewkhoury/docker-datacenter-demo.git
cd docker-datacenter-demo
vagrant plugin install vagrant-proxyconf
vagrant plugin install vagrant-hostmanager
vagrant up
```

UCP=`https://localhost:4431/` (login details `admin/orca`).
DTR=`https://localhost:4430/`.

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
- If you require a proxy on your workstation, review `VIRTUALBOX_PROXY` and `LOCAL_PROXY`

# Steps

The `vagrant up` command will bring up all 3 VMs and provision them with Docker Datacenter.

```
git clone git@github.com:drewkhoury/docker-datacenter-demo.git
cd docker-datacenter-demo
vagrant plugin install vagrant-proxyconf
vagrant plugin install vagrant-hostmanager
vagrant up
```

In your browser you should now be able to open the following:

- UCP(primary)=`https://localhost:4431/` (login details `admin/orca`)
- UCP(replica)=`https://localhost:4432/` (login details `admin/orca`)
- UCP(replica)=`https://localhost:4433/` (login details `admin/orca`)
- DTR=`https://localhost:4430/`

# Extras

## Vagrant Tips
You can use `vagrant destroy -f` to remove all containers, `vagrant up docker1` to bring up a specific container and `vagrant ssh docker1` to ssh into specific a container. `vagrant provision docker1` will reprovision the VM (useful if the up command failed and you don't need to spin up a new VM).


## DTR Notes 

Once you've done a `vagrant up`, DTR will be available on docker1 over https/443. It requires some configuration before you can use it (and currently appears to have bugs). It also needs integration with UCP (which is a manual process).

https://docs.docker.com/docker-trusted-registry/install/install-dtr/

- Set Domain Name
- Apply Licence (same as UCP)

https://docs.docker.com/docker-trusted-registry/configure/configuration/#security

- In settings>auth choose 'managed' and create an admin account e.g admin/adminadmin.

https://docs.docker.com/docker-trusted-registry/userguide/

- Create repository foo from the web interface, then you should have https://192.168.50.10/repositories/admin/foo/details

https://docs.docker.com/docker-trusted-registry/configure/config-security/

```
export DOMAIN_NAME=192.168.50.10
openssl s_client -connect $DOMAIN_NAME:443 -showcerts </dev/null 2>/dev/null | openssl x509 -outform PEM | sudo tee /etc/pki/ca-trust/source/anchors/$DOMAIN_NAME.crt
sudo update-ca-trust
sudo /bin/systemctl restart docker.service
```

Other notes (problems trying to push, see https://forums.docker.com/t/unauthorized-authentication-required-when-trying-to-do-a-docker-push-with-dtr/8094):

Push example:

```
# Example Dockerfile
touch hello
cat <<EOF | sudo tee file > /dev/null
FROM scratch
COPY hello /
CMD ["/hello"]
EOF

docker login -u drew -p drewdrew -e foo@bar.com 192.168.50.10
docker build -t hello-drew . && docker tag hello-drew 192.168.50.10/drew/hello-drew && docker push 192.168.50.10/drew/hello-drew:latest

#sudo docker tag busybox:latest 192.168.50.10/drew/foo/busybox-drew:latest
#sudo docker push 192.168.50.10/drew/foo/busybox-drew:latest
 
#sudo docker build -t 192.168.50.10/drew/foo/hello-drew .
#sudo docker push 192.168.50.10/drew/foo/hello-drew:latest

```

SSL Certs (don't think we need):

```
# grab the public key
openssl s_client -showcerts -connect 192.168.50.10:443

# add it here
/etc/docker/certs.d/192.168.50.10:443/ca.crt

# test it
curl -u drew:drewdrew --cacert ca.crt https://192.168.50.10:443
```

## Interlock Notes

I'm not sure it works with docker datacenter yet.

- `cd ~ && git clone https://github.com/ehazlett/interlock.git` - works with boot2docker
- `cd ~ && git clone https://github.com/nicolaka/interlock-lbs.git` - works with ucp (with bugs ... need to point latest semver 1.0.1?)

```
# hack for interlock
cat <<EOF | sudo tee /var/lib/docker/volumes/interlocknginx_nginx/_data/nginx.conf > /dev/null
events {
  worker_connections  4096;  ## Default: 1024
}
EOF
```

# Known Bugs & Issues

## Workstation Proxy

If the shell/cygwin on your workstation should use a proxy, make sure it's configured, e.g:

```
proxy=http://localhost:3128/
export http_proxy=$proxy
export HTTP_PROXY=$proxy
export https_proxy=$proxy
export HTTPS_PROXY=$proxy
```

## Older Centos image

Make sure hosts are using the latest images (useful if you have errors with vagrant up due to older os images)

```bash
$ vagrant up
Bringing machine 'docker1' up with 'virtualbox' provider...
Bringing machine 'docker2' up with 'virtualbox' provider...
Bringing machine 'docker3' up with 'virtualbox' provider...
==> docker1: Importing base box 'centos/7'...
==> docker1: Matching MAC address for NAT networking...
==> docker1: Checking if box 'centos/7' is up to date...
==> docker1: A newer version of the box 'centos/7' is available! You currently
==> docker1: have version '1601.01'. The latest is version '1602.02'. Run
==> docker1: `vagrant box update` to update.

vagrant destroy -f
vagrant box update
```

## WINDOWS USERS :: rsync doesn't work on Vagrant 1.8.0

See https://github.com/mitchellh/vagrant/issues/6702

WORKAROUND: Edit `$VAGRANT_HOME\embedded\gems\gems\vagrant-1.8.0\plugins\synced_folders\rsync\helper.rb`

Remove the following codes (line 77~79):

```
"-o ControlMaster=auto " +
"-o ControlPath=#{controlpath} " +
"-o ControlPersist=10m " +
```