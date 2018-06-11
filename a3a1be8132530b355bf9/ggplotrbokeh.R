library(ggplot2)
library(rbokeh)
library(htmlwidgets)

structure(list(wk = structure(c(16069, 16237, 16244, 16251, 16279,
16286, 16300, 16307, 16314, 16321, 16328, 16335, 16342, 16349,
16356, 16363, 16377, 16384, 16391, 16398, 16412, 16419, 16426,
16440, 16447, 16454, 16468, 16475, 16496, 16503, 16510, 16517,
16524, 16538, 16552, 16559, 16566, 16573), class = "Date"), n = c(1L,
1L, 1L, 1L, 3L, 1L, 3L, 2L, 4L, 2L, 3L, 2L, 5L, 5L, 1L, 1L, 3L,
3L, 3L, 2L, 1L, 1L, 1L, 2L, 1L, 2L, 7L, 1L, 2L, 6L, 7L, 1L, 1L,
1L, 2L, 2L, 7L, 1L)), .Names = c("wk", "n"), class = c("tbl_df",
"tbl", "data.frame"), row.names = c(NA, -38L)) -> by_week

events <- data.frame(when=as.Date(c("2014-10-09", "2015-03-20", "2015-05-15")),
                     what=c("Thing1", "Thing2", "Thing2"))

# ggplot version ----------------------------------------------------------

gg <- ggplot()
gg <- gg + geom_vline(data=events,
                      aes(xintercept=as.numeric(when), color=what),
                      linetype="dashed", alpha=1/2)
gg <- gg + geom_text(data=events,
                     aes(x=when, y=1, label=what, color=what),
                     hjust=1.1, size=3)
gg <- gg + geom_line(data=by_week, aes(x=wk, y=cumsum(n)))
gg <- gg + scale_x_date(expand=c(0, 0))
gg <- gg + scale_y_continuous(limits=c(0, 100))
gg <- gg + labs(x=NULL, y="Cumulative Stuff")
gg <- gg + theme_bw()
gg <- gg + theme(panel.grid=element_blank())
gg <- gg + theme(panel.border=element_blank())
gg <- gg + theme(legend.position="none")
gg

# Bokeh version -----------------------------------------------------------

figure(width=550, height=375,
       logo="grey", outline_line_alpha=0) %>%
  ly_abline(v=events$when, color=c("red", "blue", "blue"), type=2, alpha=1/4) %>%
  ly_text(x=events$when, y=5, color=c("red", "blue", "blue"),
          text=events$what, align="right", font_size="7pt") %>%
  ly_lines(x=wk, y=cumsum(n), data=by_week) %>%
  y_range(c(0, 100)) %>%
  x_axis(grid=FALSE, label=NULL,
         major_label_text_font_size="8pt",
         axis_line_alpha=0) %>%
  y_axis(grid=FALSE,
         label="Cumulative Stuff",
         minor_tick_line_alpha=0,
         axis_label_text_font_size="10pt",
         axis_line_alpha=0) -> rb

rb

