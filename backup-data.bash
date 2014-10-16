#!/bin/bash
ssh divananalit.org 'cp -a /home/komar/divananalit-working-copy/data /tmp/data' && unison ssh://divananalit.org//tmp/data data/; ssh divananalit.org 'rm -r /tmp/data/'
