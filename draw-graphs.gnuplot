#! /usr/bin/gnuplot -persist

set ylabel "$"
set y2label 'mining difficulty'

set xdata time
set timefmt "%Y%m%d"

set format x "%d.%m.%y"

#set logscale y
set y2tics
set grid x y
set key out bottom center

set terminal pngcairo transparent enhanced font "Helvetica,10" size 900, 600

set autoscale x
set autoscale y
unset xrange
unset yrange
set xrange ["20100701":"20130201"]
set yrange [0:20]
set output 'img/bitcoin-mining-cost-to-20130201.png'

plot \
  'data/mtgox-btc-usd.dat' using 1:5 with lines title 'mtgox price' axes x1y1, \
  'data/pentium_dual-core_e5400_mining_cost.dat' using 1:2 with lines title "Pentium Dual-Core E5400 bitcoin mining cost" axes x1y1, \
  'data/ati_7970_bitcoin_mining_cost.dat' using 1:2 with lines title "ATI 7970 bitcoin mining cost" axes x1y1, \
  'data/ati_7970_bitcoin_mining_cost_with_1_year_amortization.dat' using 1:2 with lines title "ATI 7970 bitcoin mining cost with 1 year amortization" axes x1y1, \
  'data/bitcoin-blocks.dat' using 2:6 with lines title "mining difficulty" linetype 7 axes x1y2


set autoscale x
set autoscale y
unset xrange
unset yrange
set xrange ["20130201":]
set yrange [0:500]
set output 'img/bitcoin-mining-cost-from-20130201-to-now.png'

plot \
  'data/mtgox-btc-usd.dat' using 1:5 with lines title 'mtgox price' axes x1y1, \
  'data/ati_7970_bitcoin_mining_cost.dat' using 1:2 with lines title "ATI 7970 bitcoin mining cost" axes x1y1, \
  'data/ati_7970_bitcoin_mining_cost_with_1_year_amortization.dat' using 1:2 with lines title "ATI 7970 bitcoin mining cost with 1 year amortization" axes x1y1, \
  'data/avalion_asic_2_bitcoin_mining_cost.dat' using 1:2 with lines title "Avalon ASIC #2 bitcoin mining cost" axes x1y1, \
  'data/avalion_asic_2_bitcoin_mining_cost_with_1_year_amortization.dat' using 1:2 with lines title "Avalon ASIC #2 bitcoin mining cost with 1 year amortization" axes x1y1, \
  'data/bitcoin-blocks.dat' using 2:6 with lines title "mining difficulty" linetype 7 axes x1y2


set autoscale x
set autoscale y
unset xrange
unset yrange
set xrange ["20100701":"20130201"]
set yrange [0:15]
set output 'img/bitcoin-profitability-to-20130201.png'

plot \
  'data/mtgox-btc-usd.dat' using 1:5 with lines title 'mtgox price' axes x1y1, \
  'data/pentium_dual-core_e5400_bitcoin_profitability.dat' using 1:2 with lines title "Pentium Dual-Core E5400 income per day" linetype 3 axes x1y1, \
  'data/ati_7970_bitcoin_profitability.dat' using 1:2 with lines title "ATI 7970 income per day" linetype 4 axes x1y1, \
  'data/bitcoin-blocks.dat' using 2:6 with lines title "mining difficulty" linetype 7 axes x1y2


set autoscale x
set autoscale y
set xrange ["20130201":]
set yrange [0:500]
set output 'img/bitcoin-profitability-from-20130201-to-now.png'

plot \
  'data/mtgox-btc-usd.dat' using 1:5 with lines title 'mtgox price' axes x1y1, \
  'data/avalon_asic_2_bitcoin_profitability.dat' using 1:2 with lines title "Avalon ASIC #2 income per day" linetype 3 axes x1y1, \
  'data/ati_7970_bitcoin_profitability.dat' using 1:2 with lines title "ATI 7970 income per day" linetype 4 axes x1y1, \
  'data/bitcoin-blocks.dat' using 2:6 with lines title "mining difficulty" linetype 7 axes x1y2


set autoscale x
set autoscale y
set xrange ["20130801":]
set yrange [0:200]
set output 'img/bitcoin-profitability-from-20130801-to-now.png'

plot \
  'data/mtgox-btc-usd.dat' using 1:5 with lines title 'mtgox price' axes x1y1, \
  'data/avalon_asic_2_bitcoin_profitability.dat' using 1:2 with lines title "Avalon ASIC #2 income per day" linetype 3 axes x1y1, \
  'data/bitcoin-blocks.dat' using 2:6 with lines title "mining difficulty" linetype 7 axes x1y2


set autoscale x
set autoscale y
set xrange ["20120701":]
#set yrange [0:500]
set y2label 'BTC'
set output 'img/bitcoin-and-litecoin-profitability.png'

plot \
  'data/btc-e-ltc-btc.dat' using 1:2 with lines linetype 5 title "BTC-E litecoin/bitcoin rate" axes x1y2, \
  'data/ati_7970_bitcoin_profitability.dat' using 1:2 with lines linetype 1 title "ATI 7970 income per day from bitcoin mining" axes x1y1, \
  'data/ati_7970_litecoin_profitability.dat' using 1:2 with lines linetype 2 title "ATI 7970 income per day from litecoin mining" axes x1y1

set autoscale x
set autoscale y
set xrange ["20130701":]
set y2label 'mining difficulty'
set output 'img/ghash-profitability-from-20130701-to-now.png'

plot \
  'data/ghash_bitcoin_profitability.dat' using 1:2 with lines title "income per day from 1 ghash for bitcoin mining" axes x1y1, \
  'data/bitcoin-blocks.dat' using 2:6 with lines title "mining difficulty" linetype 7 axes x1y2

set autoscale x
set autoscale y
unset xrange
unset yrange
set xrange ["20130101":]
#set yrange [0:20]
set output 'img/litecoin-mining-cost.png'

plot \
  'data/btc-e-ltc-usd.dat' using 1:5 with lines title 'btc-e litecoin price' axes x1y1, \
  'data/ati_7970_litecoin_mining_cost.dat' using 1:2 with lines title "ATI 7970 litecoin mining cost" axes x1y1, \
  'data/ati_7970_litecoin_mining_cost_with_1_year_amortization.dat' using 1:2 with lines title "ATI 7970 litecoin mining cost with 1 year amortization" axes x1y1, \
  'data/litecoin-blocks.dat' using 2:3 with lines title "litecoin mining difficulty" linetype 7 axes x1y2

