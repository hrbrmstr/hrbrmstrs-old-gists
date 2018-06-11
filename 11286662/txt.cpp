// these three includes do a great deal of heavy lifting
// by making the necessary structures, functions and macros
// available to us for the rest of the code

#include <Rcpp.h>
#include <Rinternals.h>
#include <Rdefines.h>

#ifdef __linux__
#include <bsd/string.h>
#endif

// REF: http://www.nlnetlabs.nl/projects/ldns/ for API info
#include <ldns/ldns.h>

// need this for 'wrap()' which *greatly* simplifies dealing
// with return values
using namespace Rcpp; 

// the sole function that does all the work. it accepts an
// R character vector as input (even though we're only expecting
// one string to lookuo) and returns a character vector (one row
// of the DNS TXT records)
RcppExport SEXP txt(SEXP ipPointer) {
  
  ldns_resolver *res = NULL;
  ldns_rdf *domain = NULL;
  ldns_pkt *p = NULL;
  ldns_rr_list *txt = NULL;
  ldns_status s;
  ldns_rr *answer;
  
  // SEXP passes in an R vector, we need this as a C++ StringVector
  Rcpp::StringVector ip(ipPointer);
  
  // we only passed in one IP address
  domain = ldns_dname_new_frm_str(ip[0]);
  if (!domain) { return(R_NilValue) ; }
  
  s = ldns_resolver_new_frm_file(&res, NULL);
  if (s != LDNS_STATUS_OK) { return(R_NilValue) ; }
  
  p = ldns_resolver_query(res, domain, LDNS_RR_TYPE_TXT, LDNS_RR_CLASS_IN, LDNS_RD);

  ldns_rdf_deep_free(domain); // no longer needed
  
  if (!p) { return(R_NilValue) ; }
                               
  // get the TXT record(s)
  txt = ldns_pkt_rr_list_by_type(p, LDNS_RR_TYPE_TXT, LDNS_SECTION_ANSWER); 
  if (!txt) {
    ldns_pkt_free(p);
    ldns_rr_list_deep_free(txt);
    return(R_NilValue) ;
  }

  // get the TXT record (could be more than one, but not for our IP->ASN)
  answer = ldns_rr_list_rr(txt, 0);
  
  // get the TXT record (could be more than one, but not for our IP->ASN)
  ldns_rdf *rd = ldns_rr_pop_rdf(answer) ;  
  
  // get the character version via safe copy
  char *answer_str = ldns_rdf2str(rd) ;

  // Max TXT record length is 255 chars, but for this example
  // the Team CYMRU ASN resolver TXT records should never exceed
  // 80 characters (from bulk analysis of large sets of IPs)
  
  char ret[80] ;
  strlcpy(ret, answer_str, sizeof(ret)) ;

  Rcpp::StringVector result(1);
  result[0] = ret ;

  // clean up memory
  free(answer_str);    
  ldns_rr_list_deep_free(txt);  
  ldns_pkt_free(p);
  ldns_resolver_deep_free(res);

  // return the TXT answer string which is ridiculously
  // simple even for wonkier structures thanks to `wrap()`
  return(wrap(result));
    
}