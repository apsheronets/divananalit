#!/usr/bin/ruby

require 'rubygems'
require 'json'
require 'date'

json = JSON.parse($stdin.read)
best_ask = json["asks"].select{|x|x['frr'] != 'Yes'}[0]["rate"]
if json["bids"][0].nil?
  best_bid = 0
else
  best_bid = json["bids"].select{|x|x['frr'] != 'Yes'}[0]["rate"]
end
unixtime = DateTime.now.strftime("%s")

file = ARGV[0]

File.open(file, 'a+', 0644) do |f|
  f.flock(File::LOCK_EX)
  f.write "#{unixtime} #{best_ask} #{best_bid}\n"
  f.flush
end

