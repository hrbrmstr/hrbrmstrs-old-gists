export PKG_LIBS=`Rscript --vanilla -e 'Rcpp:::LdFlags()'`
export PKG_CPPFLAGS=`Rscript --vanilla -e 'Rcpp:::CxxFlags()'`
R CMD SHLIB -lldns txt.cpp
