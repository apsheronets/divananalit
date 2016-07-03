#!/usr/bin/ruby

require 'rubygems'
require 'json'
require 'date'
require 'pg'
require 'httparty'

EXCHANGE = 'localbitcoins'
A_CURRENCY = 'BTC'
B_CURRENCY = 'RUR'

c = PG.connect( dbname: 'divananalit' )
c.set_error_verbosity PG::PQERRORS_VERBOSE

c.exec 'SET TIME ZONE UTC'

# I have to much of free time
c.exec %{
  INSERT INTO exchanges (name)
  SELECT '#{EXCHANGE}'
  WHERE NOT EXISTS (SELECT 1 FROM exchanges WHERE name = '#{EXCHANGE}')
}

c.exec %{

BEGIN;

  INSERT INTO currencies (code, name)
  SELECT 'RUR', 'Russian Ruble'
  WHERE NOT EXISTS (SELECT 1 FROM currencies WHERE code = 'RUR');

  INSERT INTO pairs (a_currency_id, b_currency_id)
  SELECT
    (SELECT id FROM currencies WHERE code = '#{A_CURRENCY}' LIMIT 1),
    (SELECT id FROM currencies WHERE code = '#{B_CURRENCY}' LIMIT 1)
  WHERE NOT EXISTS (
    SELECT 1
    FROM pairs
    WHERE a_currency_id = (SELECT id FROM currencies WHERE code = '#{A_CURRENCY}' LIMIT 1)
      AND b_currency_id = (SELECT id FROM currencies WHERE code = '#{B_CURRENCY}' LIMIT 1)
  );

  INSERT INTO orderbooks (exchange_id, pair_id)
  SELECT
    (SELECT id FROM exchanges WHERE name = '#{EXCHANGE}' LIMIT 1),
    (SELECT id FROM pairs
    WHERE a_currency_id = (
      SELECT id FROM currencies WHERE code = '#{A_CURRENCY}' LIMIT 1
    ) AND b_currency_id = (
      SELECT id FROM currencies WHERE code = '#{B_CURRENCY}' LIMIT 1
    ) LIMIT 1)
  WHERE NOT EXISTS (
    SELECT 1
    FROM orderbooks
    WHERE exchange_id = (SELECT id FROM exchanges WHERE name = '#{EXCHANGE}' LIMIT 1)
      AND pair_id =
        (SELECT id FROM pairs
        WHERE a_currency_id = (
          SELECT id FROM currencies WHERE code = '#{A_CURRENCY}' LIMIT 1
        ) AND b_currency_id = (
          SELECT id FROM currencies WHERE code = '#{B_CURRENCY}' LIMIT 1
        ) LIMIT 1)
  );

COMMIT;

}

c.prepare 'last_tid', %{
  SELECT tid
  FROM trades
  WHERE orderbook_id = (
    SELECT id FROM orderbooks WHERE exchange_id = (
      SELECT id FROM exchanges WHERE name = '#{EXCHANGE}' LIMIT 1
    ) AND pair_id = (
      SELECT id FROM pairs WHERE a_currency_id = (
        SELECT id FROM currencies WHERE code = '#{A_CURRENCY}' LIMIT 1
      ) AND b_currency_id = (
        SELECT id FROM currencies WHERE code = '#{B_CURRENCY}' LIMIT 1
      )
    ) LIMIT 1)
  ORDER BY trades.tid DESC
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
        SELECT id FROM currencies WHERE code = '#{A_CURRENCY}' LIMIT 1
      ) AND b_currency_id = (
        SELECT id FROM currencies WHERE code = '#{B_CURRENCY}' LIMIT 1
      )
    ) LIMIT 1)
    AND tid = $1 LIMIT 1;
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
        SELECT id FROM currencies WHERE code = '#{A_CURRENCY}' LIMIT 1
      ) AND b_currency_id = (
        SELECT id FROM currencies WHERE code = '#{B_CURRENCY}' LIMIT 1
      )
    ) LIMIT 1),
    $1,
    $2,
    $3,
    to_timestamp($4),
    $5
  );
}

while true do

  tid = 0
  c.exec_prepared('last_tid') do |result|
    unless result.first.nil?
      tid = result.first['tid']
    end
  end

  #puts tid

  response = HTTParty.get("https://localbitcoins.com/bitcoincharts/RUB/trades.json", :query => {:since => tid})
  json = JSON.parse(response.body)

  c.exec 'BEGIN;'
  json.each do |trade|
    c.exec_prepared( 'check_if_trade_exist', [trade['tid']] ) do |result|
      if result.first.nil?
        price = trade['price'].to_f
        amount = trade['amount'].to_f
        buy = (case trade['type'] when 'buy' then true when 'sell' then false else nil end)
        timestamp = trade['date'].to_i
        tid = trade['tid'].to_i
        c.exec_prepared( 'insert_trade', [price, amount, buy, timestamp, tid] )
      end
    end
  end
  c.exec 'COMMIT;'

  sleep 30

end
