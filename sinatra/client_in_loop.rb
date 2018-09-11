#!/usr/bin/env ruby
require 'net/http'

url = 'http://192.168.123.102/findings/'
items = ['bottle', 'egg', 'statue', 'vase', 'coffin']
methods = ['PUT','DELETE','GET']
characters = ['Fifield','Holloway','David','Millburn','Weyland']

while true
  uri = URI.parse(url + items.sample)

  method_type = methods.sample
  who_is_sending = characters.sample

#  puts "Sending #{method_type} #{uri.request_uri} to #{uri.host}:#{uri.port} found by #{who_is_sending}"
  Net::HTTP.start(uri.host, uri.port) do |http|
    headers = {'Content-Type' => 'text/plain; charset=utf-8', 'User-Agent' => who_is_sending}
    put_data = "we_dont_need_a_body_for_this_app"
    response = http.send_request(method_type, uri.request_uri, put_data, headers)
#    puts "Response #{response.code} #{response.message}: #{response.body}"
  end
end
