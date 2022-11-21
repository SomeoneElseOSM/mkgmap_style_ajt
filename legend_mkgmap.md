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

Various designations are appended.  In England and Wales:

* PF  Public Footpath
* PB  Bridleways
* RB  Restricted Byway
* BY  Byway Open to All Traffic

In Scotland:

* CP  Core paths

Informal paths have "(I)" appended.

Some corridors are shown as paths.

Some rare highway tags are consolidated into "track".

Various tunnel tags are consolidated into "yes.

Golf features are shown as paths or tracks if no other appropriate tags exist.

Wide paths are shown as tracks.
Narrow tracks are shown as paths.

Narrow tertiary roads are shown as unclassified.

Show highway=busway as highway=service.

Roads with different names on left and right are shown correctly.

Don't show names on things that could be reasonably be thought to be sidewalks.

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

### Barriers

Fences, hedges and walls are all shown as black lines.  Fences have "(fence)" appended; hedges "(hedge)" and walls "(wall)".

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

Broadleaved woodland has "B" appended; needleleaved has "C" and mixed "M".

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

Libraries and public bookcases are shown as libraries with an appropriate suffix to the name.

Clocks (tower, pedestal and sundial) are shown as a dot with an appropriate suffix.

Left luggage, parcel lockers and vending machines are all shown as a dot with an appropriate suffix.

Pianos and musical instruments are shown.

Motorcycle and bicycle parking are show, with a suffix if for pay.  
Show laybies as parking.

Toilets are shown with a suffix indicating pay or free, male or female etc.

amenity=leisure_centre is shown as leisure=sports_centre.

Razed railways and old inclined_planes are shown as dismantled.

Miniature railways (not handled in the style file) are shown as narrow_gauge.

Point water features (waterfalls, lock gates) are displayed with a name.

Sluice gates, weirs, floating barriers and derelict canals are all shown with names.

Unnamed farm shops with particular produce are shown as farm "vending machines".

Intermittent waterways, water and wetlands have "(int)" appended to the name.

Display "waterway=leat" and "waterway=spillway" etc. as drain.

Display "location=underground" waterways as tunnels.

Display various man_made items as buildings, with a suffix saying what each one is.

Show historic=monument, with a suffix of "(monument)"; and other historic things, with an appropriate suffix..  Similarly "tourism=attraction", "tourism=artwork", "amenity=arts_centre".

Show historic mines as ruins.  Also show non-historic mines.

Show plaques and cairns.

Show chimneys.

## Quality Control

Objects with a fixme tag have "[fix]" appended to the name.

Roads have various letters appended:

* M  No speed limit defined where one would be expected.
* L  Not known if lit
* S  Not known if sidewalk
* V  No sidewalk, but not known if sidewalk

"[RD]" is appended to any "highway=road".

"[A]" is appended to footways etc. if no "foot" tag and one is expected.

Paths and tracks have various things appended for other missing tags:

* U  No surface tag
* O  No smoothness tag
* G  No tracktype tag

