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

  download.file("http://rud.is/dl/vkbeautify.0.99.00.beta.js",
                file.path(tdir, "vkbeautify.0.99.00.beta.js"),
                quiet=TRUE)

  viewer_fil <- tempfile(tmpdir=tdir, fileext=".html")

  cat(sprintf("<html>
<head>
  <script>
    var xml_text = '';
    function do_the_thing() {
      var client = new XMLHttpRequest();
      client.open('GET', '%s');
      client.onreadystatechange = function() {
        xml_text = vkbeautify.xml(client.responseText, 2);
        xml_div = document.getElementById('xmldiv').innerText = xml_text;
      }
      client.send();
    }
  </script>
</head>
<body onload='do_the_thing();'>
  <pre id='xmldiv' class='prettyprint lang-xml'>
  </pre>
  <script charset='utf-8' src='vkbeautify.0.99.00.beta.js'></script>
</body>
</html>", basename(xml_fil)), file=viewer_fil, append=FALSE)

  viewer(viewer_fil)

}

# various files from StackOverflow

doc <- read_xml("https://www.dropbox.com/s/4gy87c1h3j63ixo/snippet.xml?dl=1")
view_xml(doc)

doc <- read_xml("http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml")
view_xml(doc)

doc <- read_xml("http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml")
view_xml(doc)

view_xml(xml_find_all(doc, ".//row[@_id and position()>=1 and position()<=10]"))
view_xml(xml_find_all(doc, ".//zipcode[contains(., '21230')]"))