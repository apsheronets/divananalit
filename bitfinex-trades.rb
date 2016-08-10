#!/usr/bin/ruby

require 'rubygems'
require 'json'
require 'date'
require 'pg'
require 'httparty'

EXCHANGE = 'bitfinex'

pairs = [
  ['BTC', 'USD'],
  ['LTC', 'USD'],
  ['LTC', 'BTC'],
  ['ETH', 'USD'],
  ['ETH', 'BTC'],
  ['BFX', 'USD'],
]

c = PG.connect( dbname: 'divananalit' )
c.set_error_verbosity PG::PQERRORS_VERBOSE

c.exec 'SET TIME ZONE UTC'

c.prepare 'last_timestamp', %{
  SELECT extract (epoch from (timestamp)) AS timestamp
  FROM trades
  WHERE orderbook_id = (
    SELECT id FROM orderbooks WHERE exchange_id = (
      SELECT id FROM exchanges WHERE name = '#{EXCHANGE}' LIMIT 1
    ) AND pair_id = (
      SELECT id FROM pairs WHERE a_currency_id = (
        SELECT id FROM currencies WHERE code = $1 LIMIT 1
      ) AND b_currency_id = (
        SELECT id FROM currencies WHERE code = $2 LIMIT 1
      )
    ) LIMIT 1)
  ORDER BY trades.timestamp DESC
  LIMIT 1;
}

c.prepare 'check_if_trade_exist', %{
  SELECT 1
  FROM trades
  WHERE orderbook_id = (
    SELECT id FROM orderbooks WHERE exchange_id = (
      SELECT id FROM exchanges WHERE name = '#{EXCHANGE}' LIMIT 1
    ) AND pair_id = (
      SELECT id FROM pairs WHERE a_currency_id = (
        SELECT id FROM currencies WHERE code = $1 LIMIT 1
      ) AND b_currency_id = (
        SELECT id FROM currencies WHERE code = $2 LIMIT 1
      )
    ) LIMIT 1)
    AND tid = $3 LIMIT 1;
}

c.prepare 'insert_trade', %{
  INSERT INTO trades (
    orderbook_id,
    price,
    amount,
    buy,
    timestamp,
    tid
  ) VALUES (
    (SELECT id FROM orderbooks WHERE exchange_id = (
      SELECT id FROM exchanges WHERE name = '#{EXCHANGE}' LIMIT 1
    ) AND pair_id = (
      SELECT id FROM pairs WHERE a_currency_id = (
        SELECT id FROM currencies WHERE code = $1 LIMIT 1
      ) AND b_currency_id = (
        SELECT id FROM currencies WHERE code = $2 LIMIT 1
      )
    ) LIMIT 1),
    $3,
    $4,
    $5,
    to_timestamp($6),
    $7
  );
}

while true do

  pairs.each do |pair|

    a_currency = pair[0]
    b_currency = pair[1]

    timestamp = nil
    c.exec_prepared('last_timestamp', [a_currency, b_currency]) do |result|
      unless result.first.nil?
        timestamp = result.first['timestamp']
      end
    end

    pairstring = a_currency.downcase + b_currency.downcase
    response = HTTParty.get("https://api.bitfinex.com/v1/trades/#{pairstring}", :query => {:timestamp => timestamp})
    json = JSON.parse(response.body)

    c.exec 'BEGIN;'
    json.each do |trade|
      c.exec_prepared( 'check_if_trade_exist', [a_currency, b_currency, trade['tid']] ) do |result|
        if result.first.nil?
          price = trade['price'].to_f
          amount = trade['amount'].to_f
          buy = (case trade['type'] when 'buy' then true when 'sell' then false else 'NULL' end)
          timestamp = trade['timestamp'].to_i
          tid = trade['tid'].to_i
          c.exec_prepared( 'insert_trade', [a_currency, b_currency, price, amount, buy, timestamp, tid] )
        end
      end
    end
    c.exec 'COMMIT;'

    sleep 10

  end

end
