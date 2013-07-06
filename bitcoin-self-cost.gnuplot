#! /usr/bin/gnuplot -persist

set xlabel "date"
set ylabel "$" #font "Helvetica,18"

set xdata time
set timefmt "%Y%m%d"

set format x "%d.%m.%y" # or whatever
set xrange ["20110401":]
#set yrange [0:10]

#set logscale y

plot \
  'data/mtgox-btc-usd.dat' using 1:5 with lines title 'mtgox price', \
  'data/bitcoin-self-cost.dat' using 1:2 with lines title "7970 mining cost", \
  'data/bitcoin-self-cost.dat' using 1:3 with lines title "7970 mining cost with 1 year amortization", \
  'data/bitcoin-self-cost.dat' using 1:4 with lines title "Avalon ASIC #2 mining cost", \
  'data/bitcoin-self-cost.dat' using 1:5 with lines title "Avalon ASIC #2 mining cost with 1 year amortization" linetype 7
