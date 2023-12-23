# -----------------------------------------------------------------------------
# garmin_map_etrex_03.sh
# This builds on garmin_map_etrex.sh and uses osm-tags-transform to 
# transform data before feeding it to splitter and mkgmap.
#
# The output files produced are ajt03supp.img, ajt03map.tdb, ajt03map.img
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
# Live weekly builds on map.atownsend.org.uk use "great-britain".
# ----------------------------------------------------------------------------
#file_prefix1=great-britain
#file_prefix1=britain-and-ireland
#file_page1=http://download.geofabrik.de/europe/${file_prefix1}.html
#file_url1=http://download.geofabrik.de/europe/${file_prefix1}-latest.osm.pbf
#
#file_prefix1=cheshire
#file_prefix1=cumbria
#file_prefix1=derbyshire
#file_prefix1=east-yorkshire-with-hull
#file_prefix1=greater-london
#file_prefix1=lincolnshire
file_prefix1=north-yorkshire
#file_prefix1=nottinghamshire
#file_prefix1=south-yorkshire
#file_prefix1=suffolk
#file_prefix1=west-yorkshire
file_page1=http://download.geofabrik.de/europe/great-britain/england/${file_prefix1}.html
file_url1=http://download.geofabrik.de/europe/great-britain/england/${file_prefix1}-latest.osm.pbf
#
#
# First things first - define some shared functions
#
final_tidy_up()
{
    cd /home/${local_filesystem_user}/data/mkgmap
    rm 6???????.osm.gz
    rm transformed_after.pbf
    cd /home/${local_filesystem_user}/data/
    rm last_modified1.$$
    rm update_garmin.running
}

m_error_01()
{
    final_tidy_up
    # qqq date | mail -s "garmin_map_etrex_03 FAILED on `hostname`" ${local_filesystem_user}
    exit 1
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
# Run osm-tags-transform
# ------------------------------------------------------------------------------
if /home/${local_filesystem_user}/src/osm-tags-transform/build/src/osm-tags-transform -c /home/${local_filesystem_user}/src/mkgmap_style_ajt/transform_03.lua ../${file_prefix1}_${file_extension1}.osm.pbf -O -o transformed_after.pbf
then
    echo Transform OK
else
    echo Transform Error
    m_error_01
fi

# ------------------------------------------------------------------------------
# Run splitter
# "--output=xml" produces a series of ".osm.gz" files.
# ------------------------------------------------------------------------------
if test -e  "6........osm.gz"
then
  echo "Splitter already run"
else
  java  -Xmx9600m -jar /usr/share/mkgmap-splitter/splitter.jar transformed_after.pbf --max-nodes=800000 --output=xml
fi
#
# ------------------------------------------------------------------------------
# Run mkgmap
#
# Other arguments currently not used:
# --family-id=3 --product-id=44 --mapname=63240002 --product-version=2 
# --series-name="AJT03S" --family-name="AJT03F" --area-name="AJT03A" 
# --description="AJT03D" 
#
# There appears to be no way to pass "--mapset-name" as a parameter; the 
# .../trunk/src/uk/me/parabola/mkgmap/combiners/GmapsuppBuilder.java 
# default value always seems to be used.
#
# The full path to the style is needed, so e.g.
# "/home/${local_filesystem_user}/src/mkgmap_style_ajt/ajt03" rather than 
# "~/src/mkgmap_style_ajt/ajt03".
# ------------------------------------------------------------------------------
java -Xmx9600m -jar /usr/share/mkgmap/mkgmap.jar --style-file=/home/${local_filesystem_user}/src/mkgmap_style_ajt/ajt03  --add-pois-to-areas --remove-short-arcs --levels="0=24, 1=22, 2=21, 3=19, 4=18, 5=16" --location-autofill=3 --route --gmapsupp --overview-mapname=ajt03map --country-name="United Kingdom" --country-abbr="UK" --copyright-message="Copyright OpenStreetMap contributors" *.osm.gz
#
if [ -f gmapsupp.img ]; then
  mkdir -p etrex
  mv 6???????.img etrex
  mv gmapsupp.img  etrex/ajt03_${file_prefix1}_supp.img
  mv ajt03map.tdb  etrex/ajt03_${file_prefix1}_map.tdb
  mv ajt03map.img  etrex/ajt03_${file_prefix1}_map.img
  # ---------------------------------------------------------------------------
  # At this point we know that a file was successfully created.
  # Copy it to a directory below a webserver /var/www/html/maps/mkgmap_maps/ajt03:
  # ---------------------------------------------------------------------------
  mkdir -p /var/www/html/maps/mkgmap_maps/ajt03/${file_prefix1}
  cp etrex/ajt03_${file_prefix1}_supp.img /var/www/html/maps/mkgmap_maps/ajt03/${file_prefix1}/
  cp etrex/ajt03_${file_prefix1}_map.tdb /var/www/html/maps/mkgmap_maps/ajt03/${file_prefix1}/
  cp etrex/ajt03_${file_prefix1}_map.img /var/www/html/maps/mkgmap_maps/ajt03/${file_prefix1}/
  # ---------------------------------------------------------------------------
  # Update html files from markdown.
  # ---------------------------------------------------------------------------
  pandoc /home/${local_filesystem_user}/src/SomeoneElse-map/mkgmap.md > /var/www/html/maps/map/mkgmap.html
  pandoc /home/${local_filesystem_user}/src/mkgmap_style_ajt/changelog_mkgmap.md > /var/www/html/maps/map/changelog_mkgmap.html
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
