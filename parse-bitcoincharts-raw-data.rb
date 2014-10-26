#!/usr/bin/ruby

require 'rubygems'
require 'json'
require 'date'

json = JSON.parse($stdin.read)

json.each do |day|
  timestamp = day[0]
  open  = day[1]
  high  = day[2]
  low   = day[3]
  close = day[4]
  volume_btc = day[5]
  volume_currency = day[6]
  weighted_price = day[7]
  line = [timestamp, low, high, open, close, volume_btc, volume_currency, weighted_price]
  # clear bitcoincharts madness
  line = line.map{|x|x == 1.7e+308 ? 'NaN' : x}
  puts line.join(' ')
end

