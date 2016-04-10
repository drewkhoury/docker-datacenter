# -*- mode: ruby -*-
# vi: set ft=ruby :

# plugins expected:
# - `vagrant plugin install vagrant-hostmanager`
# - `vagrant plugin install vagrant-proxyconf`

# vars expected:
# - `LOCAL_PROXY`

# hack for vagrant-hostmanager

  # https://github.com/devopsgroup-io/vagrant-hostmanager/issues/121

  $logger = Log4r::Logger.new('vagrantfile')
  def read_ip_address(machine)
    command = "/usr/sbin/ip addr show eth1 | grep 'inet ' | xargs | cut -f 2 -d ' '| cut -f 1 -d '/' 2>&1"
    result  = ""

    $logger.info "Processing #{ machine.name } ... "

    begin
      # sudo is needed for ifconfig
      machine.communicate.sudo(command) do |type, data|
        result << data if type == :stdout
      end
      $logger.info "Processing #{ machine.name } ... success"
    rescue
      result = "# NOT-UP"
      $logger.info "Processing #{ machine.name } ... not running"
    end

    # the second inet is more accurate
    result.chomp.split("\n").last
  end

Vagrant.configure(2) do |config|

  # hostmanager
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  config.hostmanager.ip_resolver = proc do |vm, resolving_vm|
    read_ip_address(vm)
  end

  # local proxy - e.g cntlm on windows (docker is a special case)
  if ENV['LOCAL_PROXY'] == 'true' 
    config.proxy.http     = "http://10.0.2.2:3128/"
    config.proxy.https    = "http://10.0.2.2:3128/"
    config.vm.provision "shell", path: "docker-engine-proxy.sh"
  end

  # guest proxy
  config.proxy.no_proxy = "localhost,127.0.0.1,docker1,docker2,docker3"

  # misc
  config.vm.box = "centos/7"
  config.vm.network "private_network", type: "dhcp"

  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--memory", 1792]
  end

  # docker1
  config.vm.define "docker1" do |docker1|
    docker1.vm.network "forwarded_port", guest: 443,  host: 4430
    docker1.vm.network "forwarded_port", guest: 8443, host: 4431
    docker1.vm.provision "shell", path: "docker1.sh"
  end

  # docker2 
  config.vm.define "docker2" do |docker2|
    docker2.vm.network "forwarded_port", guest: 443, host: 4432
    docker2.vm.provision "shell", path: "docker2.sh"
  end

  # docker3
  config.vm.define "docker3" do |docker3|
    docker3.vm.network "forwarded_port", guest: 443, host: 4433   
    docker3.vm.provision "shell", path: "docker3.sh"
  end

end