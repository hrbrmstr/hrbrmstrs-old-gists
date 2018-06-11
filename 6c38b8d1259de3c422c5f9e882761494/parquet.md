This thread <http://mail-archives.apache.org/mod_mbox/drill-user/201707.mbox/%3cCAHfzKEoYeE08GXtF3pJsCfExTJgJPj7nx9bjTnW3a=hgMJAxhQ@mail.gmail.com%3e> from the Drill mailing list has a good discussion abt that as well as this (open) JIRA <https://issues.apache.org/jira/browse/DRILL-3534>.

You can kinda do this with Spark <http://aseigneurin.github.io/2017/03/14/incrementally-loaded-parquet-files.html> but I actually like the filesystem-based manual partitions better (but that's just me).

What I tend to do is have data-source and date-based partitions for parquet files. So, say for one of our Sonar internet studies (I'll use our 3 SMTP scans for this example) I do something like:

- `/data/sonar/smtp/port25/yyyy/mm/dd/port25.parquet`
- `/data/sonar/smtp/port465/yyyy/mm/dd/port465.parquet`
- `/data/sonar/smtp/port587/yyyy/mm/dd/port587.parquet`

A

    SELECT * FROM dfs.d.`/sonar/smtp/*/*/*/*/*.parquet

on the first organizational structure will create 4 new return fields on the fly -- `dir0`, `dir1`, `dir2` and `dir3` with the scan name, yearl month and day.

Another option for the structure wld be:

- `/data/sonar/smtp/port25/yyyymmdd/port25.parquet`
- `/data/sonar/smtp/port465/yyyymmdd/port465.parquet`
- `/data/sonar/smtp/port587/yyyymmdd/port587.parquet`

A

    SELECT * FROM dfs.d.`/sonar/smtp/*/*/*.parquet
    
would result in 2 new return fields -- `dir0` and `dir1` for the scan name and "date stamp"

You can make those nicer with:

   SELECT dir0 AS scan_name, dir1 AS scan_date, ipv4_src, dport, ... FROM FROM dfs.d.`/sonar/smtp/*/*/*.parquet
   
(you can even make ^^ a `tbl()` source)

Depending on the scan file sizes, I'll also monitor query performance (if it starts to feel slow) and do a manual roll-up.

For some data sources we have, I'll also have a temporary structure where one of the end directories has hourly `json.gz` files and just make sure I add those to the query (you can create a `VIEW` and then rollup the `json.gz` files into either a daily parquet or whatever org structrue I need.

It's a little more user-driven maintenance, but it's not as much work as it sounds if you make scripts.