# INSTRUCTIONS

Below are the instructions of how to setup this project in your computer.

### Ensure you have rvm (or rbenv) and bundler installed and configured.

The RVM install procedure can be found here:

`https://rvm.io/rvm/install`

If you don't like rvm, you can use rbenv as your Ruby environment manager. Check this post below:

`https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-18-04`

After that, you can install bundler using the following command:

`gem install bundler`

Finally, you need to install all the gems used for this project. You can do this by executing the following command:

`bundle install`

### Ensure you are using Vagrant 2.0.2 or newer.

This Vagrantifle was configured with Vagrant 2.0.2 or above and it uses 2.x Vagrantfile syntax. This won't work with older Vagrant versions such as Vagrant 1.8.

You can download Vagrant here:

`https://www.vagrantup.com/`

On Ubuntu machines, you can execute:

`sudo apt-get install vagrant`

### Ensure you are using Oracle VirtualBox

All the testing was done using Virtualbox. The tested version was 5.2.10. You can download it over here:

`https://www.virtualbox.org/`

On Ubuntu machines, you can execute:

`sudo apt-get install virtualbox`

### Internet connection

Vagrant will need to download the Xenial Xerus (Ubuntu 16.04 LTS) box and Chef will request additional packages as well. You will need a good internet connection for these requirements.

### Presenting the Guest Virtual Machines.

For this assignment, we have two VM's: 

#### Shaw

Shaw is our app server, which is running Apache HTTP Server 2.4, Node Expoter 0.16.0 and a dummy app on Sinatra. All the Apache data is being collected by Google mtail for Prometheus
 server, which is being requested by Vickers.

Shaw name came from Elizabeth Shaw, a character from Prometheus movie. She was an archaeologist who visited LV-223 moon and was in a expedition to find out the homeworld of the Engineers.

<img src="http://www.roney.com.br/wp-content/uploads/2012/07/noomi-rapace-prometheus.jpg" alt="Noomi Rapace" width="600">

Her IP address is `192.168.123.101`

#### Vickers

Vickers is our monitoring server, which is running Prometheus 2.4.1, Node Exporter 0.16.0 and Grafana 5.2.4, both on their latest stable version. Vickers is also running a Prometheus Node Exporter to collect data from our own server. Finally, Vickers is running a Ruby script in a 'while true' loop requesting data to Shaw.

Vickers name came from Meredith Vickers, a character from Prometheus movie. Daughter of Peter Weyland, responsible for the Prometheus voyage into LV-223 moon.

<img src="https://virtualborderland.files.wordpress.com/2012/06/meredith-vickers.jpg" alt="Charlize Theron" width="600">

Her IP address is `192.168.123.102`

### Running the Guest Virtual Machines

Simply, just run the following command. It's important shaw became the first VM to be configured, because Vickers needs her data.

`$ vagrant up shaw vickers`

### Monitoring and checking the results

You can check the monitoring using Grafana by typing the following address in your preferred browser:

`http://192.168.123.101:3000`

Below are the credentials

```bash
login: admin
password: admin
```

After when you logged in, you have to add two custom dashboards to display our custom metrics.

### Adding the custom dashboards

On the left bar, click on the configuration icon `(Gear icon)` and then select ` Data Sources`.

Click on `Prometheus` and then on `Dashboards`.

You will see a list of the default dashboards. Two of them were customized by me. Click on `import` so you can use them. Here are their names:

- Apache Dashboard
- Prometheus - Dashboard 

After that, click on the four squares icon `(Dashboard icon)` and select `home`.

On the top left, at the right side of the Grafana logo, click on `home` and select `Apache dashboard` or `Prometheus - Demo dashboard`.

Below are the information for each dashboards.

#### Apache Dashboard

Apache Dashboad is collecting data from our Sinatra app over Apache using Google mTail. You have a filter called "User" which is the name of the crew members from Prometheus ship whom explored the underground cave on LV-223 moon. Each user is, in reality, an User Agent string from our Ruby while true loop script. You can change which user you want to view and explore the individual metrics for each crew member.

#### Prometheus - Dashboard

Here you can check both Shaw and Vickers status. You can switch from each server at the top left combo box. You can see the most well know data usually being monitored. All these datas came from Prometheus Node Explorer installed on each Guest VM.

### Testing.

You can use 'rake' to run 'serverspec' test suite. It will check if everything is ok.

```bash
rake spec:shaw     # Run serverspec tests to shaw
rake spec:vickers  # Run serverspec tests to vickers
```

The test can only be run after a full Guest VM installation.
