#!/bin/sh

mysql -u root -p$MYSQL_ROOT_PASSWORD << EOF
create database  IF NOT EXISTS bdr_copy;
EOF

mysql -u root -p$MYSQL_ROOT_PASSWORD bdr_copy < dump.sql

mysql -u root -p$MYSQL_ROOT_PASSWORD << EOF

use bdr_copy;

update bdr_registry_company set name = concat('ORG-', SHA1(name)),
                                addr_street = 'Kongens Nytorv 6, 1050 Copenhagen Denmark',
                                addr_postalcode = concat('CP-', SHA1(addr_postalcode)),
                                vat_number = 'VAT-0000',
                                website = concat('http://www.', SHA1(website), '.com');

update bdr_registry_companynamehistory set name = concat('ORG-', SHA1(name));

update bdr_registry_person set family_name = concat('LAST-', SHA1(family_name)),
                               first_name = concat('FIRST-', SHA1(first_name)),
                               email = concat(SHA1(email), '@bdr-dev.eea'),
                               phone = '000000000000',
                               fax = '000000000000';

update bdr_registry_comment set text = '';

update bdr_registry_account set password = '${PASSWORD}';

drop database $DB_NAME;

EOF

mysqldump -uroot -p$MYSQL_ROOT_PASSWORD  bdr_copy  > altered_dump.sql


mysql -u root -p$MYSQL_ROOT_PASSWORD << EOF
create database $DB_NAME;
drop database bdr_copy;
EOF

mysql -uroot -p$MYSQL_ROOT_PASSWORD $DB_NAME < altered_dump.sql

rm -r altered_dump.sql


