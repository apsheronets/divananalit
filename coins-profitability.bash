#!/bin/bash
make litecoin_profitability
./get-litecoin-blocks.bash
./get-mtgox-btc-usd.bash
./litecoin_profitability > data/litecoin-profitability.dat

make bitcoin_profitability
./get-bitcoin-blocks.bash
./get-mtgox-btc-usd.bash
./bitcoin_profitability > data/bitcoin-profitability.dat

./coins-profitability.gnuplot
