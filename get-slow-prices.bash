#!/bin/bash

source $HOME/.rvm/scripts/rvm
basedir=`dirname $0`

ruby $basedir/get-btce-btc-usd.rb > $basedir/data/btc-e-btc-usd-fresh.dat
ruby $basedir/get-btce-ltc-btc.rb > $basedir/data/btc-e-ltc-btc.dat
ruby $basedir/get-btce-ltc-usd.rb > $basedir/data/btc-e-ltc-usd.dat
ruby $basedir/get-mtgox-btc-usd.rb > $basedir/data/mtgox-btc-usd-fresh.dat

