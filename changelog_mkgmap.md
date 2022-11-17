# Changes made to this rendering
This page describes changes made to the "03" map style [here](https://github.com/SomeoneElseOSM/mkgmap_style_ajt/), visible [here](../mkgmap_maps/ajt03/).

## As yet unreleased
Show "(int)" at the end of names on intermittent waterways, water and wetlands.
Removed the setting of "industrialbuilding", which is not used in the mkgmap map style.
Display "waterway=leat" and "waterway=spillway" etc. as drain / water area.
Display "location=underground" waterways as tunnels.
Display various man_made items as buildings, with a suffix saying what each one is.
Show historic=monument, with a suffix of "(monument)".  Similarly "tourism=attraction", "tourism=artwork", "amenity=arts_centre".
Show historic mines as ruins.  Also show non-historic mines.
Show other historic things, with an appropriate suffix.

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
