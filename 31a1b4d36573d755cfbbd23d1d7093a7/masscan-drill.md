Simple scan for some ports on a part of vodafone's ranges:

    masscan -p445,80,22,23,21 --range 93.147.0.0/22 --output-format=json --output-file=vodafone.json

Remove the trailing `,`:

    sed -i .bak -e 's/,$//' vodafone.json

Getting Drill up and running is an exercise left to the reader but Drill standalone shld "just work".

Move `vodafone.json` to a filesystem area you can easily reference (`/tmp` initially wld work for a quick run) then do something like this in the SQL query. You need to "flatten" the array then extract the fields from the still-nested JSON. This is often confusing at-first in Drill so here's a sample query:

    SELECT t.ip, t.ts, t.ports.port AS port, t.ports.proto AS proto
    FROM
      ( SELECT ip, `timestamp` AS ts, flatten(ports) AS ports 
        FROM dfs.tmp.`vodafone.json`) t

![](https://rud.is/dl/masscan-drill.png)

Now you can use other tables to join/filter/etc.

