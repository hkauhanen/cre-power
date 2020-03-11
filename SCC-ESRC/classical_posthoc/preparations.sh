#!/bin/bash
cp ../../*.tar.gz .
rm -rf Rbatches
tar xzf Rbatches.tar.gz
rm -rf database
tar xzf database.tar.gz
rm -rf data
tar xzf data.tar.gz
rm -rf results
mkdir results
rm -rf errout
mkdir errout
rm -rf lib
mkdir lib
Rscript install_pkg.R
rm -f *.tar.gz
