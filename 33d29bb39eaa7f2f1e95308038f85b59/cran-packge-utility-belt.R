library(stringi)
library(hrbrthemes)
library(archive)
library(tidyverse)

# I ran readr::type_convert() once and it returns this column type spec. By using it
# for subsequent conversions, we'll gain reproducibility and data format change
# detection capabilities "for free"

cols(
  permsissions = col_character(),
  links = col_integer(),
  owner = col_character(),
  group = col_character(),
  size = col_integer(),
  month = col_character(),
  day = col_integer(),
  year_hr = col_character(),
  path = col_character()
) -> tar_cols

# Now, we parse the tar verbose ('ls -l') listing

stri_read_lines("~/Data/pkutils.txt") %>% # stringi was loaded so might as well use it
  stri_split_regex(" +", 9, simplify = TRUE) %>% # split input into 9 columns
  as_data_frame() %>% # ^^ returns a matrix but data frames are more useful for our work
  set_names(names(tar_cols$cols)) %>% # column names are useful and we can use our colspec for it
  type_convert(col_types = tar_cols) %>% # see comment block before cols()
  mutate(day = sprintf("%02d", day)) %>% # now we'll work on getting the date pieces to be a Date
  mutate(year_hr = case_when( # the year_hr field can be either %Y or %H:%M depending on file 'recency'
    stri_detect_fixed(year_hr, ":") &
      (month %in% c("Jan", "Feb", "Mar", "Apr")) ~ "2018", # if %H:%M but 'starter' months it's 2018
    stri_detect_fixed(year_hr, ":") &
      (month %in% c("Dec", "Nov", "Oct", "Sep", "Aug", "Jul", "Jun")) ~ "2017", # %H:%M & 'end' months
    TRUE ~ year_hr # already in %Y format
  )) %>%
  mutate(date= lubridate::mdy(sprintf("%s %s, %s", month, day, year_hr))) %>% # get a Date
  mutate(pkg = stri_match_first_regex(path, "^(.*)/R/")[,2]) %>% # extract package name (stri_extract is also usable here)
  mutate(fil = basename(path)) %>% # extrafct just the file name
  filter(!is.na(pkg)) %>% # handle one type of wrongly included file
  filter(!stri_detect_fixed(pkg, "/")) %>% # ande another
  filter(!is.na(path)) -> xdf # and another; but we're done so we close with an assignment

glimpse(xdf)

#' How many packages have some type of "util"?
nrow(distinct(xdf, pkg))

#' Crude annual temporal comparison of # pkgs using "util"
distinct(xdf, pkg, date) %>%
  mutate(yr = as.integer(lubridate::year(date))) %>%
  count(yr) %>%
  complete(yr, fill=list(n=0)) %>%
  ggplot(aes(yr, n)) +
  geom_col(fill="lightslategray", width=0.65) +
  labs(
    x = NULL, y = "Package count",
    title = "Recently published or updated packages tend to have more 'util'\nthan older/less actively-maintained ones",
    subtitle = "Count of packages (by year) with 'util's"
  ) +
  theme_ipsum_rc(grid="Y")

distinct(xdf, pkg, date) %>%
  arrange(date) %>%
  print(n=20)

#' Most common "util" file names
count(xdf, fil, sort=TRUE) %>%
  mutate(pct = scales::percent(n/sum(n))) %>%
  print(n=20)

#' File size ranges
ggplot(xdf, aes(x="", size)) +
  ggbeeswarm::geom_quasirandom(
    fill="lightslategray", color="white",
    alpha=1/2, stroke=0.25, size=3, shape=21
  ) +
  geom_boxplot(fill="#00000000", outlier.colour = "#00000000") +
  geom_text(
    data=data_frame(), aes(x=-Inf, y=median(xdf$size), label="Median:\n2,717"),
    hjust = 0, family = font_rc, size = 3, color = "lightslateblue"
  ) +
  scale_y_comma(
    name = "File size", trans="log10", limits=c(NA, 200000),
    breaks = c(10, 100, 1000, 10000, 100000)
  ) +
  labs(
    x = NULL,
    title = "Most 'util' files are between 1K and 10K in size",
    caption = "Note y-axis log10 scale"
  ) +
  theme_ipsum_rc(grid="Y")

extract_source <- function(pkg, fil, .pb = NULL) {

  if (!is.null(.pb)) .pb$tick()$print()

  list.files(
    path = "/cran/src/contrib", # my path to local CRAN
    pattern = sprintf("^%s_.*gz", pkg), # rough pattern for the package archive filename
    recursive = FALSE,
    full.names = TRUE
  ) -> tgt

  con <- archive_read(tgt[1], fil)
  src <- readLines(con, warn = FALSE)
  close(con)

  paste0(src, collapse="\n")

}

pb <- progress_estimated(nrow(xdf))
xdf <- mutate(xdf, file_src = map2_chr(pkg, path, extract_source, .pb=pb))

# we'll use these two functions to help test whether bits
# of our parsed code are, indeed, functions.
#
# Alternately: "I heard you liked functions so I made
# functions to help you find functions"
#
# we could have used `rlang` helpers here, but I had these
# handy from pre-`rlang` days.

is_assign <- function(x) {
  as.character(x) %in% c('<-', '=', '<<-', 'assign')
}

is_func <- function(x) {
  is.call(x) &&
    is_assign(x[[1]]) &&
    is.call(x[[3]]) &&
    (x[[3]][[1]] == quote(`function`))
}

read_rds("~/Data/utility-belt.rds") %>%
  mutate(parsed = map(file_src, ~parse(text = .x, keep.source = TRUE))) %>%
  mutate(func_names = map(parsed, ~{
    keep(.x, is_func) %>%
      map(~as.character(.x[[2]])) %>%
      flatten_chr()
  })) -> xdf

