#!/bin/sh

cd $1
pip install -r requirements.txt -t .
#python3 -m pip install --system -r requirements.txt -t $(pwd)
