#!/usr/bin/ruby

require 'rubygems'
require 'json'
require 'date'
require 'pg'

EXCHANGE = 'bitfinex'
A_CURRENCY = 'BTC'
B_CURRENCY = 'USD'

json = JSON.parse($stdin.read)

c = PG.connect( dbname: 'divananalit' )
c.set_error_verbosity( PG::PQERRORS_VERBOSE )

c.exec( 'BEGIN' )

c.exec( 'SET TIME ZONE UTC' )

c.prepare 'insert_orderbook_update', %{
  INSERT INTO orderbook_updates (orderbook_id, created_at)
  VALUES (
    (SELECT id FROM orderbooks WHERE exchange_id = (
      SELECT id FROM exchanges WHERE name = '#{EXCHANGE}' LIMIT 1
    ) AND pair_id = (
      SELECT id FROM pairs WHERE a_currency_id = (
        SELECT id FROM currencies WHERE code = '#{A_CURRENCY}' LIMIT 1
      ) AND b_currency_id = (
        SELECT id FROM currencies WHERE code = '#{B_CURRENCY}' LIMIT 1
      )
    ) LIMIT 1), now()
  ) RETURNING id;
}
update_id = nil
c.exec_prepared( 'insert_orderbook_update' ) do |result|
  update_id = result.first['id']
end

orders = json["asks"]
orders.sort{|a,b|a["price"] <=> b["price"]}

orders_hashes = []
orders.each do |order|
  orders_hashes << {
    :amount => order["amount"].to_f,
    :timestamp => order["timestamp"].to_i,
    :price => order["price"].to_f
  }
end

c.prepare( 'insert_orderbook_record', "INSERT INTO orderbook_records (orderbook_update_id, bid, timestamp, price, amount) VALUES ($1, $2, to_timestamp($3), $4, $5);" )
orders_hashes.each do |order|
  c.exec_prepared( 'insert_orderbook_record', [update_id, false, order[:timestamp], order[:price], order[:amount]] )
end

orders = json["bids"]
orders.sort{|a,b|(a["price"] <=> b["price"]) * (-1)}

orders_hashes = []
orders.each do |order|
  orders_hashes << {
    :amount => order["amount"].to_f,
    :timestamp => order["timestamp"].to_i,
    :price => order["price"].to_f
  }
end

orders_hashes.each do |order|
  c.exec_prepared( 'insert_orderbook_record', [update_id, true, order[:timestamp], order[:price], order[:amount]] )
end

c.exec( 'COMMIT' )

