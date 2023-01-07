-- ----------------------------------------------------------------------------
-- Apply "name" transformations to ways for "map style 03"
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- "all" function
-- ----------------------------------------------------------------------------
function process_all(object)
-- ----------------------------------------------------------------------------
-- Some changes based on style.lua
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- Treat "was:" as "disused:"
-- ----------------------------------------------------------------------------
   if (( object.tags["was:amenity"]     ~= nil ) and
       ( object.tags["disused:amenity"] == nil )) then
      object.tags["disused:amenity"] = object.tags["was:amenity"]
   end

   if (( object.tags["was:waterway"]     ~= nil ) and
       ( object.tags["disused:waterway"] == nil )) then
      object.tags["disused:waterway"] = object.tags["was:waterway"]
   end

   if (( object.tags["was:railway"]     ~= nil ) and
       ( object.tags["disused:railway"] == nil )) then
      object.tags["disused:railway"] = object.tags["was:railway"]
   end

   if (( object.tags["was:aeroway"]     ~= nil ) and
       ( object.tags["disused:aeroway"] == nil )) then
      object.tags["disused:aeroway"] = object.tags["was:aeroway"]
   end

   if (( object.tags["was:landuse"]     ~= nil ) and
       ( object.tags["disused:landuse"] == nil )) then
      object.tags["disused:landuse"] = object.tags["was:landuse"]
   end

   if (( object.tags["was:shop"]     ~= nil ) and
       ( object.tags["disused:shop"] == nil )) then
      object.tags["disused:shop"] = object.tags["was:shop"]
   end

-- ----------------------------------------------------------------------------
-- Woodland - append B, C or M based on leaf_type.
-- If there is no name after this procedure Garmins will show "Woods" instead.
-- ----------------------------------------------------------------------------
   if ( object.tags['natural'] == 'wood' ) then
      leaf_type_appendix = ''

      if ( object.tags['leaf_type'] == 'broadleaved' ) then
         leaf_type_appendix = 'B'
      end

      if ( object.tags['leaf_type'] == 'needleleaved' ) then
         leaf_type_appendix = 'C'
      end

      if ( object.tags['leaf_type'] == 'mixed' ) then
         leaf_type_appendix = 'M'
      end

      if ( leaf_type_appendix ~= nil ) then
         object = append_nonqa( object, leaf_type_appendix ) 
      end
   end

-- ----------------------------------------------------------------------------
-- Mistaggings for wastewater_plant
-- ----------------------------------------------------------------------------
   if (( object.tags["man_made"]   == "sewage_works"      ) or
       ( object.tags["man_made"]   == "wastewater_works"  )) then
      object.tags["man_made"] = "wastewater_plant"
   end

-- ----------------------------------------------------------------------------
-- Electricity substations
-- ----------------------------------------------------------------------------
   if (( object.tags["power"] == "substation"  )  or
       ( object.tags["power"] == "sub_station" )) then
      object.tags["power"]   = nil

      if (( object.tags["building"] == nil  ) or
          ( object.tags["building"] == "no" )) then
         object.tags["landuse"] = "industrial"
      else
         object.tags["building"] = "yes"
      end

      object = append_nonqa( object, "el.sub" )
   end

-- ----------------------------------------------------------------------------
-- Append (sewage) to sewage works.
-- ----------------------------------------------------------------------------
   if ( object.tags["man_made"]   == "wastewater_plant" ) then
      object.tags["man_made"] = nil
      object.tags["landuse"] = "industrial"
      object = append_nonqa( object, "sewage" )
   end

   if (( object.tags["man_made"]   == "reservoir_covered"      ) or 
       ( object.tags["man_made"]   == "petroleum_well"         ) or 
       ( object.tags["industrial"] == "warehouse"              ) or
       ( object.tags["industrial"] == "brewery"                ) or 
       ( object.tags["industrial"] == "distillery"             ) or 
       ( object.tags["craft"]      == "distillery"             ) or
       ( object.tags["craft"]      == "bakery"                 ) or
       ( object.tags["craft"]      == "sawmill"                ) or
       ( object.tags["industrial"] == "sawmill"                ) or
       ( object.tags["industrial"] == "factory"                ) or 
       ( object.tags["industrial"] == "yes"                    ) or 
       ( object.tags["industrial"] == "depot"                  ) or 
       ( object.tags["landuse"]    == "depot"                  ) or
       ( object.tags["amenity"]    == "depot"                  ) or
       ( object.tags["amenity"]    == "bus_depot"              ) or
       ( object.tags["amenity"]    == "fuel_depot"             ) or
       ( object.tags["amenity"]    == "scrapyard"              ) or 
       ( object.tags["industrial"] == "scrap_yard"             ) or 
       ( object.tags["industrial"] == "scrapyard"              ) or 
       ( object.tags["industrial"] == "yard"                   ) or 
       ( object.tags["industrial"] == "engineering"            ) or
       ( object.tags["industrial"] == "machine_shop"           ) or
       ( object.tags["industrial"] == "packaging"              ) or
       ( object.tags["industrial"] == "haulage"                ) or
       ( object.tags["power"]      == "plant"                  ) or
       ( object.tags["man_made"]   == "gas_station"            ) or
       ( object.tags["man_made"]   == "gas_works"              ) or
       ( object.tags["man_made"]   == "water_treatment"        ) or
       ( object.tags["man_made"]   == "pumping_station"        ) or
       ( object.tags["man_made"]   == "water_works"            )) then
      object.tags["landuse"] = "industrial"
   end

   if ( object.tags["man_made"]   == "reservoir_covered" ) then
      object.tags["building"] = "roof"
      object.tags["landuse"]  = "industrial"
   end

   if ( object.tags["parking"]   == "depot" ) then
      object.tags["parking"] = nil
      object.tags["landuse"] = "industrial"
   end

-- ----------------------------------------------------------------------------
-- Handle spoil heaps as landfill
-- ----------------------------------------------------------------------------
   if ( object.tags["man_made"] == "spoil_heap" ) then
      object.tags["landuse"] = "landfill"
   end

-- ----------------------------------------------------------------------------
-- Handle place=quarter
-- ----------------------------------------------------------------------------
   if ( object.tags["place"] == "quarter" ) then
      object.tags["place"] = "neighbourhood"
   end

-- ----------------------------------------------------------------------------
-- Handle natural=cape
-- ----------------------------------------------------------------------------
   if ( object.tags["natural"] == "cape" ) then
      object.tags["place"] = "locality"
   end

-- ----------------------------------------------------------------------------
-- Handle various sorts of milestones.
-- ----------------------------------------------------------------------------
   if (( object.tags["historic"] == "milestone" )  or
       ( object.tags["historic"] == "milepost"  )  or
       ( object.tags["waterway"] == "milestone" )  or
       ( object.tags["railway"]  == "milestone" )) then
      object.tags["man_made"] = "marker"
      object = append_nonqa( object, "milestone" )
   end

-- ----------------------------------------------------------------------------
-- Aerial markers for pipelines etc.
-- ----------------------------------------------------------------------------
   if (( object.tags["marker"]   == "aerial"          ) or
       ( object.tags["marker"]   == "pipeline"        ) or
       ( object.tags["man_made"] == "pipeline_marker" )) then
      object.tags["man_made"] = "marker"
      object = append_nonqa( object, "pipeline marker" )
   end

-- ----------------------------------------------------------------------------
-- Boundary stones.  If they're already tagged as tourism=attraction, remove
-- that tag.
-- Note that "marker=stone" (for "non boundary stones") are handled elsewhere.
-- ----------------------------------------------------------------------------
   if (( object.tags["historic"] == "boundary_stone"  )  or
       ( object.tags["historic"] == "boundary_marker" )  or
       ( object.tags["marker"]   == "boundary_stone"  )  or
       ( object.tags["boundary"] == "marker"          )) then
      object.tags["man_made"] = "marker"
      object.tags["tourism"]  = nil

      if ( object.tags["inscription"] ~= nil ) then
         object = append_nonqa( object, object.tags["inscription"] )
      end

      object = append_nonqa( object, "boundary stone" )
   end

-- ----------------------------------------------------------------------------
-- Stones that are not boundary stones.
-- Note that "marker=boundary_stone" are handled elsewhere.
-- ----------------------------------------------------------------------------
   if (( object.tags["marker"]   == "stone"          ) or
       ( object.tags["natural"]  == "stone"          ) or
       ( object.tags["man_made"] == "stone"          ) or
       ( object.tags["man_made"] == "standing_stone" )) then
      object.tags["man_made"] = "marker"

      if ( object.tags["inscription"] ~= nil ) then
         object = append_nonqa( object, object.tags["inscription"] )
      end

      if ( object.tags["stone_type"]   == "ogham_stone" ) then
         object = append_nonqa( object, "ogham stone" )
      else
         object = append_nonqa( object, "historic stone" )
      end
   end

   if ( object.tags["historic"]   == "stone" ) then
      object.tags["man_made"] = "marker"

      if ( object.tags["inscription"] ~= nil ) then
         object = append_nonqa( object, object.tags["inscription"] )
      end

      if ( object.tags["stone_type"]   == "ogham_stone" ) then
         object = append_nonqa( object, "ogham stone" )
      else
         if ( object.tags["historic:stone"]   == "standing_stone" ) then
            object = append_nonqa( object, "standing stone" )
         else
            object = append_nonqa( object, "historic stone" )
         end
      end
   end

   if ((   object.tags["historic"]           == "standing_stone"        ) or
       ((  object.tags["historic"]           == "archaeological_site"  )  and
        (( object.tags["site_type"]          == "standing_stone"      )   or
         ( object.tags["site_type"]          == "megalith"            )))) then
      object.tags["man_made"] = "marker"

      if ( object.tags["inscription"] ~= nil ) then
         object = append_nonqa( object, object.tags["inscription"] )
      end

      if ( object.tags["stone_type"]   == "ogham_stone" ) then
         object = append_nonqa( object, "ogham stone" )
      else
         object = append_nonqa( object, "standing stone" )
      end

      object.tags["tourism"] = nil
   end

   if ( object.tags["historic"]   == "rune_stone" ) then
      object.tags["man_made"] = "marker"

      if ( object.tags["inscription"] ~= nil ) then
         object = append_nonqa( object, object.tags["inscription"] )
      end

      object = append_nonqa( object, "standing stone" )
   end

   if ( object.tags["place_of_worship"]   == "mass_rock" ) then
      object.tags["man_made"] = "marker"
      object.tags["amenity"]  = nil
      object = append_nonqa( object, "mass rock" )
   end

-- ----------------------------------------------------------------------------
-- Former telephone boxes
-- ----------------------------------------------------------------------------
   if ((( object.tags["covered"]         == "booth"          )   and
        ( object.tags["booth"]           ~= "K1"             )   and
        ( object.tags["booth"]           ~= "KX100"          )   and
        ( object.tags["booth"]           ~= "KX200"          )   and
        ( object.tags["booth"]           ~= "KX300"          )   and
        ( object.tags["booth"]           ~= "KXPlus"         )   and
        ( object.tags["booth"]           ~= "KX410"          )   and
        ( object.tags["booth"]           ~= "KX420"          )   and
        ( object.tags["booth"]           ~= "KX520"          )   and
        ( object.tags["booth"]           ~= "oakham"         )   and
        ( object.tags["booth"]           ~= "ST6"            ))  or
       (  object.tags["booth"]           == "K2"              )  or
       (  object.tags["booth"]           == "K4_Post_Office"  )  or
       (  object.tags["booth"]           == "K6"              )  or
       (  object.tags["booth"]           == "k6"              )  or
       (  object.tags["booth"]           == "K8"              )  or
       (  object.tags["telephone_kiosk"] == "K4"              )  or
       (  object.tags["telephone_kiosk"] == "K6"              )  or
       (  object.tags["man_made"]        == "telephone_kiosk" )  or
       (  object.tags["man_made"]        == "telephone_box"   )  or
       (  object.tags["building"]        == "telephone_kiosk" )  or
       (  object.tags["building"]        == "telephone_box"   )  or
       (  object.tags["historic"]        == "telephone"       )  or
       (  object.tags["disused:amenity"] == "telephone"       )  or
       (  object.tags["removed:amenity"] == "telephone"       )) then
      if ((( object.tags["amenity"]   == "telephone"    )  or
           ( object.tags["amenity"]   == "phone"        )) and
          (  object.tags["emergency"] ~= "defibrillator" ) and
          (  object.tags["emergency"] ~= "phone"         ) and
          (  object.tags["tourism"]   ~= "information"   ) and
          (  object.tags["tourism"]   ~= "artwork"       ) and
          (  object.tags["tourism"]   ~= "museum"        )) then
         object.tags["amenity"] = "telephone"
         object.tags["tourism"] = nil
         object.tags["emergency"] = nil
      else
         if ( object.tags["emergency"] == "defibrillator" ) then
            object.tags["amenity"] = "telephone"
      	    object = append_nonqa( object, "fmr phone defib" )
         else
            if (( object.tags["amenity"] == "public_bookcase" )  or
                ( object.tags["amenity"] == "book_exchange"   )  or
                ( object.tags["amenity"] == "library"         )) then
               object.tags["amenity"] = "telephone"
      	       object = append_nonqa( object, "fmr phone book exchange" )
            else
               if ( object.tags["amenity"] == "bicycle_repair_station" ) then
                  object.tags["amenity"] = "telephone"
      	       	  object = append_nonqa( object, "fmr phone bicycle repair" )
               else
                  if ( object.tags["amenity"] == "atm" ) then
                     object.tags["amenity"] = "telephone"
      	       	     object = append_nonqa( object, "fmr phone atm" )
                  else
                     if ( object.tags["tourism"] == "information" ) then
                        object.tags["amenity"] = "telephone"
      	       	     	object = append_nonqa( object, "fmr phone tourist info" )
                     else
                        if ( object.tags["tourism"] == "artwork" ) then
                           object.tags["amenity"] = "telephone"
      	       	     	   object = append_nonqa( object, "fmr phone artwork" )
                        else
                           if ( object.tags["tourism"] == "museum" ) then
                              object.tags["amenity"] = "telephone"
      	       	     	      object = append_nonqa( object, "fmr phone museum" )
		  	   else
                              if (( object.tags["disused:amenity"]    == "telephone"        )  or
                                  ( object.tags["removed:amenity"]    == "telephone"        )  or
                                  ( object.tags["abandoned:amenity"]  == "telephone"        )  or
                                  ( object.tags["demolished:amenity"] == "telephone"        )  or
                                  ( object.tags["razed:amenity"]      == "telephone"        )  or
                                  ( object.tags["old_amenity"]        == "telephone"        )  or
                                  ( object.tags["historic:amenity"]   == "telephone"        )  or
                                  ( object.tags["disused"]            == "telephone"        )  or
                                  ( object.tags["was:amenity"]        == "telephone"        )  or
                                  ( object.tags["old:amenity"]        == "telephone"        )  or
                                  ( object.tags["amenity"]            == "former_telephone" )  or
                                  ( object.tags["amenity:old"]        == "telephone"        )  or
                                  ( object.tags["historic"]           == "telephone"        )) then
                                 object.tags["amenity"] = "telephone"
      	       	     	      	 object = append_nonqa( object, "fmr phone" )
                              end
                           end
			end
                     end
                  end
               end
            end
         end
      end
   end
   
-- ----------------------------------------------------------------------------
-- Mappings to shop=car
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"]    == "car;car_repair"  )  or
       ( object.tags["shop"]    == "cars"            )  or
       ( object.tags["shop"]    == "car_showroom"    )  or
       ( object.tags["shop"]    == "vehicle"         )) then
      object.tags["shop"] = "car"
   end

-- ----------------------------------------------------------------------------
-- Mappings to shop=bicycle
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"] == "bicycle_repair"   ) or
       ( object.tags["shop"] == "electric_bicycle" )) then
      object.tags["shop"] = "bicycle"
   end

-- ----------------------------------------------------------------------------
-- Map amenity=car_repair etc. to shop=car_repair
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"] == "car_repair"         )  or
       ( object.tags["craft"]   == "coachbuilder"       )  or
       ( object.tags["shop"]    == "car_service"        )  or
       ( object.tags["shop"]    == "car_inspection"     )  or
       ( object.tags["shop"]    == "car_bodyshop"       )  or
       ( object.tags["shop"]    == "vehicle_inspection" )  or
       ( object.tags["shop"]    == "mechanic"           )  or
       ( object.tags["shop"]    == "car_repair;car"     )  or
       ( object.tags["shop"]    == "car_repair;tyres"   )  or
       ( object.tags["shop"]    == "auto_repair"        )) then
      object.tags["shop"] = "car_repair"
   end

-- ----------------------------------------------------------------------------
-- Map various diplomatic things to embassy.
-- Pedants may claim that some of these aren't legally embassies, and they'd
-- be correct, but I use the same icon for all of these currently.
-- ----------------------------------------------------------------------------
   if (((  object.tags["diplomatic"] == "embassy"            )  and
        (( object.tags["embassy"]    == nil                 )   or
         ( object.tags["embassy"]    == "yes"               )   or
         ( object.tags["embassy"]    == "high_commission"   )   or
         ( object.tags["embassy"]    == "nunciature"        )   or
         ( object.tags["embassy"]    == "delegation"        )   or
         ( object.tags["embassy"]    == "embassy"           ))) or
       ((  object.tags["diplomatic"] == "consulate"          )  and
        (( object.tags["consulate"]  == nil                 )   or
         ( object.tags["consulate"]  == "consulate_general" )   or
         ( object.tags["consulate"]  == "yes"               ))) or
       ( object.tags["diplomatic"] == "embassy;consulate"     ) or
       ( object.tags["diplomatic"] == "embassy;mission"       ) or
       ( object.tags["diplomatic"] == "consulate;embassy"     )) then
      object.tags["amenity"]    = "embassy"
      object.tags["diplomatic"] = nil
      object.tags["office"]     = nil
   end

   if (((  object.tags["diplomatic"] == "embassy"              )  and
        (( object.tags["embassy"]    == "residence"           )   or
         ( object.tags["embassy"]    == "branch_embassy"      )   or
         ( object.tags["embassy"]    == "mission"             ))) or
       ((  object.tags["diplomatic"] == "consulate"            )  and
        (( object.tags["consulate"]  == "consular_office"     )   or
         ( object.tags["consulate"]  == "residence"           )   or
         ( object.tags["consulate"]  == "consular_agency"     ))) or
       (   object.tags["diplomatic"] == "permanent_mission"     ) or
       (   object.tags["diplomatic"] == "trade_delegation"      ) or
       (   object.tags["diplomatic"] == "liaison"               ) or
       (   object.tags["diplomatic"] == "non_diplomatic"        ) or
       (   object.tags["diplomatic"] == "mission"               ) or
       (   object.tags["diplomatic"] == "trade_mission"         )) then
      if ( object.tags["amenity"] == "embassy" ) then
         object.tags["amenity"] = nil
      end

      object.tags["diplomatic"] = nil

-- ----------------------------------------------------------------------------
-- "office" is set to something that will definitely display here, just in case
-- it was set to some value that would not.
-- ----------------------------------------------------------------------------
      object.tags["office"] = "yes"
   end

-- ----------------------------------------------------------------------------
-- Holy wells might be natural=spring or something else.
-- Make sure that we set "amenity" to something other than "place_of_worship"
-- The one existing "holy_well" is actually a spring.
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"] == "holy_well" ) and
       ( object.tags["natural"] == "spring"    )) then
      object.tags["amenity"] = nil
      object = append_nonqa( object, "holy spring" )
   end

   if ( object.tags["place_of_worship"] == "holy_well" ) then
      object.tags["natural"] = "spring"
      object.tags["amenity"] = nil
      object = append_nonqa( object, "holy well" )
   end

-- ----------------------------------------------------------------------------
-- Ordinary wells
-- ----------------------------------------------------------------------------
   if ( object.tags["man_made"] == "water_well" ) then
      object.tags["natural"] = "spring"
      object = append_nonqa( object, "well" )
   end

-- ----------------------------------------------------------------------------
-- man_made=water_tap
-- ----------------------------------------------------------------------------
   if (( object.tags["man_made"] == "water_tap" ) and
       ( object.tags["amenity"]  == nil         )) then
      object.tags["natural"] = "spring"
      object = append_nonqa( object, "tap" )
   end

-- ----------------------------------------------------------------------------
-- Beer gardens etc.
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"] == "beer_garden" ) or
       ( object.tags["leisure"] == "beer_garden" )) then
      object.tags["amenity"] = nil
      object.tags["leisure"] = "garden"
      object.tags["garden"]  = "beer_garden"
   end

