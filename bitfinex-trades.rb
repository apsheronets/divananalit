#!/usr/bin/ruby

require 'rubygems'
require 'json'
require 'date'
require 'pg'
require 'httparty'

c = PG.connect( dbname: 'divananalit' )
c.set_error_verbosity( PG::PQERRORS_VERBOSE )

c.exec( 'SET TIME ZONE UTC' )

c.prepare( 'last_timestamp', "SELECT extract (epoch from (timestamp)) AS timestamp FROM trades WHERE orderbook_id = (SELECT id FROM orderbooks WHERE exchange = 'bitfinex' AND pair = 'btcusd' LIMIT 1) ORDER BY trades.timestamp DESC LIMIT 1;" )

c.prepare( 'check_if_trade_exist', "SELECT 1 FROM trades WHERE orderbook_id = (SELECT id FROM orderbooks WHERE exchange = 'bitfinex' AND pair = 'btcusd' LIMIT 1) AND tid = $1 LIMIT 1;" )

c.prepare( 'insert_trade', "INSERT INTO trades (orderbook_id, price, amount, buy, timestamp, tid) VALUES ((SELECT id FROM orderbooks WHERE exchange = 'bitfinex' AND pair = 'btcusd' LIMIT 1), $1, $2, $3, to_timestamp($4), $5);" )

while true do

  timestamp = nil
  c.exec_prepared('last_timestamp') do |result|
    unless result.first.nil?
      timestamp = result.first['timestamp']
    end
  end

  response = HTTParty.get("https://api.bitfinex.com/v1/trades/btcusd", :query => {:timestamp => timestamp})
  json = JSON.parse(response.body)

  json.each do |trade|
    c.exec_prepared( 'check_if_trade_exist', [trade['tid']] ) do |result|
      if result.first.nil?
        price = trade['price'].to_f
        amount = trade['amount'].to_f
        buy = (case trade['type'] when 'buy' then true when 'sell' then false else 'NULL' end)
        timestamp = trade['timestamp'].to_i
        tid = trade['tid'].to_i
        c.exec_prepared( 'insert_trade', [price, amount, buy, timestamp, tid] )
      end
    end
  end

  sleep 5

end
