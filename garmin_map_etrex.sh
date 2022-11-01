# -----------------------------------------------------------------------------
# garmin_map_etrex.sh
# based on GARMIN_MAP_ETREX.BAT, which ran a VC# processor before calling
# mkgmap.
#
# The output files produced are ajt2supp.img, ajt2map.tdb, ajt2map.img
# in ~/data/mkgmap/etrex
# -----------------------------------------------------------------------------
local_filesystem_user=ajtown
cd /home/${local_filesystem_user}/data/
if test -e update_garmin.running
then
    echo update_garmin.running exists so exiting
    exit 1
else
    touch update_garmin.running
fi
#
# ----------------------------------------------------------------------------
# What's the file that we are interested in?
#
# The data file is downloaded in ~/data which allows it to be shared with data
# files user by update_render.sh; if that is also installed.
#
# While still testing, just use a small area:
# ----------------------------------------------------------------------------
file_prefix1=great-britain
file_page1=http://download.geofabrik.de/europe/${file_prefix1}.html
file_url1=http://download.geofabrik.de/europe/${file_prefix1}-latest.osm.pbf
#
#file_prefix1=north-yorkshire
#file_page1=http://download.geofabrik.de/europe/great-britain/england/${file_prefix1}.html
#file_url1=http://download.geofabrik.de/europe/great-britain/england/${file_prefix1}-latest.osm.pbf
#
#
# First things first - define some shared functions
#
final_tidy_up()
{
    cd /home/${local_filesystem_user}/data/mkgmap
    rm 6???????.osm.gz
    cd /home/${local_filesystem_user}/data/
    rm last_modified1.$$
    rm update_garmin.running
}

# -----------------------------------------------------------------------------
# When was the target file last modified?
# -----------------------------------------------------------------------------
wget $file_page1 -O file_page1.$$
grep " and contains all OSM data up to " file_page1.$$ | sed "s/.*and contains all OSM data up to //" | sed "s/. File size.*//" > last_modified1.$$
rm file_page1.$$
#
file_extension1=`cat last_modified1.$$`
#
if test -e ${file_prefix1}_${file_extension1}.osm.pbf
then
    echo "File1 already downloaded"
else
    wget $file_url1 -O ${file_prefix1}_${file_extension1}.osm.pbf
    rm mkgmap/6???????.osm.gz
fi
#
mkdir mkgmap
cd mkgmap
#
# ------------------------------------------------------------------------------
# Run splitter
# "--output=xml" produces a series of ".osm.gz" files.
# ------------------------------------------------------------------------------
if test -e  "6........osm.gz"
then
  echo "Splitter already run"
else
  java  -Xmx9600m -jar /usr/share/mkgmap-splitter/splitter.jar ../${file_prefix1}_${file_extension1}.osm.pbf --max-nodes=800000 --output=xml
fi
#
# ------------------------------------------------------------------------------
# Run mkgmap
#
# Other arguments currently not used:
# --family-id=3 --product-id=44 --mapname=63240002 --product-version=2 
# --series-name="AJT2S" --family-name="AJT2F" --area-name="AJT2A" 
# --description="AJT2D" 
#
# There appears to be no way to pass "--mapset-name" as a parameter; the 
# .../trunk/src/uk/me/parabola/mkgmap/combiners/GmapsuppBuilder.java 
# default value always seems to be used.
#
# The full path to the style is needed, so e.g.
# "/home/${local_filesystem_user}/src/mkgmap_style_ajt/ajt" rather than 
# "~/src/mkgmap_style_ajt/ajt".
# ------------------------------------------------------------------------------
java -Xmx9600m -jar /usr/share/mkgmap/mkgmap.jar --style-file=/home/${local_filesystem_user}/src/mkgmap_style_ajt/ajt  --add-pois-to-areas --remove-short-arcs --levels="0=24, 1=22, 2=21, 3=19, 4=18, 5=16" --location-autofill=3 --route --gmapsupp --overview-mapname=ajt2map --country-name="United Kingdom" --country-abbr="UK" --copyright-message="Copyright OpenStreetMap contributors" *.osm.gz
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
final_tidy_up
#
