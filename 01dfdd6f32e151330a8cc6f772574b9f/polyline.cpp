// source: https://mapzen.com/documentation/mobility/decoding/

#include <Rcpp.h>
#include <vector>

using namespace Rcpp;
// [[Rcpp::plugins(cpp11)]]

// [[Rcpp::export]]
DataFrame decode(const std::string& encoded) {
  size_t i = 0;     // what byte are we looking at

  constexpr double kPolylinePrecision = 1E5;
  constexpr double kInvPolylinePrecision = 1.0 / kPolylinePrecision;

  auto deserialize = [&encoded, &i](const int previous) {
    int byte, shift = 0, result = 0;
    do {
      byte = static_cast<int>(encoded[i++]) - 63;
      result |= (byte & 0x1f) << shift;
      shift += 5;
    } while (byte >= 0x20);
    return previous + (result & 1 ? ~(result >> 1) : (result >> 1));
  };

  std::vector<double> lonv, latv;
  int last_lon = 0, last_lat = 0;
  while (i < encoded.length()) {
    int lat = deserialize(last_lat);
    int lon = deserialize(last_lon);

    latv.emplace_back(static_cast<float>(static_cast<double>(lat) * kInvPolylinePrecision));
    lonv.emplace_back(static_cast<float>(static_cast<double>(lon) * kInvPolylinePrecision));

    last_lon = lon;
    last_lat = lat;
  }

  return DataFrame::create(_["lon"] = lonv, _["lat"] = latv);
}