-- ----------------------------------------------------------------------------
-- Show amenity=biergarten as gardens, which is all they likely are.
-- Unlike with style.lua (web maps) we don't send named "biergartens" through
-- as both amenity and leisure.
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "biergarten" ) then
      object.tags["amenity"] = nil
      object.tags["leisure"] = "garden"
      object.tags["garden"]  = "beer_garden"
      object = append_nonqa( object, "beer garden" )
   end

-- ----------------------------------------------------------------------------
-- We don't show landuse=farmland here (yet)
-- We also don't show farmland processed in style.lua as "landuse=farmgrass"
-- We do process meadows here that would process as "farmgrass" here so that
-- they don't (yet) get handled as meadows.
-- ----------------------------------------------------------------------------
   if ((  object.tags["landuse"] == "meadow"        ) and
       (( object.tags["meadow"]  == "agricultural" )  or
        ( object.tags["meadow"]  == "paddock"      )  or
        ( object.tags["meadow"]  == "pasture"      )  or
        ( object.tags["meadow"]  == "agriculture"  )  or
        ( object.tags["meadow"]  == "hay"          )  or
        ( object.tags["meadow"]  == "managed"      )  or
        ( object.tags["meadow"]  == "cut"          )  or
        ( object.tags["animal"]  == "pig"          )  or
        ( object.tags["animal"]  == "sheep"        )  or
        ( object.tags["animal"]  == "cattle"       )  or
        ( object.tags["animal"]  == "chicken"      )  or
        ( object.tags["animal"]  == "horse"        ))) then
      object.tags["landuse"] = nil
   end

-- ----------------------------------------------------------------------------
-- Render various synonyms for leisure=common.
-- ----------------------------------------------------------------------------
   if (( object.tags["landuse"]          == "common"   ) or
       ( object.tags["leisure"]          == "common"   ) or
       ( object.tags["designation"]      == "common"   ) or
       ( object.tags["amenity"]          == "common"   ) or
       ( object.tags["protection_title"] == "common"   )) then
      object.tags["leisure"] = "common"
      object.tags["landuse"] = nil
      object.tags["amenity"] = nil
   end

-- ----------------------------------------------------------------------------
-- Map various landuse to park
--
-- All handled in the style like this:
-- leisure=park {name '${name}'} [0x17 resolution 20]
-- ----------------------------------------------------------------------------
   if ( object.tags["leisure"]   == "common" ) then
      object.tags["leisure"] = "park"
      object = append_nonqa( object, "common" )
   end

   if ( object.tags["leisure"]   == "garden" ) then
      object.tags["leisure"] = "park"

      if ( object.tags["garden"] == "beer_garden" ) then
      	 object = append_nonqa( object, "beer garden" )
      else
      	 object = append_nonqa( object, "garden" )
      end
   end

   if (( object.tags["leisure"]   == "outdoor_seating" ) and
       ( object.tags["surface"]   == "grass"           )) then
      object.tags["leisure"] = "park"
      object = append_nonqa( object, "outdoor grass" )
   end

   if (( object.tags["landuse"] == "recreation_ground" ) or
       ( object.tags["leisure"] == "recreation_ground" )) then
      object.tags["leisure"] = "park"
      object.tags["landuse"] = nil
      object = append_nonqa( object, "rec" )
   end

-- ----------------------------------------------------------------------------
-- Treat landcover=grass as landuse=grass
-- Also landuse=college_court, flowerbed
-- ----------------------------------------------------------------------------
   if (( object.tags["landcover"] == "grass"         ) or
       ( object.tags["landuse"]   == "college_court" ) or
       ( object.tags["landuse"]   == "flowerbed"     )) then
      object.tags["landcover"] = nil
      object.tags["landuse"] = "grass"
   end

   if ( object.tags["landuse"]   == "grass" ) then
      object.tags["leisure"] = "park"
      object = append_nonqa( object, "grass" )
   end

   if ( object.tags["landuse"]   == "greenfield" ) then
      object.tags["leisure"] = "park"
      object = append_nonqa( object, "greenfield" )
   end

-- ----------------------------------------------------------------------------
-- These all map to meadow in the web maps
-- ----------------------------------------------------------------------------
   if ( object.tags["landuse"]   == "meadow" ) then
      object.tags["leisure"] = "park"
      object = append_nonqa( object, "meadow" )
   end

-- ----------------------------------------------------------------------------
-- Various tags for showgrounds
-- Other tags are suppressed to prevent them appearing ahead of "landuse"
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"] == "showground"   ) or
       ( object.tags["leisure"] == "showground"   ) or
       ( object.tags["amenity"] == "show_ground"  ) or
       ( object.tags["amenity"] == "show_grounds" )) then
      object.tags["amenity"] = nil
      object.tags["leisure"] = "park"
      object = append_nonqa( object, "showground" )
   end

   if ( object.tags["amenity"]   == "festival_grounds" ) then
      object.tags["amenity"] = nil
      object.tags["leisure"] = "park"
      object = append_nonqa( object, "festival grounds" )
   end

   if ( object.tags["amenity"]   == "car_boot_sale" ) then
      object.tags["amenity"] = nil
      object.tags["leisure"] = "park"
      object = append_nonqa( object, "car boot sale" )
   end
-- ----------------------------------------------------------------------------
-- (end of list that maps to meadow)
-- ----------------------------------------------------------------------------

   if ( object.tags["leisure"]   == "playground" ) then
      object.tags["leisure"] = "park"
      object = append_nonqa( object, "playground" )
   end

   if ( object.tags["landuse"]   == "village_green" ) then
      object.tags["leisure"] = "park"
      object = append_nonqa( object, "village green" )
   end

-- ----------------------------------------------------------------------------
-- Scout camps etc.
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"]   == "scout_camp"     ) or
       ( object.tags["landuse"]   == "scout_camp"     )) then
      object.tags["leisure"] = "park"
      object = append_nonqa( object, "scout camp" )
   end

   if ( object.tags["leisure"]   == "fishing" ) then
      object.tags["leisure"] = "park"
      object = append_nonqa( object, "fishing" )
   end

   if ( object.tags["leisure"]   == "outdoor_centre" ) then
      object.tags["leisure"] = "park"
      object = append_nonqa( object, "outdoor centre" )
   end
-- ----------------------------------------------------------------------------
-- (end of things that map to park)
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- These all map to farmyard in the web maps
-- ----------------------------------------------------------------------------
   if ( object.tags["landuse"]   == "farmyard" ) then
      object = append_nonqa( object, "farmyard" )
   end

-- ----------------------------------------------------------------------------
-- Change landuse=greenhouse_horticulture to farmyard.
-- ----------------------------------------------------------------------------
   if (object.tags["landuse"]   == "greenhouse_horticulture") then
      object.tags["landuse"] = "farmyard"
      object = append_nonqa( object, "greenhouse horticulture" )
   end
-- ----------------------------------------------------------------------------
-- (end of things that map to farmyard)
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- leisure=dog_park is used a few times.  Map to pitch to differentiate from
-- underlying park.
-- Also "court" often means "pitch" (tennis, basketball).
-- ----------------------------------------------------------------------------
   if (( object.tags["leisure"] == "dog_park" ) or
       ( object.tags["leisure"] == "court"    )) then
      object.tags["leisure"] = "pitch"
   end

-- ----------------------------------------------------------------------------
-- Bird hides and similar features
-- ----------------------------------------------------------------------------
   if ( object.tags["leisure"] == "bird_hide" ) then
      object.tags["tourism"] = "information"
      object = append_nonqa( object, "bird hide" )
   end

   if ( object.tags["leisure"] == "wildlife_hide" ) then
      object.tags["tourism"] = "information"
      object = append_nonqa( object, "wildlife hide" )
   end

-- ----------------------------------------------------------------------------
-- Attempt to do something sensible with trees
--
-- There are a few 10s of landuse=wood and natural=forest; treat them the same
-- as other woodland.  If we have landuse=forest on its own without
-- leaf_type, then we don't change it - we'll handle that separately in the
-- rss file.
-- ----------------------------------------------------------------------------
  if ( object.tags["landuse"] == "forestry" ) then
      object.tags["landuse"] = "forest"
  end

-- ----------------------------------------------------------------------------
-- Use operator (but not brand) on various natural objects, always in brackets.
-- (compare with the similar check including "brand" for e.g. "atm" below)
-- This is done before we change tags based on leaf_type.
-- ----------------------------------------------------------------------------
   if (( object.tags["landuse"] == "forest" )  or
       ( object.tags["natural"] == "wood"   )) then
      if ( object.tags["name"] == nil ) then
         if ( object.tags["operator"] ~= nil ) then
            object.tags["name"] = "(" .. object.tags["operator"] .. ")"
            object.tags["operator"] = nil
         end
      else
         if (( object.tags["operator"] ~= nil                )  and
             ( object.tags["operator"] ~= object.tags["name"]  )) then
            object.tags["name"] = object.tags["name"] .. " (" .. object.tags["operator"] .. ")"
            object.tags["operator"] = nil
         end
      end
   end

  if ((( object.tags["landuse"]   == "forest"     )  and
       ( object.tags["leaf_type"] ~= nil          )) or
      (  object.tags["natural"]   == "forest"      ) or
      (  object.tags["landuse"]   == "wood"        ) or
      (  object.tags["landcover"] == "trees"       ) or
      (( object.tags["natural"]   == "tree_group" )  and
       ( object.tags["landuse"]   == nil          )  and
       ( object.tags["leisure"]   == nil          ))) then
      object.tags["landuse"] = nil
      object.tags["natural"] = "wood"
   end

-- ----------------------------------------------------------------------------
-- Don't show pubs, cafes or restaurants if you can't actually get to them.
-- ----------------------------------------------------------------------------
   if ((( object.tags["amenity"] == "pub"        ) or
        ( object.tags["amenity"] == "cafe"       ) or
        ( object.tags["amenity"] == "restaurant" )) and
       (  object.tags["access"]  == "no"          )) then
      object.tags["amenity"] = nil
   end

-- ----------------------------------------------------------------------------
-- Things that are both hotels, B&Bs etc. and pubs should show as pubs, 
-- because I'm far more likely to be looking for the latter than the former.
-- This is done by removing the tourism tag for them.
--
-- People have used lots of tags for "former" or "dead" pubs.
-- "disused:amenity=pub" is the most popular.
--
-- Treat things that were pubs but are now something else as whatever else 
-- they now are.
--
-- If a real_ale tag has got stuck on something unexpected, don't show that
-- as a pub.
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"]   == "pub"   ) and
       ( object.tags["tourism"]   ~= nil     )) then
      if (( object.tags["tourism"]   == "hotel"       ) or
          ( object.tags["tourism"]   == "guest_house" )) then
         object.tags["accommodation"] = "yes"
      end

      object.tags["tourism"] = nil
   end

   if (( object.tags["tourism"] == "hotel" ) and
       ( object.tags["pub"]     == "yes"   )) then
      object.tags["accommodation"] = "yes"
      object.tags["amenity"] = "pub"
      object.tags["pub"] = nil
      object.tags["tourism"] = nil
   end

   if ((( object.tags["tourism"]  == "hotel"       )   or
        ( object.tags["tourism"]  == "guest_house" ))  and
       (  object.tags["real_ale"] ~= nil            )  and
       (  object.tags["real_ale"] ~= "maybe"        )  and
       (  object.tags["real_ale"] ~= "no"           )) then
      object.tags["accommodation"] = "yes"
      object.tags["amenity"] = "pub"
      object.tags["tourism"] = nil
   end

   if ((  object.tags["leisure"]         == "outdoor_seating" ) and
       (( object.tags["surface"]         == "grass"          ) or
        ( object.tags["beer_garden"]     == "yes"            ) or
        ( object.tags["outdoor_seating"] == "garden"         ))) then
      object.tags["leisure"] = "garden"
      object.tags["garden"] = "beer_garden"
   end

   if ((  object.tags["abandoned:amenity"] == "pub"             )   or
       (  object.tags["amenity:disused"]   == "pub"             )   or
       (  object.tags["disused"]           == "pub"             )   or
       (  object.tags["disused:pub"]       == "yes"             )   or
       (  object.tags["former_amenity"]    == "former_pub"      )   or
       (  object.tags["former_amenity"]    == "pub"             )   or
       (  object.tags["former_amenity"]    == "old_pub"         )   or
       (  object.tags["former:amenity"]    == "pub"             )   or
       (  object.tags["old_amenity"]       == "pub"             )) then
      object.tags["disused:amenity"] = "pub"
      object.tags["amenity:disused"] = nil
      object.tags["disused"] = nil
      object.tags["disused:pub"] = nil
      object.tags["former_amenity"] = nil
      object.tags["old_amenity"] = nil
   end

   if ((  object.tags["amenity"]           == "closed_pub"      )   or
       (  object.tags["amenity"]           == "dead_pub"        )   or
       (  object.tags["amenity"]           == "disused_pub"     )   or
       (  object.tags["amenity"]           == "former_pub"      )   or
       (  object.tags["amenity"]           == "old_pub"         )   or
       (( object.tags["amenity"]           == "pub"            )    and
        ( object.tags["disused"]           == "yes"            ))   or
       (( object.tags["amenity"]           == "pub"            )    and
        ( object.tags["opening_hours"]     == "closed"         ))) then
      object.tags["disused:amenity"] = "pub"
      object.tags["amenity:disused"] = nil
      object.tags["disused"] = nil
      object.tags["disused:pub"] = nil
      object.tags["former_amenity"] = nil
      object.tags["old_amenity"] = nil
      object.tags["amenity"] = nil
   end

   if ((  object.tags["disused:amenity"]   == "pub"    ) and
       (( object.tags["tourism"]           ~= nil     )  or
        ( object.tags["amenity"]           ~= nil     )  or
        ( object.tags["leisure"]           ~= nil     )  or
        ( object.tags["shop"]              ~= nil     )  or
        ( object.tags["office"]            ~= nil     ))) then
      object.tags["disused:amenity"] = nil
   end

   if ((  object.tags["real_ale"]  ~= nil    ) and
       (( object.tags["amenity"]   == nil   )  and
        ( object.tags["shop"]      == nil   )  and
        ( object.tags["tourism"]   == nil   )  and
        ( object.tags["room"]      == nil   )  and
        ( object.tags["leisure"]   == nil   )  and
        ( object.tags["club"]      == nil   ))) then
      object.tags["real_ale"] = nil
   end

-- ----------------------------------------------------------------------------
-- If something has been tagged both as a brewery and a pub or bar, show as
-- a pub with a microbrewery.
-- ----------------------------------------------------------------------------
   if ((( object.tags["amenity"]    == "pub"     )  or
        ( object.tags["amenity"]    == "bar"     )) and
       (( object.tags["craft"]      == "brewery" )  or
        ( object.tags["industrial"] == "brewery" ))) then
      object.tags["amenity"]  = "pub"
      object.tags["microbrewery"]  = "yes"
      object.tags["craft"]  = nil
      object.tags["industrial"]  = nil
   end

-- ----------------------------------------------------------------------------
-- If a food place has a real_ale tag, also add a food tag and let the real_ale
-- tag control what is shown.
-- ----------------------------------------------------------------------------
   if ((( object.tags["amenity"]  == "cafe"       )  or
        ( object.tags["amenity"]  == "restaurant" )) and
       (( object.tags["real_ale"] ~= nil          )  and
        ( object.tags["real_ale"] ~= "maybe"      )  and
        ( object.tags["real_ale"] ~= "no"         )) and
       (  object.tags["food"]     == nil           )) then
      object.tags["food"]  = "yes"
   end

-- ----------------------------------------------------------------------------
-- Attempt to do something sensible with pubs (and other places that serve
-- real_ale)
--
-- On the web map, the following "pub flags" are used:    mkgmap:
-- Live or dead pub?  y or 	      	     	 	  B (bar) or P (pub)
--                    n, or				  Social Club
--                    c (closed due to covid)		  Social Club (with description)
-- Real ale?          y       	   	       	  	  R
--                    n					  -
--                    d (don't know)           		  -
-- Food 	      y or d                              F
-- Noncarpeted floor  y or d                              L
-- Microbrewery	      y n or d                            UB
-- Micropub	      y n or d                            UP
-- Accommodation      y n or d                            A
-- Wheelchair	      y, l, n or d                        n/a
-- Beer Garden	      g (beer garden), 			  G
--                    o (outside seating), 		  O
--                    d (don't know)			  -
-- 
-- For mkgmap, we don't use different icons beyond "restaurant" and 
-- "social club" (used for "not an accessible pub").  
-- We do use appendices to the name.
-- Initially, set some object flags that we will use later.
-- ----------------------------------------------------------------------------
   if (( object.tags["description:floor"] ~= nil                ) or
       ( object.tags["floor:material"]    == "tiles"            ) or
       ( object.tags["floor:material"]    == "stone"            ) or
       ( object.tags["floor:material"]    == "lino"             ) or
       ( object.tags["floor:material"]    == "slate"            ) or
       ( object.tags["floor:material"]    == "brick"            ) or
       ( object.tags["floor:material"]    == "rough_wood"       ) or
       ( object.tags["floor:material"]    == "rough wood"       ) or
       ( object.tags["floor:material"]    == "concrete"         ) or
       ( object.tags["floor:material"]    == "lino;tiles;stone" )) then
      object.tags["noncarpeted"] = "yes"
   end

   if (( object.tags["micropub"] == "yes"   ) or
       ( object.tags["pub"]      == "micro" )) then
      object.tags["micropub"] = nil
      object.tags["pub"]      = "micropub"
   end

-- ----------------------------------------------------------------------------
-- The misspelling "accomodation" (with one "m") is quite common.
-- ----------------------------------------------------------------------------
   if (( object.tags["accommodation"] == nil )  and
       ( object.tags["accomodation"]  ~= nil )) then
      object.tags["accommodation"] = object.tags["accomodation"]
      object.tags["accomodation"]  = nil
   end
		  
-- ----------------------------------------------------------------------------
-- Next, "closed due to covid" pubs
-- ----------------------------------------------------------------------------
   if ((  object.tags["amenity"]               == "pub"        ) and
       (( object.tags["opening_hours:covid19"] == "off"       ) or
        ( object.tags["opening_hours:covid19"] == "closed"    ) or
        ( object.tags["access:covid19"]        == "no"        ))) then
      object.tags["disused:amenity"] = "pub"
      object.tags["amenity"] = nil
      object = append_nonqa( object, "closed covid" )
      object.tags["real_ale"] = nil
   end

-- ----------------------------------------------------------------------------
-- Main bar/pub description selection
-- (equivalent to "real_ale icon selection" logic on web map)
-- Note that there's no "if pub" here, so any non-pub establishment that serves
-- real ale will get the icon (hotels, restaurants, cafes, etc.)
-- We have explicitly excluded pubs "closed for covid" above.
-- After this large "if" there is no "else" but another "if" for non-real ale
-- pubs (that does check that the thing is actually a pub).
-- ----------------------------------------------------------------------------
   if (( object.tags["real_ale"] ~= nil     ) and
       ( object.tags["real_ale"] ~= "maybe" ) and
       ( object.tags["real_ale"] ~= "no"    )) then
      beer_appendix = ''

      if ( object.tags["amenity"] == "bar" ) then
         beer_appendix = 'B'
      else
         if ( object.tags["amenity"] == "pub" ) then
            beer_appendix = 'P'
         end
      end

      if ( beer_appendix == nil ) then
         beer_appendix = 'QR'
      else
         beer_appendix = beer_appendix .. 'QR'
      end

      if (( object.tags["food"] ~= nil  ) and
          ( object.tags["food"] ~= "no" )) then
         beer_appendix = beer_appendix .. 'F'
      end

      if ( object.tags["noncarpeted"] == "yes"  ) then
         beer_appendix = beer_appendix .. 'L'
      end

      if ( object.tags["microbrewery"] == "yes"  ) then
         beer_appendix = beer_appendix .. 'UB'
      end

      if ( object.tags["micropub"] == "yes"  ) then
         beer_appendix = beer_appendix .. 'UP'
      end

      if (( object.tags["accommodation"] ~= nil  ) and
          ( object.tags["accommodation"] ~= "no" )) then
         beer_appendix = beer_appendix .. 'A'
      end

      if ( object.tags["beer_garden"] == "yes" ) then
         beer_appendix = beer_appendix .. 'G'
      else
         if ( object.tags["outdoor_seating"] == "yes" ) then
            beer_appendix = beer_appendix .. 'O'
         end
      end

      if ( beer_appendix ~= '' ) then
         if ( object.tags['name'] == nil ) then
            object.tags.name = '(' .. beer_appendix .. ')'
         else
            object.tags.name = object.tags['name'] .. ' (' .. beer_appendix .. ')'
         end
      end
   end

   if ((( object.tags["amenity"] == "bar" )  or
        ( object.tags["amenity"] == "pub" )) and
       (( object.tags["real_ale"] == "no" )  or
        ( object.tags["real_ale"] == nil  ))) then
      beer_appendix = ''

      if ( object.tags["amenity"] == "bar" ) then
         beer_appendix = 'B'
      else
         if ( object.tags["amenity"] == "pub" ) then
            beer_appendix = 'P'
         end
      end

      if ( beer_appendix == nil ) then
         beer_appendix = 'Q'
      else
         beer_appendix = beer_appendix .. 'Q'
      end

      if (  object.tags["real_ale"] == "no" ) then
         beer_appendix = beer_appendix .. 'N'
      else
         beer_appendix = beer_appendix .. 'V'
      end

      if (( object.tags["food"] ~= nil  ) and
          ( object.tags["food"] ~= "no" )) then
         beer_appendix = beer_appendix .. 'F'
      end

      if ( object.tags["noncarpeted"] == "yes"  ) then
         beer_appendix = beer_appendix .. 'L'
      end

      if ( object.tags["microbrewery"] == "yes"  ) then
         beer_appendix = beer_appendix .. 'UB'
      end

      if ( object.tags["micropub"] == "yes"  ) then
         beer_appendix = beer_appendix .. 'UP'
      end

      if (( object.tags["accommodation"] ~= nil  ) and
          ( object.tags["accommodation"] ~= "no" )) then
         beer_appendix = beer_appendix .. 'A'
      end

      if ( object.tags["beer_garden"] == "yes" ) then
         beer_appendix = beer_appendix .. 'G'
      else
         if ( object.tags["outdoor_seating"] == "yes" ) then
            beer_appendix = beer_appendix .. 'O'
         end
      end

      if ( beer_appendix ~= '' ) then
         object = append_nonqa( object, beer_appendix )
      end
   end

-- ----------------------------------------------------------------------------
-- Restaurants
-- Different sorts of restaurants get mapped to different sorts of features
-- in the garmin map.  Visually they are very alike, but searching for e.g.
-- "restaurants / chinese" will find chinese restaurants.
-- As with the web map, restaurants with accommodation are shown differently.
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "restaurant" ) then
      if (( object.tags["accommodation"] ~= nil  ) and
          ( object.tags["accommodation"] ~= "no" )) then
         object = append_nonqa( object, "rest accomm" )
      else
         object = append_nonqa( object, "rest" )
      end
   end

-- ----------------------------------------------------------------------------
-- "cafe" - consolidation of lesser used tags
-- ----------------------------------------------------------------------------
   if ( object.tags["shop"] == "cafe"       ) then
      object.tags["amenity"] = "cafe"
   end

   if (( object.tags["shop"] == "sandwiches" ) or
       ( object.tags["shop"] == "sandwich"   )) then
      object.tags["amenity"] = "cafe"
      object.tags["cuisine"] = "sandwich"
   end

-- ----------------------------------------------------------------------------
-- Cafes with accommodation and without
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "cafe" ) then
      if (( object.tags["accommodation"] ~= nil  ) and
          ( object.tags["accommodation"] ~= "no" )) then
         object = append_nonqa( object, "cafe accomm" )
      else
         object = append_nonqa( object, "cafe" )
      end
   end

