#!/usr/bin/python
# generate CSV from outages

from bs4 import BeautifulSoup
import requests

r = requests.get('http://www3.cmpco.com/OutageReports/CMP.html')

soup = BeautifulSoup(r.text)
table = soup.find('table')

rows = []
i = 0

for row in table.find_all('tr'):
    i = i + 1
    if (i<4): continue
    rows.append([val.text.encode('utf8').replace(",", "") for val in row.find_all('td')])

if len(rows) > 0:
    del rows[-1]

f = open("/output/dir/current.csv","w")
f.write("county,population,withoutpower\n")
for row in rows:
    f.write("%s,%s,%s\n" % (row[0].title(), row[1], row[2]))
f.close()