library(doParallel)

rpts <- list(list(out="one.html", params=list(some_var="One")),
             list(out="two.html", params=list(some_var="Two")),
             list(out="three.html", params=list(some_var="Three")),
             list(out="four.html", params=list(some_var="Four")))

do_rpt <- function(r) {

  require(rmarkdown)

  tf <- tempfile()
  dir.create(tf)

  rmarkdown::render(input="tstrpt.Rmd",
                    output_file=r$out,
                    intermediates_dir=tf,
                    params=r$params,
                    quiet=TRUE)
  unlink(tf)
  
}

registerDoParallel(cores=3)

foreach(r=rpts, .combine=c) %dopar% do_rpt(r)

