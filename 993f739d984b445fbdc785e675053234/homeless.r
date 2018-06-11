library(readxl)

process_sheet <- function(sheet_number=1) {

  workbook <- "2007-2015-PIT-Counts-by-State.xlsx"
  dat <- read_excel(workbook, sheet=sheet_number)
  dat <- dat[complete.cases(dat),]
  dat <- dat[!(dat$State == "Total"),]

  new_col_names <- make.names(colnames(dat))
  new_col_names <- gsub("\\.+", "_", new_col_names)
  new_col_names <- tolower(new_col_names)
  new_col_names <- sub("_[[:digit:]]+$", "", new_col_names)

  dat <- setNames(dat, new_col_names)

  return(dat)

}
homeless <- lapply(2:10, process_sheet)
names(homeless) <- 2015:2007

get_stats <- function(steve) {
  summary(steve$total_homeless)
}