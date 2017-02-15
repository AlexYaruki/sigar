#!/usr/bin/env bash

rm -rf sigar
git clone https://github.com/AlexYaruki/sigar
cd sigar
mkdir build
cd build
cmake .. && make && make test
