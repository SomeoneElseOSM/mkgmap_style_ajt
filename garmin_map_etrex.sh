# ------------------------------------------------------------------------------
# garmin_map_etrex.sh
# based on GARMIN_MAP_ETREX.BAT, which ran a VC# processor before calling
# mkgmap.
#
# Normally needs to be run from the correct directory; "cd" here added for
# testing convenience.
# ------------------------------------------------------------------------------
cd /drivec/Utils/gps/convert/20190315_test/
#
# ----------------------------------------------------------------------------
# What's the file that we are interested in?
# -----------------------------------------------------------------------------
#file_prefix1=great-britain
#file_page1=http://download.geofabrik.de/europe/${file_prefix1}.html
#file_url1=http://download.geofabrik.de/europe/${file_prefix1}-latest.osm.pbf
#
file_prefix1=north-yorkshire
file_page1=http://download.geofabrik.de/europe/great-britain/england/${file_prefix1}.html
file_url1=http://download.geofabrik.de/europe/great-britain/england/${file_prefix1}-latest.osm.pbf
#
# -----------------------------------------------------------------------------
# When was the target file last modified?
# -----------------------------------------------------------------------------
    wget $file_page1 -O file_page1.$$
    grep " and contains all OSM data up to " file_page1.$$ | sed "s/.*and contains all OSM data up to //" | sed "s/T..:..:..Z. File size.*//" > last_modified1.$$
    rm file_page1.$$
#
file_extension1=`cat last_modified1.$$`
#
if test -e ${file_prefix1}_${file_extension1}.osm.pbf
then
    echo "File1 already downloaded"
else
    wget $file_url1 -O ${file_prefix1}_${file_extension1}.osm.pbf
    rm 6???????.osm.gz
fi
#
# ------------------------------------------------------------------------------
# Run splitter
# "--output=xml" produces a series of ".osm.gz" files.
# These are compressed, so there's no need to worry about converting back to
# .pbf, and it makes it easy for the "mkgmap" line below to distinguish
# between the output from splitter (*.osm.gz) and the original input file 
# (something.pbf).
# ------------------------------------------------------------------------------
if test -e  "6........osm.gz"
then
  echo "Splitter already run"
else
  java  -Xmx1200m -jar /drivec/Utils/splitter-r592/splitter.jar ${file_prefix1}_${file_extension1}.osm.pbf --max-nodes=800000 --output=xml
fi
#
# ------------------------------------------------------------------------------
# Run mkgmap
# The normal one is "/drivec/Utils/mkgmap-r4283/mkgmap.jar"
# My build is "~/src/mkgmap/trunk/dist/mkgmap.jar"
# (they are currently identical)
#
# Other arguments currently not used:
# --family-id=3 --product-id=44 --mapname=63240002 --product-version=2 
# --series-name="AJT2S" --family-name="AJT2F" --area-name="AJT2A" 
# --description="AJT2D" 
#
# There appears to be no way to pass "--mapset-name" as a parameter; the 
# ~/src/mkgmap/trunk/src/uk/me/parabola/mkgmap/combiners/GmapsuppBuilder.java 
# default value always seems to be used.
#
# The full path to the style is needed, so 
# "/home/ajtown/src/mkgmap_style_ajt/ajt" rather than 
# "~/src/mkgmap_style_ajt/ajt".
# 
# Other style locations:
# /drivec/Utils/mkgmap-r1919/resources/styles/ajt
# /drivec/Utils/mkgmap-r4283/resources/styles/ajt
# ------------------------------------------------------------------------------
java -Xmx1200M -jar ~/src/mkgmap/trunk/dist/mkgmap.jar --style-file=/home/ajtown/src/mkgmap_style_ajt/ajt  --add-pois-to-areas --remove-short-arcs --levels="0=24, 1=22, 2=21, 3=19, 4=18, 5=16" --location-autofill=3 --route --gmapsupp --overview-mapname=ajt2map --country-name="United Kingdom" --country-abbr="UK" --copyright-message="Copyright OpenStreetMap contributors" *.osm.gz
#
if [ -f gmapsupp.img ]; then
  mv gmapsupp.img ajt2supp.img
  #
  mkdir etrex
  mv 6???????.img etrex
  mv ajt2supp.img etrex
  mv ajt2map.tdb  etrex
  mv ajt2map.img  etrex
else
  echo No gmapsupp.img file found
fi
#
# -----------------------------------------------------------------------------
# And final tidying up.
# Comment out removal of splitter .osm.gz files if testing.
# -----------------------------------------------------------------------------
rm last_modified1.$$
# rm 6???????.osm.gz
#
