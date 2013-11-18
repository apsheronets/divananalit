#!/bin/bash
# 36 is for 6 hours resolution
wget http://blockexplorer.com/q/nethash/18 -O data/bitcoin-blocks.csv || exit 1
tail -n +16 data/bitcoin-blocks.csv > data/bitcoin-blocks-wo-header.csv
rm -f data/bitcoin-blocks.dat
ruby csv-unixtime-to-dat.rb data/bitcoin-blocks-wo-header.csv data/bitcoin-blocks.dat
rm -f data/bitcoin-blocks-wo-header.csv
