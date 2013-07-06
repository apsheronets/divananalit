#!/bin/bash
wget http://explorer.litecoin.net/chain/Litecoin/q/nethash -O data/litecoin-blocks
tail -n +18 data/litecoin-blocks > data/litecoin-blocks-wo-header.csv
rm -f data/litecoin-blocks.dat
ruby csv-unixtime-to-dat.rb data/litecoin-blocks-wo-header.csv data/litecoin-blocks.dat
rm -f data/litecoin-blocks-wo-header.csv
