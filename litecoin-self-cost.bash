#!/bin/bash
make litecoin_self_cost
./get-litecoin-blocks.bash
# please get litecoin rates from http://www.cryptocoincharts.info/period-charts.php?period=alltime&resolution=day&pair=ltc-usd&market=btc-e by yourself
./litecoin_self_cost < data/litecoin-blocks.dat > data/litecoin-self-cost.dat
./litecoin-self-cost.gnuplot
