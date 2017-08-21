# bdr.registry.dataobfuscation
BDR-Registry Data Obfuscation Script

This repository contains a script which obfuscates persons and companies data from bdr registry database.

## Requirements
  
  1. Access to the bdr registry database container.
  2. A database dump.

## How to use

1. Clone this project:
    ```
    $ git clone https://github.com/eea/bdr.registry.dataobfuscation.git
    ```
2. Create env file from example and fill its variables:
  ```
    $ cp bdr-registry.env.example bdr-registry.env
  ```
3. Copy the dump and the script file into the container:
    ```
    $ cd bdr.registry.dataobfuscation
    $ docker cp bdr.registry.dataobfuscation.sh <mysql_container>:hide_data.sh
    $ docker cp dump.sql <mysql_container>:dump.sql
    $ docker cp .bdr-registry.env <mysql_container>:bdr.registry.env
    ```

4. Access the container:
    ```
    $ docker exec -it <mysql_container> bash
    ```
5. Set environment variables:
    ```
    $ source .bdr-registry.env
    ```
6. Run the script:
    ```
    $ hide_data.sh
    ```
