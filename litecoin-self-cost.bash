#!/bin/bash
make litecoin_self_cost
./get-litecoin-blocks.bash
./litecoin_self_cost < data/litecoin-blocks.dat > data/litecoin-self-cost.dat
./litecoin-self-cost.gnuplot
