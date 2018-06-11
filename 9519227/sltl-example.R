library(sltl)

out <- sltl(as.timeSeries(co2),
            c.window=101,
            c.degree=1,
            type="monthly")

summary(out)

plot.sltl(out)
