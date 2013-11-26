#!/bin/bash

basedir=`dirname $0`
dst=$1

$basedir/get-bitcoin-blocks.bash || exit 1
$basedir/get-litecoin-blocks.bash || exit 1
$basedir/get-mtgox-btc-usd.bash || exit 1
ruby $basedir/get-btce-ltc-usd.rb data/btc-e-ltc-usd.dat || exit 1

#rm -f $basedir/img/*

energy_cost=0.12
blocks_data=data/bitcoin-blocks.dat
mtgox_data=data/mtgox-btc-usd.dat

$basedir/grapher -self-cost -coins-type bitcoins -hashrate 82000000000 -power 700 -blocks-data $blocks_data -energy-cost $energy_cost > data/avalion_asic_2_bitcoin_mining_cost.dat || exit 1
$basedir/grapher -amortized-self-cost 31536000. -coins-type bitcoins -hashrate 82000000000 -power 700 -blocks-data $blocks_data -energy-cost $energy_cost -hardware-cost 1499 > data/avalion_asic_2_bitcoin_mining_cost_with_1_year_amortization.dat || exit 1
$basedir/grapher -self-cost -coins-type bitcoins -hashrate 685000000 -power 250 -blocks-data $blocks_data -energy-cost $energy_cost > data/ati_7970_bitcoin_mining_cost.dat || exit 1
$basedir/grapher -amortized-self-cost 31536000. -coins-type bitcoins -hashrate 685000000 -power 250  -blocks-data $blocks_data -energy-cost $energy_cost -hardware-cost 399 > data/ati_7970_bitcoin_mining_cost_with_1_year_amortization.dat || exit 1
$basedir/grapher -self-cost -coins-type bitcoins -hashrate 2270000 -power 65 -blocks-data $blocks_data -energy-cost $energy_cost > data/pentium_dual-core_e5400_mining_cost.dat || exit 1

$basedir/grapher -profitability -coins-type bitcoins -hashrate 82000000000 -power 700 -blocks-data $blocks_data -market-rate-data $mtgox_data -energy-cost $energy_cost > data/avalon_asic_2_bitcoin_profitability.dat || exit 1
$basedir/grapher -profitability -coins-type bitcoins -hashrate 685000000 -power 250 -blocks-data $blocks_data -market-rate-data $mtgox_data -energy-cost $energy_cost > data/ati_7970_bitcoin_profitability.dat || exit 1
$basedir/grapher -profitability -coins-type bitcoins -hashrate 2270000 -power 65 -blocks-data $blocks_data -market-rate-data $mtgox_data -energy-cost $energy_cost > data/pentium_dual-core_e5400_bitcoin_profitability.dat || exit 1

cp $basedir/data/btc-e-ltc-usd.dat data/
$basedir/grapher -profitability -coins-type litecoins -hashrate 650000 -power 250 -blocks-data data/litecoin-blocks.dat -market-rate-data data/btc-e-ltc-usd.dat -energy-cost $energy_cost > data/ati_7970_litecoin_profitability.dat || exit 1

$basedir/grapher -self-cost -coins-type litecoins -hashrate 650000 -power 250 -blocks-data data/litecoin-blocks.dat -energy-cost $energy_cost > data/ati_7970_litecoin_mining_cost.dat || exit 1
$basedir/grapher -amortized-self-cost 31536000. -coins-type litecoins -hashrate 650000 -power 250  -blocks-data data/litecoin-blocks.dat -energy-cost $energy_cost -hardware-cost 399 > data/ati_7970_litecoin_mining_cost_with_1_year_amortization.dat || exit 1

mkdir -p img
$basedir/draw-graphs.gnuplot || exit 1
mkdir -p графики
$basedir/draw-graphs-ru.gnuplot || exit 1

unison -batch -silent img/ $dst || exit 1
unison -batch -silent графики/ `readlink -f $dst/../графики/` || exit 1
