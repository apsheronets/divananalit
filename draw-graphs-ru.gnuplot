#! /usr/bin/gnuplot -persist

set ylabel "$"
set y2label 'сложность'

set xdata time
set timefmt "%Y%m%d"

set format x "%d.%m.%y"

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
set style fill solid 0.5
set output 'графики/себестоимость-майнинга-биткоинов-до-20130201.png'

plot \
  'data/mtgox-btc-usd.dat' u 1:4:3 w filledcu axes x1y1 notitle, \
  'data/mtgox-btc-usd.dat' using 1:8 with lines title 'курс биткоина на MtGox' axes x1y1 linetype 1, \
  'data/pentium_dual-core_e5400_mining_cost.dat' using 1:2 with lines title "стоимость майнинга биткоинов на CPU Pentium Dual-Core E5400" axes x1y1 linetype 2, \
  'data/ati_5970_bitcoin_mining_cost.dat' using 1:2 with lines title "стоимость майнинга биткоинов на GPU ATI 5970" axes x1y1 linetype 3, \
  'data/ati_5970_bitcoin_mining_cost_with_1_year_amortization.dat' using 1:2 with lines title "стоимость майнинга биткоинов на GPU ATI 5970 с учетом амортизации за год" axes x1y1 linetype 4, \
  'data/bitcoin-blocks.dat' using 2:6 with lines title "сложность" linetype 7 axes x1y2


set autoscale x
set autoscale y
unset xrange
unset yrange
set xrange ["20130201":]
set yrange [0:500]
set output 'графики/себестоимость-майнинга-биткоинов-с-20130210-по-сегодняшний-день.png'

plot \
  'data/btc-e-btc-usd.dat' u 1:2:3 w filledcu axes x1y1 notitle, \
  'data/btc-e-btc-usd.dat' using 1:2 with lines notitle axes x1y1 linetype 1, \
  'data/btc-e-btc-usd.dat' using 1:3 with lines title 'курс биткоина на BTC-E ' axes x1y1 linetype 1, \
  'data/ati_7970_bitcoin_mining_cost.dat' using 1:2 with lines title "стоимость майнинга на GPU ATI 7970" axes x1y1, \
  'data/ati_7970_bitcoin_mining_cost_with_1_year_amortization.dat' using 1:2 with lines title "стоимость майнинга на GPU ATI 7970 с учетом амортизации за год" axes x1y1, \
  'data/avalion_asic_2_bitcoin_mining_cost.dat' using 1:2 with lines title "стоимость майнинга на Avalon ASIC #2" axes x1y1, \
  'data/avalion_asic_2_bitcoin_mining_cost_with_1_year_amortization.dat' using 1:2 with lines title "стоимость майнинга на Avalon ASIC #2 с учетом амортизации за год" axes x1y1, \
  'data/bitcoin-blocks.dat' using 2:6 with lines title "сложность" linetype 7 axes x1y2


set autoscale x
set autoscale y
unset xrange
unset yrange
set xrange ["20140201":]
set yrange [0:500]
set output 'графики/себестоимость-майнинга-биткоинов-с-20140201-по-сегодняшний-день.png'

plot \
  'data/btc-e-btc-usd.dat' u 1:2:3 w filledcu axes x1y1 notitle, \
  'data/btc-e-btc-usd.dat' using 1:2 with lines notitle axes x1y1 linetype 1, \
  'data/btc-e-btc-usd.dat' using 1:3 with lines title 'цена на BTC-E' axes x1y1 linetype 1, \
  'data/terraminer_iv_bitcoin_mining_cost.dat' using 1:2 with lines title "себестоимость майнинга на TerraMiner IV" axes x1y1 linetype 2, \
  'data/terraminer_iv_bitcoin_mining_cost_with_1_year_amortization.dat' using 1:2 with lines title "себестоимость майнинга на TerraMiner IV с учетом амортизации за год" axes x1y1 linetype 3, \
  'data/bitcoin-blocks.dat' using 2:6 with lines title "сложность" linetype 7 axes x1y2


set autoscale x
set autoscale y
unset xrange
unset yrange
set xrange ["20100701":"20130201"]
set yrange [0:15]
set output 'графики/доходность-майнинга-биткоинов-до-20130201.png'

