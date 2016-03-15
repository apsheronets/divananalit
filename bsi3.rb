require 'rubygems'
require 'mechanize'
require 'pg'
require 'bigdecimal'

def get_umf_list_from_bfxdata(symbol)

  agent = Mechanize.new do |agent|
    agent.history.max_size = 1
    agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end

  url = 'https://bfxdata.com/json/totalLendsAmount' + symbol.to_s.upcase + 'Month.json'

  JSON.parse(agent.get(url).body)

end

def assoc_list_to_hash(list)

  h = Hash.new

  list.each do |e|
    h[e[0].to_i / 1000] = e[1]
  end

  return h

end

long_currency = :usd
#short_currencies = [:btc, :ltc]
short_currencies = [:btc]

h = Hash.new

short_currencies.each do |short_currency|
  h[short_currency] = assoc_list_to_hash(get_umf_list_from_bfxdata(short_currency))
end

c = PG.connect( dbname: 'divananalit' )
c.set_error_verbosity( PG::PQERRORS_VERBOSE )

c.exec( 'SET TIME ZONE UTC' )

#c.prepare('last_price', %{
#  SELECT price FROM trades
#  WHERE trades.orderbook_id = (SELECT id FROM orderbooks WHERE pair = 'btcusd' AND exchange = 'bitfinex')
#    AND trades.timestamp <= to_timestamp($1)
#  ORDER BY trades.timestamp DESC LIMIT 1
#})

c.prepare('last_price', %{
  SELECT sum(price * amount) / sum(amount) AS price FROM trades
  WHERE trades.orderbook_id = (SELECT id FROM orderbooks WHERE pair = 'btcusd' AND exchange = 'bitfinex')
    AND trades.timestamp <= to_timestamp($1)
    AND trades.timestamp >= to_timestamp($1) - interval '3 days'
})

get_umf_list_from_bfxdata(long_currency).each do |long_currency_point|

  time = long_currency_point[0].to_i / 1000
  long_umf = long_currency_point[1]
  short_umf = short_currencies.map do |short_currency|
    short_umf = h[short_currency][time].to_f
    if short_umf.nil?
      0
    else
      price = nil
      c.exec_prepared('last_price', [time]) do |result|
        unless result.first.nil?
          price = result.first['price']
        end
      end

      if price.nil?
        STDERR.puts "zero for #{time}"
        0
      else
        short_umf * price.to_f
      end
    end
  end.reduce(0){|acc,x|x+acc}

  # FIXME
  if short_umf > 0
    printf "%i %f %f\n", time, ((long_umf / (long_umf + short_umf)) * 100.0), (long_umf + short_umf)
  end

  #puts Time.at(time)
  #puts ((long_umf / (long_umf + short_umf)) * 100.0)
  #printf "%s %f\n", Time.at(time), ((long_umf / (long_umf + short_umf)) * 100.0)

end