-- ----------------------------------------------------------------------------
-- Show building societies as banks.  Also shop=bank and credit unions.
-- No suffix added to name.
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"] == "building_society" ) or
       ( object.tags["shop"]    == "bank"             ) or
       ( object.tags["amenity"] == "credit_union"     )) then
      object.tags["amenity"] = "bank"
   end

-- ----------------------------------------------------------------------------
-- Add suffix to ATMS
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "atm" ) then
      object = append_nonqa( object, "atm" )
   end

-- ----------------------------------------------------------------------------
-- Various mistagging, comma and semicolon healthcare
-- Note that health centres currently appear as "health nonspecific".
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"] == "doctors; pharmacy"       ) or
       ( object.tags["amenity"] == "surgery"                 ) or
       ( object.tags["amenity"] == "doctor"                  )) then
      object.tags["amenity"] = "doctors"
   end

   if ( object.tags["amenity"] == "doctors" ) then
      if ( object.tags['name'] == nil ) then
         object.tags.name = '(doctors)'
      else
         object.tags.name = object.tags['name'] .. ' (doctors)'
      end
   end

   if (( object.tags["healthcare"] == "dentist" ) and
       ( object.tags["amenity"]    == nil       )) then
      object.tags["amenity"] = "dentist"
   end

-- ----------------------------------------------------------------------------
-- Dentists were not previously handled but are now passed through as doctors 
-- with a suffix.
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "dentist" ) then
      object.tags["amenity"] = "doctors"
      object = append_nonqa( object, "dentist" )
   end

   if (( object.tags["healthcare"] == "hospital" ) and
       ( object.tags["amenity"]    == nil        )) then
      object.tags["amenity"] = "hospital"
   end

   if ( object.tags["amenity"] == "hospital" ) then
      object = append_nonqa( object, "hospital" )
   end

-- ----------------------------------------------------------------------------
-- Ensure that vaccination centries (e.g. for COVID 19) that aren't already
-- something else get shown as something.
-- Things that _are_ something else get (e.g. community centres) get left as
-- that something else.
-- ----------------------------------------------------------------------------
   if ((( object.tags["healthcare"]            == "vaccination_centre" )  or
        ( object.tags["healthcare"]            == "sample_collection"  )  or
        ( object.tags["healthcare:speciality"] == "vaccination"        )) and
       (  object.tags["amenity"]               == nil                   ) and
       (  object.tags["leisure"]               == nil                   ) and
       (  object.tags["shop"]                  == nil                   )) then
      object.tags["amenity"] = "clinic"
   end

-- ----------------------------------------------------------------------------
-- Clinics were not previously handled but are now passed through as doctors 
-- with a suffix.
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "clinic" ) then
      object.tags["amenity"] = "doctors"
      object = append_nonqa( object, "clinic" )
   end

-- ----------------------------------------------------------------------------
-- If something is mapped both as a supermarket and a pharmacy, suppress the
-- tags for the latter.
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"]    == "supermarket" ) and
       ( object.tags["amenity"] == "pharmacy"    )) then
      object.tags["amenity"] = nil
   end

   if ((( object.tags["healthcare"] == "pharmacy"                   )  and
        ( object.tags["amenity"]    == nil                          )) or
       (( object.tags["shop"]       == "cosmetics"                  )  and
        ( object.tags["pharmacy"]   == "yes"                        )  and
        ( object.tags["amenity"]    == nil                          )) or
       (( object.tags["shop"]       == "chemist"                    )  and
        ( object.tags["pharmacy"]   == "yes"                        )  and
        ( object.tags["amenity"]    == nil                          )) or
       (( object.tags["amenity"]    == "clinic"                     )  and
        ( object.tags["pharmacy"]   == "yes"                        ))) then
      object.tags["amenity"] = "pharmacy"
   end

   if ( object.tags["amenity"] == "pharmacy" ) then
      object = append_nonqa( object, "pharmacy" )
   end

   if ( object.tags["shop"] == "chemist" ) then
      object = append_nonqa( object, "chemist" )
   end

-- ----------------------------------------------------------------------------
-- Add suffix to libraries and public bookcases
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "library" ) then
      object = append_nonqa( object, "library" )
   end

   if (( object.tags["amenity"] == "book_exchange"   ) or
       ( object.tags["amenity"] == "public_bookcase" )) then
      object.tags["amenity"] = "library"
      object = append_nonqa( object, "book exchange" )
   end

-- ----------------------------------------------------------------------------
-- Various clocks
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"] == "clock"   )  and
       ( object.tags["display"] == "sundial" )) then
      object.tags["man_made"] = "thing"
      object.tags["amenity"] = nil
      object = append_nonqa( object, "sundial" )
   end

-- ----------------------------------------------------------------------------
-- Clock towers
-- ----------------------------------------------------------------------------
   if (((  object.tags["man_made"]   == "tower"        )  and
        (( object.tags["tower:type"] == "clock"       )   or
         ( object.tags["building"]   == "clock_tower" )   or
         ( object.tags["amenity"]    == "clock"       ))) or
       ((  object.tags["amenity"]    == "clock"        )  and
        (  object.tags["support"]    == "tower"        ))) then
      object.tags["man_made"] = "tower"
      object.tags["tourism"] = nil
      object = append_nonqa( object, "clocktower" )
   end

   if ((  object.tags["amenity"]    == "clock"         )  and
       (( object.tags["support"]    == "pedestal"     )   or
        ( object.tags["support"]    == "pole"         )   or
        ( object.tags["support"]    == "stone_pillar" )   or
        ( object.tags["support"]    == "plinth"       )   or
        ( object.tags["support"]    == "column"       ))) then
      object.tags["man_made"] = "thing"
      object.tags["tourism"] = nil
      object = append_nonqa( object, "pedestal clock" )
   end

-- ----------------------------------------------------------------------------
-- Aircraft control towers
-- ----------------------------------------------------------------------------
   if (((  object.tags["man_made"]   == "tower"             )   and
        (( object.tags["tower:type"] == "aircraft_control" )    or
         ( object.tags["service"]    == "aircraft_control" )))  or
       (   object.tags["aeroway"]    == "control_tower"      )) then
      object.tags["man_made"] = "tower"
      object.tags["building"] = "yes"
      object.tags["tourism"] = nil
      object = append_nonqa( object, "control tower" )
   end

   if ((( object.tags["man_made"]   == "tower"              )   or
        ( object.tags["man_made"]   == "monitoring_station" ))  and
       (( object.tags["tower:type"] == "radar"              )   or
        ( object.tags["tower:type"] == "weather_radar"      ))) then
      object.tags["man_made"] = "tower"
      object.tags["building"] = "yes"
      object.tags["tourism"] = nil
      object = append_nonqa( object, "radar tower" )
   end

-- ----------------------------------------------------------------------------
-- All the domes in the UK are radomes.
-- ----------------------------------------------------------------------------
   if (( object.tags["man_made"]            == "tower"   ) and
       (( object.tags["tower:construction"] == "dome"   )  or
        ( object.tags["tower:construction"] == "dish"   ))) then
      object.tags["man_made"] = "tower"
      object.tags["building"] = "yes"
      object.tags["tourism"] = nil
      object = append_nonqa( object, "radar dome" )
   end

   if (( object.tags["man_made"]   == "tower"                ) and
       ( object.tags["tower:type"] == "firefighter_training" )) then
      object.tags["man_made"] = "tower"
      object.tags["building"] = "yes"
      object.tags["tourism"] = nil
      object = append_nonqa( object, "firefighter tower" )
   end

   if ((((  object.tags["man_made"]    == "tower"             )  and
         (( object.tags["tower:type"]  == "church"           )   or
          ( object.tags["tower:type"]  == "square"           )   or
          ( object.tags["tower:type"]  == "campanile"        )   or
          ( object.tags["tower:type"]  == "bell_tower"       ))) or
        (   object.tags["man_made"]    == "campanile"          )) and
       ((   object.tags["amenity"]     == nil                  )  or
        (   object.tags["amenity"]     ~= "place_of_worship"   ))) then
      object.tags["man_made"] = "tower"
      object.tags["tourism"] = nil
      object = append_nonqa( object, "church tower" )
   end

   if ((( object.tags["man_made"]      == "tower"            ) or
        ( object.tags["building"]      == "tower"            ) or
        ( object.tags["building:part"] == "yes"              )) and
       ((  object.tags["tower:type"]   == "spire"            )  or
        (  object.tags["tower:type"]   == "steeple"          )  or
        (  object.tags["tower:type"]   == "minaret"          )  or
        (  object.tags["tower:type"]   == "round"            )) and
       (( object.tags["amenity"]       == nil                )  or
        ( object.tags["amenity"]       ~= "place_of_worship" ))) then
      object.tags["man_made"] = "tower"
      object.tags["building"] = "yes"
      object.tags["tourism"] = nil
      object = append_nonqa( object, "church spire" )
   end

   if (( object.tags["man_made"] == "phone_mast"           ) or
       ( object.tags["man_made"] == "radio_mast"           ) or
       ( object.tags["man_made"] == "communications_mast"  ) or
       ( object.tags["man_made"] == "tower"                ) or
       ( object.tags["man_made"] == "communications_tower" ) or
       ( object.tags["man_made"] == "transmitter"          ) or
       ( object.tags["man_made"] == "antenna"              ) or
       ( object.tags["man_made"] == "mast"                 )) then
      object.tags["man_made"] = "mast"
      object.tags["tourism"] = nil
      object = append_nonqa( object, "phone mast" )
   end

-- ----------------------------------------------------------------------------
-- man_made=maypole
-- ----------------------------------------------------------------------------
   if ((  object.tags["man_made"] == "maypole"   ) or
       (  object.tags["man_made"] == "may_pole"  ) or
       (( object.tags["man_made"] == "pole"     )  and
        ( object.tags["pole"]      == "maypole" )) or
       (  object.tags["historic"] == "maypole"   )) then
      object.tags["man_made"] = "mast"
      object.tags["tourism"] = nil
      object = append_nonqa( object, "maypole" )
   end

-- ----------------------------------------------------------------------------
-- highway=streetlamp
-- ----------------------------------------------------------------------------
   if ( object.tags["highway"] == "street_lamp" ) then
      object.tags["man_made"] = "thing"

      if ( object.tags["lamp_type"] == "gaslight" ) then
      	 object = append_nonqa(object,"gas lamp")
      else
      	 object = append_nonqa(object,"streetlight")
      end
   end
   
-- ----------------------------------------------------------------------------
-- Left luggage
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"] == "luggage_locker"  ) or
       ( object.tags["shop"]    == "luggage_locker"  ) or
       ( object.tags["shop"]    == "luggage_lockers" )) then
      object.tags["man_made"]  = "thing"
      object.tags["amenity"] = nil
      object.tags["shop"]    = nil
      object = append_nonqa(object,"left luggage")
   end

-- ----------------------------------------------------------------------------
-- Parcel lockers
-- ----------------------------------------------------------------------------
   if (((  object.tags["amenity"]         == "vending_machine"                )  and
        (( object.tags["vending"]         == "parcel_pickup;parcel_mail_in"  )   or
         ( object.tags["vending"]         == "parcel_mail_in;parcel_pickup"  )   or
         ( object.tags["vending"]         == "parcel_mail_in"                )   or
         ( object.tags["vending"]         == "parcel_pickup"                 )   or
         ( object.tags["vending_machine"] == "parcel_pickup"                 )))  or
       (   object.tags["amenity"]         == "parcel_box"                      )  or
       (   object.tags["amenity"]         == "parcel_pickup"                   )) then
      object.tags["man_made"]  = "thing"
      object.tags["amenity"]  = nil
      object = append_nonqa(object,"parcel locker")
   end

-- ----------------------------------------------------------------------------
-- Excrement bags
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"] == "vending_machine" ) and
       ( object.tags["vending"] == "excrement_bags"  )) then
      object.tags["man_made"]  = "thing"
      object.tags["amenity"]  = nil
      object = append_nonqa(object,"excrement bags")
   end

-- ----------------------------------------------------------------------------
-- If a farm shop doesn't have a name but does have named produce, map across
-- to vending machine, and also the produce into "vending" for consideration 
-- below.
-- ----------------------------------------------------------------------------
   if ((  object.tags["shop"]    == "farm" ) and
       (  object.tags["name"]    == nil    ) and
       (  object.tags["produce"] ~= nil    )) then
      object.tags["amenity"] = "vending_machine"
      object.tags["vending"] = object.tags["produce"]
      object.tags["shop"]    = nil
   end

-- ----------------------------------------------------------------------------
-- Some vending machines get the thing sold as the label.
-- ----------------------------------------------------------------------------
   if (  object.tags["amenity"] == "vending_machine"  ) then
      object.tags["man_made"]  = "thing"
      object.tags["amenity"]  = nil

      if (( object.tags["vending"] == "milk"            )  or
          ( object.tags["vending"] == "eggs"            )  or
          ( object.tags["vending"] == "potatoes"        )  or
          ( object.tags["vending"] == "honey"           )  or
          ( object.tags["vending"] == "cheese"          )  or
          ( object.tags["vending"] == "vegetables"      )  or
          ( object.tags["vending"] == "fruit"           )  or
          ( object.tags["vending"] == "food"            )  or
          ( object.tags["vending"] == "photos"          )  or
          ( object.tags["vending"] == "maps"            )  or
          ( object.tags["vending"] == "newspapers"      )) then
         if ( object.tags['name'] == nil ) then
            object.tags.name = "(" .. object.tags["vending"] .. ")"
         else
            object.tags["name"] = object.tags['name'] .. " (" .. object.tags["vending"] .. ")"
         end
      else
         object = append_nonqa(object,"vending")
      end
   end

-- ----------------------------------------------------------------------------
-- Show amenity=piano and amenity=musical_instrument
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "piano" ) then
      object.tags["man_made"]  = "thing"
      object.tags["amenity"]  = nil
      object = append_nonqa(object,"piano")
   end

   if ( object.tags["amenity"] == "musical_instrument" ) then
      object.tags["man_made"]  = "thing"
      object.tags["amenity"]  = nil
      object = append_nonqa(object,"musical instrument")
   end

-- ----------------------------------------------------------------------------
-- Motorcycle parking
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"] == "parking"    )  and
       ( object.tags["parking"] == "motorcycle" )) then
      object.tags["man_made"] = "thing"
      object = append_nonqa(object,"motorcycle parking")
   end

-- ----------------------------------------------------------------------------
-- Show amenity=layby as parking.
-- highway=rest_area is used a lot in the UK for laybies, so map that over too.
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"] == "layby"     ) or
       ( object.tags["highway"] == "rest_area" )) then
      object.tags["amenity"] = "parking"
   end

-- ----------------------------------------------------------------------------
-- Lose any "access=permissive" on parking; it should not be greyed out as it
-- is "somewhere we can park".
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"] == "parking"    ) and
       ( object.tags["access"]  == "permissive" )) then
      object.tags["access"] = nil
   end

-- ----------------------------------------------------------------------------
-- Show for-pay parking areas differently.
-- ----------------------------------------------------------------------------
   if ((  object.tags["amenity"] == "parking"  ) and
       (( object.tags["fee"]     ~= nil       )  and
        ( object.tags["fee"]     ~= "no"      )  and
        ( object.tags["fee"]     ~= "No"      )  and
        ( object.tags["fee"]     ~= "none"    )  and
        ( object.tags["fee"]     ~= "None"    )  and
        ( object.tags["fee"]     ~= "Free"    )  and
        ( object.tags["fee"]     ~= "free"    )  and
        ( object.tags["fee"]     ~= "0"       ))) then
      object = append_nonqa(object,"pay")
   end

-- ----------------------------------------------------------------------------
-- Show bicycle_parking areas, and 
-- show for-pay bicycle_parking areas differently.
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "bicycle_parking" ) then
      object.tags["man_made"] = "thing"
      object = append_nonqa(object,"bicycle parking")

      if (( object.tags["fee"]     ~= nil               )  and
          ( object.tags["fee"]     ~= "no"              )  and
          ( object.tags["fee"]     ~= "No"              )  and
          ( object.tags["fee"]     ~= "none"            )  and
          ( object.tags["fee"]     ~= "None"            )  and
          ( object.tags["fee"]     ~= "Free"            )  and
          ( object.tags["fee"]     ~= "free"            )  and
          ( object.tags["fee"]     ~= "0"               )) then
         object = append_nonqa(object,"pay")
      end
   end

