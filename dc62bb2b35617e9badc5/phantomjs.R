library(rvest)

# example of using phantomjs for scraping sites that use a twisty maze
# of javascript to render HTML tables or other tags

# grab phantomjs binaries from here: http://phantomjs.org/
# and stick it somehere PATH will find it

# this example scrapes the user table from:

url <- "http://64px.com/instagram/"

# write out a script phantomjs can process

writeLines(sprintf("var page = require('webpage').create();
page.open('%s', function () {
    console.log(page.content); //page source
    phantom.exit();
});", url), con="scrape.js")

# process it with phantomjs

system("phantomjs scrape.js > scrape.html")

# use rvest as you would normally use it

page_html <- html("scrape.html")
page_html %>% html_nodes(xpath="//table[2]") %>% html_table()

# OR #

page_html %>% html_nodes("table:nth-of-type(2)") %>% html_table()

# if you prefer CSS selectors over XPath