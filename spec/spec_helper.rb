require 'serverspec'
require 'net/ssh'
require 'tempfile'
load 'spec/ssh_fallback.rb'

set :backend, :ssh

if ENV['ASK_SUDO_PASSWORD']
  begin
    require 'highline/import'
  rescue LoadError
    fail "highline is not available. Try installing it."
  end
  set :sudo_password, ask("Enter sudo password: ") { |q| q.echo = false }
else
  set :sudo_password, ENV['SUDO_PASSWORD']
end

host = ENV['TARGET_HOST']

## Vagrant was able to execute properly
if system('vagrant version > /dev/null 2>&1')
  `vagrant up #{host}`
  config = Tempfile.new('', Dir.tmpdir)
  config.write(`vagrant ssh-config #{host}`)
  config.close
  config_file = config.path
else
  # If you are using rbenv, it might break all vagrant commands
  # when executing ruby or other rbenv commands because it will
  # override systems gems, as Vagrant is a Ruby program outside
  # rbenv.
  config_file = create_fallback_config_file(host)
end

options = Net::SSH::Config.for(host, [config_file])

options[:user] ||= Etc.getlogin

set :host,        options[:host_name] || host
set :ssh_options, options

# Disable sudo
# set :disable_sudo, true


# Set environment variables
# set :env, :LANG => 'C', :LC_MESSAGES => 'C'

# Set PATH
# set :path, '/sbin:/usr/local/sbin:$PATH'
