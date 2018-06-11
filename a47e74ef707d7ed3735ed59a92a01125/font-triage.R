font_triage <- function(out_file = "font-triage.json") {
  
  require(xml2, quiet=TRUE)
  require(processx, quiet=TRUE)
  require(extrafont, quiet=TRUE)
  require(tidyverse, quiet=TRUE)
  
  extrafont::loadfonts("pdf", quiet=TRUE)
  extrafont::loadfonts("postscript", quiet=TRUE)
  
  fc_list <- sys_prof <- NULL
  
  if (Sys.which("fc-list") != "") {
    message("Found 'fc-list'!")
    fc_list <- processx::run("fc-list", c("--format", '\\{ "family" : "%{family[0]}", "fullname" : "%{fullname[0]}", "font_format" : "%{fontformat[0]}", "file" : "%{file[0]}" \\}\n'))
    fc_list <- tbl_df(jsonlite::stream_in(textConnection(fc_list$stdout), verbose=FALSE))
  }
  
  if (Sys.which("system_profiler") != "") {
    message("Found 'system_profiler'!")
    message("Running 'system_profiler' takes a moment...")
    sys_prof <-  processx::run("system_profiler", c("-xml", "SPFontsDataType"))
    plist <- read_xml(sys_prof$stdout)
    xml_find_all(plist, "//plist/array/dict/array/dict") %>% 
      map_df(~{
        set_names(
          xml_text(xml_find_all(.x, "./string")),
          xml_text(xml_find_all(.x, "./key[not(contains(., 'typefaces'))]"))
        ) %>% 
          as.list()
      }) %>% 
      janitor::clean_names() -> sys_prof
  }
  
  message("Acquiring extrafont font table...")
  font_table <- tbl_df(extrafont::fonttable())
  
  pdf_fonts <- map(pdfFonts(), unclass) %>% map_df(~{ .x$metrics = list(.$metrics) ; .x })
  
  ps_fonts <- map(postscriptFonts(), unclass) %>% map_df(~{ .x$metrics = list(.$metrics) ; .x })
  
  quartz_fonts <- map(quartzFonts(), unclass)
  
  x11_fonts <- map(X11Fonts(), unclass)
  
  list(
    fc_list = fc_list, 
    sys_prof = sys_prof, 
    font_table = font_table,
    pdf_fonts = pdf_fonts,
    ps_fonts = ps_fonts,
    quartz_fonts = quartz_fonts,
    x11_fonts = x11_fonts
  ) -> triage_df
  
  out_file <- path.expand(out_file)
  message(sprintf("Saving triage output to [%s]...", out_file))
  write_lines(jsonlite::toJSON(triage_df, pretty=TRUE), out_file)
  
  return(invisible(triage_df))
  
}

my_fonts <- font_triage("myfonts.json")

