library(iptools)

north_america <- unlist(country_ranges(countries=c("US", "CA", "MX")))
germany <- unlist(country_ranges("DE"))

set.seed(1492)
targets <- ip_random(1000)

for_sure <- range_generate(sample(north_america, 1))
all(ip_in_any(for_sure, north_america)) # shld be TRUE

absolutely_not <- range_generate(sample(germany, 1))
any(ip_in_any(absolutely_not, north_america)) # shld be FALSE

who_knows_na <- ip_in_any(targets, north_america)
who_knows_de <- ip_in_any(targets, germany)

sum(who_knows_na)
sum(who_knows_de)
