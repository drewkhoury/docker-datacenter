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