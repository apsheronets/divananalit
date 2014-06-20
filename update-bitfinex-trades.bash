#!/bin/bash

source $HOME/.rvm/scripts/rvm
basedir=`dirname $0`

if [[ -f bitfinexUSD.dat ]]
then
  wget http://api.bitcoincharts.com/v1/csv/bitfinexUSD.csv.gz -O $basedir/data/bitfinexUSD.csv.gz || exit 1
  gunzip -c $basedir/data/bitfinexUSD.csv.gz | sed 's/,/ /g' > $basedir/data/bitfinexUSD.dat
  rm $basedir/data/bitfinexUSD.csv.gz
fi

last=`tail -n1 $basedir/data/bitfinexUSD.dat | cut -d ' ' -f 1`

curl -s "http://api.bitcoincharts.com/v1/trades.csv?symbol=bitfinexUSD&start=${last}" | sed 's/,/ /g' >> $basedir/data/bitfinexUSD.dat
