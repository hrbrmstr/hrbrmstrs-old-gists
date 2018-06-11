library(rvest)
library(dplyr)
library(ggplot2)

pg <- read_html("https://ig.ft.com/sites/elections/2016/uk/eu-referendum/")

html_nodes(pg, "table.full-area-results") %>% 
  html_table() %>% 
  extract2(1) %>% 
  select(county=1, remain_votes=4, leave_votes=5) %>% 
  tbl_df() %>% 
  mutate(remain_votes=as.numeric(gsub(",", "", remain_votes)),
         leave_votes=as.numeric(gsub(",", "", leave_votes)),
         remain_pct=remain_votes/(remain_votes+leave_votes),
         leave_pct=1-remain_pct,
         county=factor(county, levels=rev(county))) -> results

gg <- ggplot(data=results)
gg <- gg + geom_segment(aes(x=county, xend=county, y=0, yend=-leave_pct, color="Leave"))
gg <- gg + geom_segment(aes(x=county, xend=county, y=0, yend=remain_pct, color="Remain"))
gg <- gg + geom_vline(xintercept=118, color="#2b2b2b", size=0.25)
gg <- gg + geom_label(data=data.frame(), aes(x=118, y=1, label="50/50 mark"), size=3, 
                      family="Arial Narrow", vjust=1, hjust=0, nudge_x=1, label.size=0)
gg <- gg + scale_y_continuous(expand=c(0,0), limits=c(-1, 1), 
                              breaks=c(-1, -0.5, 0, 0.5, 1), labels=c("100%", "50%", "0", "50%", "100%"))
gg <- gg + scale_color_manual(name=NULL, values=c(Leave="#2fad89", Remain="#4366af"))
gg <- gg + labs(x=NULL, y=NULL,
                title="EU referendum results; complete results breakdown",
                caption="Data source: https://ig.ft.com/sites/elections/2016/uk/eu-referendum/")
gg <- gg + theme_minimal(base_family="Arial Narrow")
gg <- gg + theme(panel.grid.major.x=element_blank())
gg <- gg + theme(panel.grid.major.y=element_line(size=0.75))
gg <- gg + theme(panel.grid.minor=element_blank())
gg <- gg + theme(axis.text.x=element_blank())
gg <- gg + theme(plot.title=element_text(face="bold"))
gg <- gg + theme(plot.margin=margin(20,20,20,20))
gg
