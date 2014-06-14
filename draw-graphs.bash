#!/bin/bash

basedir=`dirname $0`
dst=$1

$basedir/get-bitcoin-blocks.bash || (echo "can't get bitcoin blocks"; exit 1)
$basedir/get-litecoin-blocks.bash || (echo "can't get litecoin blocks"; exit 1)
ruby $basedir/get-btce-ltc-usd.rb  > data/btc-e-ltc-usd.dat || (echo "can't get btce-ltc-usd prices"; exit 1)
ruby $basedir/get-btce-ltc-btc.rb  > data/btc-e-ltc-btc.dat || (echo "can't get btce-ltc-btc prices"; exit 1)

ruby $basedir/get-btce-btc-usd.rb  > data/btc-e-btc-usd.dat~ || (echo "can't get btce-btc-usd prices"; exit 1)
cat $basedir/btce-btc-usd-from-bitcoincharts.dat >> data/btc-e-btc-usd.dat~
sort data/btc-e-btc-usd.dat~ | uniq -w 8 > data/btc-e-btc-usd.dat

ruby $basedir/get-mtgox-btc-usd.rb > data/mtgox-btc-usd.dat~ || (echo "can't get mtgox-btc-usd prices"; exit 1)
[[ `cat data/mtgox-btc-usd.dat~` == "" ]] && (echo "mtgox-btc-usd prices are empty"; exit 1)
[[ `cat data/btc-e-ltc-usd.dat`  == "" ]] && (echo "btce-ltc-usd prices are empty"; exit 1)
[[ `cat data/btc-e-btc-usd.dat~`  == "" ]] && (echo "btce-btc-usd prices are empty"; exit 1)
cat $basedir/mtgox-btc-usd.dat >> data/mtgox-btc-usd.dat~
sort data/mtgox-btc-usd.dat~ | uniq -w 8 > data/mtgox-btc-usd.dat

join <(sort -k1,1 data/btc-e-btc-usd.dat) <(sort -k1,1 data/mtgox-btc-usd.dat) > data/mtgox-and-btce.dat

#rm -f $basedir/img/*

energy_cost=0.12
blocks_data=data/bitcoin-blocks.dat
mtgox_data=data/mtgox-btc-usd.dat

$basedir/grapher -self-cost -coins-type bitcoins -hashrate 82000000000 -power 700 -blocks-data $blocks_data -energy-cost $energy_cost > data/avalion_asic_2_bitcoin_mining_cost.dat || exit 1
$basedir/grapher -amortized-self-cost 31536000. -coins-type bitcoins -hashrate 82000000000 -power 700 -blocks-data $blocks_data -energy-cost $energy_cost -hardware-cost 1499 > data/avalion_asic_2_bitcoin_mining_cost_with_1_year_amortization.dat || exit 1
$basedir/grapher -self-cost -coins-type bitcoins -hashrate 2000000000000 -power 2200 -blocks-data $blocks_data -energy-cost $energy_cost > data/terraminer_iv_bitcoin_mining_cost.dat || exit 1
$basedir/grapher -amortized-self-cost 31536000. -coins-type bitcoins -hashrate 2000000000000 -power 2200 -blocks-data $blocks_data -energy-cost $energy_cost -hardware-cost 5999 > data/terraminer_iv_bitcoin_mining_cost_with_1_year_amortization.dat || exit 1
$basedir/grapher -self-cost -coins-type bitcoins -hashrate 685000000 -power 250 -blocks-data $blocks_data -energy-cost $energy_cost > data/ati_7970_bitcoin_mining_cost.dat || exit 1
$basedir/grapher -amortized-self-cost 31536000. -coins-type bitcoins -hashrate 685000000 -power 250  -blocks-data $blocks_data -energy-cost $energy_cost -hardware-cost 399 > data/ati_7970_bitcoin_mining_cost_with_1_year_amortization.dat || exit 1
$basedir/grapher -self-cost -coins-type bitcoins -hashrate 530000000 -power 294 -blocks-data $blocks_data -energy-cost $energy_cost > data/ati_5970_bitcoin_mining_cost.dat || exit 1
$basedir/grapher -amortized-self-cost 31536000. -coins-type bitcoins -hashrate 530000000 -power 294  -blocks-data $blocks_data -energy-cost $energy_cost -hardware-cost 1000 > data/ati_5970_bitcoin_mining_cost_with_1_year_amortization.dat || exit 1
$basedir/grapher -self-cost -coins-type bitcoins -hashrate 2270000 -power 65 -blocks-data $blocks_data -energy-cost $energy_cost > data/pentium_dual-core_e5400_mining_cost.dat || exit 1

$basedir/grapher -profitability -coins-type bitcoins -hashrate 82000000000 -power 700 -blocks-data $blocks_data -market-rate-data data/btc-e-btc-usd.dat -energy-cost $energy_cost > data/avalon_asic_2_bitcoin_profitability.dat || exit 1
$basedir/grapher -profitability -coins-type bitcoins -hashrate 2000000000000 -power 2200 -blocks-data $blocks_data -market-rate-data data/btc-e-btc-usd.dat -energy-cost $energy_cost > data/terraminer_iv_bitcoin_profitability.dat || exit 1
$basedir/grapher -profitability -coins-type bitcoins -hashrate 685000000 -power 250 -blocks-data $blocks_data -market-rate-data data/btc-e-btc-usd.dat -energy-cost $energy_cost > data/ati_7970_bitcoin_profitability.dat || exit 1
$basedir/grapher -profitability -coins-type bitcoins -hashrate 530000000 -power 294 -blocks-data $blocks_data -market-rate-data $mtgox_data -energy-cost $energy_cost > data/ati_5970_bitcoin_profitability.dat || exit 1
$basedir/grapher -profitability -coins-type bitcoins -hashrate 2270000 -power 65 -blocks-data $blocks_data -market-rate-data $mtgox_data -energy-cost $energy_cost > data/pentium_dual-core_e5400_bitcoin_profitability.dat || exit 1

$basedir/grapher -profitability -coins-type litecoins -hashrate 650000 -power 250 -blocks-data data/litecoin-blocks.dat -market-rate-data data/btc-e-ltc-usd.dat -energy-cost $energy_cost > data/ati_7970_litecoin_profitability.dat || exit 1

$basedir/grapher -profitability -coins-type bitcoins -hashrate 1000000000 -power 0 -blocks-data $blocks_data -market-rate-data $mtgox_data -energy-cost $energy_cost > data/ghash_bitcoin_profitability.dat || exit 1

$basedir/grapher -self-cost -coins-type litecoins -hashrate 650000 -power 250 -blocks-data data/litecoin-blocks.dat -energy-cost $energy_cost > data/ati_7970_litecoin_mining_cost.dat || exit 1
$basedir/grapher -amortized-self-cost 31536000. -coins-type litecoins -hashrate 650000 -power 250  -blocks-data data/litecoin-blocks.dat -energy-cost $energy_cost -hardware-cost 399 > data/ati_7970_litecoin_mining_cost_with_1_year_amortization.dat || exit 1

$basedir/grapher -mining-hardware-recoupment -difficulty `tail -n1 data/bitcoin-blocks.dat | cut -d ' ' -f 5` > data/mining-hardware-recoupment.dat

mkdir -p img
$basedir/draw-graphs.gnuplot || exit 1
$basedir/draw-bitfinex-lendbook.gnuplot || exit 1
mkdir -p графики
$basedir/draw-graphs-ru.gnuplot || exit 1

unison -batch -silent img/ $dst || exit 1
unison -batch -silent графики/ `readlink -f $dst/../графики/` || exit 1
