library(stringi)

shroom <- read.csv("expanded", skip=9,
                   col.names=c("poisonous", "cap_shape", "cap_surface", "cap_color", "bruises",
                               "odor", "gill_attachment", "gill_spacing", "gill_size",
                               "gill_color", "stalk_shape", "stalk_root", 
                               "stalk_surface_above_ring", "stalk_surface_below_ring",
                               "stalk_color_above_ring", "stalk_color_below_ring", 
                               "veil_type", "veil_color", "ring_number", "ring_type",
                               "spore_print_color", "population", "habitat"))
shroom[] <- lapply(shroom, stri_trans_totitle)
shroom[] <- lapply(shroom, factor)

library(ggplot2)
library(tabplot)

tableplot(shroom)