# Map Legend

## How things appear on screen

### Points of interest

The standard Garmin icons are used throughout. Shops appear as a shopping bag, food and drink with a knife and fork, supermarkets as a shopping trolley, etc.

This map style varies from other similar ones in a couple of ways.  One is that often several OSM tags are processed to decide what category to show something as.  Another is that the OSM tags are used to provide more detail when you hover over the icon, or search for it on the Garmin menus. For example, a fuel station ("amenity=fuel" in OSM) will be shown with a petrol pump icon as normal, but it'll also have "fuel" qnd the brand in brackets after the name.

For many features, lots of different (but related) OSM tags are shown with the same icon.  For example, several different types of shop that sell a variety of goods are shown as "general" shops.  "shop=general" is one example, but "shop=catalogue" is another, and an Argos will appear on screen and in the search menus as "Argos (catalogue)".

### Other features

Things like roads, tracks and paths appear as you would expect them to on a Garmin device, but with extra information for rights of way and quality control appended to the name (see below for more details).

## How things can be searched for.

Among the search options on the Garmin menus are searches for different POI types.

The top level POI search options are:

> Food and Drink, Cities, Transportation, All POIs, Shopping, Fuel Services, Lodging, Entertainment, Recreation, Attractions, Auto Services, Community, Hospitals, Geographic points, Others

An attempt has been made to distribute OSM POIs logically among these menus.

### Searching for the Garmin menu used for an OSM tag

To find out what Garmin menu an OSM feature has been mapped to, go, [here](https://taginfo.openstreetmap.org/projects/someoneelse_mkgmap_ajt03#tags) and search for the OSM tag or value you are interested in.

### Details of which OSM tags appear on which Garmin menu

#### Food and Drink

Garmin's menus here are very American (you can have "International", but you can't get a curry).  Fast food and "proper restaurants" are all lumped together.  I've tried to make the best use of the catagories as I can, which results in some odd mappings:

<table border="1">
<tr>
<td> **Garmin Menu** </td>
<td> **Submenu** </td>
<td> **Description** </td>
<td> **Example OSM tags** </td>
</tr>
<tr>
<td> Food and Drink</td>
<td> All Categories </td>
<td> Everything below </td>
<td>  </td>
</tr>
<tr>
<td> </td>
<td> American </td>
<td> Burger-led fast food </td>
<td> (amenity=fast_food or amenity=restaurant) and (cuisine=burger or cuisine=american or cuisine=diner) </td>
</tr>
<tr>
<td> </td>
<td> Asian </td>
<td> Not used as not uniquely searchable </td>
<td> n/a </td>
</tr>
<tr>
<td> </td>
<td> Barbeque </td>
<td> Chicken-led fast food </td>
<td> amenity=fast_food and (cuisine=chicken or cuisine=fried_chicken) </td>
</tr>
<tr>
<td> </td>
<td> Chinese </td>
<td> Chinese or similar fast food </td>
<td> amenity=fast_food and cuisine one of chinese, thai, asian, japanese, sushi, korean, ramen, noodle, malaysian, indonesian, cantonese, oriental </td>
</tr>
<tr>
<td> </td>
<td> Deli or Bakery </td>
<td> Bakery </td>
<td> shop=bakery </td>
</tr>
<tr>
<td> </td>
<td> International </td>
<td> Kebab-led fast food </td>
<td> amenity=fast_food and (cuisine=kebab or cuisine=turkish) </td>
</tr>
<tr>
<td> </td>
<td> Fast Food </td>
<td> Pie-led fast food </td>
<td> amenity=fast_food and cuisine=pasties, pasty, cornish_pasty, pie, pies </td>
</tr>
<tr>
<td> </td>
<td> Italian </td>
<td> Italian or similar Restaurant </td>
<td> amenity=restaurant and cuisine=italian, pizza, mediterranean </td>
</tr>
<tr>
<td> </td>
<td> Mexican </td>
<td> Curry-led fast food </td>
<td> amenity=fast_food and cuisine=indian, curry, nepalese, bangladeshi, pakistani, tandoori, afghan, sri_lankan, punjabi </td>
</tr>
<tr>
<td> </td>
<td> Pizza </td>
<td> Italian or similar fast food </td>
<td> amenity=fast_food and cuisine=italian, pasta or pizza </td>
</tr>
<tr>
<td> </td>
<td> Seafood </td>
<td> Fish and Chips led fast food </td>
<td> amenity=fast_food and cuisine=fish_and_chips, fish, chines;fish_and_chips </td>
</tr>
<tr>
<td> </td>
<td> Steak or Grill </td>
<td> Steak Restaurant </td>
<td> amenity=restaurant and cuisine=steak_house, grill, brazilian, argentinian </td>
</tr>
<tr>
<td> </td>
<td> Bagel or Donut </td>
<td> Ice Cream Parlours </td>
<td> Various amenity, shop and cuisine=ice_cream tags </td>
</tr>
<tr>
<td> </td>
<td> Cafe or Diner </td>
<td> Cafes and coffee shops </td>
<td> amenity=fast_food and (cuisine=coffee or cuisine=sandwich) </td>
</tr>
<tr>
<td> </td>
<td> French </td>
<td> Indian Restaurant </td>
<td> amenity=restaurant and cuisine=indian </td>
</tr>
<tr>
<td> </td>
<td> German </td>
<td> Chinese or similar Restaurant </td>
<td> amenity=restaurant and cuisine=chinese, thai, asian, japanese, vietnamese, korean, sushi </td>
</tr>
<tr>
<td> </td>
<td> British Isles </td>
<td> Pubs and bars </td>
<td> amenity=pub or amenity=bar </td>
</tr>
<tr>
<td> </td>
<td> n/a </td>
<td> Any other fast food or restaurant </td>
<td> amenity=fast_food or amenity=restaurant with a cuisine not handled above</td>
</tr>
</table>

