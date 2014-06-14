#!/bin/bash
while true; do for sym in usd btc ltc; do curl -s https://api.bitfinex.com/v1/lendbook/$sym | ruby ./bitfinex-lendbook-parser.rb data/bitfinex-lendbook-${sym}.dat; sleep 10; done;