-- ----------------------------------------------------------------------------
-- Render for-pay toilets differently to free ones, and if male vs female is
-- known, show that too.
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "toilets" ) then
      if (( object.tags["fee"]     ~= nil       )  and
          ( object.tags["fee"]     ~= "no"      )  and
          ( object.tags["fee"]     ~= "No"      )  and
          ( object.tags["fee"]     ~= "none"    )  and
          ( object.tags["fee"]     ~= "None"    )  and
          ( object.tags["fee"]     ~= "Free"    )  and
          ( object.tags["fee"]     ~= "free"    )  and
          ( object.tags["fee"]     ~= "0"       )) then
         if (( object.tags["male"]   == "yes" ) and
             ( object.tags["female"] ~= "yes" )) then
            object = append_nonqa(object,"pay m")
         else
            if (( object.tags["female"] == "yes"       ) and
                ( object.tags["male"]   ~= "yes"       )) then
               object = append_nonqa(object,"pay w")
            else
               object = append_nonqa(object,"pay")
            end
         end
      else
         if (( object.tags["male"]   == "yes" ) and
             ( object.tags["female"] ~= "yes" )) then
	    object = append_nonqa(object,"free m")
         else
            if (( object.tags["female"] == "yes"       ) and
                ( object.tags["male"]   ~= "yes"       )) then
	       object = append_nonqa(object,"free w")
            else
	       object = append_nonqa(object,"free")
            end
         end
      end
   end

-- ----------------------------------------------------------------------------
-- Render amenity=leisure_centre as leisure=sports_centre
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "leisure_centre" ) then
      object.tags["leisure"] = "sports_centre"
   end

-- ----------------------------------------------------------------------------
-- Handle razed railways and old inclined_planes as dismantled.
-- ----------------------------------------------------------------------------
   if (( object.tags["railway:historic"] == "rail"           ) or
       ( object.tags["railway"]          == "razed"          ) or
       ( object.tags["historic"]         == "inclined_plane" )) then
      object.tags["railway"] = "dismantled"
   end

-- ----------------------------------------------------------------------------
-- The "OpenRailwayMap" crowd prefer the less popular railway:preserved=yes
-- instead of railway=preserved (which has the advantage of still allowing
-- e.g. narrow_gauge in addition to rail).
-- ----------------------------------------------------------------------------
   if ( object.tags["railway:preserved"] == "yes" ) then
      object.tags["railway"] = "preserved"
   end

-- ----------------------------------------------------------------------------
-- Change miniature railways (not handled in the style file) to narrow_gauge.
-- ----------------------------------------------------------------------------
   if ( object.tags["railway"] == "miniature" ) then
      object.tags["railway"] = "narrow_gauge"
   end

-- ----------------------------------------------------------------------------
-- Goods Conveyors - render as narrow_gauge railway.
-- ----------------------------------------------------------------------------
   if ( object.tags["man_made"] == "goods_conveyor" ) then
      object.tags["railway"] = "narrow_gauge"
   end

-- ----------------------------------------------------------------------------
-- Waterfalls
-- ----------------------------------------------------------------------------
   if ( object.tags["natural"] == "waterfall" ) then
      object.tags["waterway"] = "waterfall"
   end

-- ----------------------------------------------------------------------------
-- Lock gates
-- ----------------------------------------------------------------------------
   if ( object.tags["waterway"] == "lock_gate" ) then
      object = append_nonqa(object,"lock gate")
   end

-- ----------------------------------------------------------------------------
-- Sluice gates - send through as man_made=thing and append name
-- ----------------------------------------------------------------------------
   if ((  object.tags["waterway"]     == "sluice_gate"      ) or
       (  object.tags["waterway"]     == "sluice"           ) or
       (( object.tags["waterway"]     == "flow_control"    )  and
        ( object.tags["flow_control"] == "sluice_gate"     ))) then
      object.tags["man_made"] = "thing"
      object = append_nonqa(object,"sluice")
   end

-- ----------------------------------------------------------------------------
-- Abandoned railways etc.
-- All are passed through to the style as "railway=abandoned" with an
-- appropriate suffix.
-- ----------------------------------------------------------------------------
   if ( object.tags["railway"] == "abandoned" ) then
      object = append_nonqa(object,"abrly")
   end

   if (( object.tags["railway:historic"] == "rail"           ) or
       ( object.tags["railway"]          == "dismantled"     ) or
       ( object.tags["historic"]         == "inclined_plane" )) then
      object.tags["railway"] = "abandoned"
      object = append_nonqa(object,"dismrly")
   end

   if ( object.tags["railway"] == "disused" ) then
      object.tags["railway"] = "abandoned"
      object = append_nonqa(object,"disurly")
   end

   if ( object.tags["railway"] == "construction" ) then
      object.tags["railway"] = "abandoned"
      object = append_nonqa(object,"constrly")
   end

-- ----------------------------------------------------------------------------
-- Render bus guideways as "a sort of railway"
-- ----------------------------------------------------------------------------
   if (object.tags["highway"] == "bus_guideway") then
      object.tags["highway"] = nil
      object.tags["railway"] = "abandoned"
      object = append_nonqa(object,"bus guideway")
   end

-- ----------------------------------------------------------------------------
-- Historic canal
-- A former canal can, like an abandoned railway, still be a major
-- physical feature.
-- ----------------------------------------------------------------------------
   if (( object.tags["historic"]           == "canal"           ) or
       ( object.tags["historic:waterway"]  == "canal"           ) or
       ( object.tags["historic"]           == "leat"            ) or
       ( object.tags["disused:waterway"]   == "canal"           ) or
       ( object.tags["disused"]            == "canal"           ) or
       ( object.tags["abandoned:waterway"] == "canal"           ) or
       ( object.tags["waterway"]           == "disused_canal"   ) or
       ( object.tags["waterway"]           == "historic_canal"  ) or
       ( object.tags["waterway"]           == "abandoned_canal" ) or
       ( object.tags["waterway"]           == "former_canal"    ) or
       ( object.tags["waterway:historic"]  == "canal"           ) or
       ( object.tags["waterway:abandoned"] == "canal"           ) or
       ( object.tags["abandoned"]          == "waterway=canal"  )) then
      object.tags["waterway"] = "derelict_canal"
   end

-- ----------------------------------------------------------------------------
-- Use historical names if present for historical canals.
-- ----------------------------------------------------------------------------
   if (( object.tags["waterway"]      == "derelict_canal" ) and
       ( object.tags["name"]          == nil              ) and
       ( object.tags["name:historic"] ~= nil              )) then
      object.tags["name"] = object.tags["name:historic"]
   end

   if (( object.tags["waterway"]      == "derelict_canal" ) and
       ( object.tags["name"]          == nil              ) and
       ( object.tags["historic:name"] ~= nil              )) then
      object.tags["name"] = object.tags["historic:name"]
   end

-- ----------------------------------------------------------------------------
-- If the derelict canal still has no name at this point, give it one.
-- ----------------------------------------------------------------------------
   if ( object.tags["waterway"] == "derelict_canal" ) then
      object = append_nonqa(object,"derelict canal")
   end

-- ----------------------------------------------------------------------------
-- Intermittent water
-- ----------------------------------------------------------------------------
   if ((( object.tags["waterway"] ~= nil      )   or
        ( object.tags["natural"]  ~= nil      ))  and
       (  object.tags["intermittent"] == "yes" )) then
      object = append_nonqa(object,"int")
   end

-- ----------------------------------------------------------------------------
-- Various man_made things as normal buildings
-- ----------------------------------------------------------------------------
   if (( object.tags["man_made"]   == "storage_tank"     ) or
       ( object.tags["man_made"]   == "silo"             ) or
       ( object.tags["man_made"]   == "tank"             ) or
       ( object.tags["man_made"]   == "water_tank"       ) or
       ( object.tags["man_made"]   == "kiln"             ) or
       ( object.tags["man_made"]   == "gasometer"        ) or
       ( object.tags["man_made"]   == "oil_tank"         ) or
       ( object.tags["man_made"]   == "greenhouse"       ) or
       ( object.tags["man_made"]   == "water_treatment"  ) or
       ( object.tags["man_made"]   == "trickling_filter" ) or
       ( object.tags["man_made"]   == "filter_bed"       ) or
       ( object.tags["man_made"]   == "filtration_bed"   ) or
       ( object.tags["man_made"]   == "waste_treatment"  ) or
       ( object.tags["man_made"]   == "lighthouse"       ) or
       ( object.tags["man_made"]   == "telescope"        ) or
       ( object.tags["man_made"]   == "radio_telescope"  ) or
       ( object.tags["man_made"]   == "street_cabinet"   ) or
       ( object.tags["man_made"]   == "aeroplane"        ) or
       ( object.tags["man_made"]   == "helicopter"       )) then
      object.tags["building"] = "yes"
      object = append_nonqa( object, object.tags["man_made"] )
      object.tags["man_made"] = nil
   end

-- ----------------------------------------------------------------------------
-- Map man_made=monument to historic=monument (handled below) if no better tag
-- exists.
-- Also handle geoglyphs in this way.
-- ----------------------------------------------------------------------------
   if ((( object.tags["man_made"] == "monument" )  and
        ( object.tags["historic"]  == nil       )) or
       (  object.tags["man_made"] == "geoglyph"  )) then
      object.tags["historic"] = "monument"
      object.tags["man_made"] = nil
   end

-- ----------------------------------------------------------------------------
-- Things that are both peaks and memorials should render as the latter.
-- ----------------------------------------------------------------------------
   if (( object.tags["natural"]   == "peak"     ) and
       ( object.tags["historic"]  == "memorial" )) then
      object.tags["natural"] = nil
   end

-- ----------------------------------------------------------------------------
-- Things that are both peaks and cairns should render as the former.
-- ----------------------------------------------------------------------------
   if (( object.tags["natural"]   == "peak"     ) and
       ( object.tags["man_made"]  == "cairn" )) then
      object.tags["man_made"] = nil
   end

-- ----------------------------------------------------------------------------
-- Things that are both towers and monuments or memorials 
-- should render as the latter.
-- ----------------------------------------------------------------------------
   if ((  object.tags["man_made"]  == "tower"     ) and
       (( object.tags["historic"]  == "memorial" )  or
        ( object.tags["historic"]  == "monument" ))) then
      object.tags["man_made"] = nil
   end

-- ----------------------------------------------------------------------------
-- Render historic=wayside_cross and wayside_shrine as historic=memorialcross
-- ----------------------------------------------------------------------------
   if ((   object.tags["historic"]   == "wayside_cross"    ) or
       (   object.tags["historic"]   == "wayside_shrine"   ) or
       ((  object.tags["historic"]   == "memorial"        )  and
        (( object.tags["memorial"]   == "cross"          )   or
         ( object.tags["memorial"]   == "mercat_cross"   )))) then
      object.tags["historic"] = "memorial"
      object = append_nonqa(object,"cross")
   end

   if (( object.tags["historic"]   == "memorial"     ) and
       ( object.tags["memorial"]   == "war_memorial" )) then
      object.tags["historic"] = "memorial"
      object = append_nonqa(object,"war memorial")
   end

   if ((  object.tags["historic"]      == "memorial"     ) and
       (( object.tags["memorial"]      == "plaque"      )  or
        ( object.tags["memorial"]      == "blue_plaque" )  or
        ( object.tags["memorial:type"] == "plaque"      ))) then
      object.tags["historic"] = "memorial"
      object = append_nonqa(object,"plaque")
   end

   if (( object.tags["historic"]   == "memorial"        ) and
       ( object.tags["memorial"]   == "pavement plaque" )) then
      object.tags["historic"] = "memorial"
      object = append_nonqa(object,"pavement plaque")
   end

   if ((  object.tags["historic"]      == "memorial"  ) and
       (( object.tags["memorial"]      == "statue"   )  or
        ( object.tags["memorial:type"] == "statue"   ))) then
      object.tags["historic"] = "memorial"
      object = append_nonqa(object,"memorial statue")
   end

   if (( object.tags["historic"]   == "memorial"    ) and
       ( object.tags["memorial"]   == "sculpture"   )) then
      object.tags["historic"] = "memorial"
      object = append_nonqa(object,"memorial sculpture")
   end

   if (( object.tags["historic"]   == "memorial"    ) and
       ( object.tags["memorial"]   == "stone"       )) then
      object.tags["historic"] = "memorial"
      object = append_nonqa(object,"memorial stone")
   end

-- ----------------------------------------------------------------------------
-- historic=monument
-- ----------------------------------------------------------------------------
   if ( object.tags["historic"]   == "monument"     ) then
      object.tags["historic"] = "memorial"
      object = append_nonqa(object,"monument")
   end

   if ( object.tags["tourism"] == "gallery" ) then
      object.tags["amenity"] = nil
      object.tags["tourism"] = "museum"
      object = append_nonqa(object,"gallery")
   end

   if ( object.tags["tourism"] == "museum" ) then
      object.tags["amenity"] = nil
      object = append_nonqa(object,"museum")
   end

   if ( object.tags["tourism"] == "attraction" ) then
      object = append_nonqa(object,"tourist attraction")
   end

   if ( object.tags["tourism"] == "artwork" ) then
      object = append_nonqa(object,"artwork")
   end

   if ( object.tags["amenity"] == "arts_centre" ) then
      object = append_nonqa(object,"arts centre")
   end

-- ----------------------------------------------------------------------------
-- Mineshafts
-- First make sure that we treat historic ones as historic
-- ----------------------------------------------------------------------------
   if ((( object.tags["man_made"] == "mine"       )  or
        ( object.tags["man_made"] == "mineshaft"  )  or
        ( object.tags["man_made"] == "mine_shaft" )) and
       (( object.tags["historic"] == "yes"        )  or
        ( object.tags["historic"] == "mine"       )  or
        ( object.tags["historic"] == "mineshaft"  )  or
        ( object.tags["historic"] == "mine_shaft" ))) then
      object.tags["historic"] = "ruins"
      object.tags["man_made"] = nil
      object.tags["tourism"]  = nil
      object = append_nonqa(object,"historic mine") 
   end

-- ----------------------------------------------------------------------------
-- Then other spellings of mineshaft
-- ----------------------------------------------------------------------------
   if (( object.tags["man_made"] == "mine"       )  or
       ( object.tags["man_made"] == "mineshaft"  )  or
       ( object.tags["man_made"] == "mine_shaft" )) then
      object.tags["man_made"] = "thing"
      object = append_nonqa(object,"mine") 
   end

-- ----------------------------------------------------------------------------
-- Ensure historic things are shown.
-- There's no distinction here between building / almost a building / 
-- not a building as there is with the web maps.
-- ----------------------------------------------------------------------------
   if (( object.tags["historic"] == "building"           ) or
       ( object.tags["historic"] == "heritage_building"  ) or
       ( object.tags["historic"] == "protected_building" ) or
       ( object.tags["historic"] == "watermill"          ) or
       ( object.tags["historic"] == "windmill"           ) or
       ( object.tags["historic"] == "church"             ) or
       ( object.tags["historic"] == "wayside_chapel"     ) or
       ( object.tags["historic"] == "chapel"             ) or
       ( object.tags["historic"] == "gate_house"         ) or
       ( object.tags["historic"] == "aircraft"           ) or
       ( object.tags["historic"] == "locomotive"         ) or
       ( object.tags["historic"] == "roundhouse"         ) or
       ( object.tags["historic"] == "ship"               ) or
       ( object.tags["historic"] == "tank"               ) or
       ( object.tags["historic"] == "house"              ) or
       ( object.tags["historic"] == "mine_shaft"         ) or
       ( object.tags["historic"] == "lime_kiln"          ) or
       ( object.tags["historic"] == "limekiln"           ) or
       ( object.tags["historic"] == "kiln"               ) or
       ( object.tags["historic"] == "trough"             ) or
       ( object.tags["historic"] == "wreck"             ) or
       ( object.tags["historic"] == "monument"          ) or
       ( object.tags["historic"] == "fort"              ) or
       ( object.tags["historic"] == "ringfort"          ) or
       ( object.tags["historic"] == "earthworks"        ) or
       ( object.tags["historic"] == "motte"             ) or
       ( object.tags["historic"] == "barrow"            ) or
       ( object.tags["historic"] == "tumulus"           ) or
       ( object.tags["historic"] == "tomb"              ) or
       ( object.tags["historic"] == "fortification"     ) or
       ( object.tags["historic"] == "camp"              ) or
       ( object.tags["historic"] == "menhir"            ) or
       ( object.tags["historic"] == "stone_circle"      ) or
       ( object.tags["historic"] == "castle"            ) or
       ( object.tags["historic"] == "mill"              ) or
       ( object.tags["historic"] == "mound"             ) or
       ( object.tags["historic"] == "manor"             ) or
       ( object.tags["historic"] == "country_mansion"   ) or
       ( object.tags["historic"] == "mansion"           ) or
       ( object.tags["historic"] == "mansion;castle"    ) or
       ( object.tags["historic"] == "hall"              ) or
       ( object.tags["historic"] == "stately_home"      ) or
       ( object.tags["historic"] == "tower_house"       ) or
       ( object.tags["historic"] == "almshouse"         ) or
       ( object.tags["historic"] == "police_box"        ) or
       ( object.tags["historic"] == "bakery"            ) or
       ( object.tags["historic"] == "battlefield"       ) or
       ( object.tags["historic"] == "monastery"         ) or
       ( object.tags["historic"] == "monastic_grange"   ) or
       ( object.tags["historic"] == "abbey"             ) or
       ( object.tags["historic"] == "priory"            ) or
       ( object.tags["historic"] == "palace"            ) or
       ( object.tags["historic"] == "tower"             ) or
       ( object.tags["historic"] == "dovecote"          ) or
       ( object.tags["historic"] == "toll_house"        ) or
       ( object.tags["historic"] == "city_gate"         ) or
       ( object.tags["historic"] == "gate"              ) or
       ( object.tags["historic"] == "pinfold"           ) or
       ( object.tags["historic"] == "prison"            ) or
       ( object.tags["historic"] == "theatre"           ) or
       ( object.tags["historic"] == "shelter"           ) or
       ( object.tags["historic"] == "grave"             ) or
       ( object.tags["historic"] == "grave_yard"        ) or
       ( object.tags["historic"] == "statue"            ) or
       ( object.tags["historic"] == "cross"             ) or
       ( object.tags["historic"] == "market_cross"      ) or
       ( object.tags["historic"] == "stocks"            ) or
       ( object.tags["historic"] == "folly"             ) or
       ( object.tags["historic"] == "drinking_fountain" ) or
       ( object.tags["historic"] == "mine_adit"         ) or
       ( object.tags["historic"] == "mine"              ) or
       ( object.tags["historic"] == "sawmill"           ) or
       ( object.tags["historic"] == "well"              ) or
       ( object.tags["historic"] == "cannon"            ) or
       ( object.tags["historic"] == "icon"              )) then
      object.tags["tourism"] = nil

      if ( object.tags['name'] == nil ) then
         object.tags.name = '(historic ' .. object.tags["historic"] .. ')'
      else
         object.tags.name = object.tags['name'] .. ' (historic ' .. object.tags["historic"] .. ')'
      end

      object.tags["historic"] = "ruins"
   end

-- ----------------------------------------------------------------------------
-- If something is tagged as both an archaelogical site and a place, lose the
-- place tag.
-- ----------------------------------------------------------------------------
   if (( object.tags["historic"] == "archaeological_site" )  and
       ( object.tags["place"]    ~= nil                   )) then
      object.tags["place"] = nil
   end

   if (( object.tags["historic"] == "archaeological_site" )  and
       ( object.tags["landuse"]  == nil                   )) then
      object.tags["tourism"] = nil

      if ( object.tags["megalith_type"] == "standing_stone" ) then
         object = append_nonqa(object,"standing stone") 
      else
         object = append_nonqa(object,"archaeological") 
      end
   end

-- ----------------------------------------------------------------------------
-- palaeolontological_site
-- ----------------------------------------------------------------------------
   if ( object.tags["geological"] == "palaeontological_site" ) then
      object.tags["historic"] = "archaeological_site"
      object = append_nonqa(object,"palaeontological") 
   end

-- ----------------------------------------------------------------------------
-- Historic markers
-- ----------------------------------------------------------------------------
   if ((   object.tags["historic"]    == "marker"          )  or
       (   object.tags["historic"]    == "plaque"          )  or
       (   object.tags["historic"]    == "memorial_plaque" )  or
       (   object.tags["historic"]    == "blue_plaque"     )  or
       ((  object.tags["tourism"]     == "information"    )   and
        (( object.tags["information"] == "blue_plaque"   )    or
         ( object.tags["information"] == "plaque"        )))) then
      object.tags["historic"] = nil
      object.tags["man_made"] = "thing"
      object = append_nonqa( object, "historic plaque" )
   end

   if ( object.tags["historic"] == "pillar" ) then
      object.tags["barrier"] = "bollard"
      object.tags["historic"] = nil
   end

   if (( object.tags["historic"] == "cairn" ) or
       ( object.tags["man_made"] == "cairn" )) then
      object.tags["man_made"] = "thing"
      object.tags["historic"] = nil
      object = append_nonqa( object, "cairn" )
   end

   if ((  object.tags["historic"]   == "chimney"  ) or
       (  object.tags["man_made"]   == "chimney"  ) or
       (  object.tags["building"]   == "chimney"  ) or
       (( object.tags["building"]   == "tower"   )  and
        ( object.tags["tower:type"] == "chimney" ))) then
      object.tags["man_made"] = "tower"
      object.tags["historic"] = nil
      object = append_nonqa( object, "chimney" )
   end

