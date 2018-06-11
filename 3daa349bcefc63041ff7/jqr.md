I regularly have to process 100+GB JSON files (they aren't Spark'd, Hadooped or parqueted yet). `jq` is C and I can develop test queries on the command line. `jqr` is not just a call out to the system but the actual `jq` in R. I could do stream processing with `jsonlite` but `jq` is also known by more teammates & they can make queries there which I can use in R.

By using `jqr` I can also keep the pipeline processing all in R vs multiple processes.

This https://www.censys.io/data/certificates (free reg req'd) is an example of the 100GB file :-)