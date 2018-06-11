suppressPackageStartupMessages(library(hrbrthemes))
suppressPackageStartupMessages(library(tidyverse))

plot_status <- FALSE

x <- tibble::as_tibble(readRDS(url("https://cran.r-project.org/web/checks/check_results.rds")))
y <- tibble::as_data_frame(installed.packages())
z <- dplyr::left_join(y, x, by = c("Package", "Version", "Priority"))

dplyr::count(z, Package, Status) %>%
  filter(!is.na(Status)) %>%
  dplyr::mutate(Status = tolower(Status)) %>%
  tidyr::complete(Package, Status) %>%
  dplyr::mutate(Status = factor(Status, levels=c("error", "warn", "note", "ok"))) %>%
  dplyr::arrange(Package) %>%
  dplyr::mutate(Package = factor(Package, levels=rev(unique(Package)))) %>%
  dplyr::mutate(alpha = ifelse(is.na(n), 0, n)) -> pkgs

dplyr::filter(pkgs, Status == "error") %>%
  dplyr::filter(!is.na(n)) %>%
  dplyr::arrange(desc(n)) %>%
  dplyr::rename(errors = n) %>%
  dplyr::select(Package, errors) -> errs

cat("Installed CRAN Package Error Status:\n", sep="")
print(errs, n=nrow(errs))

dplyr::filter(pkgs, Status == "warn") %>%
  dplyr::filter(!is.na(n)) %>%
  dplyr::arrange(desc(n)) %>%
  dplyr::rename(warnings = n) %>%
  dplyr::select(Package, warnings) -> warns

cat("\n\nInstalled CRAN Package Warning Status:\n", sep="")
print(errs, n=nrow(errs))

dplyr::filter(pkgs, Status == "note") %>%
  dplyr::filter(!is.na(n)) %>%
  dplyr::arrange(desc(n)) %>%
  dplyr::rename(notes = n) %>%
  dplyr::select(Package, notes) -> notes

cat("\n\nInstalled CRAN Packages with NOTEs:\n", sep="")
print(notes, n=nrow(notes))

if (plot_status) {

ggplot(pkgs, aes(Status, Package)) +
  geom_tile(aes(fill=Status, alpha=alpha)) +
  geom_text(aes(label=n), family=font_rc, size=2) +
  scale_x_discrete(expand=c(0,0), position="top") +
  scale_fill_manual(
    values = c("error"="red", "warn"="orange", "note"="yellow", "ok"="green"),
    na.value="white"
  ) +
  labs(x=NULL, y=NULL, title="CRAN Package Check Status of Installed Packages") +
  theme_ipsum_rc(grid="") +
  theme(axis.text.y=element_text(size=2)) +
  theme(legend.position="none")

}