plot \
  'data/mtgox-btc-usd.dat' u 1:4:3 w filledcu axes x1y1 notitle, \
  'data/mtgox-btc-usd.dat' using 1:8 with lines title 'курс биткоина на MtGox' axes x1y1 linetype 1, \
  'data/pentium_dual-core_e5400_bitcoin_profitability.dat' using 1:2 with lines title "доход в день от майнинга на CPU Pentium Dual-Core E5400" linetype 3 axes x1y1, \
  'data/ati_5970_bitcoin_profitability.dat' using 1:2 with lines title "доход в день от майнинга на GPU ATI 5970" linetype 4 axes x1y1, \
  'data/bitcoin-blocks.dat' using 2:6 with lines title "сложность" linetype 7 axes x1y2


set autoscale x
set autoscale y
set xrange ["20130201":]
set yrange [0:500]
set output 'графики/доходность-майнинга-биткоинов-с-20130201-по-сегодняшний-день.png'

plot \
  'data/btc-e-btc-usd.dat' u 1:2:3 w filledcu axes x1y1 notitle, \
  'data/btc-e-btc-usd.dat' using 1:2 with lines notitle axes x1y1 linetype 1, \
  'data/btc-e-btc-usd.dat' using 1:3 with lines title 'курс биткоина на BTC-E' axes x1y1 linetype 1, \
  'data/avalon_asic_2_bitcoin_profitability.dat' using 1:2 with lines title "доход в день от майнинга на Avalon ASIC #2" linetype 3 axes x1y1, \
  'data/ati_7970_bitcoin_profitability.dat' using 1:2 with lines title "доход в день от майнинга на GPU ATI 7970" linetype 4 axes x1y1, \
  'data/bitcoin-blocks.dat' using 2:6 with lines title "сложность" linetype 7 axes x1y2


set autoscale x
set autoscale y
set xrange ["20130801":]
set yrange [0:200]
set output 'графики/доходность-майнинга-биткоинов-с-20130801-по-сегодняший-день.png'

plot \
  'data/btc-e-btc-usd.dat' u 1:2:3 w filledcu axes x1y1 notitle, \
  'data/btc-e-btc-usd.dat' using 1:2 with lines notitle axes x1y1 linetype 1, \
  'data/btc-e-btc-usd.dat' using 1:3 with lines title 'курс биткоина на BTC-E' axes x1y1 linetype 1, \
  'data/avalon_asic_2_bitcoin_profitability.dat' using 1:2 with lines title "доход от Avalon ASIC #2 в день" linetype 3 axes x1y1, \
  'data/bitcoin-blocks.dat' using 2:6 with lines title "сложность" linetype 7 axes x1y2


set autoscale x
set autoscale y
set xrange ["20140201":]
set yrange [0:500]
set output 'графики/доходность-майнинга-биткоинов-с-20140201-по-сегодняшний-день.png'

plot \
  'data/btc-e-btc-usd.dat' u 1:2:3 w filledcu axes x1y1 notitle, \
  'data/btc-e-btc-usd.dat' using 1:2 with lines notitle axes x1y1 linetype 1, \
  'data/btc-e-btc-usd.dat' using 1:3 with lines title 'цена на BTC-E' axes x1y1 linetype 1, \
  'data/terraminer_iv_bitcoin_profitability.dat' using 1:2 with lines title "доход от TerraMiner IV в день" linetype 3 axes x1y1, \
  'data/bitcoin-blocks.dat' using 2:6 with lines title "сложность" linetype 7 axes x1y2


set autoscale x
set autoscale y
set xrange ["20120701":]
#set yrange [0:500]
set y2label 'BTC'
set output 'графики/доходность-майнинга-биткоинов-и-лайткоинов.png'

plot \
  'data/btc-e-ltc-btc.dat' using 1:2 with lines linetype 5 title "цена лайткоина в биткоинах на BTC-E" axes x1y2, \
  'data/ati_7970_bitcoin_profitability.dat' using 1:2 with lines linetype 1 title "доход в день от ATI 7970 при майнинге биткоинов" axes x1y1, \
  'data/ati_7970_litecoin_profitability.dat' using 1:2 with lines linetype 2 title "доход в день от ATI 7970 при майнинге лайткоинов" axes x1y1

set autoscale x
set autoscale y
set xrange ["20130701":]
set y2label 'mining difficulty'
set output 'графики/доходность-гигахеша-на-майнинге-биткоинов-с-20130701-по-сегодняшний-день.png'

plot \
  'data/ghash_bitcoin_profitability.dat' using 1:2 with lines title "доход с гигахеша при майнинге биткоинов" axes x1y1, \
  'data/bitcoin-blocks.dat' using 2:6 with lines title "сложность" linetype 7 axes x1y2

