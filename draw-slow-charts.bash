#!/bin/bash
source $HOME/.rvm/scripts/rvm
cd /home/komar/divananalit-working-copy/
make charts
unison -batch -silent img/ /home/komar/divananalit/graphs/
unison -batch -silent графики/ /home/komar/divananalit/графики/