-- ----------------------------------------------------------------------------
-- hazard=plant is fairly rare, but render as a nonspecific historic dot.
-- ----------------------------------------------------------------------------
   if ((( object.tags["hazard"]  == "plant"                    )  or
        ( object.tags["hazard"]  == "toxic_plant"              )) and
       (( object.tags["species"] == "Heracleum mantegazzianum" )  or
        ( object.tags["taxon"]   == "Heracleum mantegazzianum" ))) then
      object.tags["man_made"] = "thing"
      object = append_nonqa( object, "hogweed" )
   end

-- ----------------------------------------------------------------------------
-- If something has a "lock_ref", append it to "lock_name" (if it exists) or
-- "name" (if it doesn't), and put the result in "name".
-- ----------------------------------------------------------------------------
   if ( object.tags["lock_ref"] ~= nil ) then
      if ( object.tags["lock_name"] ~= nil ) then
         object.tags["name"] = object.tags["lock_name"] .. " (" .. object.tags["lock_ref"] .. ")"
      else
         if ( object.tags["name"] ~= nil ) then
            object.tags["name"] = object.tags["name"] .. " (" .. object.tags["lock_ref"] .. ")"
         else
            object.tags["name"] = "(" .. object.tags["lock_ref"] .. ")"
         end
      end
   end

-- ----------------------------------------------------------------------------
-- Bridge types - only "yes" is checked below.
-- ----------------------------------------------------------------------------
   if (( object.tags["bridge"] == "viaduct"     ) or
       ( object.tags["bridge"] == "aqueduct"    ) or
       ( object.tags["bridge"] == "movable"     ) or
       ( object.tags["bridge"] == "boardwalk"   ) or
       ( object.tags["bridge"] == "swing"       ) or
       ( object.tags["bridge"] == "cantilever"  ) or
       ( object.tags["bridge"] == "footbridge"  ) or
       ( object.tags["bridge"] == "undefined"   ) or
       ( object.tags["bridge"] == "covered"     ) or
       ( object.tags["bridge"] == "cantilever"  ) or
       ( object.tags["bridge"] == "gangway"     ) or
       ( object.tags["bridge"] == "foot"        ) or
       ( object.tags["bridge"] == "plank"       ) or
       ( object.tags["bridge"] == "rope"        ) or
       ( object.tags["bridge"] == "pontoon"     ) or
       ( object.tags["bridge"] == "pier"        ) or
       ( object.tags["bridge"] == "chain"       ) or
       ( object.tags["bridge"] == "trestle"     )) then
      object.tags["bridge"] = "yes"
   end

-- ----------------------------------------------------------------------------
-- If set, move bridge:name to bridge_name
-- ----------------------------------------------------------------------------
   if ( object.tags["bridge:name"] ~= nil ) then
      object.tags["bridge_name"] = object.tags["bridge:name"]
      object.tags["bridge:name"] = nil
   end

-- ----------------------------------------------------------------------------
-- If set, move bridge_name to name
-- ----------------------------------------------------------------------------
   if ( object.tags["bridge_name"] ~= nil ) then
      object.tags["name"] = object.tags["bridge_name"]
      object.tags["bridge_name"] = nil
   end

-- ----------------------------------------------------------------------------
-- If set, move bridge:ref to bridge_ref
-- ----------------------------------------------------------------------------
   if ( object.tags["bridge:ref"] ~= nil ) then
      object.tags["bridge_ref"] = object.tags["bridge:ref"]
      object.tags["bridge:ref"] = nil
   end

-- ----------------------------------------------------------------------------
-- If set, move canal_bridge_ref to bridge_ref
-- ----------------------------------------------------------------------------
   if ( object.tags["canal_bridge_ref"] ~= nil ) then
      object.tags["bridge_ref"] = object.tags["canal_bridge_ref"]
      object.tags["canal_bridge_ref"] = nil
   end

-- ----------------------------------------------------------------------------
-- If set and relevant, do something with bridge_ref
-- ----------------------------------------------------------------------------
   if ((  object.tags["bridge_ref"] ~= nil  ) and
       (( object.tags["highway"]    ~= nil )  or
        ( object.tags["railway"]    ~= nil )  or
        ( object.tags["waterway"]   ~= nil ))) then
      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(" .. object.tags["bridge_ref"] .. ")"
      else
         object.tags["name"] = object.tags["name"] .. " (" .. object.tags["bridge_ref"] .. ")"
      end

      object.tags["bridge_ref"] = nil
   end

-- ----------------------------------------------------------------------------
-- If set, move tunnel:name to tunnel_name
-- ----------------------------------------------------------------------------
   if ( object.tags["tunnel:name"] ~= nil ) then
      object.tags["tunnel_name"] = object.tags["tunnel:name"]
      object.tags["tunnel:name"] = nil
   end

-- ----------------------------------------------------------------------------
-- If set, move tunnel_name to name
-- ----------------------------------------------------------------------------
   if ( object.tags["tunnel_name"] ~= nil ) then
      object.tags["name"] = object.tags["tunnel_name"]
      object.tags["tunnel_name"] = nil
   end

-- ----------------------------------------------------------------------------
-- If something has a "tpuk_ref", use it in preference to "name".
-- It's in brackets because it's likely not signed.
-- ----------------------------------------------------------------------------
   if ( object.tags["tpuk_ref"] ~= nil ) then
      object.tags["name"] = "(" .. object.tags["tpuk_ref"] .. ")"
   end

-- ----------------------------------------------------------------------------
-- Add "water" to some "wet" features for rendering.
-- ----------------------------------------------------------------------------
   if (( object.tags["man_made"]   == "wastewater_reservoir"  ) or
       ( object.tags["man_made"]   == "lagoon"                ) or
       ( object.tags["man_made"]   == "lake"                  ) or
       ( object.tags["man_made"]   == "reservoir"             ) or
       ( object.tags["basin"]      == "wastewater"            )) then
      object.tags["natural"] = "water"
   end

-- ----------------------------------------------------------------------------
-- Show wind turbines and wind pumps
-- ----------------------------------------------------------------------------
   if ((   object.tags["man_made"]         == "wind_turbine"   ) or
       (   object.tags["generator:method"] == "wind_turbine"   ) or
       (   object.tags["plant_method"]     == "wind_turbine"   ) or
       (   object.tags["generator:type"]   == "wind_turbine"   ) or
       ((  object.tags["man_made"]         == "tower"         )  and
        (  object.tags["power"]            == "generator"     )  and
        (( object.tags["power_source"]     == "wind"         )   or
         ( object.tags["generator:source"] == "wind"         )   or
         ( object.tags["generator:method"] == "wind_turbine" )   or
         ( object.tags["plant:source"]     == "wind"         )   or
         ( object.tags["generator:type"]   == "wind"         )   or
         ( object.tags["generator:method"] == "wind"         )))) then
      object.tags["man_made"] = "thing"

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(wind turbine)"
      else
         object.tags["name"] = object.tags["name"] .. " (wind turbine)"
      end
   end

   if ( object.tags["man_made"]   == "windpump" ) then
      object.tags["man_made"] = "thing"

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(windpump)"
      else
         object.tags["name"] = object.tags["name"] .. " (windpump)"
      end
   end

-- ----------------------------------------------------------------------------
-- Railway ventilation shaft nodes.
-- Nodes of these are rendered as a stubby black tower
-- ----------------------------------------------------------------------------
   if (( object.tags["building"]   == "air_shaft"         ) or
       ( object.tags["man_made"]   == "air_shaft"         ) or
       ( object.tags["tunnel"]     == "air_shaft"         ) or
       ( object.tags["historic"]   == "air_shaft"         ) or
       ( object.tags["railway"]    == "ventilation_shaft" ) or
       ( object.tags["tunnel"]     == "ventilation_shaft" ) or
       ( object.tags["tunnel"]     == "ventilation shaft" ) or
       ( object.tags["building"]   == "ventilation_shaft" ) or
       ( object.tags["building"]   == "vent_shaft"        ) or
       ( object.tags["man_made"]   == "vent_shaft"        ) or
       ( object.tags["tower:type"] == "vent"              )) then
      object.tags["man_made"] = "thing"

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(vent shaft)"
      else
         object.tags["name"] = object.tags["name"] .. " (vent shaft)"
      end
   end

-- ----------------------------------------------------------------------------
-- Horse mounting blocks
-- ----------------------------------------------------------------------------
   if (( object.tags["man_made"]  == "mounting_block"       ) or
       ( object.tags["amenity"]   == "mounting_block"       ) or
       ( object.tags["historic"]  == "mounting_block"       ) or
       ( object.tags["amenity"]   == "mounting_step"        ) or
       ( object.tags["amenity"]   == "mounting_steps"       ) or
       ( object.tags["amenity"]   == "horse_dismount_block" )) then
      object.tags["man_made"] = "thing"

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(mounting block)"
      else
         object.tags["name"] = object.tags["name"] .. " (mounting block)"
      end
   end

-- ----------------------------------------------------------------------------
-- Water monitoring stations
-- ----------------------------------------------------------------------------
   if ((  object.tags["man_made"]                  == "monitoring_station"  ) and
       (( object.tags["monitoring:water_level"]    == "yes"                )  or
        ( object.tags["monitoring:water_flow"]     == "yes"                )  or
        ( object.tags["monitoring:water_velocity"] == "yes"                ))) then
      object.tags["man_made"] = "thing"

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(water monitoring)"
      else
         object.tags["name"] = object.tags["name"] .. " (water monitoring)"
      end
   end

-- ----------------------------------------------------------------------------
-- Weather monitoring stations
-- ----------------------------------------------------------------------------
   if (( object.tags["man_made"]               == "monitoring_station" ) and
       ( object.tags["monitoring:weather"]     == "yes"                ) and
       ( object.tags["weather:radar"]          == nil                  ) and
       ( object.tags["monitoring:water_level"] == nil                  )) then
      object.tags["man_made"] = "thing"

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(weather monitoring)"
      else
         object.tags["name"] = object.tags["name"] .. " (weather monitoring)"
      end
   end

-- ----------------------------------------------------------------------------
-- Rainfall monitoring stations
-- ----------------------------------------------------------------------------
   if (( object.tags["man_made"]               == "monitoring_station" ) and
       ( object.tags["monitoring:rainfall"]    == "yes"                ) and
       ( object.tags["monitoring:weather"]     == nil                  ) and
       ( object.tags["monitoring:water_level"] == nil                  )) then
      object.tags["man_made"] = "thing"

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(rainfall monitoring)"
      else
         object.tags["name"] = object.tags["name"] .. " (rainfall monitoring)"
      end
   end

-- ----------------------------------------------------------------------------
-- Earthquake monitoring stations
-- ----------------------------------------------------------------------------
   if (( object.tags["man_made"]                     == "monitoring_station" ) and
       ( object.tags["monitoring:seismic_activity"]  == "yes"                )) then
      object.tags["man_made"] = "thing"

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(earthquake monitoring)"
      else
         object.tags["name"] = object.tags["name"] .. " (earthquake monitoring)"
      end
   end

-- ----------------------------------------------------------------------------
-- Sky brightness monitoring stations
-- ----------------------------------------------------------------------------
   if (( object.tags["man_made"]                   == "monitoring_station" ) and
       ( object.tags["monitoring:sky_brightness"]  == "yes"                )) then
      object.tags["man_made"] = "thing"

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(sky brightness monitoring)"
      else
         object.tags["name"] = object.tags["name"] .. " (sky brightness monitoring)"
      end
   end

-- ----------------------------------------------------------------------------
-- Air quality monitoring stations
-- ----------------------------------------------------------------------------
   if (( object.tags["man_made"]               == "monitoring_station" ) and
       ( object.tags["monitoring:air_quality"] == "yes"                ) and
       ( object.tags["monitoring:weather"]     == nil                  )) then
      object.tags["man_made"] = nil
      object.tags["landuse"] = "industrial"

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(air quality)"
      else
         object.tags["name"] = object.tags["name"] .. " (air quality)"
      end
   end

-- ----------------------------------------------------------------------------
-- Golf ball washers
-- ----------------------------------------------------------------------------
   if ( object.tags["golf"] == "ball_washer" ) then
      object.tags["man_made"] = "thing"

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(golf ball washer)"
      else
         object.tags["name"] = object.tags["name"] .. " (golf ball washer)"
      end
   end

-- ----------------------------------------------------------------------------
-- Advertising Columns
-- ----------------------------------------------------------------------------
   if ( object.tags["advertising"] == "column" ) then
      object.tags["man_made"] = "thing"

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(advertising column)"
      else
         object.tags["name"] = object.tags["name"] .. " (advertising column)"
      end
   end

-- ----------------------------------------------------------------------------
-- highway=escape to service
-- There aren't many escape lanes mapped, but they do exist
-- ----------------------------------------------------------------------------
   if ( object.tags["highway"]   == "escape" ) then
      object.tags["highway"] = "service"
      object.tags["access"]  = "destination"
   end

-- ----------------------------------------------------------------------------
-- Render guest houses subtagged as B&B as B&B
-- ----------------------------------------------------------------------------
   if ( object.tags["tourism"] == "bed_and_breakfast" ) then
      object.tags["tourism"] = "guest_house"

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(B&B)"
      else
         object.tags["name"] = object.tags["name"] .. " (B&B)"
      end
   end

-- ----------------------------------------------------------------------------
-- Also "self_catering" et al (used occasionally) as guest_house.
-- ----------------------------------------------------------------------------
   if (( object.tags["tourism"]   == "self_catering"           ) or
       ( object.tags["tourism"]   == "apartment"               ) or
       ( object.tags["tourism"]   == "apartments"              ) or
       ( object.tags["tourism"]   == "holiday_cottage"         ) or
       ( object.tags["tourism"]   == "cottage"                 ) or
       ( object.tags["tourism"]   == "holiday_village"         ) or
       ( object.tags["tourism"]   == "holiday_park"            ) or
       ( object.tags["tourism"]   == "spa_resort"              ) or
       ( object.tags["tourism"]   == "accommodation"           ) or
       ( object.tags["tourism"]   == "holiday_accommodation"   ) or
       ( object.tags["tourism"]   == "holiday_lets"            ) or
       ( object.tags["tourism"]   == "holiday_let"             ) or
       ( object.tags["tourism"]   == "Holiday Lodges"          ) or
       ( object.tags["tourism"]   == "guesthouse"              ) or
       ( object.tags["tourism"]   == "aparthotel"              )) then
      object.tags["tourism"] = "guest_house"
   end

-- ----------------------------------------------------------------------------
-- Render alternative taggings of camp_site etc.
-- ----------------------------------------------------------------------------
   if ( object.tags["tourism"] == "camping"  ) then
      object.tags["tourism"] = "camp_site"
   end

   if (( object.tags["tourism"] == "caravan_site;camp_site"    ) or
       ( object.tags["tourism"] == "caravan_site;camping_site" )) then
      object.tags["tourism"] = "caravan_site"
   end

   if ( object.tags["tourism"] == "adventure_holiday"  ) then
      object.tags["tourism"] = "hostel"
   end

-- ----------------------------------------------------------------------------
-- Beacons - render historic ones, not radio ones.
-- ----------------------------------------------------------------------------
   if ((( object.tags["man_made"] == "beacon"        )  or
        ( object.tags["man_made"] == "signal_beacon" )  or
        ( object.tags["landmark"] == "beacon"        )  or
        ( object.tags["historic"] == "beacon"        )) and
       (  object.tags["airmark"]  == nil              ) and
       (  object.tags["aeroway"]  == nil              ) and
       (  object.tags["natural"]  ~= "peak"           )) then
      object.tags["man_made"] = "thing"

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(beacon)"
      else
         object.tags["name"] = object.tags["name"] .. " (beacon)"
      end
   end

-- ----------------------------------------------------------------------------
-- Render historic railway stations.
-- ----------------------------------------------------------------------------
   if (( object.tags["abandoned:railway"] == "station" )  or
       ( object.tags["historic:railway"]  == "station" )  or
       ( object.tags["disused:railway"]   == "station" )) then
      object.tags["man_made"] = "thing"

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(historic station)"
      else
         object.tags["name"] = object.tags["name"] .. " (historic station)"
      end
   end

-- ----------------------------------------------------------------------------
-- Where military has been overtagged over natural=wood, remove military.
-- ----------------------------------------------------------------------------
   if ((( object.tags["natural"]   == "wood"        )  or
        ( object.tags["landuse"]   == "forest"      )) and
       (  object.tags["military"]  == "danger_area"  )) then
      object.tags["military"] = nil
   end

-- ----------------------------------------------------------------------------
-- Retag military bunkers as buildings
-- ----------------------------------------------------------------------------
   if ( object.tags["military"] == "bunker" )  then
      object.tags["building"] = "yes"
      object = append_nonqa( object, "bunker" )
   end

-- ----------------------------------------------------------------------------
-- Tag military barracks as military landuse, if not already.
-- ----------------------------------------------------------------------------
   if ( object.tags["military"] == "barracks" )  then
      if ( object.tags['landuse'] == nil ) then
         object.tags.landuse = "military"
      end
      object = append_nonqa( object, "barracks" )
   end

-- ----------------------------------------------------------------------------
-- Tag military offices as military landuse, if not already.
-- ----------------------------------------------------------------------------
   if (( object.tags["military"] == "office"                             ) or
       ( object.tags["military"] == "offices"                            ) or
       ( object.tags["military"] == "registration_and_enlistment_office" ))  then
      if ( object.tags['landuse'] == nil ) then
         object.tags.landuse = "military"
      end

      object = append_nonqa( object, "military office" )
   end

-- ----------------------------------------------------------------------------
-- Tag naval bases as military landuse, if not already.
-- ----------------------------------------------------------------------------
   if ( object.tags["military"] == "naval_base" ) then
      if ( object.tags['landuse'] == nil ) then
         object.tags.landuse = "military"
      end

      object = append_nonqa( object, "naval base" )
   end

-- ----------------------------------------------------------------------------
-- Tag military depots as military landuse, if not already.
-- ----------------------------------------------------------------------------
   if ( object.tags["military"] == "depot" ) then
      if ( object.tags['landuse'] == nil ) then
         object.tags.landuse = "military"
      end

      object = append_nonqa( object, "military depot" )
   end

-- ----------------------------------------------------------------------------
-- Tag ta centres as military landuse, if not already.
-- ----------------------------------------------------------------------------
   if ( object.tags["military"] == "ta centre" ) then
      if ( object.tags['landuse'] == nil ) then
         object.tags.landuse = "military"
      end

      object = append_nonqa( object, "TA centre" )
   end

-- ----------------------------------------------------------------------------
-- Tag military checkpoints as military landuse, if not already.
-- ----------------------------------------------------------------------------
   if ( object.tags["military"] == "checkpoint" ) then
      if ( object.tags['landuse'] == nil ) then
         object.tags.landuse = "military"
      end

      object = append_nonqa( object, "military checkpoint" )
   end

-- ----------------------------------------------------------------------------
-- Tag shooting ranges as military landuse, if not already.
-- ----------------------------------------------------------------------------
   if (( object.tags["hazard"] == "shooting_range" )  or
       ( object.tags["sport"]  == "shooting_range" )) then
      if ( object.tags['landuse'] == nil ) then
         object.tags.landuse = "military"
      end

      object = append_nonqa( object, "shooting range" )
   end


-- ----------------------------------------------------------------------------
-- Nightclubs wouldn't ordinarily be rendered - render them as bar
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"]   == "nightclub"   ) then
      object.tags["amenity"] = "bar"
      object = append_nonqa( object, "nightclub" )
   end


-- ----------------------------------------------------------------------------
-- Render concert hall theatres as concert halls with the nightclub icon
-- ----------------------------------------------------------------------------
   if ((( object.tags["amenity"] == "theatre"      )  and
        ( object.tags["theatre"] == "concert_hall" )) or
       (  object.tags["amenity"] == "music_venue"   )) then
      object.tags["amenity"] = "concert_hall"
      object = append_nonqa( object, "music venue" )
   end

-- ----------------------------------------------------------------------------
-- man_made=embankment and natural=cliff displays as a non-sided cliff 
-- (from z13 for cliff, z17 for embankment, direction is important)
-- man_made=levee displays as a two-sided cliff (from z14).
-- Often it's combined with highway though, and that is handled separately.
-- In that case it's passed through to the stylesheet as bridge=levee.
-- embankment handling is asymmetric for railways currently - it's checked
-- before we apply the "man_made=levee" tag, but "bridge=levee" is not applied.
-- ----------------------------------------------------------------------------
   if ((( object.tags["barrier"]    == "flood_bank"    )  or
        ( object.tags["barrier"]    == "bund"          )  or
        ( object.tags["barrier"]    == "mound"         )  or
        ( object.tags["barrier"]    == "ridge"         )  or
        ( object.tags["barrier"]    == "embankment"    )  or
        ( object.tags["man_made"]   == "dyke"          )  or
        ( object.tags["man_made"]   == "levee"         )  or
        ( object.tags["embankment"] == "yes"           )) and
       (  object.tags["highway"]    == nil              ) and
       (  object.tags["railway"]    == nil              ) and
       (  object.tags["waterway"]   == nil              )) then
      object.tags["man_made"] = "levee"
      object.tags["barrier"] = nil
      object = append_nonqa( object, "embankment" )
   end

-- ----------------------------------------------------------------------------
-- Re the "bridge" check below, we've already changed valid ones to "yes"
-- above.
-- ----------------------------------------------------------------------------
   if (((  object.tags["barrier"]    == "flood_bank"     )  or
        (  object.tags["man_made"]   == "dyke"           )  or
        (  object.tags["man_made"]   == "levee"          )  or
        (  object.tags["embankment"] == "yes"            )) and
       ((  object.tags["highway"]    ~= nil              ) or
        (  object.tags["railway"]    ~= nil              ) or
        (  object.tags["waterway"]   ~= nil              )) and
       (   object.tags["bridge"]     ~= "yes"             ) and
       (   object.tags["tunnel"]     ~= "yes"             )) then
      object = append_nonqa( object, "embankment" )
   end

-- ----------------------------------------------------------------------------
-- map "fences that are really hedges" as fences.
-- ----------------------------------------------------------------------------
   if (( object.tags["barrier"]    == "fence" ) and
       ( object.tags["fence_type"] == "hedge" )) then
      object.tags["barrier"] = "hedge"
   end

-- ----------------------------------------------------------------------------
-- barrier=ditch; handle as waterway=ditch.
-- ----------------------------------------------------------------------------
   if ( object.tags["barrier"] == "ditch" ) then
      object.tags["waterway"] = "ditch"
      object.tags["barrier"]  = nil
   end

-- ----------------------------------------------------------------------------
-- barrier=kissing_gate is handled in the style "points" file.
-- For gates, choose which of the two gate icons to used based on tagging.
-- "sally_port" is mapped to gate largely because of misuse in the data.
-- ----------------------------------------------------------------------------
   if ((  object.tags["barrier"]   == "turnstile"              )  or
       (  object.tags["barrier"]   == "full-height_turnstile"  )  or
       (  object.tags["barrier"]   == "kissing_gate;gate"      )  or
       (( object.tags["barrier"]   == "gate"                  )   and
        ( object.tags["gate"]      == "kissing"               ))) then
      object.tags["barrier"] = "kissing_gate"
   end

-- ----------------------------------------------------------------------------
-- gates
-- ----------------------------------------------------------------------------
   if (( object.tags["barrier"]   == "gate"                  )  or
       ( object.tags["barrier"]   == "swing_gate"            )  or
       ( object.tags["barrier"]   == "footgate"              )  or
       ( object.tags["barrier"]   == "wicket_gate"           )  or
       ( object.tags["barrier"]   == "hampshire_gate"        )  or
       ( object.tags["barrier"]   == "bump_gate"             )  or
       ( object.tags["barrier"]   == "lych_gate"             )  or
       ( object.tags["barrier"]   == "lytch_gate"            )  or
       ( object.tags["barrier"]   == "flood_gate"            )  or
       ( object.tags["barrier"]   == "sally_port"            )  or
       ( object.tags["barrier"]   == "pengate"               )  or
       ( object.tags["barrier"]   == "pengates"              )  or
       ( object.tags["barrier"]   == "gate;stile"            )  or
       ( object.tags["barrier"]   == "cattle_grid;gate"      )  or
       ( object.tags["barrier"]   == "gate;kissing_gate"     )  or
       ( object.tags["barrier"]   == "pull_apart_gate"       )  or
       ( object.tags["barrier"]   == "snow_gate"             )) then
      object.tags["barrier"] = "gate"
   end

-- ----------------------------------------------------------------------------
-- lift gates
-- ----------------------------------------------------------------------------
   if (( object.tags["barrier"] == "border_control"   ) or
       ( object.tags["barrier"] == "ticket_barrier"   ) or
       ( object.tags["barrier"] == "ticket"           ) or
       ( object.tags["barrier"] == "security_control" ) or
       ( object.tags["barrier"] == "checkpoint"       ) or
       ( object.tags["barrier"] == "gatehouse"        )) then
      object.tags["barrier"] = "lift_gate"
   end

-- ----------------------------------------------------------------------------
-- render barrier=bar as barrier=horse_stile (Norfolk)
-- ----------------------------------------------------------------------------
   if ( object.tags["barrier"] == "bar" ) then
      object.tags["barrier"] = "horse_stile"
   end

-- ----------------------------------------------------------------------------
-- render various cycle barrier synonyms
-- ----------------------------------------------------------------------------
   if (( object.tags["barrier"]   == "chicane"               )  or
       ( object.tags["barrier"]   == "squeeze"               )  or
       ( object.tags["barrier"]   == "motorcycle_barrier"    )  or
       ( object.tags["barrier"]   == "horse_barrier"         )  or
       ( object.tags["barrier"]   == "a_frame"               )) then
      object.tags["barrier"] = "cycle_barrier"
   end

-- ----------------------------------------------------------------------------
-- render various synonyms for stile as barrier=stile
-- ----------------------------------------------------------------------------
   if (( object.tags["barrier"]   == "squeeze_stile"   )  or
       ( object.tags["barrier"]   == "ramblers_gate"   )  or
       ( object.tags["barrier"]   == "squeeze_point"   )  or
       ( object.tags["barrier"]   == "step_over"       )  or
       ( object.tags["barrier"]   == "stile;gate"      )) then
      object.tags["barrier"] = "stile"
   end

-- ----------------------------------------------------------------------------
-- Don't show "standing benches" as benches.
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"] == "bench"          ) and
       ( object.tags["bench"]   == "stand_up_bench" )) then
      object.tags["amenity"] = nil
   end

