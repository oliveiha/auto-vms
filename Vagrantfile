# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile for bootstrapping a Basic Host Archetype

APP_BOX_HOSTNAME = ENV['APP_BOX_HOSTNAME'] || "vm-app"
APP_BOX_IP = ENV['APP_BOX_IP'] || "192.168.56.3"
APP_BOX_MEM = ENV['APP_BOX_MEM'] || "4096"
APP_BOX_NAME =  ENV['APP_BOX_NAME'] || "ubuntu/trusty64"

DB_BOX_HOSTNAME = ENV['DB_BOX_HOSTNAME'] || "vm-db"
DB_BOX_IP = ENV['DB_BOX_IP'] || "192.168.56.4"
DB_BOX_MEM = ENV['DB_BOX_MEM'] || "4096"
DB_BOX_NAME =  ENV['DB_BOX_NAME'] || "ubuntu/trusty64"

ANSIBLE_HOSTS = ENV['ANSIBLE_HOSTS'] || "hosts"
LOGLEVEL = ENV['CONSUL_LOGLEVEL'] || "info"

Vagrant.require_version ">= 1.5.0"

Vagrant.configure(2) do |config|
  if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    config.vm.synced_folder ".", "/vagrant", mount_options: ["dmode=775,fmode=775"]
  else
    config.vm.synced_folder ".", "/vagrant"
  end
  # ------------------------
  # --- APPLICATION HOST ---
  config.vm.define APP_BOX_HOSTNAME do |d|
    d.vm.box = APP_BOX_NAME
    d.vm.hostname = APP_BOX_HOSTNAME
    d.vm.network "private_network", ip: APP_BOX_IP

    # --- STARTING AUTO SETUP CONFIG ---
    if ENV['VM_PROXY']
      d.vm.provision "shell" do |s|
        s.path = "temp/bootstrap/proxy/configure.sh"
        s.args = ["#{ENV['VM_PROXY']}", "#{ENV['VM_NO_PROXY_HOSTS']}", 
                  "#{ENV['VM_INTERNAL_CONNECTION_CHECK']}",
                  "/vagrant/temp/bootstrap/proxy/"]
      end
    end
    d.vm.provision "shell" do |s|
      s.path = "temp/bootstrap/ansible/install.sh"
      s.args = ["/vagrant/temp/bootstrap/ansible/"]
    end
    d.vm.provision :ansible_local do |ansible|
      ansible.inventory_path = ANSIBLE_HOSTS
      ansible.raw_arguments = ['-c', 'local']
      ansible.provisioning_path = "/vagrant/temp/ansible/"
      ansible.playbook = "host-packages.yml"
      ansible.limit = "all"
    end
    # --- END OF AUTO SETUP CONFIG ---
    
    # --- YOUR PLAYBOOK RUNS HERE ---
    # d.vm.provision :shell, inline: "ANSIBLE_NOCOWS=1 PYTHONUNBUFFERED=1 ansible-playbook /vagrant/ansible/my-application.yml -c local"

    d.vm.provider "virtualbox" do |v|
      v.name = APP_BOX_HOSTNAME
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
      v.memory = APP_BOX_MEM
    end
  end
  # ---------------------
  # --- DATABASE HOST ---
  config.vm.define DB_BOX_HOSTNAME do |d|
    d.vm.box = DB_BOX_NAME
    d.vm.hostname = DB_BOX_HOSTNAME
    d.vm.network "private_network", ip: DB_BOX_IP

    # --- STARTING AUTO SETUP CONFIG ---
    if ENV['VM_PROXY']
      d.vm.provision "shell" do |s|
        s.path = "temp/bootstrap/proxy/configure.sh"
        s.args = ["#{ENV['VM_PROXY']}", "#{ENV['VM_NO_PROXY_HOSTS']}", 
                  "#{ENV['VM_INTERNAL_CONNECTION_CHECK']}",
                  "/vagrant/temp/bootstrap/proxy/"]
      end
    end
    d.vm.provision "shell" do |s|
      s.path = "temp/bootstrap/ansible/install.sh"
      s.args = ["/vagrant/temp/bootstrap/ansible/"]
    end
    d.vm.provision :ansible_local do |ansible|
      ansible.inventory_path = ANSIBLE_HOSTS
      ansible.raw_arguments = ['-c', 'local']
      ansible.provisioning_path = "/vagrant/temp/ansible/"
      ansible.playbook = "host-packages.yml"
      ansible.limit = "all"
    end
    # --- END OF AUTO SETUP CONFIG ---
    
    # --- YOUR PLAYBOOK RUNS HERE ---
    # d.vm.provision :shell, inline: "ANSIBLE_NOCOWS=1 PYTHONUNBUFFERED=1 ansible-playbook /vagrant/ansible/my-application.yml -c local"

    d.vm.provider "virtualbox" do |v|
      v.name = DB_BOX_HOSTNAME
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
      v.memory = DB_BOX_MEM
    end
  end

  
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
    config.vbguest.no_install = true
    config.vbguest.no_remote = true
  end
end
