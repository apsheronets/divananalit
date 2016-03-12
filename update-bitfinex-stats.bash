#!/bin/bash

source $HOME/.rvm/scripts/rvm
basedir=`dirname $0`

export DISPLAY=:10

ruby $basedir/get-bitfinex-stats.rb $basedir/data/
killall -q iceweasel
