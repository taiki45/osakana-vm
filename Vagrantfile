# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'

config_file = File.expand_path("../config.yml", __FILE__)

if File.exist? config_file
  _conf = YAML.load_file(config_file)
else
  _conf = {}
end

Vagrant.configure("2") do |config|

  config.vm.box = "Debian_7.2"
  config.vm.box_url = "https://dl.dropboxusercontent.com/u/197673519/debian-7.2.0.box"

  unless _conf["private_ip_disable"]
    config.vm.network :private_network, ip: (_conf["private_ip"] || "192.168.33.11")
  end

  config.vm.provider :virtualbox do |vb|
    vb.name = _conf["vm_name"] if _conf["vm_name"]
    vb.customize ["modifyvm", :id, "--memory", (_conf["memory_size"] || "512")]
  end

  config.omnibus.chef_version = :latest
  config.berkshelf.enabled = true

  config.vm.provision :chef_solo do |chef|
    chef.run_list = %w(
      apt
      sqlite
      mysql::client
      mysql::server
      ruby_build
      rbenv::user
      timezone-ii
      vim
      screen::source
      zsh
      osakana
    )

    chef.json = {
      rbenv: {
        user_installs: [{
          user: "vagrant",
          rubies: ["2.0.0-p247"],
          global: "2.0.0-p247",
          gems: {
            "2.0.0-p247" => [
              {name: "rbenv-rehash"},
              {name: "bundler"},
              {name: "pry"},
              {name: "sinatra"}
            ]
          }
        }]
      },
      mysql: {
        server_root_password: (_conf["mysql_root_password"] || "password"),
        server_repl_password: (_conf["mysql_root_password"] || "password"),
        server_debian_password: (_conf["mysql_root_password"] || "password"),
        bind_address: "127.0.0.1",
      },
      tz: (_conf["time_zone"] || "Asia/Tokyo")
    }
  end
end
