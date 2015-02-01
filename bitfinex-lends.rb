#!/usr/bin/ruby

require 'rubygems'
require 'json'
require 'date'
require 'pg'
require 'httparty'

c = PG.connect( dbname: 'divananalit' )
c.set_error_verbosity( PG::PQERRORS_VERBOSE )

c.prepare( 'last_timestamp', "SELECT timestamp FROM lends WHERE orderbook_id = (SELECT id FROM orderbooks WHERE exchange = 'bitfinex' AND pair = 'btcusd' LIMIT 1) ORDER BY timestamp DESC LIMIT 1;" )

c.prepare( 'check_if_lend_exist', "SELECT 1 FROM lends WHERE orderbook_id = (SELECT id FROM orderbooks WHERE exchange = 'bitfinex' AND pair = 'btcusd' LIMIT 1) AND timestamp = to_timestamp($1) AND rate = $2 AND amount = $3 LIMIT 1;" )

c.prepare( 'insert_lend', "INSERT INTO lends (orderbook_id, rate, amount, timestamp) VALUES ((SELECT id FROM orderbooks WHERE exchange = 'bitfinex' AND pair = 'btcusd' LIMIT 1), $1, $2, to_timestamp($3));" )

while true do

  timestamp = nil
  c.exec_prepared('last_timestamp') do |result|
    unless result.first.nil?
      timestamp = result.first['timestamp']
    end
  end

  response = HTTParty.get("https://api.bitfinex.com/v1/lends/btc", :query => {:timestamp => timestamp, :limit_lends => 9999})
  json = JSON.parse(response.body)

  json.each do |lend|
    timestamp = lend['timestamp'].to_f
    rate = lend['rate'].to_f
    amount = lend['amount_lent'].to_f
    c.exec_prepared( 'check_if_lend_exist', [timestamp, rate, amount] ) do |result|
      if result.first.nil?
        c.exec_prepared( 'insert_lend', [rate, amount, timestamp] )
      end
    end
  end

  sleep 10

end
