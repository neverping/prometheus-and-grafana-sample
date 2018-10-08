#
# Cookbook Name:: janek
# Recipe:: vickers
#
# Copyright 2018, Willian Braga da Silva
#
# All rights reserved - Do Not Redistribute
#

node['deb_repositories'].each do |deb,properties|
  apt_repository deb do
    uri          properties['uri']
    distribution properties['os_release']
    components   properties['components']
    key          properties['gpg_key']
  end
end

%w{ruby2.3 grafana influxdb}.each do |pkg|
  package pkg do
    action :install
  end
end

include_recipe "janek::default"
include_recipe "janek::prometheus"
include_recipe "janek::node_exporter"

template '/usr/share/grafana/public/app/plugins/datasource/prometheus/plugin.json' do
  source 'grafana/grafana-plugin.json.erb'
  mode '0644'
  owner 'root'
  group 'root'
end

%w{apache_dashboard.json prometheus_dashboard.json}.each do |jsons|
  template "/usr/share/grafana/public/app/plugins/datasource/prometheus/dashboards/#{jsons}" do
    source "grafana/#{jsons}.erb"
    mode '0644'
    owner 'root'
    group 'root'
  end
end

service 'grafana-server.service' do
  action [:enable, :start]
  supports :restart => true, :reload => true
end

file '/var/lib/grafana/do_not_modify_me.txt' do
   content 'Do not delete this file because it controls wether we need to create Prometheus datasource in Grafana or not'
   mode '0400'
   owner 'root'
   notifies :post, 'http_request[creating_prometheus_datasource]', :immediately
end

http_request 'creating_prometheus_datasource' do
  action :nothing
  url 'http://localhost:3000/api/datasources'
  message ({:name => 'Prometheus',
    :type => 'prometheus',
    :url => 'http://localhost:9090',
    :access => 'proxy',
    :basicAuth => false,
    :isDefault => true,
  }.to_json)
  headers({'AUTHORIZATION' => "Basic #{Base64.encode64('admin:admin')}",
    'Content-Type' => 'application/json;charset=UTF-8'
  })
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

template '/lib/systemd/system/client_in_loop.service' do
  source 'ruby/client_in_loop.service.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(:sinatra_home_dir => node['sinatra_home_dir'])
end

service 'client_in_loop.service' do
  action [:enable, :start]
end

service 'influxdb.service' do
  action [:enable, :start]
end
