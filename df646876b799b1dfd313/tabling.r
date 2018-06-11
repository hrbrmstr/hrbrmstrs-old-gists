library(formattable)
library(dplyr)
library(htmltools)

df <- data.frame(
  id = 1:10,
  Name = c("Bob", "Ashley", "James", "David", "Jenny", 
           "Hans", "Leo", "John", "Emily", "Lee"), 
  age = c(28, 27, 30, 28, 29, 29, 27, 27, 31, 30),
  grade = c("C", "A", "A", "C", "B", "B", "B", "A", "C", "C"),
  `Test 1 Score` = c(8.9, 9.5, 9.6, 8.9, 9.1, 9.3, 9.3, 9.9, 8.5, 8.6),
  test2_score = c(9.1, 9.1, 9.2, 9.1, 8.9, 8.5, 9.2, 9.3, 9.1, 8.8),
  final_score = c(9, 9.3, 9.4, 9, 9, 8.9, 9.25, 9.6, 8.8, 8.7),
  registered = c(TRUE, FALSE, TRUE, FALSE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE),
  stringsAsFactors = FALSE,
  check.names=FALSE)


color_bar_only <- function (color, ...) {
  formatter("span", 
            style=function(x) {
              style(display = "block", 
                    width = percent(normalize(x, ...)), 
                    `border-radius` = "4px", 
                    `padding-right` = "6px", 
                    `background-color` = csscolor(color),
                    `color` = csscolor("white"),
                    `text-align` = "right",
                    `vertical-align` = "middle",
                    `font-size` = "8pt",
                    `line-height` = "16pt",
                    `height` = "16pt")
            }
  )
}

formattable(select(arrange(df, desc(`Test 1 Score`)), 2, 5), 
  list(`Test 1 Score` = color_bar_only("black", 0.2)), 
  align=strsplit("rl", "")[[1]])