# Take a look at most common functions
select(xdf, pkg, fil, func_names) %>%
  unnest() %>%
  count(func_names, sort=TRUE) %>%
  print(n=20)

# examining case
select(xdf, pkg, fil, func_names) %>%
  unnest() %>%
  mutate(is_camel = (!stri_detect_fixed(func_names, "_")) &
           (!stri_detect_regex(func_names, "[[:alpha:]]\\.[[:alpha:]]")) &
           (stri_detect_regex(func_names, "[A-Z]"))) %>%
  mutate(is_dotcase = stri_detect_regex(func_names, "[[:alpha:]]\\.[[:alpha:]]")) %>%
  mutate(is_snake = stri_detect_fixed(func_names, "_") &
           (!stri_detect_regex(func_names, "[[:alpha:]]\\.[[:alpha:]]"))) -> case_hunt

count(case_hunt, is_camel, is_dotcase, is_snake) %>%
  mutate(pct = scales::percent(n/sum(n))) %>%
  mutate(description = c(
    "one-'word' names",
    "snake_case",
    "dot.case",
    "camelCase"
  )) %>%
  arrange(n) %>%
  mutate(description = factor(description, description)) %>%
  ggplot(aes(description, n)) +
  geom_col(fill="lightslategray", width=0.65) +
  geom_label(aes(y = n, label=pct), label.size=0, family=font_rc, nudge_y=150) +
  scale_y_comma("Number of functions") +
  labs(
    x=NULL,
    title = "dot.case does not seem to be en-vogue for utility belt functions"
  ) +
  theme_ipsum_rc(grid="Y")

# what is "is"?
select(xdf, pkg, fil, func_names) %>%
  unnest() %>%
  filter(stri_detect_regex(func_names, "^(\\.is|is)")) %>%
  mutate(func_names = snakecase::to_snake_case(func_names)) %>%
  count(func_names, sort=TRUE)

# extract comments
select(xdf, pkg, fil, file_src) %>%
  mutate(comments = map(file_src, ~{
    stri_split_lines(.x) %>%
      .[[1]] %>%
      stri_trim_left() %>%
      keep(stri_detect_regex, "^#")
  })) -> cmnt_df

# compute raw code statistics
xdf %>%
  mutate(
    num_lines = stri_count_fixed(xdf$file_src, "\n"),
    num_blank_lines = stri_count_regex(xdf$file_src, "^[[:space:]]*$", opts_regex = stri_opts_regex(multiline=TRUE)),
    num_whole_line_comments = lengths(cmnt_df$comments),
    comment_density = num_whole_line_comments / (num_lines - num_blank_lines - num_whole_line_comments),
    blank_density = num_blank_lines / (num_lines - num_whole_line_comments)
  ) %>%
  select(-permsissions, -links, -owner, -group, month, -day, -year_hr) -> xdf

# now compute mean ratios
group_by(xdf, pkg) %>%
  summarise(
    `Comment-to-code Ratio` = mean(comment_density),
    `Blank lines-to-code Ratio` = mean(blank_density)
  ) %>%
  ungroup() %>%
  filter(!is.infinite(`Comment-to-code Ratio`)) %>%
  filter(!is.nan(`Comment-to-code Ratio`)) %>%
  filter(!is.infinite(`Blank lines-to-code Ratio`)) %>%
  filter(!is.nan(`Blank lines-to-code Ratio`)) %>%
  gather(measure, value, -pkg) -> code_ratios

# we want to label the median values
group_by(code_ratios, measure) %>%
  summarise(median = median(value)) -> code_ratio_meds

ggplot(code_ratios, aes(measure, value, group=measure)) +
  ggbeeswarm::geom_quasirandom(
    fill="lightslategray", color="#2b2b2b", alpha=1/2,
    stroke=0.25, size=3, shape=21
  ) +
  geom_boxplot(fill="#00000000", outlier.colour = "#00000000") +
  geom_label(
    data = code_ratio_meds,
    aes(-Inf, c(0.3, 5), label=sprintf("Median:\n%s", round(median, 2)), group=measure),
    family = font_rc, size=3, color="lightslateblue", hjust = 0, label.size=0
  ) +
  scale_y_continuous() +
  labs(
    x = NULL, y = NULL,
    caption = "Note free y scale"
  ) +
  facet_wrap(~measure, scales="free") +
  theme_ipsum_rc(grid="Y", strip_text_face = "bold") +
  theme(axis.text.x=element_blank())

group_by(xdf, pkg) %>%
  summarise(mean_blank_density = mean(blank_density)) %>%
  arrange(desc(mean_blank_density)) %>%
  ggplot(aes(x="Mean Package Blanks-to-Code Ratio", mean_blank_density)) +
  ggbeeswarm::geom_beeswarm(fill="lightslategray", color="#2b2b2b", alpha=1/2, stroke=0.25, size=3, shape=21) +
  scale_x_discrete(name=NULL, position = "top") +
  scale_y_percent(name=NULL) +
  theme_ipsum_rc(grid="Y")

ggplot(data_frame(x=comment_density)) +
  ggalt::geom_bkde(aes(x, y=calc(count)), bandwidth=0.05, fill="lightslategray", alpha=2/3) +
  scale_x_comma(
    name="Comment-to-Code Ratio",
    trans="log10",
    breaks=unique(c(seq(0, 1, 0.1)[-1], seq(0, 50, 10)[-1]))
  ) +
  scale_y_comma("Source File Count") +
  theme_ipsum_rc(grid="XY") +
  theme(axis.text.x=element_text(angle=90, hjust=1, vjust=0.5))