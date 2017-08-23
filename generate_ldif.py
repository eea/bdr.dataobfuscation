#!/usr/bin/python
import hashlib
import MySQLdb
import os

db = MySQLdb.connect(host='localhost',
                     user='root',
                     passwd=os.environ['MYSQL_ROOT_PASSWORD'],
                     db=os.environ['DB_NAME'])

cursor = db.cursor()
cursor.execute('SELECT * FROM bdr_registry_account')

with open('bdr.ldif', 'w') as f:
    f.writelines(
        'dn: ou=Business Reporters,o=EIONET,l=Europe \n'
        'ou: Business Reporters \n'
        'description: Users who report to the Business Reportnet \n'
        'objectClass: top \n'
        'objectClass: organizationalUnit \n'
        'structuralObjectClass: organizationalUnit \n\n'
     )
    for row in cursor.fetchall():
        try:
            cursor2 = db.cursor()
            cursor2.execute(
                'select c.name, country.name from bdr_registry_company'
                ' c inner join bdr_registry_account a on'
                ' (c.account_id=a.id) inner join bdr_registry_country '
                'country on (c.country_id=country.id) where a.id = {0};'.format(
                    row[0]
                )
            )
            company, country = cursor2.fetchone()
            sha_1 = hashlib.sha1()
            sha_1.update(row[2])
            kwargs ={
                'uid': row[1],
                'pass': sha_1.hexdigest(),
                'country': country,
                'company': company
            }
            f.writelines([(
                'dn: uid={uid},ou=Business Reporters,o=EIONET,l=Europe \n'
                'uid: {uid} \n'
                'cn: {company} / {country} \n'
                'objectClass: top \n'
                'objectClass: organizationalRole \n'
                'objectClass: simpleSecurityObject \n'
                'objectClass: uidObject \n'
                'structuralObjectClass: organizationalRole \n'
                'userPassword: {pass} \n\n'.format(**kwargs))
            ])

        except:
            continue

db.close()
