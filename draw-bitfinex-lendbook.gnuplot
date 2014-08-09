#! /usr/bin/gnuplot -persist

set ylabel "% per day"
#set y2label 'Bitfinex BTCUSD'

#set y2tics

set xdata time
set timefmt "%s"

set format x "%d.%m.%y"

set grid x y
set key out bottom center

set terminal pngcairo transparent enhanced font "Helvetica,10" size 900, 600

set autoscale x
set autoscale y
unset xrange
set output 'img/bitfinex-lendbook-usd-all-time.png'

bitfinex_percent(x) = x / 365

plot \
  'data/bitfinex-lendbook-usd.dat' using 1:(bitfinex_percent($2)) with lines title 'best swap ask for USD' linetype 1, \
  'data/bitfinex-lendbook-usd.dat' using 1:(bitfinex_percent($3)) with lines title 'best swap bid for USD' linetype 2
#  'data/bitfinex-btc-usd-trades.dat' using 1:2 with lines title 'Bitfinex BTCUSD' axes x1y2 linetype 3, \

now = `date +%s`
one_day_past = now - 86400
eval(sprintf('set xrange ["%d":]', one_day_past))
unset yrange
set format x "%H:%M"
set output 'img/bitfinex-lendbook-usd-last-day.png'
replot

set format x "%d.%m.%y"

unset y2label
unset y2tics
set autoscale x
set autoscale y
unset xrange
unset yrange
set output 'img/bitfinex-lendbook-btc-all-time.png'

bitfinex_percent(x) = x / 365

plot \
  'data/bitfinex-lendbook-btc.dat' using 1:(bitfinex_percent($2)) with lines title 'best swap ask for BTC', \
  'data/bitfinex-lendbook-btc.dat' using 1:(bitfinex_percent($3)) with lines title 'best swap bid for BTC'

set autoscale x
set autoscale y
unset xrange
unset yrange
set output 'img/bitfinex-lendbook-ltc-all-time.png'

bitfinex_percent(x) = x / 365

plot \
  'data/bitfinex-lendbook-ltc.dat' using 1:(bitfinex_percent($2)) with lines title 'best swap ask for LTC', \
  'data/bitfinex-lendbook-ltc.dat' using 1:(bitfinex_percent($3)) with lines title 'best swap bid for LTC'

now = `date +%s`
one_month_past = now - 2592000
eval(sprintf('set xrange ["%d":]', one_month_past))
unset yrange
set output 'img/bitfinex-lendbook-ltc-last-month.png'
replot

