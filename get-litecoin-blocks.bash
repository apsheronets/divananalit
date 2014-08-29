#!/bin/bash

basedir=`dirname $0`
wget -q -c http://komar.lexs.blasux.ru:8888/litecoin-blocks-difficulty -O $basedir/data/litecoin-blocks
