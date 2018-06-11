// booktracker.js
// by @hrbrmstr (2013)
// MIT license
//
// run this mongo query on the command line and redirect to a CSV file:
//   $MONGO_BIN/mongo --quiet $DBNAME booktracker.js > $OUTPUT_LOCATION/book.csv
//
// stick it in the same cron job you have booktracker.py running

db.amzn.find({  }, { 'ItemLookupResponse.Items.Item.SalesRank' : 1, 
                     'ItemLookupResponse.Items.Item.ItemAttributes.ListPrice.Amount' : 1 , 
					 'ts':1, _id:0} ).sort({ ts: 1 } ).forEach(function(res) {
   print(res.ts.toISOString()+","+res.ItemLookupResponse.Items.Item.SalesRank);
}) ;