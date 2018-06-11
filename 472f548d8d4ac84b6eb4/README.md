*2015-08-05 UPDATE*
I got an official response from the Maritime Safety Office that included the official shapefile! I added that GeoJSON to this gist

-------

So, I managed to determine that NIMA is directly associated with the NGIA and I found a GitHub org for NGIA: https://github.com/ngageoint?page=1

There's an iOS app repo there - https://github.com/ngageoint/anti-piracy-iOS-app which had a CSV file: https://raw.githubusercontent.com/ngageoint/anti-piracy-iOS-app/master/Asam/subregions.csv

That CSV file is a set of "spatial lines" for framing the sub-regions. I had to modify the subregions (I put the modified file in this gist) to remove duplicate IDs.

The R script in this gist will convert the CSV tile to a `SpatialPolygonsDataFrame` and also uses the `geojsonio` package to make a geojson file of the SPDF (which is also in the repo).

Thank you to everyone who went on the hunt! It's really weird this shapefile wasn't in any catalog.

The reason for this treasure hunt will become evident on September 19th! #rrrr