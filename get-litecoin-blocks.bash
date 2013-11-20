#!/bin/bash

basedir=`dirname $0`

wget http://explorer.litecoin.net/chain/Litecoin/q/nethash -O data/litecoin-blocks || exit 1
tail -n +18 data/litecoin-blocks > data/litecoin-blocks-wo-header.csv || exit 1
rm -f data/litecoin-blocks.dat
ruby $basedir/csv-unixtime-to-dat.rb data/litecoin-blocks-wo-header.csv data/litecoin-blocks.dat || exit 1
rm -f data/litecoin-blocks-wo-header.csv
