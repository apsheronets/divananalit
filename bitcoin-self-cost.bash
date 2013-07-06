#!/bin/bash
make bitcoin_self_cost
./get-bitcoin-blocks.bash
./get-mtgox-btc-usd.bash
./bitcoin_self_cost < data/bitcoin-blocks.dat > data/bitcoin-self-cost.dat
./bitcoin-self-cost.gnuplot
