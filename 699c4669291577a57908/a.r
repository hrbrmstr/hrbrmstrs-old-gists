library(rstudioapi)
library(xml2)

#' View XML (nicely) in the RStudio Viewer
#'
#' @param x A document or node to write to disk. It's not possible to save
#'          nodesets containing more than one node
view_xml <- function(x) {

  tdir <- tempdir()

  xml_fil <- tempfile(tmpdir=tdir, fileext=".xml")

  if (inherits(x, "character")) {
    cat(x, file=xml_fil)
  } else if (inherits(x, "xml_nodeset")) {
    cat(paste0(as.character(x), collapse=""), file=xml_fil)
  } else if (inherits(x, "xml_document") | inherits(x, "xml_node")) {
    write_xml(x, xml_fil)
  }

  file.copy("~/Desktop/vkbeautify.js",
            file.path(tdir, "vkbeautify.js"))
  file.copy("~/Desktop/highlight/highlight.pack.js",
            file.path(tdir, "highlight.pack.js"))
  file.copy("~/Desktop/highlight/styles/solarized-light.css",
            file.path(tdir, "highlight.css"))

  viewer_fil <- tempfile(tmpdir=tdir, fileext=".html")

  cat(sprintf("<html>
<head>
<link rel='stylesheet' href='highlight.css'>
  <script>
    var xml_text = '', xml_div;
    function do_the_thing() {
      var client = new XMLHttpRequest();
      client.open('GET', '%s');
      client.onreadystatechange = function() {
        xml_text = vkbeautify.xml(client.responseText, 2);
        xml_div = document.getElementById('xmldiv');
        xml_div.innerText = xml_text;
        hljs.initHighlighting();
        hljs.highlightBlock(xml_div);
      }
      client.send();
    }
  </script>
</head>
<body onload='do_the_thing();'>
  <pre><code class='html' id='xmldiv'></code></pre>
<script charset='utf-8' src='vkbeautify.js'></script>
<script charset='utf-8' src='highlight.pack.js'></script>
</body>
</html>", basename(xml_fil)), file=viewer_fil, append=FALSE)

  viewer(viewer_fil)

}

# various files from StackOverflow

doc <- read_xml("~/Desktop/snippet.xml")
view_xml(doc)

doc <- read_xml("http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml")
view_xml(doc)

doc <- read_xml("http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml")
view_xml(doc)

view_xml(xml_find_all(doc, ".//row[@_id and position()>=1 and position()<=10]"))
view_xml(xml_find_all(doc, ".//zipcode[contains(., '21230')]"))

doc <- read_xml("https://raw.githubusercontent.com/CoolSwat/test1/da02bd55fc194507b1df4a5605974a5f516d446f/junk/sitemapMain.xml")
view_xml(doc)






