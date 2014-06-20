#! /usr/bin/gnuplot -persist

set ylabel "sentiment index, %"

set xdata time
set timefmt "%s"

set logscale y2

set format x "%d.%m.%y"

set grid x y
set key out bottom center

set terminal pngcairo transparent enhanced font "Helvetica,10" size 900, 600

set autoscale x
set autoscale y
set xrange ["1403232305":]
set output 'img/bitfinex-sentiment-index-all-time.png'

plot \
  'data/bitfinexUSD.dat' using 1:2 with lines title 'Bitfinex BTCUSD' axes x1y2 linetype 3, \
  'data/bitfinex-sentiment-index.dat' using 1:2 with lines title 'Bitfinex sentiment index, green thing' linetype 2
#  'data/bitfinex-sentiment-index.dat' using 1:3 with lines title 'Bitfinex sentiment index, red thing' linetype 1
