#!/bin/bash
source $HOME/.rvm/scripts/rvm
basedir=`dirname $0`
while true; do for sym in usd btc ltc eth; do curl -s "https://api.bitfinex.com/v1/lendbook/${sym}?limit_asks=9999&limit_bids=9999" | ruby $basedir/bitfinex-lendbook-parser.rb data/bitfinex-lendbook-${sym}.dat; sleep 3; done; done;
