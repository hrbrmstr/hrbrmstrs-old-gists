#!/bin/bash
# hack to dump each county outage timeline to a CSV file
# YOU SHOULD USE THE R VERSION INSTEAD!

# it doesn't look like CMP serves all Maine counties
COUNTIES=( CUMBERLAND HANCOCK KNOX LINCOLN SAGADAHOC OXFORD WALDO KENNEBEC ANDROSCOGGIN FRANKLIN PISCATAQUIS SOMERSET YORK PENOBSCOT )
OUTPUTDIR="/your/output/dir/outage/data"
TMPDIR="/your/temp/dir"
DBNAME="yourdbname"

for COUNTY in ${COUNTIES[@]}; do

	rm $OUTPUTDIR/$COUNTY.csv

	echo "SELECT ts, withoutpower
FROM outage WHERE county = '$COUNTY'
ORDER BY ts INTO OUTFILE '$OUTPUTDIR/$COUNTY.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
LINES TERMINATED BY '\n';" | mysql $DBNAME

	echo "ts,withoutPower" | cat - $OUTPUTDIR/$COUNTY.csv > $TMPDIR/out && mv $TMPDIR/out $OUTPUTDIR/$COUNTY.csv

done