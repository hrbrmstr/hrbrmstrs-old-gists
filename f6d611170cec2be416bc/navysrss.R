library(httr)

srss <- GET("http://aa.usno.navy.mil/cgi-bin/aa_rstablew.pl",
             query=list(FFX="2", xxy="2014", type="0", place="Southern Maine", 
                        xx0="-1", xx1="43", xx2="", 
                        yy0="1", yy1="70", yy2="",
                        zz1="5", zz0="-1"), verbose())

readings <- strsplit(content(srss, as="text"), "\n")




