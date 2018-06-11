#include <Rcpp.h>
#include <boost/asio.hpp>

using namespace Rcpp;

Function message("message"); // lets us use R's message() function

//[[Rcpp::export]]
std::vector< std::string > gethostbyname(std::string hostname) {
  
  // setup storage for our return value

  std::vector<std::string> addresses;

  boost::asio::io_service io_service;
  
  // we're dealing with network/connectivity 'stuff' + you never know
  // when DNS queries will fail, so we need to handle exceptional cases
  
  try {
    
    // setup the resolver query
    
    boost::asio::ip::tcp::resolver resolver(io_service);
    boost::asio::ip::tcp::resolver::query query(hostname, "");
   
    // prepare response iterator
  
    boost::asio::ip::tcp::resolver::iterator destination = resolver.resolve(query);
    boost::asio::ip::tcp::resolver::iterator end;
    boost::asio::ip::tcp::endpoint endpoint;
    
    // example of using a c-ish while loop to iterate through possible multiple resoponses
    
    while (destination != end) {
      endpoint = *destination++;
      addresses.push_back(endpoint.address().to_string());
      
    }
    
  } catch(boost::system::system_error& error) {
    message( "Hostname not found" );
  }

  return(addresses);

}

//[[Rcpp::export]]
std::vector< std::string > gethostbyaddr(std::string ipv4) {
  
  // setup storage for our return value
  
  std::vector<std::string> hostnames;
  
  boost::asio::ip::tcp::endpoint endpoint;
  boost::asio::io_service io_service;
  
  // we're dealing with network/connectivity 'stuff' + you never know
  // when DNS queries will fail, so we need to handle exceptional cases
  
  try {
    
    // setup the resolver query (for PTR record)
    
    boost::asio::ip::address_v4 ip = boost::asio::ip::address_v4::from_string(ipv4);    
    endpoint.address(ip);
    boost::asio::ip::tcp::resolver resolver(io_service);    
    
    // prepare response iterator
    
   boost::asio::ip::tcp::resolver::iterator destination = resolver.resolve(endpoint);
    boost::asio::ip::tcp::resolver::iterator end;
    
    // example of using a for-loop to iterate through possible multiple resoponses
    
    for (int i=1; destination != end; destination++, i++) {
       hostnames.push_back(destination->host_name());
    }
    
  } catch(boost::system::system_error& error) {
    message( "Address not found" );
  }
  
  return(hostnames);
  
}
