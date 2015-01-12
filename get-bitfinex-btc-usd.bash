#!/bin/bash

source $HOME/.rvm/scripts/rvm
basedir=`dirname $0`

filename=bitfinex-btc-usd.dat
tmpfile=/tmp/${filename}-`date +%s`

curl 'http://bitcoincharts.com/charts/chart.json?m=bitfinexUSD&SubmitButton=Draw&r=&i=&c=0&s=&e=&Prev=&Next=&t=S&b=&a1=&m1=10&a2=&m2=25&x=0&i1=&i2=&i3=&i4=&v=1&cv=1&ps=0&l=0&p=0&' | ruby parse-bitcoincharts-raw-data.rb > $tmpfile
mv $tmpfile $basedir/data/${filename}
