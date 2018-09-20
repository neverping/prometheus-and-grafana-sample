default['sinatra_home_dir'] = '/home/vagrant/sinatra'

default['prometheus'] = {
  "user_definition" => {
    "name" => "prometheus",
    "uid" => 1907,
    "gid" => 1907,
    "shell" => "/usr/sbin/nologin",
    "password" => "$1$xyz$2y45ZjJxPOH874GmBjP0p0"
  },
  "server" => {
    "version" => "2.4.1",
    "arch" => "linux-amd64",
    "var_dir" => "/var/lib/prometheus",
    "etc_dir" => "/etc/prometheus",
    "bin_dir" => "/usr/local/bin"
  },
  "mtail" => {
    "version" => "v3.0.0-rc10",
    "arch" => "linux_amd64",
    "bin_dir" => "/usr/local/bin",
    "etc_dir" => "/etc/mtail",
    "log_dir" => "/var/log/apache2/"
  },
  "node_exporter" => {
    "version" => "0.16.0",
    "arch" => "linux-amd64",
    "bin_dir" => "/usr/local/bin",
    "managed_nodes" => {
      "vickers" => "192.168.123.101",
      "shaw" => "192.168.123.102"
    }
  }
}

# Quick reference:
# LTS    CODENAME   DEBIAN
# 16.04  xenial     stretch
# 14.04  trusty     jessie

default['deb_repositories'] = {
  "grafana" => {
    "uri" => "https://packagecloud.io/grafana/stable/debian/",
    "components" => ['main'],
    "os_release" => "stretch", # Grafana uses Debian naming model
    "gpg_key" => "https://packagecloud.io/gpg.key"
  },
  "influxdb" =>  {
    "uri" => "https://repos.influxdata.com/ubuntu/",
    "components" => ['stable'],
    "os_release" => node['lsb']['codename'], # Influxdb uses Ubuntu nanimg model.
    "gpg_key"  => "https://repos.influxdata.com/influxdb.key"
  }
}
