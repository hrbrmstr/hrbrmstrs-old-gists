#!/usr/bin/python

import urllib2
from urlparse import urljoin
import sys
from bs4 import BeautifulSoup

if len(sys.argv) < 2:
   print "Usage:\n   hrefs url [url] ..."
   sys.exit(1)

for URL in sys.argv[1:]:

   headers = { 'User-Agent' : 'Mozilla/4.0 (compatible; MSIE 5.5; Windows NT)' }
   req = urllib2.Request(URL, None, headers)

   soup = BeautifulSoup(urllib2.urlopen(req))
   links = soup.find_all('a')
   for link in links:
      print urljoin(URL,link.get('href'))