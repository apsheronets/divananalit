#!/bin/bash

source $HOME/.rvm/scripts/rvm
basedir=`dirname $0`

cd $basedir
curl -s 'https://api.bitfinex.com/v1/book/btcusd?group=0' | bundle exec ruby ./bitfinex-orderbook.rb
