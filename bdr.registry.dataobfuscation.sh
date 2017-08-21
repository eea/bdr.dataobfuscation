#!/bin/sh

mysql -u root -p$MYSQL_ROOT_PASSWORD << EOF
create database  IF NOT EXISTS bdr_copy;
EOF

mysql -u root -p$MYSQL_ROOT_PASSWORD bdr_copy < dump.sql

mysql -u root -p$MYSQL_ROOT_PASSWORD << EOF

use bdr_copy;

update bdr_registry_company set name = concat('ORG', SHA1(name)),
                                addr_street = 'Kongens Nytorv 6, 1050 Copenhagen Denmark',
                                addr_postalcode = concat('CP', SHA1(addr_postalcode)),
                                vat_number = 'VAT0000',
                                website = concat('htttp://www.x', SHA1(website), '.com');

update bdr_registry_companynamehistory set name = concat('ORG', SHA1(name));

update bdr_registry_person set family_name = concat('LNAME', id),
			                   first_name = concat('FNAME', SHA1(first_name)),
			                   email = concat(SHA1(email), 'EMAIL@climaOds2010.yyy'),
			                   phone = concat(000, SHA1(phone), 000),
                               fax = concat(000, SHA1(fax) , 000);

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