-- ----------------------------------------------------------------------------
-- Ogham stones mapped without other tags
-- ----------------------------------------------------------------------------
   if ( object.tags["historic"]   == "ogham_stone" ) then
      object.tags["man_made"] = "marker"
      object = append_nonqa( object, "ogham stone" )
   end

-- ----------------------------------------------------------------------------
-- Memorial plates
-- ----------------------------------------------------------------------------
   if ((  object.tags["historic"]      == "memorial"  ) and
       (( object.tags["memorial"]      == "plate"    )  or
        ( object.tags["memorial:type"] == "plate"    ))) then
      object.tags["man_made"] = "thing"
      object = append_nonqa( object, "memorial plate" )
   end

-- ----------------------------------------------------------------------------
-- Memorial graves and graveyards
-- ----------------------------------------------------------------------------
   if ((  object.tags["historic"]   == "memorial"     ) and
       (( object.tags["memorial"]   == "grave"       )  or
        ( object.tags["memorial"]   == "graveyard"   ))) then
      object.tags["historic"] = "thing"
      object = append_nonqa( object, "memorial grave" )
   end

-- ----------------------------------------------------------------------------
-- Render shop=newsagent as shop=convenience
-- It's near enough in meaning I think.  Likewise kiosk (bit of a stretch,
-- but nearer than anything else)
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"]   == "newsagent"           ) or
       ( object.tags["shop"]   == "kiosk"               ) or
       ( object.tags["shop"]   == "forecourt"           ) or
       ( object.tags["shop"]   == "food"                ) or
       ( object.tags["shop"]   == "grocery"             ) or
       ( object.tags["shop"]   == "grocer"              ) or
       ( object.tags["shop"]   == "frozen_food"         ) or
       ( object.tags["shop"]   == "convenience;alcohol" )) then
      object.tags["shop"] = "convenience"
   end

-- ----------------------------------------------------------------------------
-- shoe shops
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"] == "shoes"        ) or
       ( object.tags["shop"] == "shoe"         ) or
       ( object.tags["shop"] == "footwear"     )) then
      object.tags["shop"] = "shoes"
   end

-- ----------------------------------------------------------------------------
-- "clothes" consolidation.  "baby_goods" is here because there will surely
-- be some clothes there!
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"] == "fashion"      ) or
       ( object.tags["shop"] == "boutique"     ) or
       ( object.tags["shop"] == "vintage"      ) or
       ( object.tags["shop"] == "bridal"       ) or
       ( object.tags["shop"] == "wedding"      ) or
       ( object.tags["shop"] == "lingerie"     ) or
       ( object.tags["shop"] == "baby_goods"   ) or
       ( object.tags["shop"] == "baby"         ) or
       ( object.tags["shop"] == "dance"        ) or
       ( object.tags["shop"] == "clothes_hire" ) or
       ( object.tags["shop"] == "clothing"     ) or
       ( object.tags["shop"] == "hat"          ) or
       ( object.tags["shop"] == "hats"         ) or
       ( object.tags["shop"] == "wigs"         )) then
      object.tags["shop"] = "clothes"
   end

-- ----------------------------------------------------------------------------
-- "department_store" consolidation.
-- ----------------------------------------------------------------------------
   if ( object.tags["shop"] == "department" ) then
      object.tags["shop"] = "department_store"
   end

-- ----------------------------------------------------------------------------
-- Before potentially using brand or operator as a bracketed suffix after the
-- name, explicitly exclude some "non-brands" - "Independent", etc.
-- ----------------------------------------------------------------------------
   if (( object.tags["brand"]   == "Independent"            ) or
       ( object.tags["brand"]   == "independent"            ) or
       ( object.tags["brand"]   == "Independant"            ) or
       ( object.tags["brand"]   == "independant"            ) or
       ( object.tags["brand"]   == "independant"            ) or
       ( object.tags["brand"]   == "Traditional Free House" )) then
      object.tags["brand"] = nil
   end

   if (( object.tags["operator"]   == "Independent"             ) or
       ( object.tags["operator"]   == "independent"             ) or
       ( object.tags["operator"]   == "Independant"             ) or
       ( object.tags["operator"]   == "independant"             ) or
       ( object.tags["operator"]   == "Free House"              ) or
       ( object.tags["operator"]   == "Free house"              ) or
       ( object.tags["operator"]   == "free house"              ) or
       ( object.tags["operator"]   == "free_house"              ) or
       ( object.tags["operator"]   == "independent free house"  ) or
       ( object.tags["operator"]   == "(free_house)"            )) then
      object.tags["operator"] = nil
   end

-- ----------------------------------------------------------------------------
-- If no name use brand or operator on amenity=fuel, among others.  
-- If there is brand or operator, use that with name.
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"]   == "atm"              ) or
       ( object.tags["amenity"]   == "fuel"             ) or
       ( object.tags["amenity"]   == "charging_station" ) or
       ( object.tags["amenity"]   == "bicycle_rental"   ) or
       ( object.tags["amenity"]   == "scooter_rental"   ) or
       ( object.tags["amenity"]   == "vending_machine"  ) or
       ( object.tags["amenity"]   == "pub"              ) or
       ( object.tags["amenity"]   == "cafe"             ) or
       ( object.tags["amenity"]   == "restaurant"       ) or
       ( object.tags["amenity"]   == "doctors"          ) or
       ( object.tags["amenity"]   == "pharmacy"         ) or
       ( object.tags["amenity"]   == "parcel_locker"    ) or
       ( object.tags["amenity"]   == "veterinary"       ) or
       ( object.tags["amenity"]   == "animal_boarding"  ) or
       ( object.tags["amenity"]   == "cattery"          ) or
       ( object.tags["amenity"]   == "kennels"          ) or
       ( object.tags["amenity"]   == "animal_shelter"   ) or
       ( object.tags["animal"]    == "shelter"          ) or
       ( object.tags["craft"]      ~= nil               ) or
       ( object.tags["emergency"]  ~= nil               ) or
       ( object.tags["industrial"] ~= nil               ) or
       ( object.tags["man_made"]   ~= nil               ) or
       ( object.tags["office"]     ~= nil               ) or
       ( object.tags["shop"]       ~= nil               ) or
       ( object.tags["tourism"]    == "hotel"           ) or
       ( object.tags["military"]   == "barracks"        )) then
      if ( object.tags["name"] == nil ) then
         if ( object.tags["brand"] ~= nil ) then
            object.tags["name"] = object.tags["brand"]
            object.tags["brand"] = nil
         else
            if ( object.tags["operator"] ~= nil ) then
               object.tags["name"] = object.tags["operator"]
               object.tags["operator"] = nil
            end
         end
      else
         if (( object.tags["brand"] ~= nil                )  and
             ( object.tags["brand"] ~= object.tags["name"]  )) then
            object.tags["name"] = object.tags["name"] .. " (" .. object.tags["brand"] .. ")"
            object.tags["brand"] = nil
	 else
            if (( object.tags["operator"] ~= nil                )  and
                ( object.tags["operator"] ~= object.tags["name"]  )) then
               object.tags["name"] = object.tags["name"] .. " (" .. object.tags["operator"] .. ")"
               object.tags["operator"] = nil
            end
         end
      end
   end

-- ----------------------------------------------------------------------------
-- plant_nursery and lawnmower etc. to garden_centre
-- Add unnamedcommercial landuse to give non-building areas a background.
-- Usage suggests shop=nursery means plant_nursery.
-- ----------------------------------------------------------------------------
   if (( object.tags["landuse"] == "plant_nursery"              ) or
       ( object.tags["shop"]    == "plant_nursery"              ) or
       ( object.tags["shop"]    == "plant_centre"               ) or
       ( object.tags["shop"]    == "nursery"                    ) or
       ( object.tags["shop"]    == "lawn_mower"                 ) or
       ( object.tags["shop"]    == "lawnmowers"                 ) or
       ( object.tags["shop"]    == "garden_furniture"           ) or
       ( object.tags["shop"]    == "garden_machinery"           ) or
       ( object.tags["shop"]    == "gardening"                  ) or
       ( object.tags["shop"]    == "garden_equipment"           ) or
       ( object.tags["shop"]    == "garden_tools"               ) or
       ( object.tags["shop"]    == "garden"                     ) or
       ( object.tags["shop"]    == "doityourself;garden_centre" ) or
       ( object.tags["shop"]    == "garden_machines"            )) then
      object.tags["landuse"] = "unnamedcommercial"
      object.tags["shop"]    = "garden_centre"
   end

-- ----------------------------------------------------------------------------
-- Render shop=hardware stores etc. as shop=doityourself
-- Add unnamedcommercial landuse to give non-building areas a background.
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"]    == "hardware"             ) or
       ( object.tags["shop"]    == "tool_hire"            ) or
       ( object.tags["shop"]    == "equipment_hire"       ) or
       ( object.tags["shop"]    == "diy"                  ) or
       ( object.tags["shop"]    == "tools"                ) or
       ( object.tags["shop"]    == "hardware_rental"      ) or
       ( object.tags["shop"]    == "builders_merchant"    ) or
       ( object.tags["shop"]    == "builders_merchants"   ) or
       ( object.tags["shop"]    == "timber"               ) or
       ( object.tags["shop"]    == "fencing"              ) or
       ( object.tags["shop"]    == "plumbers_merchant"    ) or
       ( object.tags["shop"]    == "building_supplies"    ) or
       ( object.tags["shop"]    == "industrial_supplies"  ) or
       ( object.tags["office"]  == "industrial_supplies"  ) or
       ( object.tags["shop"]    == "plant_hire"           ) or
       ( object.tags["amenity"] == "plant_hire;tool_hire" ) or
       ( object.tags["shop"]    == "signs"                ) or
       ( object.tags["shop"]    == "sign"                 ) or
       ( object.tags["shop"]    == "signwriter"           ) or
       ( object.tags["craft"]   == "signmaker"            ) or
       ( object.tags["craft"]   == "roofer"               ) or
       ( object.tags["shop"]    == "roofing"              ) or
       ( object.tags["craft"]   == "floorer"              ) or
       ( object.tags["shop"]    == "building_materials"   )) then
      object.tags["shop"]    = "doityourself"
      object.tags["amenity"] = nil
   end

-- ----------------------------------------------------------------------------
-- hairdresser;beauty
-- ----------------------------------------------------------------------------
   if ( object.tags["shop"] == "hairdresser;beauty" ) then
      object.tags["shop"] = "hairdresser"
   end

-- ----------------------------------------------------------------------------
-- sports
-- the name is usually characteristic, but try and use an icon.
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"]   == "golf"              ) or
       ( object.tags["shop"]   == "scuba_diving"      ) or
       ( object.tags["shop"]   == "water_sports"      ) or
       ( object.tags["shop"]   == "watersports"       ) or
       ( object.tags["shop"]   == "fishing"           ) or
       ( object.tags["shop"]   == "fishing_tackle"    ) or
       ( object.tags["shop"]   == "angling"           ) or
       ( object.tags["shop"]   == "fitness_equipment" )) then
      object.tags["shop"] = "sports"
   end

-- ----------------------------------------------------------------------------
-- Various not-really-clothes things best rendered as clothes shops
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"]    == "tailor"                  ) or
       ( object.tags["craft"]   == "tailor"                  ) or
       ( object.tags["craft"]   == "dressmaker"              )) then
      object.tags["shop"] = "clothes"
   end

-- ----------------------------------------------------------------------------
-- Currently handle beauty salons etc. as just generic beauty.  Also "chemist"
-- Mostly these have names that describe the business, so less need for a
-- specific icon.
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"]         == "beauty_salon"      ) or
       ( object.tags["leisure"]      == "spa"               ) or
       ( object.tags["shop"]         == "spa"               ) or
       ( object.tags["amenity"]      == "spa"               ) or
       ( object.tags["tourism"]      == "spa"               ) or
       (( object.tags["club"]    == "health"               )  and
        ( object.tags["leisure"] == nil                    )  and
        ( object.tags["amenity"] == nil                    )  and
        ( object.tags["name"]    ~= nil                    )) or
       ( object.tags["shop"]         == "salon"             ) or
       ( object.tags["shop"]         == "nails"             ) or
       ( object.tags["shop"]         == "nail_salon"        ) or
       ( object.tags["shop"]         == "nail"              ) or
       ( object.tags["shop"]         == "chemist"           ) or
       ( object.tags["shop"]         == "soap"              ) or
       ( object.tags["shop"]         == "toiletries"        ) or
       ( object.tags["shop"]         == "beauty_products"   ) or
       ( object.tags["shop"]         == "beauty_treatment"  ) or
       ( object.tags["shop"]         == "perfumery"         ) or
       ( object.tags["shop"]         == "cosmetics"         ) or
       ( object.tags["shop"]         == "tanning"           ) or
       ( object.tags["shop"]         == "tan"               ) or
       ( object.tags["shop"]         == "suntan"            ) or
       ( object.tags["leisure"]      == "tanning_salon"     ) or
       ( object.tags["shop"]         == "health_and_beauty" ) or
       ( object.tags["shop"]         == "beautician"        )) then
      object.tags["shop"] = "beauty"
   end

-- ----------------------------------------------------------------------------
-- Computer
-- ----------------------------------------------------------------------------
   if ( object.tags["shop"]  == "computer_repair" ) then
      object.tags["shop"] = "computer"
   end

-- ----------------------------------------------------------------------------
-- Show pastry shops as bakeries
-- ----------------------------------------------------------------------------
   if ( object.tags["shop"] == "pastry" ) then
      object.tags["shop"] = "bakery"
   end

