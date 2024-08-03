# mkgmap_style_ajt
Create maps for Garmin GPX devices.

## Introduction

[mkgmap](https://www.mkgmap.org.uk/) can be used to create maps for Garmin devices from OpenStreetMap data.  See also links from [here](https://wiki.openstreetmap.org/wiki/Mkgmap) on the OpenStreetMap wiki.

There are a few things in this repository:

* a simple variant of mkgmap's standard map style called "ajt" that shows public footpaths and some route relations, and doesn't show roads and tracks that are likely to be private as far as foot access is concerned.

* a more detailed variant called "ajt03", which appends more OSM tagging information into the resulting map.

* shell scripts that can be used to call "mkgmap" and create each one.

An example map in the simple style showing a public footpath running along a service road and a track that is part of a route relation:

![IMG_20221009_210942_HDR_2](https://user-images.githubusercontent.com/5311740/194777623-1a0fd2c3-e997-4ca1-8f54-c9a8cf839d95.jpg)

## Dependencies

The latest version of "mkgmap" can be downloaded from [here](https://www.mkgmap.org.uk/download/mkgmap.html), and you will also need "splitter" from [here](https://www.mkgmap.org.uk/download/splitter.html).

The [script](https://github.com/SomeoneElseOSM/mkgmap_style_ajt/blob/master/garmin_map_etrex.sh) assumes that the mkgmap jar file is installed at "/usr/share/mkgmap/mkgmap.jar" and the splitter jar is at "/usr/share/mkgmap-splitter/splitter.jar".  These are the default locations if installed on Ubuntu 22.04 as follows:

    sudo apt install openjdk-11-jdk-headless
    sudo apt install mkgmap-splitter
    sudo apt install mkgmap

If you already have a version of Java installed you may be able to skip the "openjdk" step.

Older versions of mkgmap and splitter will also work; it doesn't need to be a bleeding edge version.

A "local filesystem user" is defined at the top of the script.  This repository is expected to be at ".../src/mkgmap_style_ajt" and a "data" directory at ".../data" is expected to exist.

The amount of memory and disk space needed will depend on the size of the files downloaded and the map created.  4GB memory and a few GB disk should be enough for a medium-sized country (in OSM terms) such as Great Britain, which is a 1.4GB download from Geofabrik.

The total map size probably can't be greater than 4GB, which probably means that the largest OSM download that it'll work with is probably about 5GB or less (i.e. any OSM country other than the USA).

Supported Garmin devices include a range of eTrex, GPSMap and Nüvi devices, and probably others too (even some watches etc.) - as long as there's enough storage on the device for the maps you install _and_ and the waypoints, routes and tracks that you will want to create later, there should been no problems.

## Creating simple maps

Ensure that the dependencies above are met.  

Run the "garmin_map_etrex_02.sh" script with parameters specifying what Geofabrik area you want to download, so something like:

    ./garmin_map_etrex_02.sh europe great-britain england north-yorkshire

should work.

If it succeeds, you should have 3 files:

    .../data/mkgmap/etrex/ajt02_area_supp.img
    .../data/mkgmap/etrex/ajt02_area_map.img
    .../data/mkgmap/etrex/ajt02_area_map.tdb

where "area" is the area it downloaded.

If your Garmin GPS supports an external SD card and you don't currently have an SD card in it, it's recommended to copy these files to the "garmin" directory of an [FAT32-formatted](https://support.garmin.com/en-US/?faq=ZpYaMzfRLI8SE5KmrY9k27) SD card and insert that in the device.  Use a 32GB or smaller card.

If you don't have a free SD card slot you can, if [very careful](https://wiki.openstreetmap.org/wiki/Garmin/GPS_series#Problems)**, install these three files into the "Garmin" directory of the device itself.

** Do not delete or modify any existing files!  As the licence of this software notes, "THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU.  SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION".

If the script didn't work for some reason, you'll need to investigate why it failed.  You may need to delete a file "update_garmin.running" in the ".../data" directory.  If the script didn't complete successfully, don't "just try the files in your device" - fix the problem and rerun the script.

## QA map style using lua tag transforms.

In addition, another [script](https://github.com/SomeoneElseOSM/mkgmap_style_ajt/blob/master/garmin_map_etrex_03.sh) is available that uses "osm-tags-transform" (a front-end for "osmium").  This allows the mkgmap "style" files to be simpler, and allows more complicated QA rules, such as:

* roads expected to have a speed limit have (M) appended to the name
* roads untagged as either lit or not lit have (L) appended to the name
* roads untagged as either with or without sidewalk have (S) appended to the name
* roads tagged with no sidewalk but untagged as either with or without verge have (V) appended to the name
* paths without foot access tagged have (A) appended to the name
* highway=road has (RD) appended to the name
* fixme and FIXME have (fix) appended to the name (but will still only appear if some other tag would cause it to)

Run the script with parameters such as these

    ./garmin_map_etrex_03.sh europe great-britain england north-yorkshire

When run, if it succeeds, it will create 3 files:

If it succeeds, you should have 3 files:

    .../data/mkgmap/etrex/ajt03_area_supp.img
    .../data/mkgmap/etrex/ajt03_area_map.img
    .../data/mkgmap/etrex/ajt03_area_map.tdb

where "area" is the area it downloaded.  Copy to your device as per "If your Garmin GPS supports an external SD card" above.


