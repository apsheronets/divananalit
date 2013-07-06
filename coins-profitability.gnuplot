#! /usr/bin/gnuplot -persist

set xlabel "date"
set ylabel "$" #font "Helvetica,18"

set xdata time
set timefmt "%Y%m%d"

#set xrange ["20100701":"20130706"]
set xrange ["20130101":"20130706"]
set yrange [0:10]

#set logscale y
set y2tics

plot \
  'data/litecoin-profitability.dat' using 1:3 with lines linetype 1 title "7970 litecoin income per day", \
  'data/bitcoin-profitability.dat' using 1:3 with lines linetype 3 title "7970 bitcoin income per day"
