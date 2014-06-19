#!/bin/bash
source $HOME/.rvm/scripts/rvm
cd /home/komar/divananalit-working-copy/
make -s bitfinex-lendbooks
unison -batch -silent img/ /home/komar/divananalit/graphs/
