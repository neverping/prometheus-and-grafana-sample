#
# Cookbook Name:: janek
# Recipe:: shaw
#
# Copyright 2018, Willian Braga da Silva
#
# All rights reserved - Do Not Redistribute
#

## Prometheus node setup
include_recipe "janek::default"
include_recipe "janek::node_exporter"

%w{ruby-sinatra-contrib ruby-sinatra nginx nginx-extras apache2}.each do |pkg|
  package pkg do
    action :install
  end
end

directory node['sinatra_home_dir'] do
  owner 'vagrant'
  group 'vagrant'
  mode '0755'
  action :create
end

execute "rsync_app" do
  user "vagrant"
  command "rsync -rlcp --inplace --delete /vagrant/sinatra/* #{node['sinatra_home_dir']}/"
end

# Mtail for collecting nginx logs.
mtail_release = "#{node['prometheus']['mtail']['version']}_#{node['prometheus']['mtail']['arch']}"

remote_file "/usr/src/mtail_#{mtail_release}" do
  source "https://github.com/google/mtail/releases/download/#{node['prometheus']['mtail']['version']}/mtail_#{mtail_release}"
  owner node['prometheus']['user_definition']['name']
  group node['prometheus']['user_definition']['name']
  mode '0755'
  action :create
end

link "#{node['prometheus']['mtail']['bin_dir']}/mtail" do
  to "/usr/src/mtail_#{mtail_release}"
end

directory node['prometheus']['mtail']['etc_dir'] do
  owner node['prometheus']['user_definition']['name']
  group node['prometheus']['user_definition']['name']
  mode '0755'
  action :create
end

template "#{node['prometheus']['mtail']['etc_dir']}/nginx.mtail" do
  source 'mtail/nginx.mtail.erb'
  owner node['prometheus']['user_definition']['name']
  group node['prometheus']['user_definition']['name']
  mode '0644'
end

template "#{node['prometheus']['mtail']['etc_dir']}/apache_common.mtail" do
  source 'mtail/apache_common.mtail.erb'
  owner node['prometheus']['user_definition']['name']
  group node['prometheus']['user_definition']['name']
  mode '0644'
end


## VHost

file '/etc/nginx/sites-enabled/default' do
  action :delete
  force_unlink true;
  only_if { File.exist? '/etc/nginx/sites-enabled/default' }
end

file '/etc/apache2/sites-enabled/000-default.conf' do
  action :delete
  force_unlink true;
  only_if { File.exist? '/etc/apache2/sites-enabled/000-default.conf' }
  notifies :run, 'bash[enable_apache2_modules]', :immediately
end

template '/etc/nginx/sites-enabled/vh-shaw.conf' do
  source 'webservers/nginx-vh-shaw.conf.erb'
  owner 'www-data'
  group 'www-data'
  mode '0644'
end

template '/etc/apache2/sites-enabled/vh-shaw.conf' do
  source 'webservers/apache2-vh-shaw.conf.erb'
  owner 'www-data'
  group 'www-data'
  mode '0644'
end

template '/lib/systemd/system/sinatra.service' do
  source 'ruby/sinatra.service.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(:sinatra_home_dir => node['sinatra_home_dir'])
  notifies :run, 'execute[systemd_daemon_reload]', :immediately
end

template '/lib/systemd/system/mtail.service' do
  source 'mtail/mtail.service.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(:bin_file => "#{node['prometheus']['mtail']['bin_dir']}/mtail",
    :log_dir => node['prometheus']['mtail']['log_dir'],
    :mtail_config_file => "#{node['prometheus']['mtail']['etc_dir']}/apache_common.mtail",
  )
  notifies :run, 'execute[systemd_daemon_reload]', :immediately
end

## Apache2 modules needs to be enabled by a shell command.
bash 'enable_apache2_modules' do
  cwd '/usr/src/'
  code <<-EOH
    sudo a2enmod proxy
    sudo a2enmod proxy_http
    sudo a2enmod proxy_balancer
    sudo a2enmod lbmethod_byrequests
    EOH
  action :nothing
end

# mtail is not working properly with nginx. Until I figure it out
# what could it be, I will disable nginx.
service 'nginx.service' do
  action [:disable, :stop]
  supports :restart => true, :reload => true
  subscribes :reload, "template[/etc/nginx/sites-enabled/vh-shaw.conf]", :immediately
end

service 'apache2.service' do
  action [:enable, :start]
  supports :restart => true, :reload => true
  subscribes :reload, "template[/etc/apache2/sites-enabled/vh-shaw.conf]", :immediately
end

service 'sinatra.service' do
  action [:enable, :start]
  subscribes :restart, "template[/lib/systemd/system/sinatra.service]", :delayed
  notifies :run, 'execute[systemd_daemon_reload]', :immediately
end

service 'mtail.service' do
  action [:enable, :start]
  subscribes :restart, "template[/lib/systemd/system/mtail.service]docker", :delayed
  notifies :run, 'execute[systemd_daemon_reload]', :immediately
end

# Althought we are using recent Chef versions and we could be using systemd_unit resource,
# this chef is keeping compatibility with Chef 12.10.24, which does not provide systemd_unit.
execute 'systemd_daemon_reload' do
  command 'systemctl daemon-reload'
  action :nothing
end