-- ----------------------------------------------------------------------------
-- Other "homeware-like" shops.  These, e.g. chandlery, that are a bit of a
-- stretch get the shopnonspecific icon.
-- Add unnamedcommercial landuse to give non-building areas a background.
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"]   == "upholsterer"                 ) or
       ( object.tags["shop"]   == "chair"                       ) or
       ( object.tags["shop"]   == "luggage"                     ) or
       ( object.tags["shop"]   == "clock"                       ) or
       ( object.tags["shop"]   == "clocks"                      ) or
       ( object.tags["shop"]   == "home_improvement"            ) or
       ( object.tags["shop"]   == "decorating"                  ) or
       ( object.tags["shop"]   == "bed;carpet"                  ) or
       ( object.tags["shop"]   == "country_store"               ) or
       ( object.tags["shop"]   == "equestrian"                  ) or
       ( object.tags["shop"]   == "kitchen"                     ) or
       ( object.tags["shop"]   == "kitchen;bathroom"            ) or
       ( object.tags["shop"]   == "kitchen;bathroom_furnishing" ) or
       ( object.tags["shop"]   == "bedroom"                     ) or
       ( object.tags["shop"]   == "bathroom"                    ) or
       ( object.tags["shop"]   == "glaziery"                    ) or
       ( object.tags["craft"]  == "glaziery"                    ) or
       ( object.tags["shop"]   == "glazier"                     ) or
       ( object.tags["craft"]  == "glazier"                     ) or
       ( object.tags["shop"]   == "glazing"                     ) or
       ( object.tags["shop"]   == "stone"                       ) or
       ( object.tags["shop"]   == "brewing"                     ) or
       ( object.tags["shop"]   == "gates"                       ) or
       ( object.tags["shop"]   == "sheds"                       ) or
       ( object.tags["shop"]   == "shed"                        ) or
       ( object.tags["shop"]   == "ironmonger"                  ) or
       ( object.tags["shop"]   == "furnace"                     ) or
       ( object.tags["shop"]   == "plumbing"                    ) or
       ( object.tags["craft"]  == "plumber"                     ) or
       ( object.tags["craft"]  == "carpenter"                   ) or
       ( object.tags["craft"]  == "decorator"                   ) or
       ( object.tags["shop"]   == "bed"                         ) or
       ( object.tags["shop"]   == "beds"                        ) or
       ( object.tags["shop"]   == "mattress"                    ) or
       ( object.tags["shop"]   == "waterbed"                    ) or
       ( object.tags["shop"]   == "glass"                       ) or
       ( object.tags["shop"]   == "garage"                      ) or
       ( object.tags["shop"]   == "conservatory"                ) or
       ( object.tags["shop"]   == "conservatories"              ) or
       ( object.tags["shop"]   == "bathrooms"                   ) or
       ( object.tags["shop"]   == "swimming_pool"               ) or
       ( object.tags["shop"]   == "fitted_furniture"            ) or
       ( object.tags["shop"]   == "upholstery"                  ) or
       ( object.tags["shop"]   == "chandler"                    ) or
       ( object.tags["shop"]   == "chandlers"                   ) or
       ( object.tags["shop"]   == "chandlery"                   ) or
       ( object.tags["shop"]   == "ship_chandler"               ) or
       ( object.tags["craft"]  == "boatbuilder"                 ) or
       ( object.tags["shop"]   == "saddlery"                    )) then
      object.tags["shop"] = "furniture"
   end

-- ----------------------------------------------------------------------------
-- Car parts
-- ----------------------------------------------------------------------------
   if ((( object.tags["shop"]    == "trade"                       )  and
        ( object.tags["trade"]   == "car_parts"                   )) or
       (  object.tags["shop"]    == "car_accessories"              )  or
       (  object.tags["shop"]    == "tyres"                        )  or
       (  object.tags["shop"]    == "automotive"                   )  or
       (  object.tags["shop"]    == "battery"                      )  or
       (  object.tags["shop"]    == "batteries"                    )  or
       (  object.tags["shop"]    == "number_plate"                 )  or
       (  object.tags["shop"]    == "number_plates"                )  or
       (  object.tags["shop"]    == "license_plates"               )  or
       (  object.tags["shop"]    == "car_audio"                    )  or
       (  object.tags["shop"]    == "motor"                        )  or
       (  object.tags["shop"]    == "motoring"                     )  or
       (  object.tags["shop"]    == "motor_spares"                 )  or
       (  object.tags["shop"]    == "motor_accessories"            )  or
       (  object.tags["shop"]    == "car_parts;car_repair"         )  or
       (  object.tags["shop"]    == "bicycle;car_parts"            )  or
       (  object.tags["shop"]    == "car_parts;bicycle"            )) then
      object.tags["shop"] = "car_parts"
   end

-- ----------------------------------------------------------------------------
-- If a quarry is disused, it's still likely a hole in the ground, so render it
-- ----------------------------------------------------------------------------
   if (( object.tags["disused:landuse"] == "quarry" ) and
       ( object.tags["landuse"]         == nil      )) then
      object.tags["landuse"] = "quarry"
   end

-- ----------------------------------------------------------------------------
-- Masts etc.  Consolidate various sorts of masts and towers into the "mast"
-- group.  Note that this includes "tower" temporarily, and "campanile" is in 
-- here as a sort of tower (only 2 mapped in UK currently).
-- Also remove any "tourism" tags (which may be semi-valid mapping but are
-- often just "for the renderer").
-- ----------------------------------------------------------------------------
   if ((  object.tags["man_made"]  == "tower"   )  and
       ( object.tags["tower:type"] == "chimney" )) then
      object.tags["man_made"] = "tower"
      object.tags["tourism"] = nil
      object = append_nonqa( object, "chimney" )
   end

   if (( object.tags["man_made"]   == "tower"   )  and
       ( object.tags["tower:type"] == "cooling" )) then
      object.tags["man_made"] = "tower"
      object.tags["tourism"] = nil
      object = append_nonqa( object, "cooling tower" )
   end

   if (( object.tags["man_made"]   == "tower"    ) and
       ( object.tags["tower:type"] == "lighting" )) then
      object.tags["man_made"] = "thing"
      object.tags["tourism"] = nil
      object = append_nonqa( object, "illumination tower" )
   end

   if ((   object.tags["man_made"]           == "tower"       ) and
       ((  object.tags["tower:type"]         == "defensive"  )  or
        (( object.tags["tower:type"]         == nil         )   and
         ( object.tags["tower:construction"] == "stone"     )))) then
      object.tags["man_made"] = "thing"
      object.tags["tourism"] = nil
      object = append_nonqa( object, "defensive tower" )
   end

   if (( object.tags["man_made"]   == "tower"       ) and
       ( object.tags["tower:type"] == "observation" )) then
      object.tags["man_made"] = "thing"
      object.tags["tourism"] = nil
      object = append_nonqa( object, "observation tower" )
   end

-- ----------------------------------------------------------------------------
-- Concatenate a couple of names for bus stops so that the most useful ones
-- are displayed.
-- ----------------------------------------------------------------------------
   if ( object.tags["highway"] == "bus_stop" ) then
      if (( object.tags["name"]             ~= nil ) and
          ( object.tags["naptan:Indicator"] ~= nil )) then
         object.tags["name"] = object.tags["name"] .. " " .. object.tags["naptan:Indicator"]
      end
   end

-- ----------------------------------------------------------------------------
-- Some people tag waste_basket on bus_stop.  We render just bus_stop.
-- ----------------------------------------------------------------------------
   if (( object.tags["highway"] == "bus_stop"     ) and
       ( object.tags["amenity"] == "waste_basket" )) then
      object.tags["amenity"] = nil
   end

-- ----------------------------------------------------------------------------
-- Remove icon for public transport and animal field shelters and render as
-- "roof" (if they are a way).
-- "roof" isn't rendered for nodes, so this has the effect of suppressing
-- public_transport shelters and shopping_cart shelters on nodes.
-- shopping_cart, parking and animal_shelter aren't really a "shelter" type 
-- that we are interested in (for humans).  There are no field or parking 
-- shelters on nodes in GB/IE.
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"]      == "shelter"            ) and
       (( object.tags["shelter_type"] == "public_transport" )  or
        ( object.tags["shelter_type"] == "field_shelter"    )  or
        ( object.tags["shelter_type"] == "shopping_cart"    )  or
        ( object.tags["shelter_type"] == "trolley_park"     )  or
        ( object.tags["shelter_type"] == "parking"          )  or
        ( object.tags["shelter_type"] == "animal_shelter"   ))) then
      object.tags["amenity"] = nil
      if ( object.tags["building"] == nil ) then
         object.tags["building"] = "roof"
      end
   end

  if (( object.tags["amenity"]      == "shelter"            ) and
      ( object.tags["shelter_type"] == "bicycle_parking"    )) then
      object.tags["amenity"] = "bicycle_parking"
      if ( object.tags["building"] == nil ) then
         object.tags["building"] = "roof"
      end
   end

-- ----------------------------------------------------------------------------
-- Drop some highway areas - "track" etc. areas wherever I have seen them are 
-- garbage.
-- "footway" (pedestrian areas) and "service" (e.g. petrol station forecourts)
-- tend to be OK.  Other options tend not to occur.
-- ----------------------------------------------------------------------------
   if ((( object.tags["highway"] == "track"          )  or
        ( object.tags["highway"] == "leisuretrack"   )  or
        ( object.tags["highway"] == "gallop"         )  or
        ( object.tags["highway"] == "residential"    )  or
        ( object.tags["highway"] == "unclassified"   )  or
        ( object.tags["highway"] == "tertiary"       )) and
       (  object.tags["area"]    == "yes"             )) then
      object.tags["highway"] = nil
   end

-- ----------------------------------------------------------------------------
-- addr:unit
-- ----------------------------------------------------------------------------
   if ( object.tags["addr:unit"] ~= nil ) then
      if ( object.tags["addr:housenumber"] ~= nil ) then
         object.tags["addr:housenumber"] = object.tags["addr:unit"] .. ", " .. object.tags["addr:housenumber"]
      else
         object.tags["addr:housenumber"] = object.tags["addr:unit"]
      end
   end

-- ----------------------------------------------------------------------------
-- Climbing features (boulders, stones, etc.)
-- Deliberately only use this for outdoor features that would not otherwise
-- display, so not cliffs etc.
-- ----------------------------------------------------------------------------
   if (( object.tags["sport"]    == "climbing"      ) and
       ( object.tags["natural"]  ~= "peak"          ) and
       ( object.tags["natural"]  ~= "cliff"         ) and
       ( object.tags["leisure"]  ~= "sports_centre" ) and
       ( object.tags["leisure"]  ~= "climbing_wall" ) and
       ( object.tags["shop"]     ~= "sports"        ) and
       ( object.tags["tourism"]  ~= "attraction"    ) and
       ( object.tags["building"] == nil             ) and
       ( object.tags["man_made"] ~= "tower"         ) and
       ( object.tags["barrier"]  ~= "wall"          )) then
      object.tags["man_made"] = "thing"
      object = append_nonqa( object, "climbing" )
   end

-- ----------------------------------------------------------------------------
-- Quality Control tagging on all objects
-- Append something to end of name for fixme tags
-- ----------------------------------------------------------------------------
    if (( object.tags['fixme'] ~= nil  ) or
        ( object.tags['FIXME'] ~= nil  )) then
        if ( object.tags['name'] == nil ) then
            object.tags.name = '[fix]'
        else
            object.tags.name = object.tags['name'] .. ' [fix]'
        end
    end

    return object
end


-- ----------------------------------------------------------------------------
-- "node" function
-- ----------------------------------------------------------------------------
function ott.process_node(object)
    object = process_all(object)

-- ----------------------------------------------------------------------------
-- Render amenity=information as tourism
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "information"  ) then
      object.tags["tourism"] = "information"
   end

-- ----------------------------------------------------------------------------
-- Various types of information
-- ----------------------------------------------------------------------------
   if ((   object.tags["amenity"]     == "notice_board" )  or
       (   object.tags["tourism"]     == "village_sign" )  or
       (   object.tags["man_made"]    == "village_sign" )) then
      object.tags["tourism"]     = "information"
      object.tags["information"] = "board"
   end

   if ((  object.tags["amenity"]     == "notice_board"       )  or
       (  object.tags["tourism"]     == "sign"               )  or
       (  object.tags["emergency"]   == "beach_safety_sign"  )) then
      object.tags["tourism"]     = "information"
      object.tags["information"] = "sign"
   end

   if (( object.tags["tourism"]     == "information" )  and
       ( object.tags["name"]        == nil           )  and
       ( object.tags["board:title"] ~= nil           )) then
      object.tags["name"] = object.tags["board:title"]
   end

-- ----------------------------------------------------------------------------
-- NCN Route markers
-- ----------------------------------------------------------------------------
   if ( object.tags["ncn_milepost"] == "dudgeon" ) then
      object.tags["tourism"] = "information"

      if ( object.tags["sustrans_ref"] == nil ) then
         object.tags["name"]    = "NCN Dudgeon"
      else
         object.tags["name"]    = "NCN Dudgeon " .. object.tags["sustrans_ref"]
      end
   end

   if ( object.tags["ncn_milepost"] == "mccoll" ) then
      object.tags["tourism"] = "information"

      if ( object.tags["sustrans_ref"] == nil ) then
         object.tags["name"]    = "NCN McColl"
      else
         object.tags["name"]    = "NCN McColl " .. object.tags["sustrans_ref"]
      end
   end

   if ( object.tags["ncn_milepost"] == "mills" ) then
      object.tags["tourism"] = "information"

      if ( object.tags["sustrans_ref"] == nil ) then
         object.tags["name"]    = "NCN Mills"
      else
         object.tags["name"]    = "NCN Mills " .. object.tags["sustrans_ref"]
      end
   end

   if ( object.tags["ncn_milepost"] == "rowe" ) then
      object.tags["tourism"] = "information"

      if ( object.tags["sustrans_ref"] == nil ) then
         object.tags["name"]    = "NCN Rowe"
      else
         object.tags["name"]    = "NCN Rowe " .. object.tags["sustrans_ref"]
      end
   end

   if (( object.tags["ncn_milepost"] == "unknown" )  or
       ( object.tags["ncn_milepost"] == "yes"     )) then
      object.tags["tourism"] = "information"

      if ( object.tags["sustrans_ref"] == nil ) then
         object.tags["name"]    = "NCN"
      else
         object.tags["name"]    = "NCN " .. object.tags["sustrans_ref"]
      end
   end

-- ----------------------------------------------------------------------------
-- Information guideposts, route markers, boards
-- ----------------------------------------------------------------------------
   information_appendix = ''

   if ( object.tags["tourism"] == "information" ) then
      if (( object.tags["information"] == "guidepost"                        )   or
          ( object.tags["information"] == "fingerpost"                       )   or
          ( object.tags["information"] == "marker"                           )) then
         information_appendix = 'GP'
      end

      if (( object.tags["information"] == "route_marker"                     )  or
          ( object.tags["information"] == "trail_blaze"                      )) then
         information_appendix = 'RM'
      end

      if (( object.tags["information"] == "board"                            )  or
          ( object.tags["information"] == "map"                              )  or
          ( object.tags["information"] == "terminal"                         )  or
          ( object.tags["information"] == "nature"                           )  or
          ( object.tags["information"] == "noticeboard"                      )  or
          ( object.tags["information"] == "map_board"                        )  or
          ( object.tags["information"] == "wildlife"                         )  or
          ( object.tags["information"] == "sitemap"                          )  or
          ( object.tags["information"] == "notice_board"                     )  or
          ( object.tags["information"] == "tactile_map"                      )  or
          ( object.tags["information"] == "electronic_board"                 )  or
          ( object.tags["information"] == "hikingmap"                        )  or
          ( object.tags["information"] == "interpretation"                   )  or
          ( object.tags["information"] == "map;board"                        )  or
          ( object.tags["information"] == "former_telephone_box"             )  or
          ( object.tags["information"] == "leaflets"                         )  or
          ( object.tags["information"] == "departure times and destinations" )  or
          ( object.tags["information"] == "sitemap"                          )  or
          ( object.tags["information"] == "notice_board"                     )  or
          ( object.tags["information"] == "tactile_map"                      )  or
          ( object.tags["information"] == "electronic_board"                 )  or
          ( object.tags["information"] == "hikingmap"                        )  or
          ( object.tags["information"] == "interpretation"                   )  or
          ( object.tags["information"] == "map;board"                        )  or
          ( object.tags["information"] == "former_telephone_box"             )  or
          ( object.tags["information"] == "leaflets"                         )  or
          ( object.tags["information"] == "departure times and destinations" )  or
          ( object.tags["information"] == "board;map"                        )) then
         information_appendix = 'B'
      end

      if ( object.tags["information"] == "sign" ) then
         information_appendix = 'S'
      end

      if (( object.tags["operator"]  == "Peak & Northern Footpaths Society"                                )  or
          ( object.tags["operator"]  == "Peak and Northern Footpaths Society"                              )  or
          ( object.tags["operator"]  == "Peak District & Northern Counties Footpaths Preservation Sciety"  ) or
          ( object.tags["operator"]  == "Peak District & Northern Counties Footpaths Preservation Society" )) then
         if ( information_appendix == nil ) then
             information_appendix = 'PNFS'
         else
             information_appendix = information_appendix .. ' PNFS'
         end
      end

      if ( object.tags["operator:type"] == "military" ) then
         if ( information_appendix == nil ) then
             information_appendix = 'MIL'
         else
             information_appendix = information_appendix .. ' MIL'
         end
      end

      if ( object.tags["guide_type"] == "intermediary" ) then
         if ( information_appendix == nil ) then
             information_appendix = 'INT'
         else
             information_appendix = information_appendix .. ' INT'
         end
      end

      if ( object.tags["guide_type"] == "destination" ) then
         if ( information_appendix == nil ) then
             information_appendix = 'DEST'
         else
             information_appendix = information_appendix .. ' DEST'
         end
      end

      if ( object.tags["guidepost_type"] == "PROW" ) then
         if ( information_appendix == nil ) then
             information_appendix = 'PROW'
         else
             information_appendix = information_appendix .. ' PROW'
         end
      end

      if ( object.tags["guidepost_type"] == "route_marker" ) then
         if ( information_appendix == nil ) then
             information_appendix = 'ROUTE'
         else
             information_appendix = information_appendix .. ' ROUTE'
         end
      end

      if ( object.tags["guidepost_type"] == "route_marker;PROW" ) then
         if ( information_appendix == nil ) then
             information_appendix = 'ROUTE PROW'
         else
             information_appendix = information_appendix .. ' ROUTE PROW'
         end
      end
   end

   if ( information_appendix ~= '' ) then
      object = append_nonqa( object, information_appendix )
   end

   if ((  object.tags["tourism"]     == "information"                       )  and
       (( object.tags["information"] == "office"                           )   or
        ( object.tags["information"] == "kiosk"                            )   or
        ( object.tags["information"] == "visitor_centre"                   ))) then
      object.tags["office"] = "yes"
      object = append_nonqa( object, "info" )
   end

   if (( object.tags["tourism"]     == "information"                       )  and
       ( object.tags["information"] == "audioguide"                        )) then
      object.tags["man_made"] = "thing"
      object = append_nonqa( object, "audio" )
   end

-- ----------------------------------------------------------------------------
-- Point weirs are sent through as points with a name of "weir"
-- ----------------------------------------------------------------------------
   if ( object.tags['waterway'] == 'weir' ) then
      object.tags["man_made"] = "thing"
      object.tags["waterway"] = nil
      object = append_nonqa( object, "weir" )
   end

   return object.tags
end


-- ----------------------------------------------------------------------------
-- "way" function
-- ----------------------------------------------------------------------------
function ott.process_way(object)
    object = process_all(object)

-- ----------------------------------------------------------------------------
-- From style.lua
--
-- Before processing footways, turn certain corridors into footways
--
-- Note that https://wiki.openstreetmap.org/wiki/Key:indoor defines
-- indoor=corridor as a closed way.  highway=corridor is not documented there
-- but is used for corridors.  We'll only process layer or level 0 (or nil)
-- ----------------------------------------------------------------------------
    if (( object.tags['highway'] == 'corridor'  ) and
        (( object.tags["level"]  == nil         )  or
         ( object.tags["level"]  == "0"         )) and
        (( object.tags["layer"]  == nil         )  or
         ( object.tags["layer"]  == "0"         ))) then
       object.tags["highway"] = "path"
   end

-- ----------------------------------------------------------------------------
-- Different names on each side of the street
-- ----------------------------------------------------------------------------
   if (( object.tags["name:left"]  ~= nil ) and
       ( object.tags["name:right"] ~= nil )) then
      object.tags["name"] = object.tags["name:left"] .. " / " .. object.tags["name:right"]
   end

