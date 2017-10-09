#!/bin/sh

COMMANDS="full eionet bdr"
OPTS=$1
if [ $# -eq 0 ]
  then
    OPTS="full"
fi

if [[ $COMMANDS == *"$OPTS"* ]]; then
    runDeps="gcc virtualenv python-pip python-dev libmysqlclient-dev python-genshi"
    apt-get update -y \
    && apt-get install -y --no-install-recommends $runDeps

    virtualenv -p python2.7 venv

    . venv/bin/activate

    pip install MySQL-python Genshi

    python generate_ldif.py $OPTS

    deactivate

    rm -r venv
else
    echo "Valid script arguments are one of: $COMMANDS"
fi

