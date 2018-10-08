# TO DO LIST

Here are a list of things I should / like to do:

## InfluxDB for Prometheus.
- Check if InfluxDB would be a better time series database solution for Prometheus rather than its own storage engine.

## Grafana should be under a webserver.
- We have to use Grafana directly over its HTTP service port. We should install nginx or Apache and proxying to it, so we can access Grafana using only the ip address without needing to type the default port.

## Sinatra exporting data to Prometheus.
- I think I could make Sinatra scrape data to Prometheus and plot a time series using the /metrics URL. We could also give other fake statistics to it like environment state on LV-223 or even fake telemetry from Prometheus ship and its crew.
