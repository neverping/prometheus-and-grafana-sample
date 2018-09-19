name             'janek'
maintainer       'Willian Braga da Silva'
maintainer_email 'neverping@gmail.com'
license          'Apache-2.0'
description      'Configures both Prometheus and Grafana on Vagrant'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
issues_url 'https://www.twitter.com/neverping' if respond_to?(:issues_url)
source_url 'https://github.com/neverping' if respond_to?(:source_url)
chef_version '>= 12.10.24' if respond_to?(:chef_version)
version          '0.1.0'

depends 'ruby_rbenv'
supports 'ubuntu'
