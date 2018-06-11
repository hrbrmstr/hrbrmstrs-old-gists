library(rvest)
library(ore)
library(tidyverse)
library(jericho)

options("HTTPUserAgent"="hrbrbot")

pg <- read_html("https://help.github.com/")

html_nodes(pg, "a") %>% 
  html_attr("href") %>% 
  keep(startsWith, "/articles") %>% 
  sprintf("https://help.github.com%s", .) -> help_links

n <- length(help_links)
pb <- progress_estimated(length(help_links[1:n]))
map_chr(help_links[1:n], ~{
  
  Sys.sleep(2) # they have beefy servers

  pb$tick()$print()
    
  httr::GET(.x, httr::user_agent("hrbrbot")) %>% 
    httr::content("text") %>% 
    jericho::html_to_text()
  
  
}) %>% 
  paste0(collapse=" ") -> gh_help_text

# so we don't have to scrape it again
writeLines(gh_help_text, "gh_help_text.txt")

# gh_help_text <- readLines("gh_help_text.txt")

specials <- ore(" (\\.[[:lower:]_]{3,}|[[:alpha:]_]+\\.md)|([[:upper:]_]{3,})")

x <- ore_search(specials, gh_help_text, all=TRUE, simplify=TRUE)
x <- trimws(sort(unique(x$matches)))

grep("[[:upper:]_]+\\.md", x, value=TRUE)
## [1] "CODE_OF_CONDUCT.md" "CONTRIBUTING.md"    "LICENSE.md"         "README.md"          "SUPPORT.md" 

grep("TEMPLATE", x, value=TRUE)
## [[1]] PULL_REQUEST_TEMPLATE

grep("\\.", x, value=TRUE)
##  [1] ".com"               ".conf"              ".css"               ".csv"               ".doc"               ".fed"              
##  [7] ".geojson"           ".git"               ".gitattributes"     ".github"            ".gitignore"         ".gitmodules"       
## [13] ".gov"               ".htaccess"          ".ipynb"             ".json"              ".mil"               ".nojekyll"         
## [19] ".patch"             ".psd"               ".rtf"               ".ssh"               ".stl"               ".topojson"         
## [25] ".travis"            ".tsv"               ".txt"               ".vimrc"             "CODE_OF_CONDUCT.md" "CONTRIBUTING.md"   
## [31] "foo.md"             "issue_template.md"  "LICENSE.md"         "README.md"          "styleguide.md"      "SUPPORT.md"        

# + a few listed here https://help.github.com/articles/helping-people-contribute-to-your-project/