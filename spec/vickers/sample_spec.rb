require 'spec_helper'

%w{ruby2.3 grafana influxdb}.each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

%w{grafana-server.service prometheus.service node_exporter.service client_in_loop.service}.each do |services|
  describe service(services) do
    it { should be_enabled }
    it { should be_running }
  end
end

# 8086/8088 - InfluxDB
# 3000 - Grafana
# 9090 - Prometheus
# 9100 - Prometheus node exporter.
%w{8088 8086 3000 9090 9100}.each do |ports|
  describe port(ports) do
    it { should be_listening }
  end
end

describe file('/home/vagrant/sinatra/client_in_loop.rb') do
  it { should exist }
  it { should be_owned_by 'vagrant' }
end

%w{grafana influxdb prometheus}.each do |user_and_group|
  describe group(user_and_group) do
    it { should exist }
  end
  describe group(user_and_group) do
    it { should exist }
  end
end

%w{alert.rules prometheus.yml}.each do |prometheus_files|
  describe file("/etc/prometheus/#{prometheus_files}") do
    it { should exist }
    it { should be_owned_by 'prometheus' }
  end
end

# Vickers needs Shaw.
# 3093 - mtail
# 9100 - Prometheus node exporter
describe host('192.168.123.102') do
  # ping
  it { should be_reachable }
  # Services
  it { should be_reachable.with( :port => 9100, :proto => 'tcp', :timeout => 5 ) }
  it { should be_reachable.with( :port => 3093, :proto => 'tcp', :timeout => 5 ) }
end
