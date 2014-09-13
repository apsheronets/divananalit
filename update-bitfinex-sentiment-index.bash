#!/bin/bash

source $HOME/.rvm/scripts/rvm
basedir=`dirname $0`

export DISPLAY=:10

ruby $basedir/get-bitfinex-sentiment-index.rb $basedir/data/bitfinex-sentiment-index.dat
killall iceweasel
