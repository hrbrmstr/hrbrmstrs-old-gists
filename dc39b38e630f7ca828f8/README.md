This gist:

- uses selenium to render the table (since it's dynamic)
- ensures all the GapMinder indicators are present
- scrapes the table
- converts the XLS links to CSV 
- makes a data frame of the table. 

One can then `read.csv` (or your fav CSV reader) to grab the data. 

I use `httr::GET` for reliability (I had issues with `read_csv` and `read.csv` at times with some of the URLs)

You don't need to use the `build_gap.r` file unless you really want to go hardcore. Just source the `gap_data.r` and follow the idiom in `a_read_gap.r`.