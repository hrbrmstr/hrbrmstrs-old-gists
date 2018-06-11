library(xml2)
library(rvest)

doc_txt <- "<p>hello world</p>
<p>the weather is fine today</p>
<p>it is fine in a lot of places in the world<p>"

doc <- read_html(doc_txt)

xml_text(xml_nodes(doc, xpath="//p[text()[contains(.,'world')]]"))
