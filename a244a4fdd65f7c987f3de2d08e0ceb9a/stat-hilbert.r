library(Rcpp)
library(dplyr)
library(ggplot2) # devtools::install_github("tidyverse/ggplot2")

#' @param ips a vector of numeric IPv4 addresses
#' @param addr_space_bits_per_image (will depend on CIDR being shown - default = full IPv4)
#' @param addr_space_bits_per_pixel (normally 1 pixel == 256 addrs; this mods that)
cppFunction('
List ips_to_xy(std::vector<unsigned> ips,
               int addr_space_bits_per_image = 32L,
               int addr_space_bits_per_pixel = 8L) {

  int i;
  int order = (addr_space_bits_per_image - addr_space_bits_per_pixel) / 2L;
  unsigned int state, x, y, row, s;

  unsigned int addr_space_first_addr = 0L;

  std::vector<unsigned> out_x(ips.size());
  std::vector<unsigned> out_y(ips.size());

  for (unsigned int j=0; j<ips.size(); j++) {

    s = (((unsigned)ips[j]) - addr_space_first_addr) >> addr_space_bits_per_pixel;

    state = x = y = 0L;

    for (i = 2L * order - 2L; i >= 0; i -= 2L) {

      row = 4 * state | ((s >> i) & 3);

      x = (x << 1L) | ((0x936C >> row) & 1L);
      y = (y << 1L) | ((0x39C6 >> row) & 1L);

      state = (0x3E6B94C1 >> 2L * row) & 3L;

    }

    out_x[j] = x;
    out_y[j] = y;

  }

  DataFrame out = DataFrame::create(Named("x", out_x), Named("y", out_y));

  out.attr("class") = CharacterVector::create("tbl_df", "data.frame") ;

  return(out);

}
')

StatHilbertV4 <- ggproto(

  "StatHilbertV4",
  Stat,

  extra_params = c("na.rm", "bpp", "bpi"),

  setup_params = function(data, params) {
    params
  },

  setup_data = function(self, data, params) {
    data$ip <- if (is.character(data$ip)) iptools::ip_to_numeric(data$ip) else data$ip
    data <- cbind(data, ips_to_xy(data$ip, params$bpi, params$bpp))
    data <- dplyr::count(data, PANEL, x, y)
    data$ip <- 0
    data$y <- -(data$y)
    data
  },

  compute_panel = function(self, data, scales, ...) {
    data
  },

  default_aes = aes(fill = calc(n)),
  required_aes = c("ip")

)

stat_hilbert_v4 <- function(mapping = NULL, data = NULL, geom = "raster",
                            bpi=32, bpp=c(8, 10, 12, 14, 16),
                            position = "identity", na.rm = FALSE, show.legend = NA,
                            inherit.aes = TRUE, ...) {
  layer(
    stat = StatHilbertV4,
    data = data,
    mapping = mapping,
    geom = geom,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      na.rm = na.rm,
      bpi = bpi,
      bpp = bpp[1],
      ...
    )
  )
}

"%||%" <- function(a, b) if (!is.null(a)) a else b

CoordHilbertV4 <- ggproto(
  "CoordHilbertV4",
  CoordCartesian,
  aspect = function(self, ranges) {
    diff(ranges$y.range) / diff(ranges$x.range) * self$ratio
  }
)

coord_hilbert_v4 <- function(xlim = NULL, ylim = NULL, bpp=c(8, 10, 12, 14, 16), expand=FALSE) {

  mx <- 4096/c(`8`=1, `10`=2, `12`=4, `14`=8, `16`=16)[as.character(bpp[1])]

  if (!is.null(ylim)) ylim <- -(ylim)

  ggproto(
    NULL,
    CoordHilbertV4,
    limits = list(
      x = xlim %||% c(0, mx),
      y = ylim %||% c(0, -mx)
    ),
    ratio = 1,
    expand = expand
  )

}

theme_hilbert_v4 <- function() {
  theme(panel.background = element_rect(fill = "black")) +
    theme(panel.grid.major = element_blank()) +
    theme(panel.grid.minor = element_blank()) +
    theme(axis.ticks = element_blank()) +
    theme(axis.text = element_blank()) +
    theme(axis.title = element_blank())
}

# test --------------------------------------------------------------------

# Use any IPs you want...this is the file from the other day
xdf <- read_rds("heis_eb_ip_uniq_asn_org.rds")

# the only aes() is `ip`
ggplot(xdf, aes(ip=ip)) +
  stat_hilbert_v4(bpp=16) +
  coord_hilbert_v4(bpp=16) +
  # coord_hilbert_v4(xlim=c(0,255), ylim=c(0,255)) +
  viridis::scale_fill_viridis(name="IPv4 count per pixel", trans="log10") +
  theme_hilbert_v4()
