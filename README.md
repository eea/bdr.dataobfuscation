# bdr.dataobfuscation
BDR Data Obfuscation Script

This repository contains two scripts which obfuscate data from bdr registry database and generate a ldif file for LDAP account changes.

## Bdr registry Data Obfuscation
The repository contains a script which obfuscates persons and companies data from bdr registry database.

### Requirements
  1. Access to the bdr registry database container.
  2. A database dump.

### How to use

1. Clone this project:

        $ git clone https://github.com/eea/bdr.registry.dataobfuscation.git

2. Create env file from example and fill its variables:

        $ cp .bdr-registry.env.example .bdr-registry.env
    
3. Copy files required into the container:

        $ cd bdr.dataobfuscation
        $ docker cp bdr.registry.dataobfuscation.sh <mysql_container>:hide_data.sh
        $ docker cp dump.sql <mysql_container>:dump.sql
        $ docker cp .bdr-registry.env <mysql_container>:.bdr.registry.env

4. Access the container:

        $ docker exec -it <mysql_container> bash

5. Set environment variables:
    
        $ source .bdr-registry.env

6. Run the script:
    
        $ hide_data.sh
    
    
## Ldap Data Obfuscation
  After bdr registry data obfuscation, ldap must be updated with the new accounts. The repo contains a script that generates   a ldif file. 
### Requirements
 
  1. Access to the bdr registry database container.
  
### How to use
1. Clone this project:

        $ git clone https://github.com/eea/bdr.registry.dataobfuscation.git

2. Create env file from example and fill its variables:
   
        $ cp .generate_ldif.env.example .generate_ldif.env
 
3. Copy files required into the container:

        $ cd bdr.dataobfuscation
        $ docker cp generate_ldif.sh <mysql_container>:generate_ldif.sh
        $ docker cp generate_ldif.py <mysql_container>:generate_ldif.py
        $ docker cp .generate_ldif.env <mysql_container>:.generate_ldif.env
    
4. Access the container:

        $ docker exec -it <mysql_container> bash
    
5. Set environment variables:

        $ source .generate_ldif.env

6. Run the script:

        $ generate_ldif.sh

7. Copy script outside docker (optional):

        $ docker cp <mysql_container>:bdr.ldif bdr.ldif
