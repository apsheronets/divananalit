#!/bin/bash
make bitcoin_profitability
./get-bitcoin-blocks.bash
./get-mtgox-btc-usd.bash
./bitcoin_profitability > data/bitcoin-profitability.dat
./bitcoin-profitability.gnuplot
