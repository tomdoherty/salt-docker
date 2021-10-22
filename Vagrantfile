# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "master" do |master|
    master.vm.hostname = "master"
    master.vm.network "private_network", ip: "192.168.33.10"
    master.vm.synced_folder "srv", "/srv"
    master.vm.provision "shell", upload_path: "/home/vagrant/build.sh", inline: <<-SHELL
      dnf install -y https://repo.saltstack.com/py3/redhat/salt-py3-repo-latest.el8.noarch.rpm
      dnf install -y salt-master salt-minion salt-ssh salt-syndic salt-cloud salt-api
      echo -e '192.168.33.10\tmaster salt' >>/etc/hosts
      echo -e '192.168.33.11\tminion' >>/etc/hosts
      echo -e 'open_mode: true' >>/etc/salt/master
      systemctl start salt-master
    SHELL
    master.vm.provider "docker" do |d, overide|
      d.build_dir	= "."
      d.has_ssh		= true
      d.remains_running	= true
      d.privileged	= true
      d.create_args     = ['--tmpfs', '/tmp', '--tmpfs', '/run', '--tmpfs', '/run/lock', '-v', '/sys/fs/cgroup:/sys/fs/cgroup:ro', '-t']
    end
  end

  config.vm.define "minion" do |minion|
    minion.vm.hostname = "minion"
    minion.vm.network "private_network", ip: "192.168.33.11"
    minion.vm.provision "shell", upload_path: "/home/vagrant/build.sh", inline: <<-SHELL
      dnf install -y https://repo.saltstack.com/py3/redhat/salt-py3-repo-latest.el8.noarch.rpm
      dnf install -y salt-minion salt-ssh salt-syndic salt-cloud salt-api
      echo -e '192.168.33.10\tmaster salt' >>/etc/hosts
      echo -e '192.168.33.11\tminion' >>/etc/hosts
      systemctl start salt-minion
    SHELL
    minion.vm.provider "docker" do |d, overide|
      d.build_dir	= "."
      d.has_ssh		= true
      d.remains_running	= true
      d.privileged	= true
      d.create_args     = ['--tmpfs', '/tmp', '--tmpfs', '/run', '--tmpfs', '/run/lock', '-v', '/sys/fs/cgroup:/sys/fs/cgroup:ro', '-t']
    end
  end
end
