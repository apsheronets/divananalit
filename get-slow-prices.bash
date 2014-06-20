#!/bin/bash

source $HOME/.rvm/scripts/rvm
basedir=`dirname $0`

ruby $basedir/get-btce-btc-usd.rb
ruby $basedir/get-btce-ltc-btc.rb
ruby $basedir/get-btce-ltc-usd.rb
ruby $basedir/get-mtgox-btc-usd.rb

