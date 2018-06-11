https://publicwww.com/websites/NoSuchBucket/

aws s3 mb s3://BUCKET_NAME
aws s3 cp SOMEFILE s3://BUCKET_NAME SOMEFILE

{
 "Version":"2018-01-01",
 "Statement":[{"Sid":"AddPerm","Effect":"Allow","Principal": "*",
 "Action":["s3:GetObject"],
 "Resource":["arn:aws:s3:::BUCKET_NAME/*"] }]
}

aws s3api put-bucket-policy --bucket BUCKET_NAME --policy THE_ABOVE_POLICY
aws s3 website s3://BUCKET_NAME --index-document SOMEFILE_FROM_ABOVE

BUCKET_NAME.s3-website-us-east-1.amazonaws.com


{"LoggingEnabled":{"TargetBucket":"SOME_BUCKET_YOU_OWN","TargetPrefix": "PREFIX-" }}

aws s3api put-bucket-logging --bucket=BUCKET_NAME file://WHERE_YOU_STORED ^^