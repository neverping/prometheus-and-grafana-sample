#
# Cookbook Name:: janek
# Recipe:: default
#
# Copyright 2018, Willian Braga da Silva
#
# All rights reserved - Do Not Redistribute
#

group node['prometheus']['user_definition']['name'] do
  gid     node['prometheus']['user_definition']['gid']
  action  :create
end

user node['prometheus']['user_definition']['name'] do
  comment 'Prometheus daemon'
  uid node['prometheus']['user_definition']['uid']
  gid node['prometheus']['user_definition']['gid']
  home node['prometheus']['var_dir']
  shell '/usr/sbin/nologin'
  password '$1$xyz$2y45ZjJxPOH874GmBjP0p0'
end
