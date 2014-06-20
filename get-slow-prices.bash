#!/bin/bash

source $HOME/.rvm/scripts/rvm
basedir=`dirname $0`

ruby $basedir/get-btce-btc-usd.rb >      /tmp/btc-e-btc-usd-fresh.dat
mv /tmp/btc-e-btc-usd-fresh.dat $basedir/data/btc-e-btc-usd-fresh.dat
ruby $basedir/get-btce-ltc-btc.rb > /tmp/btc-e-ltc-btc.dat
mv /tmp/btc-e-ltc-btc.dat  $basedir/data/btc-e-ltc-btc.dat
ruby $basedir/get-btce-ltc-usd.rb > /tmp/btc-e-ltc-usd.dat
mv /tmp/btc-e-ltc-usd.dat  $basedir/data/btc-e-ltc-usd.dat
ruby $basedir/get-mtgox-btc-usd.rb >     /tmp/mtgox-btc-usd-fresh.dat
mv /tmp/mtgox-btc-usd-fresh.dat $basedir/data/mtgox-btc-usd-fresh.dat

