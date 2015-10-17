# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'fileutils'

#require '../common_scripts/jenkins_env.rb'
#require '../common_scripts/process_vm_cfg.rb'

#if ARGV.first == 'up'
#  system('rm -rf vagrant/puppet')
#  puts 'vagrant/puppet does not exist - so getting it....'
#  system("cd vagrant; git clone --depth=1 --branch=#{$git_puppet_branch} #{$git_puppet_url} ; cd puppet; git remote set-url --push origin nopush")
#  create_local_yaml()
#end

#
# def provision(my_vm, tags)
#   my_vm.vm.provision :puppet do |puppet|
#     puppet.module_path = 'vagrant/puppet/modules'
#     puppet.manifests_path = 'vagrant/manifests'
#     puppet.manifest_file = 'basebox.pp'
#     puppet.options = "--no-noop #{tags}"
#     puppet.facter = {
#         'mykeystore' => $radiosite_hostname,
#         'operatingsystem' => 'debian',
#         'we7_environment' => 'vagrant'
#         #          'radiosite_http_port'  =>  $radiosite_http_port,
#         #          'radiosite_https_port' =>  $radiosite_https_port,
#         #          'api_http_port'        =>  $api_http_port,
#         #          'api_https_port'       =>  $api_https_port,
#     }
#   end
# end


def port_forwards(my_vm, offset)
  radio_site = 8180+offset
  radio_site_sec = 8543+offset
  api = 8080+offset
  api_sec = 8443+offset
  database = 5432+offset
  rec = 2082+offset
  solr = 8880+offset
  memcache = 11212+offset
  my_vm.vm.network "forwarded_port", :guest=> radio_site,     :host=> radio_site
  my_vm.vm.network "forwarded_port", :guest=> radio_site_sec, :host=> radio_site_sec
  my_vm.vm.network "forwarded_port", :guest=> api,            :host=> api
  my_vm.vm.network "forwarded_port", :guest=> api_sec,        :host=> api_sec
  my_vm.vm.network "forwarded_port", :guest=> database,       :host=> database
  my_vm.vm.network "forwarded_port", :guest=> rec,            :host=> rec
  my_vm.vm.network "forwarded_port", :guest=> solr,           :host=> solr
  my_vm.vm.network "forwarded_port", :guest=> memcache,       :host=> memcache
end

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|


  # Try to use installed box "wheezy64", or download and install it from the given URL
  # This URL is configured in vagrant.props
  config.vm.box = 'box-cutter/ubuntu1404-docker'

#  config.vm.box = 'lxc-raring-amd64-2013-07-12.box'
#  config.vm.box_url = 'http://dl.dropbox.com/u/13510779/lxc-raring-amd64-2013-07-12.box'

  # Use NAT networking, setting the VM hostname to the value defined in vagrant.props
  config.vm.hostname = 'dockerVM'
  vboxname = 'dockerVMbox'

  config.vm.define vboxname do |my_vm|

    my_vm.vm.provider 'virtualbox' do |v|
      # Allow the option of using the VirtualBox GUI
      if $vagrant_virtualbox_gui == true
        v.gui = true
      end
      # The DNS when using VirtualBox by default is dog slow - this fixes it
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]

      v.customize ['modifyvm', :id, '--nictype1', 'virtio']

      # This part must only be done the first time when the VM is created
      # So use the id file as a guide
      id_path = ".vagrant/machines/#{vboxname}/virtualbox/id"
      unless File.file?(id_path)
#        v.customize ['modifyvm', :id, '--unplugcpu', '3']
#        v.customize ['modifyvm', :id, '--unplugcpu', '2']
        v.customize ['modifyvm', :id, '--cpus', '4']
      end

      v.customize ['modifyvm', :id, '--memory', '6048']
    end

    port_forwards(my_vm, 1)

# Set the Timezone to something useful

    my_vm.vm.provision 'shell',
                       :inline => 'echo "Europe/London" | sudo tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata'

    my_vm.vm.provision 'shell', :inline => 'sudo /usr/bin/apt-get -yqq update;'
    my_vm.vm.provision 'shell', :inline => 'sudo /usr/bin/apt-get -yqq upgrade;'

    my_vm.vm.provision 'shell', :inline => 'sudo /usr/bin/apt-get -yqq install dialog;'

    my_vm.vm.provision 'shell', :inline => 'sudo /usr/bin/apt-get -yqq default-jre;'


#     my_vm.vm.provision 'shell',
#                        :inline => 'echo "Europe/London" | sudo tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata'
#
#
#
#     provision(my_vm, '--tags sdkfjhskdfjh') # updates pluggins
#     provision(my_vm, '--tags repository')   # updates repos
# # Now we have all the repositories it is time to apt-get update
#     my_vm.vm.provision 'shell', :inline => 'sudo /usr/bin/apt-get update;'
#     provision(my_vm, '') # actually gets everything
#
#
#
#     my_vm.vm.provision 'shell',
#                        inline: "if [ `psql -lqtU postgres | cut -d '|' -f 1 | grep -w podsplice | wc -l` -eq 0 ]; then createdb -U postgres podsplice; fi; if [ `psql -lqtU postgres | cut -d '|' -f 1 | grep -w testpodsplice | wc -l` -eq 0 ]; then createdb -U postgres testpodsplice; fi ; if [ `psql -lqtU recommends | cut -d '|' -f 1 | grep -w recommends | wc -l` -eq 0 ]; then createdb -U postgres recommends; fi; true"
#
#     my_vm.vm.provision 'shell',
#                        inline: 'sudo cp /vagrant/vagrant/.keystore   /var/lib/tomcat7/.keystore;sudo chown root:root   /var/lib/tomcat7/.keystore;sudo chmod 644 /var/lib/tomcat7/.keystore'

  end
end
