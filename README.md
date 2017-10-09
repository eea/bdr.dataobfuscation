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

    $ ./bdr.registry.sh


### Ldap instructions

After the BDR-registry data obfuscation, ldap database must be updated with the new accounts. This script will generate a ldif file named _bdr.ldif_, in the current directory, ready for import.

Calling the script without any arguments will generate a full dummy data ldif, for the eionet branch and the Business Reporters branch. In order to properly populate the eionet branch with users, it expects the eionet.users file to be filled with `user:password` entries, one entry for each line. There is an eionet.users.example file which can be renamed to eionet.users and populated with the desired values

    $ ./ldap.sh

If only the Business Reporters branch is to be populated, calling the script with:

    $ ./ldap.sh bdr

will populate only the Business Reporters branch, but still create the initial structure for the eionet branch.

If only the eionet branch should be populated, the script can be called with:

    $ ./ldap.sh eionet

The template for the ldif is defined in the ldap_template.txt template file.