set autoscale x
set autoscale y
unset xrange
unset yrange
set xrange ["20130101":]
#set yrange [0:20]
set output 'графики/себестоимость-майнинга-лайткоинов.png'

plot \
  'data/btc-e-ltc-usd.dat' u 1:2:3 w filledcu axes x1y1 notitle, \
  'data/btc-e-ltc-usd.dat' using 1:2 with lines notitle axes x1y1 linetype 1, \
  'data/btc-e-ltc-usd.dat' using 1:3 with lines title 'курс лайткоина на BTC-E' axes x1y1 linetype 1, \
  'data/ati_7970_litecoin_mining_cost.dat' using 1:2 with lines title "стоимость майнинга на GPU ATI 7970" axes x1y1 linetype 2, \
  'data/ati_7970_litecoin_mining_cost_with_1_year_amortization.dat' using 1:2 with lines title "стоимость майнинга на GPU ATI 7970 с учетом амортизации за год" axes x1y1 linetype 3, \
  'data/litecoin-blocks.dat' using 2:3 with lines title "сложность" linetype 7 axes x1y2

set autoscale x
set autoscale y
unset xrange
unset yrange
set xrange ["20100701":]
set yrange [0.01:]
set logscale y
set logscale y2
set output 'графики/себестоимость-майнинга-биткоинов-логарифмическая-шкала.png'

plot \
  'data/mtgox-btc-usd.dat' using 1:5 with lines title 'курс биткоина на MtGox' axes x1y1 linetype 1, \
  'data/btc-e-btc-usd.dat' using 1:5 with lines title 'курс биткоина на BTC-E' axes x1y1 linetype 1, \
  'data/pentium_dual-core_e5400_mining_cost.dat' using 1:2 with lines title "стоимость майнинга биткоинов на CPU Pentium Dual-Core E5400" axes x1y1 linetype 2, \
  'data/ati_7970_bitcoin_mining_cost.dat' using 1:2 with lines title "стоимость майнинга биткоинов на GPU ATI 7970" axes x1y1 linetype 3, \
  'data/avalion_asic_2_bitcoin_mining_cost.dat' using 1:2 with lines title "стоимость майнинга на Avalon ASIC #2" linetype 8 axes x1y1, \
  'data/bitcoin-blocks.dat' using 2:6 with lines title "сложность" linetype 7 axes x1y2

set terminal pngcairo transparent enhanced font "Helvetica,10" size 600, 400
set output 'графики/себестоимость-майнинга-биткоинов-логарифмическая-шкала-600x400.png'
replot

unset logscale y
unset logscale y2
set terminal pngcairo transparent enhanced font "Helvetica,10" size 900, 600

set autoscale x
set autoscale y
unset xrange
unset yrange
set xrange ["20130501":"20140301"]
#set yrange [0:20]
set y2label '%'
set grid x y y2
set output 'графики/разнциа-между-mtgox-и-btce.png'

plot \
  '< sort -n data/mtgox-and-btce.dat' using 1:((1-($2/$8))*100) with lines axes x1y2 linetype 6 title "относительная разница между MtGox и BTC-E в процентах", \
  '< sort -n data/mtgox-and-btce.dat' using 1:($8-$2) with lines axes x1y1 linetype 3 title "абсолютная разница между MtGox и BTC-E в долларах", \
  'data/mtgox-btc-usd.dat' using 1:2 with lines title 'цена на MtGox' axes x1y1 linetype 1, \
  'data/btc-e-btc-usd.dat' using 1:2 with lines title 'цена на BTC-E' axes x1y1 linetype 2

set autoscale x
set autoscale y
set xrange [30:2500]
set yrange [0:800]
unset y2label
unset xdata
unset format
set xlabel 'мегахешей в секунду на доллар'
set ylabel 'необходимая цена биткоина для покрытия стоимости оборудования'
set xtics 200
set ytics 50
unset y2tics
set grid x y
set output 'графики/необходимая-цена-биткоина-для-покрытия-стоимости-оборудования.png'

plot \
  'data/mining-hardware-recoupment.dat' using 1:2 with lines title "если сложность будет расти на 5% каждые 2 недели", \
  'data/mining-hardware-recoupment.dat' using 1:3 with lines title "если сложность будет расти на 15% каждые 2 недели", \
  'data/mining-hardware-recoupment.dat' using 1:4 with lines title "если сложность будет расти на 25% каждые 2 недели"

