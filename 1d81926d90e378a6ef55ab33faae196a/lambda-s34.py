from __future__ import print_function

import time
import gzip
import boto3

from urllib2 import urlopen
from datetime import datetime
from boto3.s3.transfer import S3Transfer

def download_file(url, fil):
    try:
        f = urlopen(url)
        with open("/tmp/" + fil, "wb") as local_file:
            local_file.write(f.read())
    except HTTPError, e:
        print("HTTP Error")
    except URLError, e:
        print("URL Error")

def gzip_file(fil, filz):
    with open(fil) as f_in, gzip.open(filz, 'wb') as f_out:
        f_out.writelines(f_in)

def to_s3(local_fil, bucket, fil):
    try:
        transfer = S3Transfer(boto3.client('s3'))
        transfer.upload_file(local_fil, bucket, fil)
    except:
        print("S3 Transfer Error")

def lambda_handler(event, context):
    try:
        STATION_INFO_URL = "https://api-core.thehubway.com/gbfs/en/station_information.json"
        STATION_STATUS_URL = "https://api-core.thehubway.com/gbfs/en/station_status.json"

        HUBWAY_DATA_S3_BUCKET = "hubway.data"

        TIME = time.strftime("%Y%m%d-%H%M%S")

        STATION_INFO_FIL = TIME + "-station-information.json"
        STATION_STATUS_FIL = TIME + "-station-status.json"

        download_file(STATION_INFO_URL, STATION_INFO_FIL)
        gzip_file("/tmp/" + STATION_INFO_FIL, "/tmp/" + STATION_INFO_FIL + ".gz")
        to_s3("/tmp/" + STATION_INFO_FIL + ".gz", HUBWAY_DATA_S3_BUCKET, STATION_INFO_FIL + ".gz")
        
        download_file(STATION_STATUS_URL, STATION_STATUS_FIL)
        gzip_file("/tmp/" + STATION_STATUS_FIL, "/tmp/" + STATION_STATUS_FIL + ".gz")
        to_s3("/tmp/" + STATION_STATUS_FIL + ".gz", HUBWAY_DATA_S3_BUCKET, STATION_STATUS_FIL + ".gz")
    except:
        print('Operation failed!')
        raise
    else:
        print('Operation succeeded!')
    finally:
        print('Operation complete at {}'.format(str(datetime.now())))