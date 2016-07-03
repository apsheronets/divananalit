#! /usr/bin/gnuplot -persist

set terminal pngcairo transparent enhanced font "Helvetica,10" size 900, 600
set xdata time
set timefmt "%Y-%m-%d"
set format y '%.0f'
set ytics
set grid y
set title "Localbitcoins CNY weekly amounts"
set style fill solid border -1
set output 'img/localbitcoins-cny-weekly-amounts.png'
## Last datafile plotted: "random-points"
plot \
  "data/localbitcoins-cny-weekly-amounts.dat" u 1:2 smooth freq t 'value in CNY' w boxes