#### Cities

Most places are handled.

<table border="1">
<tr>
<td> **Garmin Menu** </td>
<td> **Submenu** </td>
<td> **Description** </td>
<td> **Example OSM tags** </td>
</tr>
<tr>
<td> Cities </td>
<td> n/a </td>
<td> Most "place" values </td>
<td> place=city, town, suburb, village, hamlet, locality, cape</td>
</tr>
</table>

#### Transportation

<table border="1">
<tr>
<td> **Garmin Menu** </td>
<td> **Submenu** </td>
<td> **Description** </td>
<td> **Example OSM tags** </td>
</tr>
<tr>
<td> Transportation </td>
<td> All Categories </td>
<td> Everything below </td>
<td> </td>
</tr>
<tr>
<td>  </td>
<td> Auto Rental </td>
<td> Car Rental etc. </td>
<td> amenity=car_rental, van_rental </td>
</tr>
<tr>
<td>  </td>
<td> Air Transportation </td>
<td> Public transportation airports </td>
<td> aeroway=aerodrome, heliport with iata tag; terminal </td>
</tr>
<tr>
<td>  </td>
<td> Ground Transportation </td>
<td> Railway stations, bus stations </td>
<td> railway=station, amenity=bus_station, ferry_terminal, bicycle_rental </td>
</tr>
<tr>
<td>  </td>
<td> Transit Service </td>
<td> Tram stops, bus stops </td>
<td> railway=tram_stop, highway=bus_stop, amenity=taxi </td>
</tr>
</table>

#### Shopping

