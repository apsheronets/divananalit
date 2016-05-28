#!/bin/bash
source $HOME/.rvm/scripts/rvm
basedir=`dirname $0`
while true; do for sym in usd btc ltc eth; do curl -s https://api.bitfinex.com/v1/lendbook/$sym | ruby $basedir/bitfinex-lendbook-parser.rb data/bitfinex-lendbook-${sym}.dat; sleep 2; done; done;
