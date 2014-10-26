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
set style fill solid 0.5
set datafile missing "NaN"
set output 'img/bitfinex-sentiment-index-all-time.png'

plot \
  'data/bitfinex-btc-usd.dat' u 1:2:3 w filledcu axes x1y2 notitle, \
  'data/bitfinex-btc-usd.dat' using 1:2 with lines notitle axes x1y2 linetype 1, \
  'data/bitfinex-btc-usd.dat' using 1:3 with lines title 'Bitfinex BTCUSD' axes x1y2 linetype 1, \
  'data/bitfinex-sentiment-index.dat' using 1:2 with lines title 'Bitfinex sentiment index, green thing' linetype 2
#  'data/bitfinex-sentiment-index.dat' using 1:3 with lines title 'Bitfinex sentiment index, red thing' linetype 1

now = `date +%s`
three_days_past = now - 259200
eval(sprintf('set xrange ["%d":]', three_days_past))
unset yrange
set output 'img/bitfinex-sentiment-index-three-days.png'
set format x "%d %H:%M"
#replot