<table border="1">
<tr>
<td> **Garmin Menu** </td>
<td> **Submenu** </td>
<td> **Description** </td>
<td> **Example OSM tags** </td>
</tr>
<tr>
<td> Shopping </td>
<td> All Categories </td>
<td> Everything below </td>
<td> </td>
</tr>
<tr>
<td> Shopping </td>
<td> Department </td>
<td> Department stores </td>
<td> shop=department_store</td>
</tr>
<tr>
<td> Shopping </td>
<td> Grocery </td>
<td> Supermarkets </td>
<td> shop=supermarket</td>
</tr>
<tr>
<td> Shopping </td>
<td> General Merchandise </td>
<td> Other shops taking a variety of goods </td>
<td> shop=variety_store, outpost, general, catalogue</td>
</tr>
<tr>
<td> Shopping </td>
<td> Shopping Center </td>
<td> Various shop groups </td>
<td> amenity=marketplace, market, food_court</td>
</tr>
<tr>
<td> Shopping </td>
<td> Pharmacy or Chemist </td>
<td> Parmacies, chemists etc. </td>
<td> amenity=pharmacy, spa, healthcare=pharmacy, shop=beauty, chemist, cosmetics, leisure=spa </td>
</tr>
<tr>
<td> Shopping </td>
<td> Apparel </td>
<td> Various clothes shops </td>
<td> shop=clothes, shoes, etc.; craft=dressmaker, tailor </td>
</tr>
<tr>
<td> Shopping </td>
<td> House and Garden </td>
<td> Garden centres </td>
<td> shop=garden_centre, plant_nursery, nursery, lawn_mower, etc. </td>
</tr>
<tr>
<td> Shopping </td>
<td> Home Furnishings </td>
<td> DIY and hardware shops, also related trades. </td>
<td> craft=plumber (and many others), shop=hardware, furniture, doityourself, homeware, etc. </td>
</tr>
<tr>
<td> Shopping </td>
<td> Specialty Retail </td>
<td> Shops that don't fit other categories </td>
<td> shop=hairdresser, butcher (and many, many others) </td>
</tr>
<tr>
<td> Shopping </td>
<td> Computer or Software </td>
<td> Computer and mobile phone shops </td>
<td> shop=mobile_phone, computer </td>
</tr>
<tr>
<td> Shopping </td>
<td> Convenience </td>
<td> Shops that don't fit other categories </td>
<td> shop=convenience, kiosk, newsagent </td>
</tr>
<tr>
<td> Shopping </td>
<td> Florist </td>
<td> Florists </td>
<td> shop=florist </td>
</tr>
<tr>
<td> Shopping </td>
<td> Gift/Antiques/Art </td>
<td> Various gift etc. shops </td>
<td> shop=gift, art, antiques, craft, bag among others </td>
</tr>
<tr>
<td> Shopping </td>
<td> Record/CD/Video </td>
<td> Record,CD,Video and Music shops </td>
<td> shop=music, records </td>
</tr>
<tr>
<td> Shopping </td>
<td> Sporting Goods </td>
<td> Various sport shops </td>
<td> shop=sports, fishing, etc. </td>
</tr>
<tr>
<td> Shopping </td>
<td> Wine and Liquor </td>
<td> Shops specialising in alcohol (but not wineries) </td>
<td> shop=alcohol, wine etc. </td>
</tr>
<tr>
<td> Shopping </td>
<td> Book Store </td>
<td> Book shops </td>
<td> shop=books </td>
</tr>
</table>


#### Fuel Services

<table border="1">
<tr>
<td> **Garmin Menu** </td>
<td> **Submenu** </td>
<td> **Description** </td>
<td> **Example OSM tags** </td>
</tr>
<tr>
<td> Fuel Services </td>
<td> </td>
<td> Fuel stations (petrol and diesel, and electric) </td>
<td> amenity=fuel, amenity=charging_station </td>
</tr>
</table>

#### Lodging

<table border="1">
<tr>
<td> **Garmin Menu** </td>
<td> **Submenu** </td>
<td> **Description** </td>
<td> **Example OSM tags** </td>
</tr>
<tr>
<td> Lodging </td>
<td> All catgories</td>
<td> Everything below </td>
<td>  </td>
</tr>
<tr>
<td> Lodging </td>
<td> Hotel or Motel</td>
<td> Hotels </td>
<td> tourism=hotel, motel </td>
</tr>
<tr>
<td> Lodging </td>
<td> Bed and Breakfast or</td>
<td> Guest houses, tourist apartments, etc. </td>
<td> tourism=guest_house, apartment, holiday_village </td>
</tr>
<tr>
<td> Lodging </td>
<td> Resort</td>
<td> Holiday resorts </td>
<td> tourism=resort, spa_resort </td>
</tr>
<tr>
<td> Lodging </td>
<td> Campground </td>
<td> Camp sites, hostels, caravan sites </td>
<td> tourism=camp_site, hostel, caravan_site </td>
</tr>
<tr>
<td> Lodging </td>
<td> Other </td>
<td> Nothing in this category </td>
<td> n/a </td>
</tr>
</table>

#### Entertainment

<table border="1">
<tr>
<td> **Garmin Menu** </td>
<td> **Submenu** </td>
<td> **Description** </td>
<td> **Example OSM tags** </td>
</tr>
<tr>
<td> Entertainment </td>
<td> All catgories</td>
<td> Everything below </td>
<td>  </td>
</tr>
<tr>
<td> Entertainment </td>
<td> Live Theater</td>
<td> Theatres, arts centres </td>
<td> amenity=theatre, arts_centre </td>
</tr>
<tr>
<td> Entertainment </td>
<td> Bar or Nightclub </td>
<td> Nightclubs </td>
<td> amenity=nightclub </td>
</tr>
<tr>
<td> Entertainment </td>
<td> Movie Theater </td>
<td> Cinemas </td>
<td> amenity=cinema </td>
</tr>
<tr>
<td> Entertainment </td>
<td> Casino </td>
<td> Casinos </td>
<td> amenity=casino </td>
</tr>
</table>

