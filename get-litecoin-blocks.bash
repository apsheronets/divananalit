#!/bin/bash

basedir=`dirname $0`
wget -q -c http://komar.lexs.blasux.ru/litecoin-blocks-difficulty -O $basedir/data/litecoin-blocks
