# "ajt03" map legend
This page describes how OpenStreetMap features are shown on the "03" map style [here](https://github.com/SomeoneElseOSM/mkgmap_style_ajt/), visible [here](../mkgmap_maps/ajt03/).

## General Processing

No .typ file is used.

Most map features are transferred in the same way as mkgmap's standard style.  The mkgmap style used can be found [here](https://github.com/SomeoneElseOSM/mkgmap_style_ajt/tree/master/ajt03).  Differences include:

* Names used on more objects
* Removal of some duplicates and "typing error mappings" from the style; these are now handled in lua.
* Hiking routes are shown

The created maps are routable.

## Processing for specific objects

### Infrastructure

Some rarer tags are consolidated into "man_made=wastewater_plant".
