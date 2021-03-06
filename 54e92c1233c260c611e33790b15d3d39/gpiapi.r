library(tidyverse)

gpi <- jsonlite::fromJSON("http://staging-maps.visionofhumanity.org/json_feeds/gpi.json?v=2.6.12&vv=2.6.12")

map(gpi, "csv") %>% 
  map_df(~read_csv(sprintf("http://staging-maps.visionofhumanity.org/csv/%s", .x))) %>% 
  docxtractr::mcga() -> gpi_df

glimpse(gpi_df)
## Observations: 1,618
## Variables: 121
## $ countrycode                              <chr> "AFG", "AGO", "ALB", "ARE", "ARG", "ARM", "AUS", "AUT", "AZE", "BDI", "B...
## $ countryname                              <chr> "Afghanistan", "Angola", "Albania", "United Arab Emirates", "Argentina",...
## $ rank                                     <int> 158, 119, 67, 30, 50, 138, 17, 11, 129, 142, 15, 110, 58, 98, 48, 64, 71...
## $ over                                     <dbl> 3.001, 2.266, 1.967, 1.695, 1.834, 2.458, 1.507, 1.415, 2.373, 2.496, 1....
## $ over_band                                <int> 5, 3, 3, 2, 2, 4, 2, 1, 3, 4, 2, 3, 2, 3, 2, 3, 3, 3, 3, 3, 2, 2, 4, 1, ...
## $ dist                                     <dbl> 5, 5, 3, 2, 3, 3, 2, 2, 3, 4, 2, 4, 4, 3, 3, 3, 3, 4, 3, 3, 2, 2, 5, 2, ...
## $ dist_band                                <int> 5, 5, 3, 2, 3, 3, 2, 2, 3, 4, 2, 4, 4, 3, 3, 3, 3, 4, 3, 3, 2, 2, 5, 2, ...
## $ poli                                     <dbl> 2.500, 2.500, 2.903, 3.250, 2.500, 2.500, 2.150, 2.529, 3.011, 2.500, 2....
## $ poli_band                                <int> 2, 2, 3, 3, 2, 2, 2, 2, 3, 2, 3, 4, 3, 1, 3, 5, 3, 2, 2, 3, 1, 3, 1, 2, ...
## $ homi                                     <dbl> 2.506, 4.085, 2.247, 1.397, 3.211, 2.158, 1.673, 1.368, 2.048, 2.488, 2....
## $ homi_band                                <int> 2, 4, 2, 1, 3, 2, 1, 1, 2, 2, 2, 3, 1, 2, 2, 1, 1, 3, 3, 5, 2, 5, 5, 1, ...
## $ jail                                     <dbl> 1.277, 1.348, 1.878, 3.278, 2.108, 1.965, 1.997, 1.831, 2.733, 1.823, 1....
## $ jail_band                                <int> 1, 1, 1, 3, 2, 2, 2, 1, 3, 1, 1, 1, 1, 1, 2, 1, 1, 5, 1, 2, 1, 4, 1, 1, ...
## $ wmid                                     <dbl> 5.0, 3.0, 4.0, 2.0, 2.0, 4.0, 1.0, 2.0, 4.0, 4.0, 2.0, 4.0, 4.0, 3.0, 3....
## $ wmid_band                                <int> 5, 3, 4, 2, 2, 4, 1, 2, 4, 4, 2, 4, 4, 3, 3, 2, 3, 3, 4, 4, 2, 3, 5, 2, ...
## $ inco                                     <dbl> 5, 2, 1, 1, 1, 2, 1, 1, 2, 4, 1, 4, 2, 3, 1, 2, 2, 3, 2, 1, 2, 1, 4, 1, ...
## $ inco_band                                <int> 5, 2, 1, 1, 1, 2, 1, 1, 2, 4, 1, 4, 2, 3, 1, 2, 2, 3, 2, 1, 2, 1, 4, 1, ...
## $ demo                                     <dbl> 3.0, 2.5, 3.0, 1.5, 3.5, 3.0, 2.0, 1.0, 3.0, 3.0, 2.0, 3.0, 2.5, 4.0, 2....
## $ demo_band                                <int> 3, 2, 3, 1, 4, 3, 2, 1, 3, 3, 2, 3, 2, 4, 2, 3, 2, 2, 4, 3, 2, 1, 2, 1, ...
## $ crim                                     <dbl> 3.0, 2.5, 3.0, 2.0, 3.0, 3.0, 2.0, 1.0, 2.0, 3.0, 2.0, 3.0, 1.0, 4.0, 3....
## $ crim_band                                <int> 3, 2, 3, 2, 3, 3, 2, 1, 2, 3, 2, 3, 1, 4, 3, 1, 1, 2, 3, 4, 2, 3, 4, 1, ...
## $ inst                                     <dbl> 4.250, 3.250, 2.750, 2.625, 2.250, 3.750, 1.000, 1.000, 3.500, 3.000, 1....
## $ inst_band                                <int> 5, 3, 3, 3, 2, 4, 1, 1, 4, 3, 1, 2, 2, 2, 1, 4, 2, 3, 4, 1, 2, 1, 5, 1, ...
## $ rehr                                     <dbl> 5.0, 3.0, 3.0, 2.0, 1.0, 3.0, 1.0, 2.0, 2.0, 4.0, 2.0, 2.0, 5.0, 4.0, 2....
## $ rehr_band                                <int> 5, 3, 3, 2, 1, 3, 1, 2, 2, 4, 2, 2, 5, 4, 2, 2, 2, 3, 2, 4, 1, 2, 4, 1, ...
## $ weim                                     <dbl> 1.034, 1.788, 1.192, 5.000, 1.406, 1.684, 3.715, 5.000, 1.257, 1.000, 1....
## $ weim_band                                <int> 1, 1, 1, 5, 1, 1, 4, 5, 1, 1, 1, 1, 1, 1, 2, 5, 1, 1, 1, 1, 1, 1, 1, 1, ...
## $ gtdx                                     <dbl> 4.072, 1.000, 1.004, 1.000, 1.058, 1.184, 1.031, 1.222, 1.184, 2.483, 1....
## $ gtdx_band                                <int> 5, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ...
## $ icon                                     <dbl> 3.905, 1.884, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.147, 4.095, 1....
## $ icon_band                                <int> 4, 2, 1, 1, 1, 1, 1, 1, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ...
## $ ndic                                     <dbl> 3.803, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1....
## $ ndic_band                                <int> 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 2, 1, ...
## $ mexp                                     <dbl> 1.793, 3.160, 1.835, 2.833, 1.466, 2.586, 2.135, 1.390, 2.625, 4.982, 1....
## $ mexp_band                                <int> 1, 3, 2, 3, 1, 2, 2, 1, 3, 5, 1, 1, 1, 1, 2, 3, 2, 1, 1, 1, 2, 2, 1, 1, ...
## $ army                                     <dbl> 1.245, 2.006, 1.529, 2.623, 1.288, 3.312, 1.390, 1.735, 2.198, 1.346, 1....
## $ army_band                                <int> 1, 2, 1, 3, 1, 3, 1, 1, 2, 1, 1, 1, 1, 1, 2, 3, 1, 2, 1, 1, 1, 1, 1, 1, ...
## $ unfu                                     <dbl> 1.000, 3.529, 1.000, 1.000, 3.072, 4.051, 1.000, 1.000, 1.296, 1.000, 1....
## $ unfu_band                                <int> 1, 4, 1, 1, 3, 4, 1, 1, 1, 1, 2, 1, 1, 5, 1, 2, 1, 1, 5, 5, 1, 1, 5, 1, ...
## $ hewe                                     <dbl> 1.038, 1.326, 1.002, 1.523, 1.423, 1.090, 1.371, 1.195, 1.216, 1.014, 1....
## $ hewe_band                                <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 2, 1, 1, 1, 1, ...
## $ weex                                     <dbl> 1.000, 1.002, 1.000, 1.126, 1.002, 1.000, 1.198, 1.719, 1.000, 1.000, 1....
## $ weex_band                                <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, ...
## $ refu                                     <dbl> 3.238, 1.681, 1.132, 1.000, 1.001, 1.265, 1.000, 1.000, 1.989, 2.515, 1....
## $ refu_band                                <int> 3, 1, 1, 1, 1, 1, 1, 1, 2, 2, 1, 1, 1, 1, 1, 1, 4, 1, 1, 1, 1, 1, 2, 1, ...
## $ rela                                     <dbl> 4.0, 3.0, 2.0, 1.0, 3.0, 5.0, 1.0, 1.0, 5.0, 3.0, 1.0, 4.0, 3.0, 2.0, 1....
## $ rela_band                                <int> 4, 3, 2, 1, 3, 5, 1, 1, 5, 3, 1, 4, 3, 2, 1, 2, 2, 3, 2, 1, 2, 1, 5, 1, ...
## $ econ                                     <dbl> 1.238, 1.000, 4.779, 1.000, 1.000, 3.300, 5.000, 1.129, 4.779, 1.000, 1....
## $ econ_band                                <int> 1, 1, 5, 1, 1, 3, 5, 1, 5, 1, 1, 1, 1, 1, 5, 1, 3, 1, 1, 1, 1, 1, 1, 1, ...
## $ ndec                                     <dbl> 1.478, 1.000, 1.000, 1.000, 1.000, 1.609, 1.000, 1.000, 1.696, 1.000, 1....
## $ ndec_band                                <int> 2, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, ...
## $ elec                                     <dbl> 6.167, 0.833, 7.333, 0.000, 8.750, NA, 10.000, 9.583, 3.083, NA, 9.583, ...
## $ elec_band                                <int> 3, 1, 4, 1, 4, NA, 5, 5, 2, NA, 5, NA, 2, 4, 4, 2, 4, 2, 4, 5, 3, 4, 1, ...
## $ gove                                     <dbl> 0.000, 3.214, 5.071, 3.929, 5.000, NA, 8.929, 7.857, 0.786, NA, 8.214, N...
## $ gove_band                                <int> 1, 2, 3, 2, 3, NA, 5, 4, 1, NA, 4, NA, 1, 3, 3, 2, 2, 2, 3, 4, 3, 4, 1, ...
## $ part                                     <dbl> 2.222, 3.333, 4.444, 1.111, 5.556, NA, 7.778, 7.778, 3.333, NA, 6.667, N...
## $ part_band                                <int> 2, 2, 3, 1, 3, NA, 4, 4, 2, NA, 4, NA, 2, 3, 4, 2, 3, 2, 3, 3, 2, 3, 1, ...
## $ pcul                                     <dbl> 2.500, 4.375, 5.625, 5.000, 5.625, NA, 8.750, 8.125, 3.750, NA, 7.500, N...
## $ pcul_band                                <int> 1, 2, 3, 3, 3, NA, 5, 4, 2, NA, 4, NA, 3, 2, 3, 3, 3, 2, 2, 3, 2, 3, 1, ...
## $ libe                                     <dbl> 4.412, 2.941, 7.059, 2.941, 8.235, NA, 10.000, 9.118, 5.000, NA, 9.412, ...
## $ libe_band                                <int> 2, 2, 3, 2, 3, NA, 4, 4, 2, NA, 4, NA, 2, 3, 4, 2, 3, 2, 3, 4, 2, 4, 1, ...
## $ corr                                     <dbl> 18, 22, 29, 57, 29, NA, 86, 81, 21, NA, 71, NA, 29, 20, 41, 50, 33, 21, ...
## $ corr_band                                <int> 1, 1, 1, 3, 1, NA, 5, 5, 1, NA, 4, NA, 1, 1, 2, 3, 2, 1, 1, 2, 3, 3, 1, ...
## $ wome                                     <dbl> 27.3, 15.0, 7.1, 22.5, 35.0, NA, 24.7, 32.2, 11.3, NA, 34.7, NA, 15.3, 1...
## $ wome_band                                <int> 3, 2, 1, 3, 4, NA, 3, 4, 2, NA, 4, NA, 2, 2, 3, 1, 2, 3, 2, 1, 1, 2, 2, ...
## $ dein                                     <dbl> 3.060, 2.939, 5.907, 2.596, 6.633, NA, 9.091, 8.492, 3.190, NA, 8.275, N...
## $ dein_band                                <int> 2, 2, 3, 1, 4, NA, 5, 5, 2, NA, 5, NA, 2, 3, 4, 2, 3, 2, 3, 4, 2, 4, 1, ...
## $ gein                                     <dbl> NA, 0.604, 0.661, 0.592, 0.683, NA, 0.716, 0.699, 0.678, NA, 0.708, NA, ...
## $ gein_band                                <int> NA, 3, 3, 2, 4, NA, 4, 4, 4, NA, 4, NA, 2, 3, 4, 2, NA, 4, 3, 3, NA, 4, ...
## $ pres                                     <dbl> 56.50, 26.50, 25.50, 20.25, 24.83, NA, 8.79, 4.25, 55.40, NA, 1.50, NA, ...
## $ pres_band                                <int> 3, 2, 2, 1, 2, NA, 1, 1, 3, NA, 1, NA, 1, 3, 1, 2, 1, 3, 1, 2, 2, 2, 2, ...
## $ exim                                     <dbl> 121.260, 159.600, 67.500, 69.016, 43.991, NA, 42.944, 106.736, 105.370, ...
## $ exim_band                                <int> 3, 4, 2, 2, 2, NA, 2, 3, 3, NA, 5, NA, 1, 1, 4, 4, 2, 3, 2, 1, 3, 3, 1, ...
## $ fdi                                      <dbl> 0.025, -0.100, 3.510, 5.140, 2.259, NA, 3.423, 0.048, -2.942, NA, 15.147...
## $ fdi_band                                 <int> 1, 1, 2, 2, 1, NA, 2, 1, 1, NA, 4, NA, 1, 1, 4, 4, 1, 1, 1, 1, 1, 1, 1, ...
## $ visi                                     <dbl> 0.000, 1.268, 1.451, 118.702, 9.995, NA, 24.778, 240.850, 13.794, NA, 63...
## $ visi_band                                <int> 1, 1, 1, 2, 1, NA, 1, 3, 1, NA, 1, NA, 1, 1, 1, 5, 1, 1, 1, 1, 1, 1, 1, ...
## $ migr                                     <dbl> 6.711, 0.875, -3.155, 19.410, -0.257, NA, 2.468, 1.207, -1.172, NA, 0.63...
## $ migr_band                                <int> 3, 2, 1, 5, 2, NA, 2, 2, 1, NA, 2, NA, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 1, ...
## $ male                                     <dbl> 13.415, 16.659, 15.841, 31.243, 16.461, NA, 14.097, 12.395, 17.625, NA, ...
## $ male_band                                <int> 1, 2, 2, 5, 2, NA, 1, 1, 2, NA, 1, NA, 2, 2, 1, 2, 1, 1, 2, 2, 1, 3, 2, ...
## $ gera                                     <dbl> 0.931, 1.028, 1.009, 0.477, 1.045, NA, 1.010, 1.040, 1.057, NA, 1.043, N...
## $ gera_band                                <int> 4, 4, 4, 1, 5, NA, 4, 5, 5, NA, 5, NA, 4, 4, 5, 2, 5, 5, 4, 4, 3, 4, 5, ...
## $ inte                                     <dbl> 4, 4, 3, 3, 3, NA, 3, 1, 3, NA, 1, NA, 4, 3, 1, 3, 3, 4, 3, 3, 2, 2, 4, ...
## $ inte_band                                <int> 4, 4, 3, 3, 3, NA, 3, 1, 3, NA, 1, NA, 4, 3, 1, 3, 3, 4, 3, 3, 2, 2, 4, ...
## $ educ                                     <dbl> 3.800, 2.608, 2.866, 1.268, 3.778, NA, 4.613, 5.421, 2.100, NA, 6.021, N...
## $ educ_band                                <int> 2, 1, 1, 1, 2, NA, 2, 2, 1, NA, 2, NA, 2, 1, 2, 1, 2, 2, 3, 2, 2, 4, 1, ...
## $ prim                                     <dbl> 53.000, 76.000, 94.000, 71.000, 99.000, NA, 96.000, 89.895, 85.000, NA, ...
## $ prim_band                                <int> 3, 4, 5, 4, 5, NA, 5, 5, 4, NA, 5, NA, 2, 5, 5, 5, 4, 4, 5, 5, 4, 4, 2, ...
## $ seco                                     <dbl> 16.000, 15.000, 69.000, 57.000, 79.000, NA, 85.000, 88.510, 78.000, NA, ...
## $ seco_band                                <int> 1, 1, 4, 3, 4, NA, 5, 5, 4, NA, 4, NA, 1, 3, 5, 5, 3, 5, 4, 4, 3, 3, 1, ...
## $ tert                                     <dbl> 1.079, 0.850, 19.280, 22.485, 63.863, NA, 72.209, 49.784, 14.773, NA, 62...
## $ tert_band                                <int> 1, 1, 2, 2, 4, NA, 5, 3, 1, NA, 4, NA, 1, 1, 3, 2, 2, 4, 3, 2, 1, 1, 1, ...
## $ scho                                     <dbl> 7.771, 5.000, 11.291, 11.465, 15.378, NA, 20.360, 15.087, 10.815, NA, 15...
## $ scho_band                                <int> 2, 1, 3, 3, 4, NA, 5, 4, 3, NA, 4, NA, 1, 2, 4, 4, 3, 4, 4, 4, 2, 3, 1, ...
## $ lite                                     <dbl> 28.0, 67.4, 98.7, 88.7, 97.2, NA, 99.0, 99.0, 98.8, NA, 99.0, NA, 23.6, ...
## $ lite_band                                <int> 1, 3, 5, 5, 5, NA, 5, 5, 5, NA, 5, NA, 1, 2, 5, 5, 5, 5, 5, 5, 2, 4, 2, ...
## $ host                                     <dbl> 4.0, 2.0, 2.0, 1.0, 2.0, NA, 1.5, 0.0, 2.0, NA, 1.0, NA, 0.0, 0.5, 0.0, ...
## $ host_band                                <int> 5, 3, 3, 2, 3, NA, 2, 1, 3, NA, 2, NA, 1, 1, 1, 3, 3, 3, 4, 2, 4, 2, 3, ...
## $ wilf                                     <dbl> 1, 3, 3, 1, 2, NA, 1, 2, 4, NA, 1, NA, 2, 1, 3, 1, 3, 4, 2, 2, 1, 1, 2, ...
## $ wilf_band                                <int> 1, 3, 3, 1, 2, NA, 1, 2, 4, NA, 1, NA, 2, 1, 3, 1, 3, 4, 2, 2, 1, 1, 2, ...
## $ gdp1                                     <dbl> 23.927, 56.778, 18.447, 100.439, 469.457, NA, 721.549, 299.352, 68.370, ...
## $ gdp1_band                                <int> 1, 1, 1, 1, 1, NA, 1, 1, 1, NA, 1, NA, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ...
## $ gdp2                                     <dbl> 8.399, 33.421, 9.267, 163.145, 214.267, NA, 755.794, 323.965, 19.851, NA...
## $ gdp2_band                                <int> 1, 1, 1, 1, 1, NA, 1, 1, 1, NA, 1, NA, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ...
## $ gdp3                                     <dbl> 323.0, 2020.0, 2920.0, 32990.0, 5498.2, NA, 37300.0, 39107.3, 2326.5, NA...
## $ gdp3_band                                <int> 1, 1, 1, 3, 1, NA, 3, 3, 1, NA, 3, NA, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, ...
## $ gini                                     <dbl> 60.0, 62.0, 31.1, 31.0, 51.3, NA, 35.2, 29.1, 36.5, NA, 33.0, NA, 39.5, ...
## $ gini_band                                <int> 4, 5, 2, 2, 4, NA, 3, 2, 3, NA, 3, NA, 3, 3, 2, 3, 2, 2, 4, 4, 2, 5, 5, ...
## $ unem                                     <dbl> 8.500, 8.000, 13.800, 2.300, 10.600, NA, 5.100, 4.700, 8.500, NA, 8.200,...
## $ unem_band                                <int> 1, 1, 2, 1, 1, NA, 1, 1, 1, NA, 1, NA, 1, 1, 1, 1, 3, 1, 1, 1, 1, 2, 1, ...
## $ expe                                     <dbl> 42.900, 41.416, 75.478, 79.185, 74.835, NA, 80.626, 79.383, 72.283, NA, ...
## $ expe_band                                <int> 1, 1, 5, 5, 5, NA, 5, 5, 4, NA, 5, NA, 2, 4, 4, 5, 5, 4, 4, 4, 4, 1, 1, ...
## $ mort                                     <dbl> 165.0, 154.0, 16.0, 7.8, 15.0, NA, 5.0, 4.0, 74.0, NA, 4.0, NA, 96.0, 54...
## $ mort_band                                <int> 5, 5, 1, 1, 1, NA, 1, 1, 3, NA, 1, NA, 3, 2, 1, 1, 1, 1, 2, 1, 2, 3, 4, ...
## $ militarisation                           <dbl> 1.839, 2.174, 1.713, 2.168, 1.632, 2.443, 1.599, 1.941, 1.965, 2.041, 1....
## $ militarisation_band                      <int> 2, 2, 2, 2, 1, 3, 1, 2, 2, 2, 1, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 1, 2, 2, ...
## $ safety_and_security                      <dbl> 3.396, 2.768, 2.437, 2.005, 2.273, 2.543, 1.565, 1.470, 2.463, 2.910, 1....
## $ safety_and_security_band                 <int> 4, 3, 3, 2, 2, 3, 1, 1, 3, 3, 2, 3, 2, 3, 2, 2, 2, 3, 3, 3, 1, 3, 4, 1, ...
## $ domestic_and_international_conflict      <dbl> 3.401, 1.782, 1.548, 1.000, 1.403, 2.340, 1.367, 1.012, 2.523, 2.630, 1....
## $ domestic_and_international_conflict_band <int> 5, 2, 2, 1, 1, 3, 1, 1, 3, 4, 1, 3, 2, 2, 1, 1, 2, 2, 1, 1, 1, 1, 4, 1, ...
