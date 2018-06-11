#!/usr/bin/python
#
# parses CMP website like other table but shoves data into a database and 
# executes at a different frequency than the other one

from bs4 import BeautifulSoup
import requests
from datetime import datetime
import MySQLdb as mdb

r = requests.get('http://www3.cmpco.com/OutageReports/CMP.html')

soup = BeautifulSoup(r.text)
table = soup.find('table')

ts = datetime.now().isoformat(' ')

rows = []
i = 0

try:
    for row in table.find_all('tr'):
        i = i + 1
        if (i<4): continue
        rows.append([val.text.encode('utf8').replace(",", "") for val in row.find_all('td')])

    del rows[-1]

    con = mdb.connect('DBHOST', 'USER', 'PASS', 'DB')
    cur = con.cursor()

    for row in rows:
        cur.execute("INSERT INTO outage VALUES (%s,%s,%s,%s);", (ts, row[0], row[1], row[2]))
        con.commit()
    con.close()

except:
    pass


# Database schema:
#
# CREATE TABLE outage (
#   ts VARCHAR(30),
#   county VARCHAR(50),
#   population INT,
#   withoutpower INT
# )