#### Recreation

<table border="1">
<tr>
<td> **Garmin Menu** </td>
<td> **Submenu** </td>
<td> **Description** </td>
<td> **Example OSM tags** </td>
</tr>
<tr>
<td> Recreation </td>
<td> All catgories</td>
<td> Everything below </td>
<td>  </td>
</tr>
<tr>
<td> Recreation </td>
<td> Golf Course</td>
<td> Golf courses </td>
<td> leisure=golf_course </td>
</tr>
<tr>
<td> Recreation </td>
<td> Skiing Center or Reso</td>
<td> Skiing </td>
<td> sport=skiing </td>
</tr>
<tr>
<td> Recreation </td>
<td> Bowling Center</td>
<td> Skiing </td>
<td> leisure=bowling_alley, sport=bowls, 10pin, 9pin </td>
</tr>
<tr>
<td> Recreation </td>
<td> Ice Skating</td>
<td> Skiing </td>
<td> leisure=ice_rink, sport=ice_skating </td>
</tr>
<tr>
<td> Recreation </td>
<td> Swimming Pool</td>
<td> Swimming pools </td>
<td> leisure=swimming_pool, sport=swimming </td>
</tr>
<tr>
<td> Recreation </td>
<td> Sports or Fitness Cen</td>
<td> Leisure centres etc. </td>
<td> leisure=sports_centre, amenity=leisure_centre, dojo, gym, sport=fitness_centre </td>
</tr>
<tr>
<td> Recreation </td>
<td> Public Sport Airport</td>
<td> Gliding clubs and general aviation </td>
<td> amenity=aerodrome, heliport without 'iata' tag and non-military </td>
</tr>
<tr>
<td> Recreation </td>
<td> Park or Garden</td>
<td> Parks and gardens (named) </td>
<td> landuse=grass, meadow, recreation_ground, greenfield, flowerbed, leisure=park, garden, playground, outdoor_seating, common, fishing, recreation_ground, showground </td>
</tr>
<tr>
<td> Recreation </td>
<td> Arena or Track</td>
<td> Sports pitches tracks and stadia </td>
<td> leisure=pitch, track, stadium, dog_park </td>
</tr>
</table>

#### Attractions

<table border="1">
<tr>
<td> **Garmin Menu** </td>
<td> **Submenu** </td>
<td> **Description** </td>
<td> **Example OSM tags** </td>
</tr>
<tr>
<td> Attractions </td>
<td> All catgories</td>
<td> Everything below </td>
<td>  </td>
</tr>
<tr>
<td> Attractions </td>
<td> Other</td>
<td> Nothing in this category </td>
<td> n/a </td>
</tr>
<tr>
<td> Attractions </td>
<td> Amusement Park or T</td>
<td> (see above) </td>
<td> </td>
</tr>
<tr>
<td> Attractions </td>
<td> Museum or Historical</td>
<td> Various historic features </td>
<td> tourism=artwork, museum, historic=memorial, wayside_cross, archaeological_site, ruins, wayside_shrine, monument, building, castle, tomb, manor, mine, mine_shaft </td>
<td> </td>
</tr>
</table>

(more to follow)

#### Auto Services

#### Community

#### Hospitals

#### Geographic Points

#### Others

## Rights of way and hiking trails

## Quality control information on roads, tracks and paths

With very few exceptions, most POIs processed by this style will have more details in brackets.


## Technical Details

