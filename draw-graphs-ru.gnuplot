#! /usr/bin/gnuplot -persist

set ylabel "$"
set y2label 'сложность'

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
set output 'графики/себестоимость-майнинга-биткоинов-до-20130201.png'

plot \
  'data/mtgox-btc-usd.dat' using 1:5 with lines title 'курс биткоина на MtGox' axes x1y1, \
  'data/pentium_dual-core_e5400_mining_cost.dat' using 1:2 with lines title "стоимость майнинга биткоинов на CPU Pentium Dual-Core E5400" axes x1y1, \
  'data/ati_7970_bitcoin_mining_cost.dat' using 1:2 with lines title "стоимость майнинга биткоинов на GPU ATI 7970" axes x1y1, \
  'data/ati_7970_bitcoin_mining_cost_with_1_year_amortization.dat' using 1:2 with lines title "стоимость майнинга биткоинов на GPU ATI 7970 с учетом амортизации за год" axes x1y1, \
  'data/bitcoin-blocks.dat' using 2:6 with lines title "сложность" linetype 7 axes x1y2


set autoscale x
set autoscale y
unset xrange
unset yrange
set xrange ["20130201":]
set yrange [0:500]
set output 'графики/себестоимость-майнинга-лайткоинов-с-20130210-по-сегодняшний-день.png'

plot \
  'data/mtgox-btc-usd.dat' using 1:5 with lines title 'курс биткоина на MtGox' axes x1y1, \
  'data/ati_7970_bitcoin_mining_cost.dat' using 1:2 with lines title "стоимость майнинга на GPU ATI 7970" axes x1y1, \
  'data/ati_7970_bitcoin_mining_cost_with_1_year_amortization.dat' using 1:2 with lines title "стоимость майнинга на GPU ATI 7970 с учетом амортизации за год" axes x1y1, \
  'data/avalion_asic_2_bitcoin_mining_cost.dat' using 1:2 with lines title "стоимость майнинга на Avalon ASIC #2" axes x1y1, \
  'data/avalion_asic_2_bitcoin_mining_cost_with_1_year_amortization.dat' using 1:2 with lines title "стоимость майнинга на Avalon ASIC #2 с учетом амортизации за год" axes x1y1, \
  'data/bitcoin-blocks.dat' using 2:6 with lines title "сложность" linetype 7 axes x1y2


set autoscale x
set autoscale y
unset xrange
unset yrange
set xrange ["20100701":"20130201"]
set yrange [0:15]
set output 'графики/доходность-майнинга-биткоинов-до-20130201.png'

plot \
  'data/mtgox-btc-usd.dat' using 1:5 with lines title 'курс биткоина на MtGox' axes x1y1, \
  'data/pentium_dual-core_e5400_bitcoin_profitability.dat' using 1:2 with lines title "доход в день от майнинга на CPU Pentium Dual-Core E5400" linetype 3 axes x1y1, \
  'data/ati_7970_bitcoin_profitability.dat' using 1:2 with lines title "доход в день от майнинга на GPU ATI 7970" linetype 4 axes x1y1, \
  'data/bitcoin-blocks.dat' using 2:6 with lines title "сложность" linetype 7 axes x1y2


set autoscale x
set autoscale y
set xrange ["20130201":]
set yrange [0:500]
set output 'графики/доходность-майнинга-биткоинов-с-20130201-по-сегодняшний-день.png'

plot \
  'data/mtgox-btc-usd.dat' using 1:5 with lines title 'курс биткоина на MtGox' axes x1y1, \
  'data/avalon_asic_2_bitcoin_profitability.dat' using 1:2 with lines title "доход в день от майнинга на Avalon ASIC #2" linetype 3 axes x1y1, \
  'data/ati_7970_bitcoin_profitability.dat' using 1:2 with lines title "доход в день от майнинга на GPU ATI 7970" linetype 4 axes x1y1, \
  'data/bitcoin-blocks.dat' using 2:6 with lines title "сложность" linetype 7 axes x1y2


set autoscale x
set autoscale y
set xrange ["20130801":]
set yrange [0:200]
set output 'графики/доходность-майнинга-биткоинов-с-20130801-по-сегодняший-день.png'

plot \
  'data/mtgox-btc-usd.dat' using 1:5 with lines title 'курс биткоина на MtGox' axes x1y1, \
  'data/avalon_asic_2_bitcoin_profitability.dat' using 1:2 with lines title "доход от Avalon ASIC #2 в день" linetype 3 axes x1y1, \
  'data/bitcoin-blocks.dat' using 2:6 with lines title "сложность" linetype 7 axes x1y2


set autoscale x
set autoscale y
set xrange ["20120701":]
#set yrange [0:500]
set output 'графики/доходность-майнинга-биткоинов-и-лайткоинов.png'

plot \
  'data/ati_7970_bitcoin_profitability.dat' using 1:2 with lines title "доход в день от ATI 7970 при майнинге биткоинов" axes x1y1, \
  'data/ati_7970_litecoin_profitability.dat' using 1:2 with lines title "доход в день от ATI 7970 при майнинге лайткоинов" axes x1y1


set autoscale x
set autoscale y
unset xrange
unset yrange
set xrange ["20130101":]
#set yrange [0:20]
set output 'графики/себестоимость-майнинга-лайткоинов.png'

plot \
  'data/btc-e-ltc-usd.dat' using 1:5 with lines title 'курс лайткоина на BTC-E' axes x1y1, \
  'data/ati_7970_litecoin_mining_cost.dat' using 1:2 with lines title "стоимость майнинга на GPU ATI 7970" axes x1y1, \
  'data/ati_7970_litecoin_mining_cost_with_1_year_amortization.dat' using 1:2 with lines title "стоимость майнинга на GPU ATI 7970 с учетом амортизации за год" axes x1y1, \
  'data/litecoin-blocks.dat' using 2:6 with lines title "сложность" linetype 7 axes x1y2

