#! /usr/bin/gnuplot -persist

set ylabel "% per day"

set xdata time
set timefmt "%s"

set format x "%d.%m.%y"

set grid x y
set key out bottom center

set terminal pngcairo transparent enhanced font "Helvetica,10" size 900, 600

set autoscale x
set autoscale y
unset xrange
unset yrange
set output 'img/bitfinex-lendbook-usd-all-time.png'

bitfinex_percent(x) = x / 365

plot \
  'data/bitfinex-lendbook-usd.dat' using 1:(bitfinex_percent($2)) with lines title 'best ask for USD', \
  'data/bitfinex-lendbook-usd.dat' using 1:(bitfinex_percent($3)) with lines title 'best bid for USD'

set autoscale x
set autoscale y
unset xrange
unset yrange
set output 'img/bitfinex-lendbook-btc-all-time.png'

bitfinex_percent(x) = x / 365

plot \
  'data/bitfinex-lendbook-btc.dat' using 1:(bitfinex_percent($2)) with lines title 'best ask for BTC', \
  'data/bitfinex-lendbook-btc.dat' using 1:(bitfinex_percent($3)) with lines title 'best bid for BTC'

set autoscale x
set autoscale y
unset xrange
unset yrange
set output 'img/bitfinex-lendbook-ltc-all-time.png'

bitfinex_percent(x) = x / 365

plot \
  'data/bitfinex-lendbook-ltc.dat' using 1:(bitfinex_percent($2)) with lines title 'best ask for LTC', \
  'data/bitfinex-lendbook-ltc.dat' using 1:(bitfinex_percent($3)) with lines title 'best bid for LTC'

