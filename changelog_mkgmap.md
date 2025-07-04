# Changes made
This page describes changes made to the [detailed map style](https://github.com/SomeoneElseOSM/mkgmap_style_ajt/) for use with [mkgmap](https://wiki.openstreetmap.org/wiki/Mkgmap) and [Garmin](https://wiki.openstreetmap.org/wiki/Garmin) devices.  Maps are downloadable from below [here](../mkgmap_maps/ajt03/).

## 05/07/2025
Removed `LPG=yes`.  No longer in the data.

## 15/06/2025
Treat `access=emergency` and `services=emergency_access` as "no access".
Handle both spellings of `basin=waste_water`.
Removed `shop=clothing`.  No longer in the data.
Removed `barrier=hand_rail_fence`.  No longer in the data.

## 03/05/2025
Removed `power=sub_station` and `amenity=escape_game`.  No longer in the data.

## 17/04/2025
If "name" does not exist but "is_sidepath:of:name" does, use it.

## 13/04/2025
Changed the pub floor logic to only look at the first entry in semicolon-separated list.  Added "glued gravel" as a noncarpeted floor material.

## 30/03/2025
Removed `landmark=obelisk`.  No longer in the data.
Suppress `substance=gas_topology`.  Not really a pipeline.
Show `barrier=toll_gantry` as "G", searchable via "Others / Garmin Dealer"
Removed `gate=kissing`.  No longer in the data.
Removed `information=leaflet_board`.  No longer in the data.

## 10/03/2025
Removed `shop=loan_shark`, no longer in the data.
Removed `crossing=light_controlled`.  No longer in the data.
Removed `landmark=windsock`.  No longer in the data.

## 06/03/2025
Changed the weekly "detailed" map build to save a copy of last week's files in an "old" directory on the web server.

## 23/02/2025
`ford=Tidal_Causeway` has been renamed to the more normal `ford=tidal_causeway`.
Removed `information=noticeboard`, no longer in the data.

## 04/02/2025
Show `emergency=access_point` and `highway=emergency_access_point`; searchable as 'Others / Social Service'.
Removed `healthcare=osteopath`, no longer in the data, and added `office=osteopath`.

## 08/01/2025
Fixed typo in "dismantled_colliery", one of the odd tags used for "named historic stations".
Removed `natural=col` from taginfo and code, no longer in the data.


## 14/12/2024
Handle `railway=phone` as `emergency=phone`.
Handle `railway=water_crane` as historic object.
Show `railway=crane` (which are all linear) as miniature railways in their own right.
Handle a couple more historic railway features as "named historic stations".
Show `railway=subway_entrance` with 'entrance' shown in brackets; points searchable as 'Others / Social Service'.
Show `railway=crossing` and `railway=level_crossing` in brackets along the railway.
Show `railway=turntable` in brackets; points searchable as 'Others / Social Service'.

## 09/12/2024
Linear locked and unlocked gates are shown on the map, with a suffix of "locked" if appropriate.
Linear lift gates are also shown.
Show some more utility aerial pipeline markers.
Removed `military=danger_area` check on woodland; no longer in the data.
Removed `shop=casino`; no longer in the data.
Added `amenity=motorcycle_rental`.
Removed `shop=marketplace`; the only example is also a car park.

## 22/11/2024
If a trunk road has a sidewalk on it, treat as primary to allow pedestrian routing.
Readability changes to documents on the hosting website.
Things that are both peaks and survey points should render as the former.
Added [man_made=milk_churn_stand](https://taginfo.openstreetmap.org/tags/man_made=milk_churn_stand#overview) as a separate icon.

## 05/11/2024
Removed various rare "fee=no" synonyms, no longer in the data.
Removed "building=telephone_kiosk", no longer in the data.
If a shop=agrarian doesn't have "agrarian" set, show as a speciality shop with "agrarian" appended.
Added shop=doors to the list of homeware shops processed.
Added various piercing variations to shop=tattoo.
Added more shops from the "long tail", mostly as "nonspecific specialist", or "gift" shops.
Fix the appending of parts of names of bus stops so that it handles odd characters in them.
Remove the name from the area component of linear water bodies to add to river (such as canal, stream, etc.)
Removed "shop=petfood", no longer in the data.

## 18/09/2024
Removed "[dogs=leashed](https://taginfo.openstreetmap.org/tags/dogs=leashed#overview)" and "[dogs=no](https://taginfo.openstreetmap.org/tags/dogs=no#overview)", no longer in the data.
When checking sidewalks and verges, also look for e.g. [sidewalk:left](https://taginfo.openstreetmap.org/keys/sidewalk%3Aleft#overview) and [verge:left](https://taginfo.openstreetmap.org/keys/verge%3Aleft#overview) (and right, both, and separate).
Removed [waterway=life_belt](https://taginfo.openstreetmap.org/tags/waterway=life_belt#overview) and [waterway=life_ring](https://taginfo.openstreetmap.org/tags/waterway=life_ring#overview), no longer in the data.
Removed "[fee=free](https://taginfo.openstreetmap.org/tags/fee=free#overview)", no longer in the data.  Also "Free".

## 16/08/2024
Show "[amenity=waste_disposal](https://taginfo.openstreetmap.org/tags/amenity=waste_disposal#overview)" in a similar manner to recycling.
Append "QDB" if we know a bus stop has a realtime display but don't know "[departures_board:speech_output](https://taginfo.openstreetmap.org/keys/departures_board:speech_output#values)".
Append meadow type in brackets for the meadow types that we show.
Append prow_ref in brackets where relevant.
Removed "[memorial=plate](https://taginfo.openstreetmap.org/tags/memorial=plate#overview)", no longer in the data.
Show "[waterway=cave_of_debouchement](https://taginfo.openstreetmap.org/tags/waterway=cave_of_debouchement#overview)" in brackets as a spring; searchable as 'Geographic Points / Water Features'.
Show "[building=train_station](https://taginfo.openstreetmap.org/tags/building=train_station#overview)" in brackets as a railway station; searchable as 'Transportation / Ground Transportation', unless some other tag is set.
Show various building entrances as "entrance" in brackets.
Show [shop=marine](https://taginfo.openstreetmap.org/tags/shop=marine#overview) and [shop=boat_repair](https://taginfo.openstreetmap.org/tags/shop=boat_repair#overview) as marine facilities.

## 03/08/2024
Removed "[crossing=traffic_signals;pelican](https://taginfo.openstreetmap.org/tags/crossing=traffic_signals%3Bpelican#overview)", only stragglers left in the data.
Removed "[amenity=book_exchange](https://taginfo.openstreetmap.org/tags/amenity=book_exchange#overview)", no longer in the data.
Removed "[shop=electric_bicycle](https://taginfo.openstreetmap.org/tags/shop=electric_bicycle#overview)", no longer in the data.
Detect variously tagged canoe put-ins.

## 27/04/2024
Removed "shop=takeaway" and "shop=offlicence", no longer in the data.
Removed "amenity=shopmobility" from list of expected tags, no longer in the data.
Added "playground=trampoline" to complement "leisure=trampoline"; most of the latter are no longer in the data but new ones are still being added.
Removed "historic=martello_tower;fort", no longer in the data.

## 26/03/2024
Removed "shop=guns", no longer in the data.
Removed "craft=joinery", no longer in the data.
Don't append "water" value if a linear water type.
Don't append "QDB" QA if a bus stop is disused.

## 20/03/2024
Render shop=esoteric in the same list as other "woo" shops such as "new_age" etc.
Added a couple of other checks to what makes a meadow "farmgrass".
Append CUS to NaPTAN customary bus stop names.
Removed "man_made=bird_hide", no longer in the data.
Don't append "check for bus stop departures board" QA if there is no flag/pole.
Show "bus_speech_output_name" and/or "bus_display_name" if non-blank and not contained within "name".
Show bus stops which exist but have no service with a unique suffix.
Suppress "naptan:Indicator" or "ref" on a bus stop if more than 3 characters long.
Show mazes as "speciality shops", in the same way as other leisure items.
Excluded some "food" values (such as "snacks") from indicating that "this pub serves food".
Added "grubby carpet" to the list of floor:material values that indicate a less-precious floor.
If something has been tagged as a beach resort and a beach, show as just a beach.

## 28/02/2024
Removed "shop=beautician", no longer in the data.
Append 'dog gate' in brackets to stiles with dog gates.
Added "departures_board=yes" as "implying at least a timetable".
Added "shop=duty_free" to list of ships shown as "gift".
Removed "departures_board=realtime; timetable", no longer in the data.
Append "qdb" as QA to "no destination board known about" bus stops.

## 21/02/2024
If a "ref" is set for an international walking network, use that instead of "name".
Detect former kilns tagged as "ruins:man_made". 
Show non-historic watermills. 
Show "historic=pound" as a synonym for "historic=pinfold". 
Added support for "vending=bottle_return" 
Display "waterway=drainage_channel" as "waterway=ditch". 

## 18/02/2024
Show whether a bus stop has no flag or pole at all.
Removed "pole=maypole", no longer in the data.
Removed "man_made=telephone_kiosk" and "telephone_kiosk=K4", no longer in the data.
Show whether a bus stop has a real-time departures board, a timetable or no flag or pole at all.  Also show whether the departures board has speech output.
Removed "emergency_service=air", no longer in the data. 
Treat "status=abandoned" as a synonym for "disused=yes". 
Detect tumuli mapped as tombs. 
Include "tower:type = ventilation_shaft" in the "vent shaft" list.

## 06/02/2024
Removed "shop=adult_gaming_centre" from taginfo (it had been there in error).
Removed "cuisine=ice_cream;coffee;waffles;crepes", no longer in the data.
Removed "emergency_service=air", no longer in the data.

## 10/01/2024
Removed "shop=printer_cartridges", no longer in the data.
Append "castle_type"to to historic and archaeological items if set.
Added "historic=battery", "historic=village", "historic=village_pump", "historic=water_pump" to list of historic items identified.
Append value of "historic" to windmills, if set.
Detect "leisure=sport" as either sports club or golf, depending on "sport" tag.
Detect "man_made=boundary_stone" in the same way as "man_made=boundary_marker".
Detect "man_made=concrete_post", "man_made=marker_post" and "man_made=post" in the same way as "barrier=post".
Updated "floor:material" list to match what is now in the data.  
Removed "craft=glazier", no longer in the data.
Append a "ref" from zoom 19 for aerial pipeline markers. 

## 27/12/2023
Fixed bug with spelling of "historic=clochan"

## 26/12/2023
Show "leisure=picnic_table" in the same way as benches.
Detect "leisure=bandstand" and "leisure=music_venue" as synonyms for "amenity=music_venue".
Detect "leisure=bleachers" and "leisure=fitness_station" as leisure items.
Added "man_made=windsock" as a synonym of "aeroway=windsock".
Added "man_made=wildlife_hide" as a synonym of "leisure=wildlife_hide".
Added "emergency=water_rescue_station" to the list of lifeguard etc. tags.
Removed "shop=ink_cartridge", no longer in the data.
Add "historic=anchor", "historic=clochan", "historic=deserted_medieval_village", "historic=ice_house" and "historic=rath" to list of historic items.
Added "historic=tramway" to the list of detected abandoned railways.
Detect "historic=bullaun_stone" a a historic stone.
"garmin_map_etrex_03.sh" script now takes parameters.

## 21/12/2023
Append "flood" on flood-prone paths.
Detect more "healthcare" values and combinations.
Added support for some "unexpected" highway values and some expected but rarer ones.
Added support for more historical tags.
Removed "historic=churchyard cross", no longer in the data, and was misspelt here.
Added "amenity=scrapyard" to the "depot" logic, and fixed "amenity=fuel_depot" to appear too.
Added more handling of "industrial" values.
Added more handling of "information" values.
Detect ladders.
Added more handling of "landuse" values.
Fixed bug where Aberdeen March Stones were not detected.
Detect some "leisure=swimming_pool" synonyms, and "leisure=swimming_area".
Show "leisure=practice_pitch" as "leisure=pitch".

## 19/12/2023
Added craft and office values for various art, homeware, photo and electrician synonyms.
Show crossings and traffic signals.
Detect Aberdeen March Stones.
Added "designation=public_footpath" as a synonym of "designation=public_footway".
Improve detection of historic cemeteries and graveyards.
Detect disused buildings.
Detect disused mineshafts tagged as "disused:man_made".
Detect information boards without "tourism=information".
Added some synonyms for life_ring.
Append (TVI), (TVH), (TVN) to less-visible footways etc.
Detect more "ford" values as fords.
Detect stepping stones, shown in brackets; points searchable as 'Others / Social Service'
Detect locked gates.
Append "nodog" or "doglead" to show dog restrictions on paths.

## 16/12/2023
"business" is used as an alternative to "office" by some people.
Add "climbing=boulder" and "sport=climbing;boundering" to the tags used to identify climbing features.
Detect walking networks with a route colour.
"colour" shown in brackets on telephones if set.
Append "constructon" or "proposed" values to "highway=constructon" and "highway=proposed".
Don't assume that roads under construction are routable.
Improved the detection of scooter rental parking places.
Detect escooter operators via the "network" tag if used.
Detect "bicycle_parking;bicycle_rental" as "bicycle_rental".
Detect covered highways.

## 09/12/2023
Added support for "barrier=chain" and "barrier=v_stile" as both point and linear.
Treat "barrier=door" in a similar way to "barrier=gate".
Treat "barrier=flood_wall", "barrier=haha", "barrier=jersey_barrier", "barrier=retaining_wall" and "barrier=sea_wall" in a similar way to "barrier=wall".
Removed "tourism=guesthouse", no longer in the data (it was a typo for "tourism=guest_house").
Treat "barrier=guard_rail", "barrier=hand_rail_fence", "barrier=railing", "barrier=traffic_island", "barrier=wire_fence" and "barrier=wood_fence" in a similar way to "barrier=fence".
Treat linear "barrier=kerb" and "barrier=obstruction" in a similar way to "barrier=wall".
Show "barrier=toll_booth" as kissing gate.
Append value of "basin" to "landuse=basin" objects.  Similarly "reservoir" and "reservoir_type".
Treat "boundary=forest" as "landuse=forest".
Added more bridge types to list detected.
Added better detection of the various ways that historic military bunkers are tagged.
Use building tag to tell "emergency=water_rescue" lifeboats from lifeboat stations.

## 05/12/2023
Move "amenity=bbq" to the search menu "Others / Social Service".
Added support for "amenity=bird_hide" and "amenity=wildlife_hide".
Added "amenity=bus_stop" as a synonym of "highway=bus_stop".
Added support for "amenity=compressed_air".
Added "amenity=embassy" as a synonym for "diplomatic=embassy".
Added support for "amenity=fountain", "amenity=grit_bin".
Added support for hunting stands and grouse butts.
Added support for "amenity=left_luggage" and "amenity=lounger".
Added support for "amenity=mountain_rescue", "emergency=mountain_rescue" and "emergency=rescue_box".
Added support for "amenity=outdoor_education_centre" and "amenity=pinfold".
Support both "amenity=shopmobility" as well as "amenity=shop_mobility".
Removed "healthcare=cosmetic_treatments", no longer in the data.
Added "emergency=ses_station" as a synonym for "emergency=coast_guard" and show as a government office.
Added "amenity=sundial" as a synonym for "amenity=clock; display=sundial".
Detect if someone has mapped scooter rental locations as "amenity=parking", detect that.
Added support for "amenity=waste_basket" and "amenity=watering_place".
Added "amenity=youth_centre" as a synonym for former tag "amenity=youth_club".
Added "cow" to list of animals used to detect non-meadows.
Add "archaeological_site", "fortification_type" or "historic:civilization" to historic items if set.
Added "barrier=barrier"; handled the same way as "barrier=horse_jump".  Also "berm".  Added more synonyms for flood banks.
Added support for point "barrier=bollards".
Removed "shop=undertaker", "shop=solicitors", "shop=chandlers", "leisure=court", no longer in the data.
Extended and consolidated the list of barriers shown; show more as "barrier=bollard".  Fixed bug that prevented some linear barriers from being shown.

## 01/12/2023
Removed "shop=take_away", no longer in the data.
Added support for various linear aerialway types (the same as https://taginfo.openstreetmap.org/projects/someoneelse_style ).
Detect public transport stations not obviously bus, railway or aerialway stations.
Show railway=funicular as narrow gauge railways.
Append a bracketed description of "light_rail".
Detect aerialway stations.
Added support for "aeroway=gate" and "aeroway=parking_position".
Moved numerous previously unsearchable shop, healthcare, office tags to "Shopping / Speciality retail" etc.
Added support for ambulance stations as government offices.
Added support for "amenity=bbq".

## 26/11/2023
Removed "fee=No", no longer in the data.
Removed "shop=car_inspection" (no longer in the data), added "amenity=vehicle_inspection".
Removed "shop=accountants" (no longer in the data).
Detect covered waterways as tunnels.
Added a couple of "craft" printer synonyms, and some other craft synonyms.
Removed "shop=alarm" and "shop=pet;florist", no longer in the data.

## 02/11/2023
Removed "shop=food_court" from taginfo; no longer in the data.
Show "railway:miniature=station" as "tourist stations".
Show "station=miniature" or "tourism=yes" as "tourist stations".

## 26/10/2023
Treat pillboxes (tagged as building or historic) as historic items.
Added "natural=saltmarsh" and translate to more common tags.
Handle "natural=mud" and "natural=shingle" as "sand", but append "mud" or "shingle" (or "sand") in brackets.
Handle "natural=scree" as "rock", but append "scree" in brackets.
Append any surface value and tidal to some natural values.
Added "waterway=tidal_channel" as a synonym for "stream".
Removed "amenity=storage_rental", which no longer appears in the data, and replaced it with "office" which has a few examples.
Removed "shop=jewellery", which no longer appears in the data, and added a number of semicolon-based versions as synonyms in the style.
Removed "shop=picture_frames", which no longer appears in the data, and added "shop=frame;restoration", which does.
Added "jewelry;art;crafts" to accommodate an oddly-tagged shop.
Show "historic=vehicle" as a nonspecific historic item.

## 11/10/2023
Removed "embassy=embassy"; no longer in the data.
Treat "closed:" pubs and shops as disused.
Show historic=martello_tower (and some semicolon derivatives) as other eqivalent historic items.

## 04/10/2023
Removed "diplomatic=consulate_general"; no longer in the data.

## 23/08/2023
Removed "shop=luggage_locker" as a synonym for left luggage; it was only ever an extreme outlier and it has now been removed from the data.
Removed "historic=limekiln" as a synonym for "historic=lime_kiln"; no longer in the data.
Removed "shop=animal_boarding"; no longer in the data.

## 17/08/2023
Append information to name from "community_centre", "community_centre:for", "social_centre", "social_centre:for", "social_facility", "social_facility:for", "club".
Treat "carriageway" as "byway", and added more commonly used synonyms for designations, including with semicolons.
Changed category of "audio_video" and "video" shops to "Shopping / Record/CD/Video".
Changed category of "video_games" to "Shopping / Computer or Software".
Made non-government (commercial) offices searchable as 'Shopping / Speciality retail'.
Made non-government (commercial) office-like amenities searchable as 'Shopping / Speciality retail'.
Added amenity=bus_depot and industrial=bus_depot as manmade places.
Added amenity=depot, industrial=depot and landuse=depot as manmade places.
Added amenity=fuel_depot and industrial=fuel_depot as manmade places.
Updated taginfo to say that amenity=lifeboat maps to "man_made=thing" (which comes through as "Others / Social Service").
Also map "seamark:rescue_station:category=lifeboat_on_mooring" to "man_made=thing" (which comes through as "Others / Social Service").

## 03/08/2023
Remove support for shop-motoring - it was actually a very old mistagging.

## 22/07/2023
The map legend has been significantly updated - "what Garmin contains what common OSM tag" is now complete, as a complement to [taginfo](https://taginfo.openstreetmap.org/projects/someoneelse_mkgmap_ajt03#tags).

## 19/07/2023
When detecting megaliths and standing stones, use "archaeological_site" as well as "site_type".  See the forum [here](https://community.openstreetmap.org/t/implementation-of-new-tagging-scheme-of-archaeological-site/7850/69) for more details.
Final iteration of taginfo_ajt03.json for the current lua.  Detailed descriptions Now complete.

## 28/06/2023
Show utility marker=pedestal, marker=plate, marker=pole with the utility in brackets.
Show pipeline=marker in the same way marker=pipeline.
Improve comments around historic=marker.
Ensure that natural=scrub has a bracketed name.
Show (steps) in brackets.
Removed some no-longer-present key/value combinations from the lua code.
Update taginfo to reflect that shop=gun is back in the data again.
Removed 'waterway=aqueduct', no longer in the data.
Next iteration of taginfo_ajt03.json.  Detailed descriptions done down to "natural=waterfall".

## 17/06/2023
Next iteration of taginfo_ajt03.json.  Detailed descriptions done down to "micropub=yes".
Show milestones as milestones, not pipeline markers.
Show utility marker posts and marker=yes with the utility in brackets.
Show non-utility marker posts.

## 27/05/2023
Removed "shop=bags", "shop=beds", "shop=cars", "shop=closed", "shop=collectables", "shop=crafts", "shop=fabrics", "shop=farm_shop", "shop=haberdasher", "shop=lamps", "shop=misc", "shop=models", "shop=opticians", "shop=pets", no longer in the data.
Changed "shop=spice" to "shop=spices", following some mechanical tag changes.
Append "UH" to roads and tracks with e.g. "unclassified county road" designation.
Make allotments searchable as "Geographic Points / Land Features", like unnamed parks and trees.
Made some other leisure etc. items searchable
Next iteration of taginfo_ajt03.json.  Detailed descriptions done down to "man_made=works".

## 13/05/2023
Removed several internal-only values, and a couple of other errors from taginfo.
Removed shop=locksmiths and shop=fireplaces; no longer in the data.

## 08/05/2023
Show standalone bicycle repair stations in addition to those in old phone boxes.
Show crematorium among others as government offices.
Next draft of taginfo_ajt03.json.  Improved some default descriptions. Detailed descriptions done down to "craft=carpenter".
Improved taginfo_ajt03.json description.
Removed amenity=doctor; no longer in the data.
Removed amenity=micro_scooter_rental; no longer in the data.
Removed amenity=scooter_hire; no longer in the data.
Removed amenity=taxi_office; no longer in the data.
Corrected spelling of "university".
Removed amenity=youth_centre; no longer in the data.
Removed amenity:old; no longer in the data.
Corrected spelling of "K4 Post Office", removed "k6" (no longer in the data).
Removed cuisine=sandwiches; no longer in the data.
Removed various internal-only "diplomatic" values from taginfo_ajt03.json
Removed generator:type=wind; no longer in the data.
Removed internal handling of "gallop" and "leisuretrack"; no longer needed here.
Improved description of "highway=residential_link" and "highway=unclassified_link".
Removed "historic=mansion;castle"; no longer in the data.
Removed "historic=menhir"; no longer in the data.
Removed "historic=motte"; no longer in the data.
Changed "historic=police_box" to "historic=police_call_box"
Removed "historic=ringfort"; no longer in the data.
Removed "historic=stone_circle"; no longer in the data.
Removed "historic:stone"; no longer in the data.
Removed "industrial=scrapyard"; no longer in the data.
Removed "leisure=brothel"; no longer in the data.
Removed "leisure=dance:teaching" from taginfo; only used internally.
Removed "man_made=may_pole" from taginfo; only used internally.
Handled named scout huts etc. as other scout huts.
Removed "Gala Bingo Hall"; no longer in the data.
Handled laser_tag as speciality shop.
Improved descriptions for NCN mileposists in taginfo_ajt03.json.
Removed "noncarpeted" from taginfo; only used internally.
Removed "office=photo_studio"; no longer in the data.
Removed "plant_method"; no longer in the data.
Removed "power_source" from taginfo; only used internally.
Removed several internal-only shop values.
Removed "shop=auto_repair", "shop=dance␣training", "shop=diy", "shop=empty", "shop=flower", "shop=healthfood", "shop=language␣training", "shop=luggage_lockers", "shop=other", "shop=taxi_office", "stone_type=ogham_stone", "tourism=caravan_site;camping_site", "tourism=holiday_accommodation"; no longer in the data.

## 29/04/2023
Add WY, WL, WN to the suffix on pubs and bars depending on wheelchair access (yes, limited, no).
First draft of taginfo_ajt03.json (down to "noncarpeted").
Better handling of commercial offices and office-like commercial places.
More description in taginfo_ajt03.json of amenities.

## 20/04/2023
Show powerlines in a similar way to pipelines.
Add a suffix for trams and railways, and to ferry routes.
Add a suffix to stream, ditch, drain, etc.
Add a name to hospitals areas.
Added a suffix to quarries, landfill, various industrial and commerial landuse.
Only add a "military" suffix if landuse=military, but add a "type of military" suffix if "military=(something we recognise)".
Map natural=tree through to generic "Geographic Points / Land Features" and add a suffix.
Map natural=bare_rock through to the already handled natural=rock and add a suffix.

## 08/03/2023
Map parks etc. without names to a "green" landuse without a tree icon rather than the usual park "tree" icon.
Show highway=emergency_bay with a suffix.
Show highway=trailhead with a trailhead and make it searchable via "Recreation / Sports or Fitness Cen"
Show highway=turning_loop, highway=escape and highway=busway as service roads.
Show higyway=bus_guideway as tram.
Show highway=proposed as a line.

## 03/03/2023
Add a suffix to stiles to replace the now removed default name.
Map cattle grids through to "man_made=thing", with a suffix.
Add a suffix to telephones that are mapped through.
Add suffix for landuse=forest.
Send natural=water, landuse=reservoir and landuse=basin (and their synonyms) through separately.  They appear on different search menus.
Ensure landuse=military and military objects have appropriate suffixes.
Added suffix to ford=yes ways and nodes.
Made suffixes for highway=motorway_junction depend on whether tag:signed=no is not set.
Expanded comments to explain the handling of highway=services.
Add comments to explain how historic=archaeological_site and historic=ruins appear.
Process galleries before museums, and explain the handling of tourism=museum.
Expand the "historic" list and remove the "historic and tourist attraction" points entry.
Added suffix for leisure=marina and leisure=nature_reserve and added comments.
Expand the comments around the handling of towers and masts, and tourist info and markers.
Added suffix for beaches and cave entrances.
Added suffix for cliffs mapped as nodes, and also added them as lines.
Added suffix to peaks and similar and some other natural items.
Added suffix to island, and explained why it's in points and not polygons.
Added suffix to picnic site.
Added explanatory comments around stile, cycle_barrier etc.
Added name or ref and suffix to runways and taxiways.
Removed some "lines" entries for highway types that no longer exist.

## 24/02/2023
Ensure sport is shown on more leisure facilities, if set.
Ensure sports shops aren't accidentally processed as sports facilities.
Use an appropriate suffix for parking.
Add "railway" as a suffix for railway stations before "station" or "halt".
Show amenity=bicycle_rental as ground transportation.
Don't show private swimming pools.
Because restaurant and fast food burger joints are shown together, append restaurant as a suffix on actual restaurants.
Show vending machines with a suffix of the vend product.
Show a suffix for landuse=basin water features.
Append barrier type as suffix for barrier=block etc.; not yet displayed.
Remove references to aeroway=airport as it no longer appears in the data.
Split large, military and small heliports.
Added suffix for helipads.
Handle barrier=border_control as government=customs.
Split out amenity=courthouse and add comment.
Add amenity=drinking_water to lua and map man_made=water_tap to same, better icon, same menu.
Add suffix for graveyards and cemeteries.
Remove "amenity=disused_pub" from "points" (no longer used) and improve comments re vacant/disused handling, which follows how the web map's "style.lua" does it, not the old Garmin process.

## 20/02/2023
Ensure historic ruins have a "historic" suffix.
Show vending machines in the "Shopping / Specialty Retail" menu with a suffix of "vending".

## 19/02/2023
Show names and types of schools, universities, etc.
Show names and types of memorials.
Make toilets more searchable, via "Auto Services / Rest Area" rather than among all the other stuff in "Geographic Points / Man Made".
If a name is used for golf tees, ensure it appears.
Suppress a second "bowls" suffix from appearing on bowls pitches.
Show all amenity=fuel and shop=convenience in one menu each, not two, to avoid confusion.
Make charging stations searchable via "Fuel Services / Auto Fuel" as well as other fuel.
Append cuisine to other restaurants and fast food.
Move caravan_site and camp_site to 0x2b05 ("Campground")
Ensure names are displayed for all places.
Add "landuse=vineyard" to the things that appear under "Attractions / Winery"

## 18/02/2023
Prevent military airfields dropping through without processing; ensure they get a suffix of something.
Moved wildcards down in "points" file and commented out; fixed bug that prevented car repair from appearing.
Move sluices and water monitoring to water features.
Add a suffix to amenity=police objects.
Show name of places of worship, and append religion and denomination as suffixes.
Handle chalets as either "single chalets" or "resorts" depending on other tags.

## 17/02/2023
Substantially improve the mapping of "community" data - both the mapping ("community / community center" rather than "shop / specialty") and the suffix (if there is "social_facility", use that).
There is a category for casinos, so use it.
Expand the items mapped through to government offices beyond just diplomatic ones.
Ensure that usage=tourism stations aren't also detected as tourist attractions.
Ensure that sports are handled before leisure centres, so that the sport item is categorised properly.
Ensure that mini golf only gets one suffix (mini golf) not two (mini golf and golf).
Add a suffix for hotels, motels, etc.
Append the name of the sport as a suffix to sports shops if set.
Don't set mall on landuse if shop already set.
Suppress amenity=shelter or amenity=waste_basket on bus stops.
As well as restaurants without known cuisine, also send fast food without known cuisine through as "other".
Ensure barriers get a suffix, not just a default value.
Add a suffix for natural=water type.
Map fire stations through as fire stations, not government offices.

## 16/02/2023
Don't show sports facilities if the leisure faciity they are part of is disused.
Don't show unnamed theme parks.
Don't show military airfields as public sport airports.
Show cinemas, theatres and concert halls with a suffix.
Show resorts, water parks and things like wilderness_hut as resorts with a suffix.
Show some retail non-sport leisure as "shop=specialty" with a suffix.

## 12/02/2023
Handle more office types from style.lua, with a suffix.
Append "man_made=thing" (which comes through as "Others / Social Service") to nodes we have named with no other tag.
Send leisure=pitch, leisure=park, leisure=ice_rink, swimming pools, bowling alleys, skiing, golf courses with a suffix and the name.

## 09/02/2023
Added a name parameter to the "natural=wood" entry in "points" to avoid "Woods" appearing.
Added a name parameter to the "natural=wetland" entry in "points" to avoid "Swamp" appearing.
Mapped volcano across to "peak" rather than "hot springs"(!).
Various other nonspecific shops are mapped to "Specialty".
Nonspecific healthcare is handled via a suffix.
Map craft and industrial breweries to "Specialty" with a suffix.
Handle more shop types from style.lua, mostly as "Specialty" with a suffix.

## 06/02/2023
Mop up some of the values previously treated as wildcards.
Add motorcycle (and repair, rental, parts), and atv.
Categorise tourist railway stations as tourist attractions.
Only show "real" airports as airports; include the rest in "Recreation / public-sport-airport".
Show name on forests.
Show passing places.
Added horse jumps (ways and nodes).
Map breweries to "Shopping / Specialty"
Show numbers lcn_ref nodes.

## 03/02/2023
Updated the map legend to explain the shop mappings below.

## 30/01/2023
Map geoglyph polygons through to "Native American Reservation " rather than "State Park", with a suffix of "geoglyph".
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
