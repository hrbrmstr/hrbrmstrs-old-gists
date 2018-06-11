#include <Rcpp.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

using namespace Rcpp ;

// [[Rcpp::export]]
CharacterVector getNameInfo(std::string fqdn) {

  struct addrinfo hints, *res, *res0;
	int error;
	char host[NI_MAXHOST];

  memset(&hints, 0, sizeof hints);
	hints.ai_family = PF_UNSPEC;
	hints.ai_socktype = SOCK_DGRAM;

	error = getaddrinfo(fqdn.c_str(), NULL, &hints, &res0);
	if (error) { return(NA_STRING);	}

  int i = 0 ;
	for (res = res0; res; res = res->ai_next) {
  	error = getnameinfo(res->ai_addr, res->ai_addrlen,
		    host, sizeof host, NULL, 0, NI_NUMERICHOST);
		if (!error) { i++ ; }
	}

  CharacterVector results(i) ;

  i = 0;

  for (res = res0; res; res = res->ai_next) {
		error = getnameinfo(res->ai_addr, res->ai_addrlen,
		    host, sizeof host, NULL, 0, NI_NUMERICHOST);
		if (!error) { results[i++] = host ; }
	}

  freeaddrinfo(res0);

  return(results) ;

}

// [[Rcpp::export]]
CharacterVector getAddrInfo(std::string ip) {

  struct sockaddr_in sa;
  sa.sin_family = AF_INET;
  inet_pton(AF_INET, ip.c_str(), &sa.sin_addr);

  char node[NI_MAXHOST];
  int res = getnameinfo((struct sockaddr*)&sa,
                        sizeof(sa), node, sizeof(node), NULL, 0, 0);
  if (res) { return(NA_STRING); }
  return(node);

}
