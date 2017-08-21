# bdr.registry.dataobfuscation
BDR-Registry Data Obfuscation Script

This repository contains a script which obfuscates persons and companies data from bdr registry database.

## Requirements
  
  1. Access to the bdr registry database container.
  2. A database dump.

## How to use

1. Clone this project:
```
    git clone git@github.com:eea/bdr.registry.dataobfuscation.git
```

2. Copy the dump and the script file into the container:

```
    cd bdr.registry.dataobfuscation
    docker cp bdr.registry.dataobfuscation.sh <mysql_container>:hide_data.sh
    docker cp dump.sql <mysql_container>:dump.sql

```

3. Access the container and run the script:

```
    docker exec -it *<mysql_container>* bash
    bash hide_data.sh

```
