#!/bin/bash
source ../configuration.cfg

rm -rf ./bin/*.update
mkdir -p ./bin

cd src
make $TARGET_TYPE
if [ $? = 0 ]
then
	cp *.update ../bin
fi
make clean
cd ../
