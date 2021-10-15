Vagrant.configure("2") do |config|
  config.vm.box = "centos/8"


  MEM_SIZE = 2048 
  NUM_BUILD_SERVERS = 1 # Add more build servers by increasing this number

  #-----------------------------------------------------
  build_server_list = []

  (1..NUM_BUILD_SERVERS).each do |machine_id|
    machine_name = "buildserver#{machine_id}"
    build_server_list.append(machine_name)
    config.vm.define machine_name do |machine|

      machine.vm.hostname = machine_name
      machine.vm.network "private_network", ip: "10.22.66.#{100+machine_id}"

      machine.vm.provider "virtualbox" do |v|
        v.memory = "#{MEM_SIZE}"
        v.check_guest_additions = false
        v.cpus = 16
      end
    end
  end
  #-----------------------------------------------------

  #-----------------------------------------------------
  config.vm.define "buildclient" do |c|
    c.vm.host_name = "buildclient"
    c.vm.network "private_network", ip: "10.22.66.200"
    # https://www.vagrantup.com/docs/providers/virtualbox/configuration
    c.vm.provider "virtualbox" do |v|
      v.memory = "#{MEM_SIZE}"
      v.check_guest_additions = false
      v.cpus = 16
    end

    c.vm.synced_folder "src", "/home/vagrant/src", type: "nfs"

    # <<START ANSIBLE>>
    # Only execute the Ansible provisioner once,
    # when all the machines are up and ready.
    c.vm.provision :ansible do |ansible|
      ansible.limit = "all"
      ansible.playbook = "playbook.yml"
      ansible.groups = {
        "clients" => [ "buildclient" ],
        "buildservers" => build_server_list
      }
    end
    # <<END ANSIBLE>>

  end
  # -----------------------------------------------

end
