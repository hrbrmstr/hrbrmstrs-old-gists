import csv
import geoip2.database

# yeah, despite having a nice long int, the city lookup function
# requires a string so we have to do this
  
def to_string(ip):
  return ".".join(map(lambda n: str(ip>>n & 0xFF), [24,16,8,0]))
  
# you'll need to download the city database and point this to it
	
reader = geoip2.database.Reader('GeoLite2-City.mmdb')
  
with open('marx.csv', 'rb') as marx:
  with open('marx-geo.csv', 'w') as f:
    flyreader = csv.reader(marx, delimiter=',', quotechar='"')
    for fly in flyreader:
      strIP = to_string(int(fly[2]))
      try: # sometimes the city function coughs up blood
        r = reader.city(strIP)
        f.write("%s%s,%s,%s,%s,%s,%s,%s,%s\n" % 
                                    (','.join(fly),
                                     strIP,
                                     r.country.iso_code,
                                     r.country.name, 
                                     r.subdivisions.most_specific.name,
                                     r.subdivisions.most_specific.iso_code,
                                     r.postal.code,
                                     r.location.latitude,
                                     r.location.longitude))
      except:
        f.write("%s%s,,,,,,,,\n" % (','.join(fly), strIP))
