#!/usr/bin/python 

import tldextract

f = open("/tmp/indomains.txt")
hosts = f.readlines()
f.close()

tlds = ['.'.join(tldextract.extract(host.rstrip())[-2 : ]) for host in hosts]

f = open("/tmp/outdomains.txt","w")
f.writelines( "%s\n" % tld for tld in tlds )
f.close()
