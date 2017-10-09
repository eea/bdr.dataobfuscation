#!/usr/bin/python
from genshi.template import NewTextTemplate
from genshi.template import TemplateLoader
import MySQLdb
import hashlib
import os
import sys

LDIF_TYPE = "full"

if len(sys.argv) == 2 and sys.argv[1] in ["full", "eionet", "bdr"]:
    LDIF_TYPE = sys.argv[1]


def make_secret(password):
    """
    Encodes the given password as a base64 SSHA hash+salt buffer
    """
    salt = os.urandom(4)

    # hash the password and append the salt
    sha = hashlib.sha1(password)
    sha.update(salt)

    # create a base64 encoded string of the concatenated digest + salt
    digest_salt_b64 = '{}{}'.format(sha.digest(), salt).encode('base64').strip()

    # now tag the digest above with the {SSHA} tag
    tagged_digest_salt = '{{SSHA}}{}'.format(digest_salt_b64)

    return tagged_digest_salt

db = MySQLdb.connect(host='localhost',
                     user='root',
                     passwd=os.environ['MYSQL_ROOT_PASSWORD'],
                     db=os.environ['DB_NAME'])

cursor = db.cursor()
cursor.execute('SELECT * FROM bdr_registry_account')

loader = TemplateLoader([os.getcwd()])
tmpl = loader.load('ldap_template.txt', cls=NewTextTemplate)

with open('bdr.ldif', 'w') as f:
    e_users = []
    b_users = []
    if LDIF_TYPE in ["full", "eionet"]:
        e_users = []
        with open('eionet.users', 'r') as e_users_f:
            for user in e_users_f:
                user = user.rstrip('\n').split(':')
                e_users.append({"user": user[0],
                                "password": make_secret(user[1])})
    if LDIF_TYPE in ["full", "bdr"]:
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
                b_users.append({
                    'user': row[1],
                    'password': make_secret(row[2]),
                    'country': country,
                    'company': company
                })
            except:
                continue
    stream = tmpl.generate(eionetitems=e_users, bdritems=b_users)
    f.write(stream.render())

db.close()
