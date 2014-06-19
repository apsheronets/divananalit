#!/bin/bash

basedir=`dirname $0`
# 36 is for 6 hours resolution
wget -q http://blockexplorer.com/q/nethash/18 -O /tmp/bitcoin-blocks.csv
mv /tmp/bitcoin-blocks.csv $basedir/data/bitcoin-blocks.csv
rm -f /tmp/bitcoin-blocks.csv
