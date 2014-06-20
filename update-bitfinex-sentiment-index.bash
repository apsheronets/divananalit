#!/bin/bash

source $HOME/.rvm/scripts/rvm
basedir=`dirname $0`

ruby $basedir/get-bitfinex-sentiment-index.rb $basedir/data/bitfinex-sentiment-index.dat

