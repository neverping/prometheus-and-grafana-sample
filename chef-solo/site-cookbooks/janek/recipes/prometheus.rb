#
# Cookbook Name:: janek
# Recipe:: prometheus
#
# Copyright 2018, Willian Braga da Silva
#
# All rights reserved - Do Not Redistribute
#

dirs_to_create = [node['prometheus']['server']['var_dir'], node['prometheus']['server']['etc_dir']]
prometheus_release = "#{node['prometheus']['server']['version']}.#{node['prometheus']['server']['arch']}"

dirs_to_create.each do |dirs| 
  directory dirs do
    owner node['prometheus']['user_definition']['name']
    group node['prometheus']['user_definition']['name']
    mode '0755'
    action :create
  end
end

remote_file "/usr/src/prometheus-#{prometheus_release}.tar.gz" do
  source "https://github.com/prometheus/prometheus/releases/download/v#{node['prometheus']['server']['version']}/prometheus-#{prometheus_release}.tar.gz"
  owner node['prometheus']['user_definition']['name']
  group node['prometheus']['user_definition']['name']
  mode '0755'
  action :create
  notifies :run, 'bash[extract_prometheus]', :immediately
end

bash 'extract_prometheus' do
  cwd '/usr/src/'
  code <<-EOH
    tar xzf prometheus-#{prometheus_release}.tar.gz
    cd prometheus-#{prometheus_release}
    cp prometheus promtool #{node['prometheus']['server']['bin_dir']}
    rsync -rlcp --inplace --delete consoles #{node['prometheus']['server']['etc_dir']}
    rsync -rlcp --inplace --delete console_libraries #{node['prometheus']['server']['etc_dir']}
    EOH
  action :nothing
end


template "#{node['prometheus']['server']['etc_dir']}/prometheus.yml" do
  source 'prometheus/prometheus.yml.erb'
  owner node['prometheus']['user_definition']['name']
  group node['prometheus']['user_definition']['name']
  mode '0644'
  variables(managed_nodes: node['prometheus']['node_exporter']['managed_nodes'],
    mtail_on_shaw: node['prometheus']['node_exporter']['managed_nodes']['shaw'],
  )
end

template "#{node['prometheus']['server']['etc_dir']}/alert.rules" do
  source 'prometheus/alert.rules.erb'
  owner node['prometheus']['user_definition']['name']
  group node['prometheus']['user_definition']['name']
  mode '0644'
  notifies :reload, "service[prometheus]", :delayed
end

template '/lib/systemd/system/prometheus.service' do
  source 'prometheus/prometheus.service.erb'
  owner node['prometheus']['user_definition']['name']
  group node['prometheus']['user_definition']['name']
  mode '0644'      
  notifies :reload, "service[prometheus]", :delayed
  notifies :run, 'execute[systemd_daemon_reload]', :immediately
  variables(bin_dir: node['prometheus']['server']['bin_dir'],
    config_dir: node['prometheus']['server']['etc_dir'],
    var_dir: node['prometheus']['server']['var_dir'],
    user: node['prometheus']['user_definition']['name'],
  )
end

service 'prometheus' do
  action [:enable, :start]
  supports :reload => true
  subscribes :reload, "template[#{node['prometheus']['server']['etc_dir']}/prometheus.yml]", :delayed
  notifies :run, 'execute[systemd_daemon_reload]', :immediately
end

# Althought we are using recent Chef versions and we could be using systemd_unit resource,
# this chef is keeping compatibility with Chef 12.10.24, which does not provide systemd_unit.
execute 'systemd_daemon_reload' do
  command 'systemctl daemon-reload'
  action :nothing
end
