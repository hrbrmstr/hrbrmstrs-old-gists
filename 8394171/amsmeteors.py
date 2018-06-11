import urllib2
from bs4 import BeautifulSoup

soup = BeautifulSoup(urllib2.urlopen("http://www.amsmeteors.org/observations/").read())

rows = soup.findChildren('table')[0].findChildren

for row in t[0].findAll('tr')[1:]:

    col = row.findAll('td')

    ts = col[0].string.encode('ascii',errors='ignore').replace("\r\n\ \t","").strip()
    lat, c, lon = col[1].string.encode('ascii',errors='ignore').split()
    facing = col[2].string.encode('ascii',errors='ignore').strip("\r\n\t\ ")
    method = col[3].string.encode('ascii',errors='ignore').strip("\r\n\t\ ")
    alt = col[4].string.encode('ascii',errors='ignore').strip("\r\n\t\ ").replace(",","").replace("m","").replace("-","0")

    record = (ts, l1, l2, facing, method, alt)
    
    # replace print(...) with a file write
    print(",".join(record))