# ACKNOWLEDGES

First of all, this repository was a personal test for my skills, as I wanted to prove to myself my knowledges for new technologies and try new approaches.

Within a month, I had to do coding, automation and a little bit of testing. What it was fascinating to me (and I hope it would be for you) was the fact most of these tools I've used I never tried before! Those are totally new to me, with the exception of Vagrant and my knowledge of automation (I do automation with Puppet) and testing (I use TDI - Test Driven Infrastructure). While I have some background with monitoring by using Grafana with Zabbix, I never in fact installed them. So doing from scratch was quite interesting.

I would like to list everything I've learned (not fully, though) in this one month of coding.

- Prometheus;
- Grafana;
- Ruby as a programming language rather than just scripting; 
- Chef with Librarian and FoodCritic;
- Rakefile;
- ServerSpec;
- Sinatra;
- Google mtail.

With no further delays, let's talk about what I did.

## Prometheus + Grafana monitoring system with a dummy app.

When I was thinking about Prometheus and Grafana, I was thinking not only about displaying the regular graphics as most of the examples are doing. I wish there were more good examples with Grafana integration and even with more dashboards.

And then I recall attending FOSDEM 2017 and FOSDEM 2018 and I remembered speakers were telling us that collecting bare host telemetry is not what we should be doing anymore in a cloud environment. We should start doing observability, which is how our applications are performing, about alerting when changes occurs. We should know when something is going wrong with the cloud itself rather than the node itself (which it still part of the monitoring, but we are talking about beyond that). How many Docker units are we using? How fast are the response time of each app? Those definitions were in my mind and then I think I should come to answer them in this test.

Right on the first day from this attempt, why did I choose Prometheus rather than Zabbix? Zabbix is still more a 'host' monitoring tool, and Prometheus is more a 'cloud' monitoring tool, discovering and scraping data from VMs, Docker units and services that can be created and destroyed quickly in a truly cloud environment. And then I felt the need to try Prometheus. And then I fired up the Prometheus Movie Soundtrack on Spotify and took a time reading Prometheus Documentation along with Grafana as well. Finally, Prometheus and Grafana has a good integration, so it looked I could do great usage integrating them.

In the beginning, I was thinking about which app I should monitor. I thought using Ruby on Rails would take so much time and bring complexity for what I wanted: A simple app that I could treat as a dummy API and I could run a simple Ruby client doing requests on it. And then I found out Sinatra. Unfortunately, I didn't find any good fake/test API's written in Sinatra, so I have to code it. And then I just build a fake app which reads/writes data over a file.

When building everything altogether, it took a very long time, almost three weeks. Most of the problem was figuring out how to configure Prometheus properly and understand its unique SQL format, the PromQL. Then I found out the 'play.grafana.org' playground and things became easier to me. Scraping data out of the nginx took me another time, so I have to switch to Apache where it was working properly. By this time, I took almost three weeks, so I have to make it even easily than I thought.

In conclusion, I was able to finish both approaches, surely some of them needs to be improved. On the other hand, both of them are mutable, stable and usable.
