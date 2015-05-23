#!/bin/bash

source $HOME/.rvm/scripts/rvm
basedir=`dirname $0`

cd $basedir
while true; do bundle exec ruby bitfinex-trades.rb; done
