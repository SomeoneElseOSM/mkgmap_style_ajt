# "ajt03" map legend
This page describes how OpenStreetMap features are shown on the "03" map style [here](https://github.com/SomeoneElseOSM/mkgmap_style_ajt/), visible [here](../mkgmap_maps/ajt03/).

## General Processing

No .typ file is used.

Most map features are transferred in the same way as mkgmap's standard style.  The mkgmap style used can be found [here](https://github.com/SomeoneElseOSM/mkgmap_style_ajt/tree/master/ajt03).  Differences include:

* Names used on more objects
* Removal of some duplicates and "typing error mappings" from the style; these are now handled in lua.
* Hiking routes are shown

The created maps are routable.

Extra information is added to a tag in round brackets, for example "(meadow)".

Tags useful for quality control are added to a tag in square brackets, for example "[fix]".

## Processing for specific objects

### Roads and Paths

Some corridors are shown as paths.

Some rare highway tags are consolidated into "track".

Golf features are shown as paths or tracks if no other appropriate tags exist.

Wide paths are shown as tracks.
Narrow tracks are shown as paths.

Narrow tertiary roads are shown as unclassified.

Show highway=busway as highway=service.

Roads with different names on left and right are shown correctly.

Unusual access tags such as "access:foot" are used if no more usual equivalent (here "foot") is available.

Negative access tags (private / no) are consolidated to make value checks simpler.

These maps are designed for foot access, so use tags such as "foot" in place of "access".

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

### Diplomatic

End-user diplomatic things are consolidated into "amenity=embassy".  Others (e.g. "diplomatic=trade_delegation") are shown as offices.

### Wells

Holy wells are shown as springs and have "(holy well)" appended to the name
Ordinary wells are shown as springs and have "(well)" appended to the name

### Grass etc. landuse

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

### Tourism

Bird and wildlife hides are shown as tourist information with a suffix added to the name.

Guideposts, fingerposts and markers have "GP" appended to the name.

Route markers have "RM" appended to the name.

Various types of boards and maps have "B" appended to to name.

Signs have "S" appended to to name.

"destination" features have "DEST" appended.  "intermediary" ones have "INT".

Guideposts that are "public right of way" markers have "PROW" appended.

Guideposts that sign a route have "ROUTE" appended.


### Trees

"forestry" is handled as "forest".  Various tags are consolidated into "wood".  "operator" is appended to the name, if present.

### Shops

Some rarer tags are consolidated into "shop=car", "shop=car_repair" and "shop=bicycle".
Building societies are consolidated into banks.
ATMs have "(ATM)" added as a suffix.

### Pubs, restaurants etc.

Pubs that are inaccessible (e.g. "access=no") are hidden.
Things that are both hotels and pubs are treated as pubs that do accommodation.
Some other things that serve real ale are treated as pubs, unless another tag is more relevant (e.g. brewery).  Other tags (e.g. "food=yes", for restaurants) are also added.
Pub beer gardens are handled as beer gardens (see grass landuse elsewhere).
Various disused and former pubs are shown as social clubs (Garmin symbol "0x4f00").

All open pubs and bars have a suffix added, that contains:

* BQ (bars) or PQ (pubs)
* R if they serve real ale
* F if they serve food
* L if they have a noncarpeted floor
* UB if they are a microbrewery
* UP if they are a micropub
* A if they have accommodation
* G if there is a beer garden
* O if there is outside seating

Pubs that are allegedly still "closed due to covid" have an appropriate suffix added to the name.

Restaurants have "(rest)" added as a suffix, or "(rest accomm)" if they have rooms.

### Healthcare

An appropriate suffix is added for doctors, dentists, hospitals and clinics.
Vaccination centres are shown as clinics if no other tag applies.
Pharmacies and chemists have a suffix added.

### Other

Libraries and public bookcases are shown as libraries with an appropriate suffix.

## Quality Control

Objects with a fixme tag have "[fix]" appended to the name.