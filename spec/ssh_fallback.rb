require 'etc'
require 'tempfile'

def create_fallback_config_file(server) 

  config_file = Tempfile.new('', Dir.tmpdir)

  # Output from 'vagrant ssh-config $VAGRANT_HOST'
  ssh_parameters = {
    'User' => 'vagrant',
    'HostName' => '127.0.0.1',
    'UserKnownHostsFile' => '/dev/null',
    'StrictHostKeyChecking' => 'no',
    'PasswordAuthentication' => 'no',
    'IdentityFile' => "#{Etc.getpwuid.dir}/.vagrant.d/insecure_private_key",
    'IdentitiesOnly' => 'yes',
    'LogLevel' => 'FATAL'
  }

  # These values are declared in Vagranfile
  ssh_port = {'shaw' => '2232', 'vickers' => '2231'}

  ssh_parameters.each do |k, v|
     config_file.write("#{k} #{v}\n")
  end

  config_file.write("Port #{ssh_port[server]}\n")
  config_file.write("Host #{server}\n")
  config_file.close

  return config_file.path
end

create_fallback_config_file('shaw')
