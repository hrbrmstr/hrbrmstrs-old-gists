# need "chron" package for is.weekend()
require(chron)

# generate a sequence of dates
m.days <- seq.Date(from=as.Date("2013-08-01"), to=as.Date("2013-08-31"), by="1 day")

# if a day in the sequence is a weekend, return it
wknds <- ldply(m.days, function(m.day) {
  if (is.weekend(m.day)) m.day
})

# makes the following:
#           V1
# 1 2013-08-03
# 2 2013-08-04
# 3 2013-08-10
# 4 2013-08-11
# 5 2013-08-17
# 6 2013-08-18
# 7 2013-08-24
# 8 2013-08-25
# 9 2013-08-31

# now make a data frame with the weekend dates and which dow it is
wknds.df <- data.frame(d=wknds$V1, dow=weekdays(wknds$V1))

#            d      dow
# 1 2013-08-03 Saturday
# 2 2013-08-04   Sunday
# 3 2013-08-10 Saturday
# 4 2013-08-11   Sunday
# 5 2013-08-17 Saturday
# 6 2013-08-18   Sunday
# 7 2013-08-24 Saturday
# 8 2013-08-25   Sunday
# 9 2013-08-31 Saturday
