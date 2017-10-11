#!/bin/sh

function help {
    printf "Valid arguments are:\n"
    printf "\t--type=full|eionet|bdr\n"
    printf "\t--rootuid=<uid_of_the_root_user>\n"
    printf "\t--rootpw=<password_for_the_root_user>\n"
    exit 1
}

if [ $# -eq 0 ]; then
    help
fi

while [ $# -gt 0 ]; do
  case "$1" in
    --type=*)
      type="${1#*=}"
      ;;
    --rootuid=*)
      rootuid="${1#*=}"
      ;;
    --rootpw=*)
      rootpw="${1#*=}"
      ;;
    *)
      printf "***************************\n"
      printf "* Error: Invalid argument.*\n"
      printf "***************************\n"
      exit 1
  esac
  shift
done

if [[ -n $type && -n $rootuid && -n $rootpw ]]; then
    runDeps="gcc virtualenv python-pip python-dev libmysqlclient-dev python-genshi"
    apt-get update -y \
    && apt-get install -y --no-install-recommends $runDeps

    virtualenv -p python2.7 venv

    . venv/bin/activate

    pip install MySQL-python Genshi

    python generate_ldif.py $type $rootuid $rootpw

    deactivate

    rm -r venv
else
    help
fi
