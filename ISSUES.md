# ISSUES

Here we will describe a list of issues you might encounter when running this example.

## NETWORK SPEED
Some artifacts are being downloaded outside from a Ubuntu mirror, such as Prometheus, Node Explorer (Prometheus node extractor), mtail (logging extractor for Prometheus) and they all are being downloaded straight from Github or AWS infrastructure. I've found out they can be slow sometimes, with download speed of 40kbp/s or 6kbp/s. I've managed to tune the VM to achieve faster download speeds, but expect the download speed be capped at this rate. This could make the initial provisioning speed under in 10 minutes for both Vickers and Shaw VMs.
