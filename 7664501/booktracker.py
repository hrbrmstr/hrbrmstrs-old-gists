# booktracker.py - track a book on AMZN by ISBN
# by @hrbrmstr (2013)
# MIT license
#
# run this in a cron job to update a mongo db with amzn book info
#
import base64
import hashlib
import hmac
import time
import datetime
import urllib2
import ConfigParser
import xmltodict

from urllib import urlencode, quote_plus

# gotta do all this to build a URL we can send to AMZN to process
def amazon_aws_url_from_isbn(book_isbn):

    # need to setup a config file with AWS creds in it
    # the cconfig file format should look like:
    #
    # [amzn]
    # AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY
    # AWS_SECRET_ACCESS_KEY=YOUR_SEEKRIT_ACCESS_KEY
    # AWS_ASSOCIATE_TAG=YOUR_ASSOCIATE_TAG
    #
    # take a look here for how to get these:
    # https://portal.aws.amazon.com/gp/aws/securityCredentials
    
    CONFIG_FILE = "freerank.conf"
    Config = ConfigParser.ConfigParser()
    Config.read(CONFIG_FILE)

    AWS_ACCESS_KEY_ID = Config.get("amzn","AWS_ACCESS_KEY_ID")
    AWS_SECRET_ACCESS_KEY = Config.get("amzn","AWS_SECRET_ACCESS_KEY")  

    amzn_base_url = "http://ecs.amazonaws.com/onca/xml"

    url_params = dict(
        Service='AWSECommerceService', 
        Operation='ItemLookup', 
        SearchIndex='Books',
        IdType='ISBN', 
        ItemId=book_isbn,
        AssociateTag =Config.get("amzn","AWS_ASSOCIATE_TAG"),
        AWSAccessKeyId=AWS_ACCESS_KEY_ID,  
        ResponseGroup='Images,ItemAttributes,EditorialReview,SalesRank')

    # GMT timestamp
    url_params['Timestamp'] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())

    # url string is picky so gotta sort the URL parameters by key
    keys = url_params.keys()
    keys.sort()

    # same for values
    values = map(url_params.get, keys)

    # build/encode url
    url_string = urlencode(zip(keys,values))

    pre_sign = "GET\necs.amazonaws.com\n/onca/xml\n%s" % url_string

    # sign req
    signature = hmac.new(
        key=AWS_SECRET_ACCESS_KEY,
        msg=pre_sign,
        digestmod=hashlib.sha256).digest()

    # encode sig
    signature = base64.encodestring(signature).strip()

    # quote sig
    urlencoded_signature = quote_plus(signature)
    url_string += "&Signature=%s" % urlencoded_signature

    return("%s?%s" % (amzn_base_url, url_string))

# put your ISBN here, obviously :-)
book_url = urllib2.urlopen(amazon_aws_url_from_isbn('1118793722'))
book_xml = book_url.read()
book_dict = xmltodict.parse(book_xml)

# the JSON is kinda ugly, so add our own timestamp
book_dict['ts'] = datetime.datetime.utcnow()

# shove the whole JSON into Mongo (never know when you need it)
# prbly want to change out BOOK_DATABASE_NAME
client = MongoClient('mongodb://localhost:27017/')
db = client.BOOK_DATABASE_NAME
db.amzn.insert(book_dict)