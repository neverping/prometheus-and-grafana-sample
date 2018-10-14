require 'spec_helper'

%w{ruby-sinatra-contrib ruby-sinatra nginx nginx-extras apache2}.each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

# TODO: make nginx work with mtail and disable apache.
%w{node_exporter.service mtail.service sinatra.service apache2.service}.each do |services|
  describe service(services) do
    it { should be_enabled }
    it { should be_running }
  end
end

describe command('apachectl -M') do
  #NOTE: I thought about looping it, but it would execute this command 4 times.
  its(:stdout) { should contain('proxy_module') }
  its(:stdout) { should contain('proxy_balancer_module') }
  its(:stdout) { should contain('proxy_http_module') }
  its(:stdout) { should contain('lbmethod_byrequests_module') }
end

# 80 - webserver (nginx or apache)
# 3093 - mtail
# 8888 - Sinatra
# 9100 - Prometheus node exporter.
%w{80 3093 8888 9100}.each do |ports|
  describe port(ports) do
    it { should be_listening }
  end
end

%w{config.ru shaw.rb}.each do |sinatra_files|
  describe file("/home/vagrant/sinatra/#{sinatra_files}") do
    it { should exist }
    it { should be_owned_by 'vagrant' }
  end
end

%w{apache_common.mtail nginx.mtail}.each do |mtail_files|
  describe file("/etc/mtail/#{mtail_files}") do
    it { should exist }
    it { should be_owned_by 'prometheus' }
  end
end

describe file('/etc/nginx/sites-enabled/vh-shaw.conf') do
  it { should exist }
  it { should be_owned_by 'www-data' }
end

describe file('/etc/apache2/sites-enabled/vh-shaw.conf') do
  it { should exist } 
  it { should be_owned_by 'www-data' }
end


# Vickers needs Shaw.
# 80 - apache or nginx.
# 3093 - mtail
# 9100 - Prometheus node exporter
describe host('192.168.123.102') do
  # ping
  it { should be_reachable }
  # Services
  it { should be_reachable.with( :port => 9100, :proto => 'tcp', :timeout => 5 ) }
  it { should be_reachable.with( :port => 3093, :proto => 'tcp', :timeout => 5 ) }
  it { should be_reachable.with( :port => 80, :proto => 'tcp', :timeout => 5 ) }
end
