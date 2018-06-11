library(shiny)
library(ggplot2)

shinyServer(function(input, output) {

  dat <- data.frame(t=seq(0, 5*pi, by=0.01))

  xhrt <- function(t) 16*sin(t)^3
  yhrt <- function(t) 13*cos(t)-5*cos(2*t)-2*cos(3*t)-cos(4*t)

  dat$y=yhrt(dat$t)
  dat$x=xhrt(dat$t)

  heart_colors <- c("#d799d9", "#6db6e5", "#f5a877", "#aad085", "#ffeb60")

  # 2006 was just a stupid year

  years <- list("2009"=c("RECIPE 4\nLOVE", "TABLE 4\nTWO", "STIR MY\nHEART", "MY TREAT", "TOP CHEF", "SUGAR PIE", "SWEET LOVE", "HONEY BUN", "SPICE IT\nUP", "YUM YUM"),
                "2008"=c("MELT MY\nHEART", "IN A FOG", "CHILL OUT", "CLOUD NINE", "HEAT WAVE", "SUNSHINE", "GET MY\nDRIFT", "WILD LIFE", "NATURE LOVER", "DO GOOD"),
                "2007"=c("COOL CAT", "PUPPY LOVE", "TAKE A WALK", "MY PET", "BEAR HUG", "TOP DOG", "URA TIGER", "GO FISH", "LOVE BIRD", "PURR FECT"),
                "2005"=c("#1 FAN", "FIT FOR LOVE", "DREAM TEAM", "LOVE LIFE", "BE A SPORT", "LOVE MY\nTEAM", "CHEER ME ON", "BE MY\nHERO", "HEART OF\nGOLD", "ALL-STAR"),
                "2004"=c("3 WISHES", "EVER AFTER", "NEW YOU", "MAGIC", "DREAM", "CHARM ME", "START NOW", "NEW LOVE", "IM ME", "I LOVE\nYOU"))

  output$hearts <- renderPlot({

    candy_year <- sample(names(years), 1)
    saying <- sample(years[[candy_year]], 1)

    gg <- ggplot(dat, aes(x=x, y=y))
    gg <- gg + geom_polygon(fill=sample(heart_colors, 1))
    gg <- gg + geom_text(label=saying, aes(x=0, y=0), size=14, family="Helvetica", face="bold")
    gg <- gg + labs(x=sprintf("Year: %s", candy_year), y=NULL, title=NULL)
    gg <- gg + coord_equal()
    gg <- gg + theme_minimal()
    gg <- gg + theme(axis.text=element_blank())
    gg <- gg + theme(axis.ticks=element_blank())
    gg <- gg + theme(panel.grid=element_blank())
    gg

  })

})
