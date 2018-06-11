library(adobecolor) # hrbrmstr/adobecolor
library(tidyverse)

# using xScope to make a color palette from loupe capture
ml_aco_cols <- rev(read_aco("ml_cols.aco"))
col2rgb(ml_aco_cols)

# OCR'd
readLines(textConnection("Clardic Fug 112 113 84
Snowbonk 201 199 165
Catbabel 97 93 68
Bunfiow 190 174 155
Ronching Blue 121 114 125
Bank Butt 221 196 199
Caring Tan 171 166 170
Stargoon 233 191 141
Sink 176 138 110
Stummy Beige 216 200 185
Dorkwood 61 63 66
Flower 178 184 196
Sand Dan 201 172 143
Grade Bat 48 94 83
Light Of Blast 175 150 147
Grass Bat 176 99 108
Sindis Poop 204 205 194
Dope 219 209 179
Testing 156 101 106
Stoncr Blue 152 165 159
Burblc Simp 226 181 132
Stanky Bean 197 162 171
Thrdly 190 164 116")) %>% 
  stringi::stri_match_all_regex("([[:alpha:] ]+) ([[:digit:]]+) ([[:digit:]]+) ([[:digit:]]+)") %>% 
  map(~{
    y <- as.numeric(.x[,3:5])
    rgb(y[1], y[2], y[3], names=.x[,2], maxColorValue = 255)
  }) %>% 
  flatten_chr() -> ocr_cols

# NOTE they are slightly different numerically
ocr_cols
ml_aco_cols

# BUT not necessarily visually
par(mfrow=c(1,2))
scales::show_col(ocr_cols)
scales::show_col(ml_aco_cols)
par(mfrow=c(1,1))