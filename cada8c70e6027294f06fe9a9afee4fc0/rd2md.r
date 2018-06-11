w <- tools::Rd_db("warc")
a <- purrr::map_chr(w, ~trimws(capture.output(tools::Rd2txt(., options=tools::Rd2txt_options(width=1000)))[5]))
cat(sprintf("- `%s`: %s\n", gsub(".Rd", "", names(a)), a), sep="")
