#! /usr/bin/gnuplot -persist
set xlabel "date"
set ylabel "$" #font "Helvetica,18"

set xdata time
set timefmt "%Y%m%d"

set xrange ["20120713":"20130706"]

#set logscale y

plot \
  'data/litecoin-self-cost.dat' using 1:2 with lines title "7970 mining cost", \
  'data/litecoin-self-cost.dat' using 1:3 with lines title "7970 mining cost with 1 year amortization", \
  'data/btc-e-ltc-usd.dat' using 1:5 with lines title 'btc-e price'
