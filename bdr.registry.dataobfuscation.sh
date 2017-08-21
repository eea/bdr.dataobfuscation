#!/bin/sh

echo Importing...

mysql -u root -p$MYSQL_ROOT_PASSWORD << EOF
create database  IF NOT EXISTS bdr_copy;
EOF

mysql -u root -p$MYSQL_ROOT_PASSWORD bdr_copy < dump.sql

mysql -u root -p$MYSQL_ROOT_PASSWORD << EOF

use bdr_copy;

update bdr_registry_company set name = concat('NMORGANIZATION', id),
                                addr_street = concat('NMSTREET', id),
                                addr_postalcode = concat('CP', id),
                                vat_number = concat('VAT', id),
                                website = concat('htttp://www.x', id, '.com');

update bdr_registry_companynamehistory set name = concat('NMORGANIZATION', company_id);

update bdr_registry_person set family_name = concat('LNAME', id),
			                   first_name = concat('FNAME', id),
			                   email = concat(id, 'EMAIL@climaOds2010,yyy'),
			                   phone = concat(000, id, 000),
                               fax = concat(000, id , 000);

update bdr_registry_comment set text = '';

update bdr_registry_account set uid = concat('uid', id),
				password = concat('pass', id);

drop database $DB_NAME;

EOF

mysqldump -uroot -p$MYSQL_ROOT_PASSWORD  bdr_copy  > altered_dump.sql


mysql -u root -p$MYSQL_ROOT_PASSWORD << EOF
create database $DB_NAME;
drop database bdr_copy;
EOF

mysql -uroot -p$MYSQL_ROOT_PASSWORD $DB_NAME < altered_dump.sql

rm -r altered_dump.sql


