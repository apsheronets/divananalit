#!/bin/bash
today=`date +%Y-%m-%d`
wget "http://www.quandl.com/api/v1/datasets/BITCOIN/MTGOXUSD.csv?&trim_start=2010-07-17&trim_end=${today}&collapse=daily&sort_order=desc" -O data/mtgox-btc-usd.csv
tail -n +2 data/mtgox-btc-usd.csv > data/mtgox-btc-usd-wo-header.csv
sed -i 's/-//g'  data/mtgox-btc-usd-wo-header.csv
sed -i 's/,/ /g' data/mtgox-btc-usd-wo-header.csv
cp data/mtgox-btc-usd-wo-header.csv data/mtgox-btc-usd.dat
rm -f data/mtgox-btc-usd-wo-header.csv
