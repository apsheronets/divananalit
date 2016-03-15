#!/usr/bin/ruby

require 'rubygems'
require 'json'
require 'date'
require 'pg'

exchange = ARGV[0]
pair = ARGV[1]

c = PG.connect( dbname: 'divananalit' )
c.set_error_verbosity( PG::PQERRORS_VERBOSE )

c.prepare( 'insert_trade', "INSERT INTO trades (orderbook_id, price, amount, buy, timestamp, tid) VALUES ((SELECT id FROM orderbooks WHERE exchange = '#{exchange}' AND pair = '#{pair}' LIMIT 1), $1, $2, NULL, to_timestamp($3), NULL);" )

lines = $stdin.readlines
lines.each do |line|
  l = line.split(',')
  timestamp = l[0].to_i
  price = l[1].to_f
  amount = l[2].to_f
  c.exec_prepared( 'insert_trade', [price, amount, timestamp] )
end
