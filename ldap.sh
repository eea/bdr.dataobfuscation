#!/bin/sh

runDeps="gcc virtualenv python-pip python-dev libmysqlclient-dev"
apt-get update -y \
&& apt-get install -y --no-install-recommends $runDeps

virtualenv -p python2.7 venv

. venv/bin/activate

pip install MySQL-python

python generate_ldif.py

deactivate

rm -r venv

