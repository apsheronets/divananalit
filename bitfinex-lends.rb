#!/usr/bin/ruby

require 'rubygems'
require 'json'
require 'date'
require 'pg'
require 'httparty'

c = PG.connect( dbname: 'divananalit' )
c.set_error_verbosity( PG::PQERRORS_VERBOSE )

c.exec( 'SET TIME ZONE UTC' )

c.prepare( 'last_timestamp', "SELECT extract (epoch from (timestamp)) AS timestamp FROM lends WHERE currency = $1 AND exchange = 'bitfinex' ORDER BY timestamp DESC LIMIT 1;" )

c.prepare( 'check_if_lend_exist', "SELECT 1 FROM lends WHERE currency = $1 AND exchange = 'bitfinex' AND timestamp = to_timestamp($2) AND rate = $3 AND amount = $4 LIMIT 1;" )

c.prepare( 'insert_lend', "INSERT INTO lends (currency, exchange, rate, amount, timestamp) VALUES ($1, 'bitfinex', $2, $3, to_timestamp($4));" )

while true do
  ['btc', 'usd', 'ltc'].each do |currency|

    timestamp = nil
    c.exec_prepared('last_timestamp', [currency]) do |result|
      unless result.first.nil?
        timestamp = result.first['timestamp']
      end
    end

    response = HTTParty.get("https://api.bitfinex.com/v1/lends/#{currency}", :query => {:timestamp => timestamp, :limit_lends => 9999})
    json = JSON.parse(response.body)

    json.each do |lend|
      timestamp = lend['timestamp'].to_f
      rate = lend['rate'].to_f
      amount = lend['amount_lent'].to_f
      c.exec_prepared( 'check_if_lend_exist', [currency, timestamp, rate, amount] ) do |result|
        if result.first.nil?
          c.exec_prepared( 'insert_lend', [currency, rate, amount, timestamp] )
        end
      end
    end

    sleep 10
  end
end