This page describes how OpenStreetMap features are shown on the "03" map style [here](https://github.com/SomeoneElseOSM/mkgmap_style_ajt/), visible [here](../mkgmap_maps/ajt03/).

No .typ file is used.

Most map features are transferred in the same way as mkgmap's standard style.  The mkgmap style used can be found [here](https://github.com/SomeoneElseOSM/mkgmap_style_ajt/tree/master/ajt03).  Differences include:

* Names used on more objects
* Removal of some duplicates and "typing error mappings" from the style; these are now handled in lua.
* Hiking routes are shown

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

### Single point objects

Various milestones etc. are consolidated into "man_made=marker" and "(milestone)" is appended to the name.
Various pipeline markers are consolidated into "man_made=marker" and "(pipeline marker)" is appended to the name.
Various boundary stones are consolidated into "man_made=marker" and any inscription and "(boundary stone)" are appended to the name.
Various other stones are consolidated into "man_made=marker" and any inscription and "(ogham stone)", "(historic stone)" or "(historic stone)" are appended to the name.
Mass rocks are consolidated into "man_made=marker" and "(mass rock)" is appended to the name.
Clocks (tower, pedestal and sundial) are shown as a dot with an appropriate suffix.
Left luggage, parcel lockers and vending machines are all shown as a dot with an appropriate suffix.
Pianos and musical instruments are shown with a suffix.
Motorcycle and bicycle parking are shown, with a suffix if for pay.  
Laybies are shown as parking.
Toilets are shown with a suffix indicating pay or free, male or female etc.
"historic=monument" are shown with a suffix of "(monument)"; and other historic things, with an appropriate suffix..  Similarly "tourism=attraction", "tourism=artwork", "amenity=arts_centre", information offices, audioguides.
Historic mines are shown as ruins.  Also show non-historic mines are shown.
Plaques and cairns, chimneys, and hogweed are all shown.
Various points that have references (e.g. trig points) have that "ref" shown.
Wind turbines and wind pumps, vent shafts and horse mounting blocks are all shown with an appropriate suffix.
B&Bs and self catering etc. are shown.
If we've named a node, and it has no other useful tag, it'll appear as a named point (actually searchable via "Others / Social Service").

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

### Other landuse

Military landuse is labelled as such.

### Barriers

Fences, hedges and walls are all shown as black lines.  Fences have "(fence)" appended; hedges "(hedge)" and walls "(wall)".

### Tourism

Bird and wildlife hides are shown as tourist information with a suffix added to the name.
Guideposts, fingerposts and markers have "GP" appended to the name.
Route markers have "RM" appended to the name.
Various types of boards and maps have "B" appended to to name.
Signs have "S" appended to to name.
"destination" features have "DEST" appended.  "intermediary" ones have "INT".
Military signs have "MIL" appended.
Peak and Northern Footpath Society signposts have "PNFS" appended.
Guideposts that are "public right of way" markers have "PROW" appended.
Guideposts that sign a route have "ROUTE" appended.
NCN route markers are shown with "NCN", the marker type and the sustrans reference.

### Trees

"forestry" is handled as "forest".  Various tags are consolidated into "wood".  "operator" is appended to the name, if present.

Broadleaved woodland has "B" appended; needleleaved has "C" and mixed "M".

### Shops and Amenities

OSM shops and amenities are matched to items on the Garmin search menus, so for example "Shopping / General" shows general stores and also catalogue shops.  "Shopping / Apparel" shows all clothes shops, add also shoes etc.  Suffixes are added to show what the original OSM tag was (e.g. "(Clothes)", "(Shoes)" with "Apparel").

Unnamed farm shops with particular produce are shown as farm "vending machines".


### Pubs and bars

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

### Transportation

On the Garmin menus, "Transportation / Air Transportation" only includes "proper airports" (i.e. not gliding clubs and not military facilities).

"Transportation / Ground Transportation" includes regular bus and train stations, but not e.g. a station on a park miniature railway.  A suffix is added to show which is which.

"Transportation / Transit Service" includes bus stops, taxi stands etc.

### Railways

Razed railways and old inclined_planes are shown as dismantled.
Miniature railways (not handled in the style file) are shown as narrow_gauge.
Render historic railway stations.

### Healthcare

An appropriate suffix is added for doctors, dentists, hospitals and clinics.
Vaccination centres are shown as clinics if no other tag applies.
Pharmacies and chemists have a suffix added.

### Water features

Point water features (waterfalls, lock gates) are displayed with a name.
Sluice gates, weirs, floating barriers and derelict canals are all shown with names.
Intermittent waterways, water and wetlands have "(int)" appended to the name.
Display "waterway=leat" and "waterway=spillway" etc. as drain.
Display "location=underground" waterways as tunnels.
Show waterway lock references.
Show Water monitoring stations etc.
Show various sorts of rarer water as "natural=water".

### Other

Libraries and public bookcases are shown as libraries with an appropriate suffix to the name.
amenity=leisure_centre is shown as leisure=sports_centre.
Display various man_made items as buildings, with a suffix saying what each one is.

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

