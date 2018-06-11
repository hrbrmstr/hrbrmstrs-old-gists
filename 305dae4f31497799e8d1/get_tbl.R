library(xml2)

get_tbls <- function(word_doc) {
  
  tmpd <- tempdir()
  tmpf <- tempfile(tmpdir=tmpd, fileext=".zip")
  
  file.copy(word_doc, tmpf)
  unzip(tmpf, exdir=sprintf("%s/docdata", tmpd))
  
  doc <- read_xml(sprintf("%s/docdata/word/document.xml", tmpd))
  
  unlink(tmpf)
  unlink(sprintf("%s/docdata", tmpd), recursive=TRUE)

  ns <- xml_ns(doc)
  
  tbls <- xml_find_all(doc, ".//w:tbl", ns=ns)
  
  lapply(tbls, function(tbl) {
    
    cells <- xml_find_all(tbl, "./w:tr/w:tc", ns=ns)
    rows <- xml_find_all(tbl, "./w:tr", ns=ns)
    dat <- data.frame(matrix(xml_text(cells), 
                             ncol=(length(cells)/length(rows)), 
                             byrow=TRUE), 
                      stringsAsFactors=FALSE)
    colnames(dat) <- dat[1,]
    dat <- dat[-1,]
    rownames(dat) <- NULL
    dat
    
  })
  
}

get_tbls("~/Dropbox/data3.docx")
