Vagrant.configure(2) do |config|
    config.vm.box = "box-cutter/ubuntu1410-docker"
    config.vm.provision "shell", path: "./provision.sh"

    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.aliases = %w(photoworld.local)

    config.vm.network "forwarded_port", guest: 80, host: 8079
    config.vm.network "private_network", ip: "192.168.32.10"

    config.vm.synced_folder "../PhotoWorld", "/var/www", type: "nfs"
end
