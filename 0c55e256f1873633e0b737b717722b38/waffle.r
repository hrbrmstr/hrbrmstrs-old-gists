library(extrafont)
library(waffle)

waffle(c(`Europe`=113, `Afrique`=2600), 
       rows=40, colors=c("#70b8da", "#d55c5c"), 
       use_glyph="male", glyph_size=4.5, flip=TRUE)
