#!/bin/bash

source $HOME/.rvm/scripts/rvm
basedir=`dirname $0`

cd $basedir
bundle exec ruby bitfinex-trades.rb
