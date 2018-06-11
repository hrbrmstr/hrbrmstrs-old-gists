# save this to '_chat.txt` (it require a login)
# https://www.kaggle.com/sarthaknautiyal/whatsappsample

library(ore)
library(dplyr)

emoji_src <- "https://raw.githubusercontent.com/laurenancona/twimoji/gh-pages/twitterEmojiProject/emoticon_conversion_noGraphic.csv"
emoji_fil <- basename(emoji_src)
if (!file.exists(emoji_fil)) download.file(emoji_src, emoji_fil)

emoji <- read.csv(emoji_fil, header=FALSE, stringsAsFactors = FALSE)
emoji_regex <- sprintf("(%s)", paste0(emoji$V2, collapse="|"))
compiled <- ore(emoji_regex)

chat <- readLines("_chat.txt", encoding = "UTF-8", warn = FALSE)

which(grepl(emoji_regex, chat, useBytes = TRUE))
##   [1]   8   9  10  11  13  19  20  22  23  62  65  69  73  74  75  82  83  84  87  88  90  91
##  [23]  92  93  94  95 107 108 114 115 117 119 122 123 124 125 130 135 139 140 141 142 143 144
##  [45] 146 147 150 151 153 157 159 161 162 166 169 171 174 177 178 183 184 189 191 192 195 196
##  [67] 199 200 202 206 207 209 220 221 223 224 225 226 228 229 234 235 238 239 242 244 246 247
##  [89] 248 249 250 251 253 259 260 262 263 265 274 275 280 281 282 286 287 288 291 292 293 296
## [111] 302 304 305 307 334 335 343 346 348 351 354 355 356 358 361 362 382 389 390 391 396 397
## [133] 398 399 400 401 402 403 404 405 406 407 408 409 410 411 412 413 414 415 416 417 418 419
## [155] 420 421 422 423 424 425 426 427 428 429 430 431 432 433 434 435 436 437 438 442 451 452
## [177] 454 459 463 465 466 469 471 472 473 474 475 479 482 484 485 486 488 490 492 493 496 503
## [199] 505 506 507 509 517 518 519 525 526 527 528 531 535 540 543 545 548 549 557 558 559 560
## [221] 566 567 571 572 573 574 576 577 578 580 587 589 591 592 594 597 600 601 603 608 609 625
## [243] 626 627 637 638 639 640 641 643 645 749 757 764

chat_emoji_lines <- chat[which(grepl(emoji_regex, chat, useBytes = TRUE))]

found_emoji <- ore.search(compiled, chat_emoji_lines, all=TRUE)
emoji_matches <- matches(found_emoji)

str(emoji_matches, 1)
## List of 254
##  $ : chr [1:4] "\U0001f600" "\U0001f600" "\U0001f44d" "\U0001f44d"
##  $ : chr "\U0001f648"
##  $ : chr [1:2] "\U0001f44d" "\U0001f44d"
##  $ : chr "\U0001f602"
##  $ : chr [1:3] "\U0001f602" "\U0001f602" "\U0001f602"
##  $ : chr [1:4] "\U0001f44c" "\U0001f44c" "\U0001f44c" "\U0001f44c"
##  $ : chr [1:6] "\U0001f602" "\U0001f602" "\U0001f602" "\U0001f602" ...
##  $ : chr "\U0001f600"
##  $ : chr [1:5] "\U0001f604" "\U0001f604" "\U0001f604" "\U0001f603" ...
##  $ : chr "\U0001f44d"
## ...

data_frame(
  V2 = flatten_chr(emoji_matches) %>% 
    map(charToRaw) %>% 
    map(as.character) %>% 
    map(toupper) %>% 
    map(~sprintf("\\x%s", .x)) %>% 
    map_chr(paste0, collapse="")
) %>% 
  left_join(emoji) %>% 
  count(V3, sort=TRUE)
## # A tibble: 89 x 2
##                                                    V3     n
##                                                 <chr> <int>
##  1                             face with tears of joy   110
##  2                     smiling face with smiling eyes    50
##  3         face with stuck-out tongue and winking eye    43
##  4                                       musical note    42
##  5                                      birthday cake    35
##  6                    grinning face with smiling eyes    26
##  7 face with stuck-out tongue and tightly-closed eyes    24
##  8                                      grinning face    21
##  9                                            bouquet    17
## 10                                     thumbs up sign    17
## # ... with 79 more rows