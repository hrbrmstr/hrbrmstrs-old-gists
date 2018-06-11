# Roll your own GitHub Gist Comments Feed in R

library(xml2)    # github version
library(rvest)   # github version
library(stringr) # for str_trim & str_replace
library(dplyr)   # for data_frame & bind_rows
library(pbapply) # free progress bars for everyone!
library(XML)     # to build the RSS feed

who <- "hrbrmstr" # CHANGE ME!

# Grab the user's gist feed -----------------------------------------------

gist_feed <- sprintf("https://gist.github.com/%s.atom", who)
feed_pg <- read_xml(gist_feed)
ns <- xml_ns_rename(xml_ns(feed_pg), d1 = "feed")

# Extract the links & titles of the gists in the feed ---------------------

links <-  xml_attr(xml_find_all(feed_pg, "//feed:entry/feed:link", ns), "href")
titles <-  xml_text(xml_find_all(feed_pg, "//feed:entry/feed:title", ns))

#' This function does the hard part by iterating over the
#' links/titles and building a tbl_df of all the comments per-gist
get_comments <- function(links, titles) {

  bind_rows(pblapply(1:length(links), function(i) {

    # get gist

    pg <- read_html(links[i])

    # look for comments

    ref <- tryCatch(html_attr(html_nodes(pg, "div.timeline-comment-wrapper a[href^='#gistcomment']"), "href"),
                    error=function(e) character(0))

    # in theory if 'ref' exists then the rest will

    if (length(ref) != 0) {

      # if there were comments, get all the metadata we care about

      author <- html_text(html_nodes(pg, "div.timeline-comment-wrapper a.author"))
      timestamp <- html_attr(html_nodes(pg, "div.timeline-comment-wrapper time"), "datetime")
      contentpg <- str_trim(html_text(html_nodes(pg, "div.timeline-comment-wrapper div.comment-body")))

    } else {
      ref <- author <- timestamp <- contentpg <- character(0)
    }

    # bind_rows ignores length 0 tbl_df's
    if (sum(lengths(list(ref, author, timestamp, contentpg))==0)) {
      return(data_frame())
    }

    return(data_frame(title=titles[i], link=links[i],
                      ref=ref, author=author,
                      timestamp=timestamp, contentpg=contentpg))

  }))

}

comments <- get_comments(links, titles)

feed <- xmlTree("feed")
feed$addNode("id", sprintf("user:%s", who))
feed$addNode("title", sprintf("%s's gist comments", who))
feed$addNode("icon", "https://assets-cdn.github.com/favicon.ico")
feed$addNode("link", attrs=list(href=sprintf("https://github.com/%s", who)))
feed$addNode("updated", format(Sys.time(), "%Y-%m-%dT%H:%M:%SZ", tz="GMT"))

for (i in 1:nrow(comments)) {

  feed$addNode("entry", close=FALSE)
    feed$addNode("id", sprintf("gist:comment:%s:%s", who, comments[i, "timestamp"]))
    feed$addNode("link", attrs=list(href=sprintf("%s%s", comments[i, "link"], comments[i, "ref"])))
    feed$addNode("title", sprintf("Comment by %s", comments[i, "author"]))
    feed$addNode("updated", comments[i, "timestamp"])
    feed$addNode("author", close=FALSE)
      feed$addNode("name", comments[i, "author"])
    feed$closeTag()
    feed$addNode("content", saveXML(xmlTextNode(as.character(comments[i, "contentpg"])), prefix=""), 
                 attrs=list(type="html"))
  feed$closeTag()

}

rss <- str_replace(saveXML(feed), "<feed>", '<feed xmlns="http://www.w3.org/2005/Atom">')

writeLines(rss, con="feed.xml")