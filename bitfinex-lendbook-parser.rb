#!/usr/bin/ruby

require 'rubygems'
require 'json'
require 'date'

json = JSON.parse($stdin.read)
best_ask = json["asks"][0]["rate"]
best_bid = json["bids"][0]["rate"]
unixtime = DateTime.now.strftime("%s")

file = ARGV[0]

File.open(file, 'a+', 0644) do |f|
  f.flock(File::LOCK_EX)
  f.write "#{unixtime} #{best_ask} #{best_bid}\n"
  f.flush
end

