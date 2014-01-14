#!/bin/bash

basedir=`dirname $0`

wget -q http://komar.lexs.blasux.ru/litecoin-blocks-difficulty -O data/litecoin-blocks || exit 1
ruby $basedir/unixtime-to-dat.rb data/litecoin-blocks data/litecoin-blocks.dat || exit 1

