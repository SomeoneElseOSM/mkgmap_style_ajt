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

### Infrastructure and industrial landuse

Some rarer tags are consolidated into "man_made=wastewater_plant" and have "(sewage)" appended to the name.

Electricity substations have "(el. sub.)" appended.

A selection of industrial tags have the "landuse=industrial" tag added.

### Places

place=quarter is shown as place=neighbourhood

natural=cape is shown as place=locality

### Single point objects

Various milestones etc. are consolidated into "man_made=marker" and "(milestone)" is appended to the name.
Various pipeline markers are consolidated into "man_made=marker" and "(pipeline marker)" is appended to the name.
Various boundary stones are consolidated into "man_made=marker" and any inscription and "(boundary stone)" are appended to the name.
Various other stones are consolidated into "man_made=marker" and any inscription and "(ogham stone)", "(historic stone)" or "(historic stone)" are appended to the name.
Mass rocks are consolidated into "man_made=marker" and "(mass rock)" is appended to the name.

### Former telephone boxes

The current use is appended to the name, for example "(fmr phone defib)".

## Shops

Some rarer tags are consolidated into "shop=car", "shop=car_repair" and "shop=bicycle".

## Diplomatic

End-user diplomatic things are consolidated into "amenity=embassy".  Others (e.g. "diplomatic=trade_delegation") are shown as offices.

## Wells

Holy wells are shown as springs and have "(holy well)" appended to the name
Ordinary wells are shown as springs and have "(well)" appended to the name

## Grass etc. landuse

Unnamed "amenity=biergarten" are shown as pub beer gardens, which is all they likely are.

Unlike the web maps, "landuse=farmland" is not explicitly shown, and neither is the "landuse=farmgrass" computer tag (from agricultural pasture and agricultural meadows).  Meadows that would count as "farmgrass" have their landuse tag removed.

Many "green" features are shown as "leisure=park" wirh the type (e.g. "(common)") appended to the name.  
This includes:

* beer_garden (pub beer gardens)
* outdoor grass (grass-covered outdoor seating areas)
* garden (other gardens)
* grass (other grass)
* greenfield
* meadow
* showground (various showground tags)
* car boot sale
* playground
* village green
* scout camp
* fishing
* outdoor centre

Farmyards and greenhouse horticulture are consolidated into "landuse=farmyard" and a suffix is appended to the name.

Dog parks and "leisure=court" are shown as "leisure=pitch".

## Tourism

Bird and wildlife hides are shown as tourist information with a suffix added to the name.