-- ----------------------------------------------------------------------------
-- If name does not exist but name:en does, use it.
-- ----------------------------------------------------------------------------
   if (( object.tags["name"]    == nil ) and
       ( object.tags["name:en"] ~= nil )) then
      object.tags["name"] = object.tags["name:en"]
   end

-- ----------------------------------------------------------------------------
-- Consolidate some rare highway types into track
--
-- The "bywayness" of something should be handled by designation now.  byway
-- isn't otherwise shown (and really should no longer be used), so change 
-- to track (which is what it probably will be).
--
-- "gallop" makes sense as a tag (it really isn't like anything else), but for
-- our purposes change to "track".  "unsurfaced" makes less sense; change to
-- "track" also.
--
-- "track" will be changed into something else lower down 
-- (path, pathwide or track_graded).
-- ----------------------------------------------------------------------------
   if (( object.tags["golf"]    == "track"     )  and
       ( object.tags["highway"] == nil         )) then
      object.tags["highway"] = "track"
   end

   if ((  object.tags["golf"]    == "path"       ) and
       (( object.tags["highway"] == nil         )  or
        ( object.tags["highway"] == "service"   ))) then
      object.tags["highway"] = "path"
   end

   if ((  object.tags["golf"]    == "cartpath"   ) and
       (( object.tags["highway"] == nil         )  or
        ( object.tags["highway"] == "service"   ))) then
      object.tags["highway"] = "track"
   end

-- ----------------------------------------------------------------------------
-- Where a wide width is specified on a normally narrow path, show as wider
--
-- Note that "steps" and "footwaysteps" are unchanged by the 
-- track / path choice below:
-- ----------------------------------------------------------------------------
   if (( object.tags["highway"] == "footway"   ) or 
       ( object.tags["highway"] == "bridleway" ) or 
       ( object.tags["highway"] == "cycleway"  ) or
       ( object.tags["highway"] == "path"      )) then
      if ((( tonumber(object.tags["width"]) or 0 ) >=  2 ) or
          ( object.tags["width"] == "2 m"                ) or
          ( object.tags["width"] == "2.5 m"              ) or
          ( object.tags["width"] == "3 m"                ) or
          ( object.tags["width"] == "4 m"                )) then
         object.tags["highway"] = "track"
      else
         object.tags["highway"] = "path"
      end
   end

-- ----------------------------------------------------------------------------
-- Where a narrow width is specified on a normally wide track, show as
-- narrower
-- ----------------------------------------------------------------------------
   if ( object.tags["highway"] == "track" ) then
      if ( object.tags["width"] == nil ) then
         object.tags["width"] = "2"
      end
      if ((( tonumber(object.tags["width"]) or 0 ) >= 2 ) or
          (  object.tags["width"] == "2 m"              ) or
          (  object.tags["width"] == "2.5 m"            ) or
          (  object.tags["width"] == "2.5m"             ) or
          (  object.tags["width"] == "3 m"              ) or
          (  object.tags["width"] == "3 metres"         ) or
          (  object.tags["width"] == "3.5 m"            ) or
          (  object.tags["width"] == "4 m"              ) or
          (  object.tags["width"] == "5m"               )) then
         object.tags["highway"] = "track"
      else
         object.tags["highway"] = "path"
      end
   end

-- ----------------------------------------------------------------------------
-- Handle dodgy access tags.  Note that this doesn't affect my "designation"
-- processing, but may be used by the main style, as "foot", "bicycle" and 
-- "horse" are all in as columns.
-- ----------------------------------------------------------------------------
   if (object.tags["access:foot"] == "yes") then
      object.tags["access:foot"] = nil
      object.tags["foot"] = "yes"
   end

   if (object.tags["access:bicycle"] == "yes") then
      object.tags["access:bicycle"] = nil
      object.tags["bicycle"] = "yes"
   end

   if (object.tags["access:horse"] == "yes") then
      object.tags["access:horse"] = nil
      object.tags["horse"] = "yes"
   end

-- ----------------------------------------------------------------------------
-- When handling TROs etc. we test for "no", not private, hence this change:
-- ----------------------------------------------------------------------------
   if ( object.tags["access"] == "private" ) then
      object.tags["access"] = "no"
   end

   if ( object.tags["foot"] == "private" ) then
      object.tags["foot"] = "no"
   end

   if ( object.tags["bicycle"] == "private" ) then
      object.tags["bicycle"] = "no"
   end

   if ( object.tags["horse"] == "private" ) then
      object.tags["horse"] = "no"
   end

-- ----------------------------------------------------------------------------
-- The extra information "and"ed with "public_footpath" below checks that
-- "It's access=private and designation=public_footpath, and ordinarily we'd
-- just remove the access=private tag as you ought to be able to walk there,
-- unless there isn't foot=yes/designated to say you can, or there is an 
-- explicit foot=no".
-- ----------------------------------------------------------------------------
   if (((   object.tags["access"]      == "no"                          )  or
        (   object.tags["access"]      == "destination"                 )) and
       (((( object.tags["designation"] == "public_footpath"           )    or
          ( object.tags["designation"] == "public_bridleway"          )    or
          ( object.tags["designation"] == "restricted_byway"          )    or
          ( object.tags["designation"] == "byway_open_to_all_traffic" )    or
          ( object.tags["designation"] == "unclassified_county_road"  )    or
          ( object.tags["designation"] == "unclassified_country_road" )    or
          ( object.tags["designation"] == "unclassified_highway"      ))   and
         (  object.tags["foot"]        ~= nil                          )   and
         (  object.tags["foot"]        ~= "no"                         ))  or
        ((( object.tags["highway"]     == "footway"                   )    or
          ( object.tags["highway"]     == "bridleway"                 )    or
          ( object.tags["highway"]     == "cycleway"                  )    or
          ( object.tags["highway"]     == "path"                      )    or
          ( object.tags["highway"]     == "track"                     )    or
          ( object.tags["highway"]     == "service"                   ))   and
         (( object.tags["foot"]        == "permissive"                )    or
          ( object.tags["foot"]        == "yes"                       ))))) then
      object.tags["access"]  = nil
   end

-- ----------------------------------------------------------------------------
-- Show narrow tertiary roads as unclassified
-- ----------------------------------------------------------------------------
   if (( object.tags["highway"]    == "tertiary"   )  and
       ( object.tags["oneway"]     == nil          )  and
       ((( tonumber(object.tags["width"])    or 4 ) <=  3 ) or
        (( tonumber(object.tags["maxwidth"]) or 4 ) <=  3 ))) then
      object.tags["highway"] = "unclassified"
   end

-- ----------------------------------------------------------------------------
-- Show bus-only service roads tagged as "highway=busway" as service roads.
-- ----------------------------------------------------------------------------
   if (object.tags["highway"] == "busway") then
      object.tags["highway"] = "service"
   end

-- ----------------------------------------------------------------------------
-- Remove name from footway=sidewalk (we expect it to be shown via the
-- road that this is a sidewalk for), or "is_sidepath=yes".
-- ----------------------------------------------------------------------------
   if ((( object.tags["footway"]     == "sidewalk" )  or
        ( object.tags["cycleway"]    == "sidewalk" )  or
	( object.tags["cycleway"]    == "sidepath" )  or
        ( object.tags["is_sidepath"] == "yes"      )) and
       (  object.tags["name"]    ~= nil             )) then
      object.tags["name"] = nil
   end

-- ----------------------------------------------------------------------------
-- Tunnel values - show as "yes" if appropriate.
-- ----------------------------------------------------------------------------
   if (( object.tags["tunnel"] == "culvert"             ) or
       ( object.tags["tunnel"] == "covered"             ) or
       ( object.tags["tunnel"] == "avalanche_protector" ) or
       ( object.tags["tunnel"] == "passage"             ) or
       ( object.tags["tunnel"] == "1"                   ) or
       ( object.tags["tunnel"] == "cave"                ) or
       ( object.tags["tunnel"] == "flooded"             )) then
      object.tags["tunnel"] = "yes"
   end

-- ----------------------------------------------------------------------------
-- Display "location=underground" waterways as tunnels.
--
-- There are currently no "location=overground" waterways that are not
-- also "man_made=pipeline".
-- ----------------------------------------------------------------------------
   if (( object.tags["waterway"] ~= nil           )  and
       ( object.tags["location"] == "underground" ) and
       ( object.tags["tunnel"]   == nil           )) then
      object.tags["tunnel"] = "yes"
   end

-- ----------------------------------------------------------------------------
-- Don't show subsurface waterways
-- ----------------------------------------------------------------------------
   if (( object.tags["waterway"] ~= nil   ) and
       ( object.tags["tunnel"]   == "yes" )) then
      object.tags["waterway"] = nil
   end

-- ----------------------------------------------------------------------------
-- Designation tagging on ways
-- ----------------------------------------------------------------------------
   designation_appendix = ''

   if (( object.tags['designation'] == 'public_footpath'  ) or
       ( object.tags['designation'] == 'footpath'         )) then
      designation_appendix = 'PF'
   end

   if ( object.tags['designation'] == 'core_path'  ) then
      designation_appendix = 'CP'
   end

   if (( object.tags['designation'] == 'public_bridleway' ) or
       ( object.tags['designation'] == 'bridleway'        )) then
      designation_appendix = 'PB'
   end

   if (( object.tags['designation'] == 'restricted_byway'    ) or
       ( object.tags['designation'] == 'public_right_of_way' )) then
      designation_appendix = 'RB'
   end

   if (( object.tags['designation'] == 'byway_open_to_all_traffic'  ) or
       ( object.tags['designation'] == 'public_byway'               ) or
       ( object.tags['designation'] == 'byway'                      )) then
      designation_appendix = 'BY'
   end

   if (( object.tags['designation'] == 'quiet_lane'                      ) or
       ( object.tags['designation'] == 'quiet_lane;unclassified_highway' ) or
       ( object.tags['designation'] == 'unclassified_highway;quiet_lane' ) or
       ( object.tags['designation'] == 'restricted_byway;quiet_lane'     )) then
      if ( designation_appendix == '' ) then
         designation_appendix = 'QL'
      else
         object.tags.name = designation_appendix .. ' QL'
      end
   end

   if ( designation_appendix ~= '' ) then
      object = append_nonqa( object, designation_appendix )
   end

-- ----------------------------------------------------------------------------
-- End Designation tagging on ways
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- Informal footway-service
-- ----------------------------------------------------------------------------
   if ((( object.tags['highway']  == 'footway'   ) or
         ( object.tags['highway']  == 'path'      ) or
         ( object.tags['highway']  == 'steps'     ) or
         ( object.tags['highway']  == 'bridleway' ) or
         ( object.tags['highway']  == 'cycleway'  ) or
         ( object.tags['highway']  == 'track'     ) or
         ( object.tags['highway']  == 'service'   )) and
        (  object.tags['informal'] == 'yes'        )) then
      object = append_nonqa( object, "I" )
   end

-- ----------------------------------------------------------------------------
-- Fence, hedge, wall
-- ----------------------------------------------------------------------------
   if ( object.tags['barrier'] == 'fence' ) then
      object = append_nonqa( object, "fence" )
   end

   if ( object.tags['barrier'] == 'hedge' ) then
      object = append_nonqa( object, "hedge" )
   end

-- ----------------------------------------------------------------------------
-- Show castle_wall and citywalls as walls with a "city wall" suffix,
-- and regular walls with "wall".
-- ----------------------------------------------------------------------------
   if ( object.tags["barrier"] == "wall" ) then
      if ( object.tags["wall"] == "castle_wall" ) then
         object = append_nonqa( object, "castle wall" )
      else
         object = append_nonqa( object, "wall" )
      end
   end

   if ( object.tags["historic"] == "citywalls" ) then
      object.tags["barrier"] = "wall"
      object = append_nonqa( object, "city wall" )
   end

   if ( object.tags['natural'] == 'tree_row' ) then
      object = append_nonqa( object, "tree row" )
   end

-- ----------------------------------------------------------------------------
-- Linear weirs are sent through as "county lines" with a name of "weir"
-- Likewise floating barriers.
-- ----------------------------------------------------------------------------
   if ( object.tags['waterway'] == 'weir' ) then
      object.tags["barrier"] = "wall"
      object.tags["waterway"] = nil
      object = append_nonqa( object, "weir" )
   end

   if ( object.tags['waterway'] == 'floating_barrier' ) then
      object.tags["barrier"] = "wall"
      object.tags["waterway"] = nil
      object = append_nonqa( object, "floating barrier" )
   end

-- ----------------------------------------------------------------------------
-- Display "waterway=leat" and "waterway=spillway" etc. as drain.
-- man_made=spillway tends to be used on areas, hence show as natural=water.
-- ----------------------------------------------------------------------------
   if ( object.tags["waterway"] == "leat" )  then
      object.tags["waterway"] = "drain"
      object = append_nonqa( object, "leat" )
   end

   if ( object.tags["waterway"] == "spillway" )  then
      object.tags["waterway"] = "drain"
      object = append_nonqa( object, "spillway" )
   end

   if ( object.tags["waterway"] == "aqueduct" )  then
      object.tags["waterway"] = "drain"
      object = append_nonqa( object, "aqueduct" )
   end

   if ( object.tags["waterway"] == "fish_pass" )  then
      object.tags["waterway"] = "drain"
      object = append_nonqa( object, "fish pass" )
   end

   if ((  object.tags["waterway"] == "canal"      )  and
       (( object.tags["usage"]    == "headrace"  )   or
        ( object.tags["usage"]    == "spillway"  ))) then
      object.tags["waterway"] = "drain"
      object = append_nonqa( object, "canal" )
   end

   if ( object.tags["man_made"] == "spillway" ) then
      object.tags["natural"] = "water"
      object.tags["man_made"] = nil
      object = append_nonqa( object, "spillway" )
   end

-- ----------------------------------------------------------------------------
-- Apparently there are a few "waterway=brook" in the UK.  Render as stream.
-- ----------------------------------------------------------------------------
   if ( object.tags["waterway"] == "brook" ) then
      object.tags["waterway"] = "stream"
   end

-- ----------------------------------------------------------------------------
-- Quality Control tagging on ways
--
-- Append M to roads if no speed limit defined
-- Append L if not known if lit
-- Append S if not known if sidewalk
-- Append V no sidewalk, but not known if verge
-- ----------------------------------------------------------------------------
    street_appendix = ''

    if (( object.tags['highway'] == 'unclassified'  ) or
        ( object.tags['highway'] == 'living_street' ) or
        ( object.tags['highway'] == 'residential'   ) or
        ( object.tags['highway'] == 'tertiary'      ) or
        ( object.tags['highway'] == 'secondary'     ) or
        ( object.tags['highway'] == 'primary'       ) or
        ( object.tags['highway'] == 'trunk'         )) then
        if ( object.tags['maxspeed'] == nil ) then
            street_appendix = 'M'
        end
    end

    if (( object.tags['highway'] == 'unclassified'  ) or
        ( object.tags['highway'] == 'living_street' ) or
        ( object.tags['highway'] == 'residential'   ) or
        ( object.tags['highway'] == 'service'       ) or
        ( object.tags['highway'] == 'tertiary'      ) or
        ( object.tags['highway'] == 'secondary'     ) or
        ( object.tags['highway'] == 'primary'       ) or
        ( object.tags['highway'] == 'trunk'         )) then
        if ( object.tags['lit'] == nil ) then
            if ( street_appendix == nil ) then
                street_appendix = 'L'
            else
                street_appendix = street_appendix .. 'L'
            end
        end

        if ( object.tags['sidewalk'] == nil ) then
            if ( object.tags['verge'] == nil ) then
                if ( street_appendix == nil ) then
                    street_appendix = 'S'
                else
                    street_appendix = street_appendix .. 'S'
                end
            end
        else
            if (( object.tags['sidewalk'] == 'no'   ) or
                ( object.tags['sidewalk'] == 'none' )) then
                if ( object.tags['verge'] == nil ) then
                    if ( street_appendix == nil ) then
                        street_appendix = 'V'
                    else
                        street_appendix = street_appendix .. 'V'
                    end
                end
            end
        end
    end

    if ( street_appendix ~= '' ) then
        if ( object.tags['name'] == nil ) then
            object.tags.name = '[' .. street_appendix .. ']'
        else
            object.tags.name = object.tags['name'] .. ' [' .. street_appendix .. ']'
        end
    end

-- ----------------------------------------------------------------------------
-- Append (RD) to roads tagged as highway=road
-- ----------------------------------------------------------------------------
    if ( object.tags['highway'] == 'road'  ) then
        if ( object.tags['name'] == nil ) then
            object.tags.name = '[RD]'
        else
            object.tags.name = object.tags['name'] .. ' [RD]'
        end
    end


-- ----------------------------------------------------------------------------
-- QA for footway-bridleway
-- ----------------------------------------------------------------------------
    if (( object.tags['highway'] == 'footway'   ) or
        ( object.tags['highway'] == 'path'      ) or
        ( object.tags['highway'] == 'bridleway' )) then
-- ----------------------------------------------------------------------------
-- Append (A) if an expected foot tag is missing 
-- on things that aren't obviously sidewalks
-- ----------------------------------------------------------------------------
        if (( object.tags['foot']     == nil        ) and
            ( object.tags['footway']  ~= 'sidewalk' ) and
            ( object.tags['cycleway'] ~= 'sidewalk' ) and
            ( object.tags['path']     ~= 'sidewalk' ) and
            ( object.tags['informal'] ~= 'yes'      )) then
            if ( object.tags['name'] == nil ) then
                object.tags.name = '[A]'
            else
                object.tags.name = object.tags['name'] .. ' [A]'
            end
        end

-- ----------------------------------------------------------------------------
-- Append U to roads if no surface defined
-- Append O if no smoothness (on non-long fords)
-- ----------------------------------------------------------------------------
        track_appendix = ''

        if ( object.tags['surface'] == nil ) then
            track_appendix = 'U'
        end

        if (( object.tags['smoothness'] == nil ) and
            ( object.tags['ford']       == nil )) then
            if ( track_appendix == nil ) then
                track_appendix = 'O'
            else
                track_appendix = track_appendix .. 'O'
            end
        end

        if ( track_appendix ~= '' ) then
            if ( object.tags['name'] == nil ) then
                object.tags.name = '[' .. track_appendix .. ']'
            else
                object.tags.name = object.tags['name'] .. ' [' .. track_appendix .. ']'
            end
        end
    end
-- ----------------------------------------------------------------------------
-- End QA for footway-bridleway
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- QA for track
-- ----------------------------------------------------------------------------
    if ( object.tags['highway'] == 'track' ) then
-- ----------------------------------------------------------------------------
-- Append (A) if an expected foot tag is missing
-- ----------------------------------------------------------------------------
        if (( object.tags['foot']     == nil   ) and
            ( object.tags['informal'] ~= 'yes' )) then
            if ( object.tags['name'] == nil ) then
                object.tags.name = '[A]'
            else
                object.tags.name = object.tags['name'] .. ' [A]'
            end
        end

-- ----------------------------------------------------------------------------
-- Append U to roads if no surface defined
-- Append G if no tracktype
-- Append O if no smoothness (on non-long fords)
-- ----------------------------------------------------------------------------
        track_appendix = ''

        if ( object.tags['surface'] == nil ) then
            track_appendix = 'U'
        end

        if ( object.tags['tracktype'] == nil ) then
            if ( track_appendix == nil ) then
                track_appendix = 'G'
            else
                track_appendix = track_appendix .. 'G'
            end
        end

        if (( object.tags['smoothness'] == nil ) and
            ( object.tags['ford']       == nil )) then
            if ( track_appendix == nil ) then
                track_appendix = 'O'
            else
                track_appendix = track_appendix .. 'O'
            end
        end

        if ( track_appendix ~= '' ) then
            if ( object.tags['name'] == nil ) then
                object.tags.name = '[' .. track_appendix .. ']'
            else
                object.tags.name = object.tags['name'] .. ' [' .. track_appendix .. ']'
            end
        end
    end
-- ----------------------------------------------------------------------------
-- End QA for track
-- ----------------------------------------------------------------------------

    return object.tags
end


-- ----------------------------------------------------------------------------
-- "relation" function
-- ----------------------------------------------------------------------------
function ott.process_relation(object)
    object = process_all(object)
    return object.tags
end


-- ----------------------------------------------------------------------------
-- "append non QA information" function
-- ----------------------------------------------------------------------------
function append_nonqa(object,appendage)
    if ( object.tags['name'] == nil ) then
      object.tags.name = '(' .. appendage .. ')'
    else
      object.tags.name = object.tags['name'] .. ' (' .. appendage .. ')'
    end

    return object
end
