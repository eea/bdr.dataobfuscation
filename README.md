# BDR Data Obfuscation Script

This repository contains two scripts which obfuscate data from bdr registry database and generate a ldif file for LDAP account changes.

The repository contains a script which obfuscates persons and companies data from BDR-registry database.


### Prerequisites

1. Clone this project:

        $ git clone https://github.com/eea/bdr.registry.dataobfuscation.git
        $ cd bdr.registry.dataobfuscation

2. Set the target BDR-registry database name, the MySQL root password and a default password for all company accounts:

        $ cp mysql.env.example mysql.env
        $ vi mysql.env
        $ source mysql.env


### BDR-registry instructions

The obfuscation script expects to find the source database file in the same folder under the name _dump.sql_. The target database should exists in a local MySQL server.

**WARNING: The existing target database will be overwritten!**

    $ ./bdr.registry.dataobfuscation.sh


### Ldap instructions

After the BDR-registry data obfuscation, ldap database must be updated with the new accounts. This script will generate a ldif file named _bdr.ldif_, in the current directory, ready for import.

    $ ./ldap.sh

