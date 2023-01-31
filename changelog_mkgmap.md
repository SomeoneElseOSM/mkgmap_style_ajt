# Changes made to this rendering
This page describes changes made to the "03" map style [here](https://github.com/SomeoneElseOSM/mkgmap_style_ajt/), visible [here](../mkgmap_maps/ajt03/).

## As yet unreleased
Mop up some of the values previously treated as wildcards.
Add motorcycle (and repair, rental, parts), and atv.
Categorise tourist railway stations as tourist attractions.
Only show "real" airports as airports; include the rest in "Recreation / public-sport-airport".
Show name on forests.
Show passing places.

## 30/01/2023
Map geoglyph polygons through to "Native American Reservation " rather than "State Park1", with a suffix of "geoglyph".
Show historic railway stations as generic item with either a building or landuse.
Show nightclubs and music venues.
Distinguish camp sites from caravan sites with a suffix.
Distinguish aeroway features with a suffix.
Distinguish ground transportation features with a suffix.
Added car sharing features with a suffix.
Added emergency phones.
Use a suffix for post offices and postboxes.
Moved gift shops from Specialty so that they are searchable as Gift in the Garmin menus.
Added shop=music to be searchable as Record/CD/Video.
Moved sports shops from Specialty so that they are searchable as Sporting Goods in the Garmin menus.
Added hairdressers as Specialty so that they are searchable in the Garmin menus.
Added shop=florist to be searchable as Shopping / Florist.
Split out General Stores (which have their own category on Garmin).  Also added appendage for eco shops.
Added more missing shops as "specialty".
Remapped the food menus to match UK/IE usage.
Fixed boat_rental_suffix.
Tidied code formatting somewhat.
If a marketplace doesn't have a name, don't include it.
Show deli with other food shops as "specialty".
Added more missing shops and moved the shop and office wildcards to "all pois".

## 28/01/2023
Show vacant shops as "(vacant: name)" as either a building or landuse, depending on whether a building tag is present.
Show gift shops as either a building or landuse.
Show non-government (commercial) offices that you might visit for a service as either a building or landuse.
Show car repair etc. as either a building or landuse.
Show electrical and elecroncs shops as "specialty" with either a building or landuse.
Show shop=alcohol as "wine and liquor" with either a building or landuse.
Show shop=boat with either a building or landuse.
Show fabric and wool shops as "specialty" with either a building or landuse.
Show betting shops etc. as "specialty" with either a building or landuse.
Show sports shops etc. as "specialty" with either a building or landuse.
Show pet shops etc. as "specialty" with either a building or landuse.
Show bookshops etc. with either a building or landuse.
Show stationery shops as "specialty" with either a building or landuse.
Show antiques shops as "specialty" with either a building or landuse.
Show other shops as "specialty" with either a building or landuse.
Show clothes shops with either a building or landuse.
Show bakeries as "deli or bakery" with either a building or landuse.
Show banks, atms, building socienties etc. as banks with an appropriate suffix, and with either building or landuse as appropriate.
Show beauty salons with either a building or landuse.
Added Shopmobility.
Mapped shop=convenience to 0x2e0e
Show public buildings and prisons as offices rather than government buildings.
Show diplomatic embassies as government buildings, and diplomatic non-embassies as offices.
Show name on golf courses.

## 24/01/2023
Show railway platform ref if no name.
Show railway platforms as pedestrian areas.
No longer show pedestrian areas as leisure=park(!).
Show man_made=boundary_stone.
Show breakwaters and groynes.
Show man_made=bunker_silo and other farm-related items as farmyard, with an appropriate suffix.
Show military and other flagpoles.
Added man_made=obelisk.
Added man_made=observatory, as either a building or landuse, depending on whether a building tag is present.
Added function "building_or_landuse( object )" for use with other observatory-type things.
Handle man_made=reservoir_covered as building, with suffix.
Added man_made=telephone_exchange, as either a building or landuse, depending on whether a building tag is present.
Handle man_made=water_tower as tower, with a suffix.
Now that all man_made items are explicitly handled, remove catch-all.

## 22/01/2023
Removed some more unused tag key/value combinations from the ajt03 style.
Apply more tag processing from raster web maps style.lua file, including shops.
Handle various sorts of walls.
Show mill ponds.
Show name, operator, substance on pipelines.
Handle things that are both towers and monuments or memorials.
historic=icon shouldn't supersede amenity or tourism tags.
Suppress disused railway platforms.

## 04/01/2023
Removed some more unused tag key/value combinations from the ajt02 style.
Added support for more military landuse for the ajt03 style.
Added support for levees, either with highways on them or not, in ajt03.
In ajt03: Consolidate "was:" into "disused:",
handle man_made stones, 
trim values consolidated into e.g. amenity=car_repair based on what actually occurs in the data, 
trim unused highway values.

## 31/12/2022
Added taginfo_ajt02.json to the project.
Removed some unused tag key/value combinations from the ajt02 style.

## 29/12/2022
Fix bug where woodland relations weren't processed properly.

## 27/11/2022
Show various references, including for trig points.
Show various sorts of rarer water as "natural=water".
Show wind turbines and wind pumps.
Show vent shafts.
Show horse mounting blocks.
Show Water monitoring stations etc.
Show B&Bs and self catering etc.
Added suffix for old railways
Show tourist information offices and audioguides with a suffix.
Show NCN route markers.
Show recreation grounds as grass.
Render historic railway stations.
Where military has been overtagged over natural=wood, remove military.

## 21/11/2022
Show "(int)" at the end of names on intermittent waterways, water and wetlands.
Removed the setting of "industrialbuilding", which is not used in the mkgmap map style.
Display "waterway=leat" and "waterway=spillway" etc. as drain / water area.
Display "location=underground" waterways as tunnels.
Display various man_made items as buildings, with a suffix saying what each one is.
Show historic=monument, with a suffix of "(monument)".  Similarly "tourism=attraction", "tourism=artwork", "amenity=arts_centre".
Show historic mines as ruins.  Also show non-historic mines.
Show other historic things, with an appropriate suffix.
Show plaques and cairns.
Show chimneys with a suffix of "(chimney)".
Show giant hogweed with a suffix of"(hogweed)".
Show waterway lock references.

## 13/11/2022
Show derelict canals with a name.
Show unnamed farm shops with particular produce as farm "vending machines".

## 10/11/2022
Show various clocks with an appropriate suffix.
Show left luggage, parcel lockers, vending machines (with suffix of what sold if appropriate).
Show musical instruments and pianos.
Show motorcycle and bicycle parking.
Show laybies as parking.
Append "(pay)" to the end of for-pay parking.
Show toilets with a suffix indicating pay or free, male or female etc.
Show amenity=leisure_centre as leisure=sports_centre.
Handle razed railways and old inclined_planes as dismantled.
Change miniature railways (not handled in the style file) to narrow_gauge.
Show names on point water features (waterfalls, lock gates).
Show sluice gates, weirs and floating barriers, with names.

## 08/11/2022
Show grass-covered outdoor seating areas as green with an "(outdoor grass)" suffix.
Show landuse=grass as green with a "(grass)" suffix.
Show names of cafes.
Show various things as meadows.
Show "(farmyard)" in a suffix on farmyard names.
Show names on any genuine biergartens.
Show names on doctors and hospitals.  Show clinics as doctors.
Show names on various food places.
Show "(rest accomm)" as a suffix on restaurants with rooms and "(rest)" on others.
Show "(cafe)" as a suffix on cafes.
Append "(atm)" to ATMs.
Show name on libraries, and also render a suffix for them and public bookcases.
Don't show narrow tertiary roads as unclassified if a oneway tag is set.

## 05/11/2022
Show names for guesthouses.
Don't show "[a]" as QA on intermittent paths and tracks.
Show names on meadows etc., and indicate type on various types.
Show various places that serve beer (hotels etc.) as pubs.
Handle the myriad of ways of tagging dead pubs.
Don't show dead pubs that are now something else as dead pubs.
Show beer gardens as beer gardens.
Handle pubs that are also breweries.
Handle pubs that serve real ale.
Coalesce "noncarpeted" tags.
Handle "closed due to covid" pubs.
Show flags on pubs and bars for outside seating/beer garden etc.
Render unnamed amenity=biergarten as gardens, which is all they likely are.

## First map.atownsend.org.uk release - 01/11/2022
Includes style processing for a number of features includng sewage works, electricity substations, various industrial areas and localities, markers and stones, telephones and reused phoneboxes, car shops, embassies, holy springs and wells, wells, outdoor centres, dog parks, bird ad wildlife hides, forestry, pubs, tourist info boards, signs guideposts and route markers.

Contains the same width-based road processing and surface-based track processing as the [web maps](//map.atownsend.org.uk) here.
Shows designated public footpaths, core paths, public bridleways, restricted byways and byways open to all traffic as such.
Shows trees as broadleaved, needleleaved, or mixed as appropriate.
Shows fences, walls and hedges.

Includes QA for "fixme", roads without a speed limit, roads not shown as being lit or not, having a sidewalk or not or having a verge or not.
Also indicates "highway=road" for QA, paths without expected "foot" access, and missing surface, smoothness and tracktype on paths and tracks.
