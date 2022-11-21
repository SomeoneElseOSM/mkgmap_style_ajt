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

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(el.sub.)"
      else
         object.tags["name"] = object.tags["name"] .. " (el.sub.)"
      end
   end

-- ----------------------------------------------------------------------------
-- Append (sewage) to sewage works.
-- ----------------------------------------------------------------------------
   if ( object.tags["man_made"]   == "wastewater_plant" ) then
      object.tags["man_made"] = nil
      object.tags["landuse"] = "industrial"
      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(sewage)"
      else
         object.tags["name"] = object.tags["name"] .. " (sewage)"
      end
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

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(milestone)"
      else
         object.tags["name"] = object.tags["name"] .. " (milestone)"
      end
   end

-- ----------------------------------------------------------------------------
-- Aerial markers for pipelines etc.
-- ----------------------------------------------------------------------------
   if (( object.tags["marker"]   == "aerial"          ) or
       ( object.tags["marker"]   == "pipeline"        ) or
       ( object.tags["man_made"] == "pipeline_marker" )) then
      object.tags["man_made"] = "marker"

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(pipeline marker)"
      else
         object.tags["name"] = object.tags["name"] .. " (pipeline marker)"
      end
   end

-- ----------------------------------------------------------------------------
-- Boundary stones.  If they're already tagged as tourism=attraction, remove
-- that tag.
-- Note that "marker=stone" (for "non boundary stones") are handled elsewhere.
-- ----------------------------------------------------------------------------
   if (( object.tags["historic"] == "boundary_stone"  )  or
       ( object.tags["historic"] == "boundary_marker" )  or
       ( object.tags["historic"] == "boundary_post"   )  or
       ( object.tags["marker"]   == "boundary_stone"  )  or
       ( object.tags["boundary"] == "marker"          )) then
      object.tags["man_made"] = "marker"
      object.tags["tourism"]  = nil

      if ( object.tags["inscription"] ~= nil ) then
         if ( object.tags["name"] == nil ) then
            object.tags["name"] = object.tags["inscription"]
         else
            object.tags["name"] = object.tags["name"] .. " " .. object.tags["inscription"]
         end
      end

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(boundary stone)"
      else
         object.tags["name"] = object.tags["name"] .. " (boundary stone)"
      end
   end

-- ----------------------------------------------------------------------------
-- Stones that are not boundary stones.
-- Note that "marker=boundary_stone" are handled elsewhere.
-- ----------------------------------------------------------------------------
   if (( object.tags["marker"]   == "stone" ) or
       ( object.tags["natural"]  == "stone" )) then
      object.tags["man_made"] = "marker"

      if ( object.tags["inscription"] ~= nil ) then
         if ( object.tags["name"] == nil ) then
            object.tags["name"] = object.tags["inscription"]
         else
            object.tags["name"] = object.tags["name"] .. " " .. object.tags["inscription"]
         end
      end

      if ( object.tags["stone_type"]   == "ogham_stone" ) then
         if ( object.tags["name"] == nil ) then
            object.tags["name"] = "(ogham stone)"
         else
            object.tags["name"] = object.tags["name"] .. " (ogham stone)"
         end
      else
         if ( object.tags["name"] == nil ) then
            object.tags["name"] = "(historic stone)"
         else
            object.tags["name"] = object.tags["name"] .. " (historic stone)"
         end
      end
   end

   if ( object.tags["historic"]   == "stone" ) then
      object.tags["man_made"] = "marker"

      if ( object.tags["inscription"] ~= nil ) then
         if ( object.tags["name"] == nil ) then
            object.tags["name"] = object.tags["inscription"]
         else
            object.tags["name"] = object.tags["name"] .. " " .. object.tags["inscription"]
         end
      end

      if ( object.tags["stone_type"]   == "ogham_stone" ) then
         if ( object.tags["name"] == nil ) then
            object.tags["name"] = "(ogham stone)"
         else
            object.tags["name"] = object.tags["name"] .. " (ogham stone)"
         end
      else
         if ( object.tags["historic:stone"]   == "standing_stone" ) then
            if ( object.tags["name"] == nil ) then
               object.tags["name"] = "(standing stone)"
            else
               object.tags["name"] = object.tags["name"] .. " (standing stone)"
            end
         else
            if ( object.tags["name"] == nil ) then
               object.tags["name"] = "(historic stone)"
            else
               object.tags["name"] = object.tags["name"] .. " (historic stone)"
            end
         end
      end
   end

   if ((   object.tags["historic"]           == "standing_stone"        ) or
       ((  object.tags["historic"]           == "archaeological_site"  )  and
        (( object.tags["site_type"]          == "standing_stone"      )   or
         ( object.tags["site_type"]          == "megalith"            )   or
         ( object.tags["Canmore_Site_Type"]  == "Standing Stone"      )))) then
      object.tags["man_made"] = "marker"

      if ( object.tags["inscription"] ~= nil ) then
         if ( object.tags["name"] == nil ) then
            object.tags["name"] = object.tags["inscription"]
         else
            object.tags["name"] = object.tags["name"] .. " " .. object.tags["inscription"]
         end
      end

      if ( object.tags["stone_type"]   == "ogham_stone" ) then
         if ( object.tags["name"] == nil ) then
            object.tags["name"] = "(ogham stone)"
         else
            object.tags["name"] = object.tags["name"] .. " (ogham stone)"
         end
      else
         if ( object.tags["name"] == nil ) then
            object.tags["name"] = "(standing stone)"
         else
            object.tags["name"] = object.tags["name"] .. " (standing stone)"
         end
      end

      object.tags["tourism"] = nil
   end

   if ( object.tags["historic"]   == "rune_stone" ) then
      object.tags["man_made"] = "marker"

      if ( object.tags["inscription"] ~= nil ) then
         if ( object.tags["name"] == nil ) then
            object.tags["name"] = object.tags["inscription"]
         else
            object.tags["name"] = object.tags["name"] .. " " .. object.tags["inscription"]
         end
      end

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(standing stone)"
      else
         object.tags["name"] = object.tags["name"] .. " (standing stone)"
      end
   end

   if ( object.tags["place_of_worship"]   == "mass_rock" ) then
      object.tags["man_made"] = "marker"
      object.tags["amenity"]  = nil

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(mass rock)"
      else
         object.tags["name"] = object.tags["name"] .. " (mass rock)"
      end
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

	    if ( object.tags["name"] == nil ) then
               object.tags["name"] = "(fmr phone defib)"
	    else
               object.tags["name"] = object.tags["name"] .. " (fmr phone defib)"
	    end
         else
            if (( object.tags["amenity"] == "public_bookcase" )  or
                ( object.tags["amenity"] == "book_exchange"   )  or
                ( object.tags["amenity"] == "library"         )) then
               object.tags["amenity"] = "telephone"

	       if ( object.tags["name"] == nil ) then
                  object.tags["name"] = "(fmr phone book exchange)"
	       else
                  object.tags["name"] = object.tags["name"] .. " (fmr phone book exchange)"
	       end
            else
               if ( object.tags["amenity"] == "bicycle_repair_station" ) then
                  object.tags["amenity"] = "telephone"

	          if ( object.tags["name"] == nil ) then
                     object.tags["name"] = "(fmr phone bicycle repair)"
	          else
                     object.tags["name"] = object.tags["name"] .. " (fmr phone bicycle repair)"
	          end
               else
                  if ( object.tags["amenity"] == "atm" ) then
                     object.tags["amenity"] = "telephone"

	             if ( object.tags["name"] == nil ) then
                        object.tags["name"] = "(fmr phone atm)"
	             else
                        object.tags["name"] = object.tags["name"] .. " (fmr phone atm)"
	             end
                  else
                     if ( object.tags["tourism"] == "information" ) then
                        object.tags["amenity"] = "telephone"

	                if ( object.tags["name"] == nil ) then
                           object.tags["name"] = "(fmr phone tourist info)"
	                else
                           object.tags["name"] = object.tags["name"] .. " (fmr phone tourist info)"
	                end
                     else
                        if ( object.tags["tourism"] == "artwork" ) then
                           object.tags["amenity"] = "telephone"

	                   if ( object.tags["name"] == nil ) then
                              object.tags["name"] = "(fmr phone artwork)"
	                   else
                              object.tags["name"] = object.tags["name"] .. " (fmr phone artwork)"
	                   end
                        else
                           if ( object.tags["tourism"] == "museum" ) then
                              object.tags["amenity"] = "telephone"

	                      if ( object.tags["name"] == nil ) then
                                 object.tags["name"] = "(fmr phone museum)"
	                      else
                                 object.tags["name"] = object.tags["name"] .. " (fmr phone museum)"
	                      end
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

	                         if ( object.tags["name"] == nil ) then
                                    object.tags["name"] = "(fmr phone)"
	                         else
                                    object.tags["name"] = object.tags["name"] .. " (fmr phone)"
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
   end
   
-- ----------------------------------------------------------------------------
-- Mappings to shop=car
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"]    == "car;car_repair"  )  or
       ( object.tags["shop"]    == "car;bicycle"     )  or
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
       ( object.tags["craft"]   == "car_repair"         )  or
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
   if (( object.tags["diplomatic"] == "embassy"            ) or
       ( object.tags["diplomatic"] == "consulate"          ) or
       ( object.tags["diplomatic"] == "consulate_general"  ) or
       ( object.tags["diplomatic"] == "honorary_consulate" ) or
       ( object.tags["diplomatic"] == "high_commission"    )) then
      object.tags["amenity"] = "embassy"
   end

   if (( object.tags["diplomatic"] == "permanent_mission"     ) or
       ( object.tags["diplomatic"] == "ambassadors_residence" ) or
       ( object.tags["diplomatic"] == "trade_delegation"      )) then
      if ( object.tags["amenity"] == "embassy" ) then
         object.tags["amenity"] = nil
      end
      object.tags["office"] = "yes"
   end

-- ----------------------------------------------------------------------------
-- Holy wells might be natural=spring or something else.
-- Make sure that we set "amenity" to something other than "place_of_worship"
-- The one existing "holy_well" is actually a spring.
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"] == "holy_well" ) and
       ( object.tags["natural"] == "spring"    )) then
      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(holy spring)"
      else
         object.tags["name"] = object.tags["name"] .. " (holy spring)"
      end
   end

   if ( object.tags["place_of_worship"] == "holy_well" ) then
      object.tags["natural"] = "spring"

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(holy well)"
      else
         object.tags["name"] = object.tags["name"] .. " (holy well)"
      end
   end

-- ----------------------------------------------------------------------------
-- Ordinary wells
-- ----------------------------------------------------------------------------
   if ( object.tags["man_made"] == "water_well" ) then
      object.tags["natural"] = "spring"

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(well)"
      else
         object.tags["name"] = object.tags["name"] .. " (well)"
      end
   end

-- ----------------------------------------------------------------------------
-- Beer gardens etc.
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"] == "beer_garden" ) or
       ( object.tags["landuse"] == "beer_garden" ) or
       ( object.tags["leisure"] == "beer_garden" )) then
      object.tags["amenity"] = nil
      object.tags["leisure"] = "garden"
      object.tags["garden"]  = "beer_garden"
   end

-- ----------------------------------------------------------------------------
-- Show unnamed amenity=biergarten as gardens, which is all they likely are.
-- ----------------------------------------------------------------------------
   if ((  object.tags["amenity"] == "biergarten"   )  and
       (( object.tags["name"]    == nil           )   or
        ( object.tags["name"]    == "Beer Garden" ))) then
      object.tags["amenity"] = nil
      object.tags["leisure"] = "garden"
      object.tags["garden"]  = "beer_garden"
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
-- Map various landuse to park
--
-- All handled in the style like this:
-- leisure=park {name '${name}'} [0x17 resolution 20]
-- ----------------------------------------------------------------------------
   if ( object.tags["leisure"]   == "common" ) then
      object.tags["leisure"] = "park"

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(common)"
      else
         object.tags["name"] = object.tags["name"] .. " (common)"
      end
   end

   if ( object.tags["leisure"]   == "garden" ) then
      object.tags["leisure"] = "park"

      if ( object.tags["garden"] == "beer_garden" ) then
         if ( object.tags["name"] == nil ) then
            object.tags["name"] = "(beer_garden)"
         else
            object.tags["name"] = object.tags["name"] .. " (beer_garden)"
         end
      else
         if ( object.tags["name"] == nil ) then
            object.tags["name"] = "(garden)"
         else
            object.tags["name"] = object.tags["name"] .. " (garden)"
         end
      end
   end

   if (( object.tags["leisure"]   == "outdoor_seating" ) and
       ( object.tags["surface"]   == "grass"           )) then
      object.tags["leisure"] = "park"

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(outdoor grass)"
      else
         object.tags["name"] = object.tags["name"] .. " (outdoor grass)"
      end
   end

   if ( object.tags["landuse"]   == "grass" ) then
      object.tags["leisure"] = "park"

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(grass)"
      else
         object.tags["name"] = object.tags["name"] .. " (grass)"
      end
   end

   if ( object.tags["landuse"]   == "greenfield" ) then
      object.tags["leisure"] = "park"

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(greenfield)"
      else
         object.tags["name"] = object.tags["name"] .. " (greenfield)"
      end
   end

-- ----------------------------------------------------------------------------
-- These all map to meadow in the web maps
-- ----------------------------------------------------------------------------
if ( object.tags["landuse"]   == "meadow" ) then
      object.tags["leisure"] = "park"

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(meadow)"
      else
         object.tags["name"] = object.tags["name"] .. " (meadow)"
      end
   end

if (( object.tags["amenity"] == "showground"   ) or
    ( object.tags["leisure"] == "showground"   ) or
    ( object.tags["amenity"] == "show_ground"  ) or
    ( object.tags["amenity"] == "show_grounds" )) then
      object.tags["amenity"] = nil
      object.tags["leisure"] = "park"

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(showground)"
      else
         object.tags["name"] = object.tags["name"] .. " (showground)"
      end
   end

if ( object.tags["amenity"]   == "festival_grounds" ) then
      object.tags["amenity"] = nil
      object.tags["leisure"] = "park"

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(festival grounds)"
      else
         object.tags["name"] = object.tags["name"] .. " (festival grounds)"
      end
   end

   if ( object.tags["amenity"]   == "car_boot_sale" ) then
      object.tags["amenity"] = nil
      object.tags["leisure"] = "park"

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(car boot sale)"
      else
         object.tags["name"] = object.tags["name"] .. " (car boot sale)"
      end
   end
-- ----------------------------------------------------------------------------
-- (end of list that maps to meadow)
-- ----------------------------------------------------------------------------

   if ( object.tags["leisure"]   == "playground" ) then
      object.tags["leisure"] = "park"

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(playground)"
      else
         object.tags["name"] = object.tags["name"] .. " (playground)"
      end
   end

   if ( object.tags["landuse"]   == "village_green" ) then
      object.tags["leisure"] = "park"

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(village green)"
      else
         object.tags["name"] = object.tags["name"] .. " (village green)"
      end
   end

   if (( object.tags["amenity"]   == "scout_camp"     ) or
       ( object.tags["landuse"]   == "scout_camp"     )) then
      object.tags["leisure"] = "park"

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(scout camp)"
      else
         object.tags["name"] = object.tags["name"] .. " (scout camp)"
      end
   end

   if ( object.tags["leisure"]   == "fishing" ) then
      object.tags["leisure"] = "park"

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(fishing)"
      else
         object.tags["name"] = object.tags["name"] .. " (fishing)"
      end
   end

   if ( object.tags["leisure"]   == "outdoor_centre" ) then
      object.tags["leisure"] = "park"

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(outdoor centre)"
      else
         object.tags["name"] = object.tags["name"] .. " (outdoor centre)"
      end
   end
-- ----------------------------------------------------------------------------
-- (end of things that map to park)
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- These all map to farmyard in the web maps
-- ----------------------------------------------------------------------------
   if ( object.tags["landuse"]   == "farmyard" ) then
      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(farmyard)"
      else
         object.tags["name"] = object.tags["name"] .. " (farmyard)"
      end
   end

-- ----------------------------------------------------------------------------
-- Change landuse=greenhouse_horticulture to farmyard.
-- ----------------------------------------------------------------------------
   if (object.tags["landuse"]   == "greenhouse_horticulture") then
      object.tags["landuse"] = "farmyard"

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(greenhouse horticulture)"
      else
         object.tags["name"] = object.tags["name"] .. " (greenhouse horticulture)"
      end
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

      if ( object.tags['name'] == nil ) then
         object.tags.name = '(bird hide)'
      else
         object.tags.name = object.tags['name'] .. ' (bird hide)'
      end
   end

   if ( object.tags["leisure"] == "wildlife_hide" ) then
      object.tags["tourism"] = "information"

      if ( object.tags['name'] == nil ) then
         object.tags.name = '(wildlife hide)'
      else
         object.tags.name = object.tags['name'] .. ' (wildlife hide)'
      end
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
-- Handle mistagged pubs
-- ----------------------------------------------------------------------------
   if ( object.tags["tourism"]  == "pub;hotel" ) then
      object.tags["amenity"] = "pub"
      object.tags["tourism"] = nil
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

   if (( object.tags["leisure"]     == "outdoor_seating" ) and
       ( object.tags["beer_garden"] == "yes"             )) then
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
        ( object.tags["opening_hours:covid19"] == "Mu-Su off" ) or
        ( object.tags["access:covid19"]        == "no"        ))) then
      object.tags["disused:amenity"] = "pub"
      object.tags["amenity"] = nil

      if ( object.tags['name'] == nil ) then
         object.tags.name = '(closed covid)'
      else
         object.tags.name = object.tags['name'] .. ' (closed covid)'
      end

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
         if ( object.tags['name'] == nil ) then
            object.tags.name = '(' .. beer_appendix .. ')'
         else
            object.tags.name = object.tags['name'] .. ' (' .. beer_appendix .. ')'
         end
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
         if ( object.tags['name'] == nil ) then
            object.tags.name = '(rest accomm)'
         else
            object.tags.name = object.tags['name'] .. ' (rest accomm)'
         end
      else
         if ( object.tags['name'] == nil ) then
            object.tags.name = '(rest)'
         else
            object.tags.name = object.tags['name'] .. ' (rest)'
         end
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
         if ( object.tags['name'] == nil ) then
            object.tags.name = '(cafe accomm)'
         else
            object.tags.name = object.tags['name'] .. ' (cafe accomm)'
         end
      else
         if ( object.tags['name'] == nil ) then
            object.tags.name = '(cafe)'
         else
            object.tags.name = object.tags['name'] .. ' (cafe)'
         end
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
      if ( object.tags['name'] == nil ) then
         object.tags.name = '(atm)'
      else
         object.tags.name = object.tags['name'] .. ' (atm)'
      end
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

      if ( object.tags['name'] == nil ) then
         object.tags.name = '(dentist)'
      else
         object.tags.name = object.tags['name'] .. ' (dentist)'
      end
   end

   if (( object.tags["healthcare"] == "hospital" ) and
       ( object.tags["amenity"]    == nil        )) then
      object.tags["amenity"] = "hospital"
   end

   if ( object.tags["amenity"] == "hospital" ) then
      if ( object.tags['name'] == nil ) then
         object.tags.name = '(hospital)'
      else
         object.tags.name = object.tags['name'] .. ' (hospital)'
      end
   end

-- ----------------------------------------------------------------------------
-- Ensure that vaccination centries (e.g. for COVID 19) that aren't already
-- something else get shown as something.
-- Things that _are_ something else get (e.g. community centres) get left as
-- that something else.
-- ----------------------------------------------------------------------------
   if ((( object.tags["healthcare"]            == "vaccination_centre" )  or
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

      if ( object.tags['name'] == nil ) then
         object.tags.name = '(clinic)'
      else
         object.tags.name = object.tags['name'] .. ' (clinic)'
      end
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
      if ( object.tags['name'] == nil ) then
         object.tags.name = '(pharmacy)'
      else
         object.tags.name = object.tags['name'] .. ' (pharmacy)'
      end
   end

   if ( object.tags["shop"] == "chemist" ) then
      if ( object.tags['name'] == nil ) then
         object.tags.name = '(chemist)'
      else
         object.tags.name = object.tags['name'] .. ' (chemist)'
      end
   end

-- ----------------------------------------------------------------------------
-- Add suffix to libraries and public bookcases
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "library" ) then
      if ( object.tags['name'] == nil ) then
         object.tags.name = '(library)'
      else
         object.tags.name = object.tags['name'] .. ' (library)'
      end
   end

   if (( object.tags["amenity"] == "book_exchange"   ) or
       ( object.tags["amenity"] == "public_bookcase" )) then
      object.tags["amenity"] = "library"

      if ( object.tags['name'] == nil ) then
         object.tags.name = '(book exchange)'
      else
         object.tags.name = object.tags['name'] .. ' (book exchange)'
      end
   end

-- ----------------------------------------------------------------------------
-- Various clocks
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"] == "clock"   )  and
       ( object.tags["display"] == "sundial" )) then
      object.tags["man_made"] = "thing"
      object.tags["amenity"] = nil

      if ( object.tags['name'] == nil ) then
         object.tags.name = '(sundial)'
      else
         object.tags.name = object.tags['name'] .. ' (sundial)'
      end
   end

   if (((  object.tags["man_made"]   == "tower"        )  and
        (( object.tags["tower:type"] == "clock"       )   or
         ( object.tags["building"]   == "clock_tower" )   or
         ( object.tags["amenity"]    == "clock"       ))) or
       ((  object.tags["amenity"]    == "clock"        )  and
        (  object.tags["support"]    == "tower"        ))) then
      object.tags["man_made"] = "thing"
      object.tags["tourism"] = nil

      if ( object.tags['name'] == nil ) then
         object.tags.name = '(clocktower)'
      else
         object.tags.name = object.tags['name'] .. ' (clocktower)'
      end
   end

   if ((  object.tags["amenity"]    == "clock"         )  and
       (( object.tags["support"]    == "pedestal"     )   or
        ( object.tags["support"]    == "pole"         )   or
        ( object.tags["support"]    == "stone_pillar" )   or
        ( object.tags["support"]    == "plinth"       )   or
        ( object.tags["support"]    == "column"       ))) then
      object.tags["man_made"] = "thing"
      object.tags["tourism"] = nil

      if ( object.tags['name'] == nil ) then
         object.tags.name = '(clockpedestal)'
      else
         object.tags.name = object.tags['name'] .. ' (clockpedestal)'
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

      if ( object.tags['name'] == nil ) then
         object.tags.name = '(left luggage)'
      else
         object.tags.name = object.tags['name'] .. ' (left luggage)'
      end
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

      if ( object.tags['name'] == nil ) then
         object.tags.name = '(parcel locker)'
      else
         object.tags.name = object.tags['name'] .. ' (parcel locker)'
      end
   end

-- ----------------------------------------------------------------------------
-- Excrement bags
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"] == "vending_machine" ) and
       ( object.tags["vending"] == "excrement_bags"  )) then
      object.tags["man_made"]  = "thing"
      object.tags["amenity"]  = nil

      if ( object.tags['name'] == nil ) then
         object.tags.name = '(excrement bags)'
      else
         object.tags.name = object.tags['name'] .. ' (excrement bags)'
      end
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
         if ( object.tags['name'] == nil ) then
            object.tags.name = '(vending)'
         else
            object.tags.name = object.tags['name'] .. ' (vending)'
         end
      end
   end

-- ----------------------------------------------------------------------------
-- Show amenity=piano and amenity=musical_instrument
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "piano" ) then
      object.tags["man_made"]  = "thing"
      object.tags["amenity"]  = nil

      if ( object.tags['name'] == nil ) then
         object.tags.name = '(piano)'
      else
         object.tags.name = object.tags['name'] .. ' (piano)'
      end
   end

   if ( object.tags["amenity"] == "musical_instrument" ) then
      object.tags["man_made"]  = "thing"
      object.tags["amenity"]  = nil

      if ( object.tags['name'] == nil ) then
         object.tags.name = '(musical instrument)'
      else
         object.tags.name = object.tags['name'] .. ' (musical instrument)'
      end
   end

-- ----------------------------------------------------------------------------
-- Motorcycle parking
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"] == "parking"    )  and
       ( object.tags["parking"] == "motorcycle" )) then
      object.tags["man_made"] = "thing"

      if ( object.tags['name'] == nil ) then
         object.tags.name = '(motorcycle parking)'
      else
         object.tags.name = object.tags['name'] .. ' (motorcycle parking)'
      end
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
      if ( object.tags['name'] == nil ) then
         object.tags.name = '(pay)'
      else
         object.tags.name = object.tags['name'] .. ' (pay)'
      end
   end

-- ----------------------------------------------------------------------------
-- Show bicycle_parking areas, and 
-- show for-pay bicycle_parking areas differently.
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "bicycle_parking" ) then
      object.tags["man_made"] = "thing"

      if ( object.tags['name'] == nil ) then
         object.tags.name = '(bicycle parking)'
      else
         object.tags.name = object.tags['name'] .. ' (bicycle parking)'
      end

      if (( object.tags["fee"]     ~= nil               )  and
          ( object.tags["fee"]     ~= "no"              )  and
          ( object.tags["fee"]     ~= "No"              )  and
          ( object.tags["fee"]     ~= "none"            )  and
          ( object.tags["fee"]     ~= "None"            )  and
          ( object.tags["fee"]     ~= "Free"            )  and
          ( object.tags["fee"]     ~= "free"            )  and
          ( object.tags["fee"]     ~= "0"               )) then
         if ( object.tags['name'] == nil ) then
            object.tags.name = '(pay)'
         else
            object.tags.name = object.tags['name'] .. ' (pay)'
         end
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
            if ( object.tags['name'] == nil ) then
               object.tags.name = '(pay m)'
            else
               object.tags.name = object.tags['name'] .. ' (pay m)'
            end
         else
            if (( object.tags["female"] == "yes"       ) and
                ( object.tags["male"]   ~= "yes"       )) then
               if ( object.tags['name'] == nil ) then
                  object.tags.name = '(pay w)'
               else
                  object.tags.name = object.tags['name'] .. ' (pay w)'
               end
            else
               if ( object.tags['name'] == nil ) then
                  object.tags.name = '(pay)'
               else
                  object.tags.name = object.tags['name'] .. ' (pay)'
               end
            end
         end
      else
         if (( object.tags["male"]   == "yes" ) and
             ( object.tags["female"] ~= "yes" )) then
            if ( object.tags['name'] == nil ) then
               object.tags.name = '(free m)'
            else
               object.tags.name = object.tags['name'] .. ' (free m)'
            end
         else
            if (( object.tags["female"] == "yes"       ) and
                ( object.tags["male"]   ~= "yes"       )) then
               if ( object.tags['name'] == nil ) then
                  object.tags.name = '(free w)'
               else
                  object.tags.name = object.tags['name'] .. ' (free w)'
               end
            else
               if ( object.tags['name'] == nil ) then
                  object.tags.name = '(free)'
               else
                  object.tags.name = object.tags['name'] .. ' (free)'
               end
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
   if (( object.tags["railway"]  == "razed"          ) or
       ( object.tags["historic"] == "inclined_plane" )) then
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
-- Lock gtes
-- ----------------------------------------------------------------------------
   if ( object.tags["waterway"] == "lock_gate" ) then
      if ( object.tags['name'] == nil ) then
         object.tags.name = '(lock gate)'
      else
         object.tags.name = object.tags['name'] .. ' (lock gate)'
      end
   end

-- ----------------------------------------------------------------------------
-- Sluice gates - send through as man_made=thing and append name
-- ----------------------------------------------------------------------------
   if ((  object.tags["waterway"]     == "sluice_gate"      ) or
       (  object.tags["waterway"]     == "sluice"           ) or
       (( object.tags["waterway"]     == "flow_control"    )  and
        ( object.tags["flow_control"] == "sluice_gate"     ))) then
      object.tags["man_made"] = "thing"

      if ( object.tags['name'] == nil ) then
         object.tags.name = '(sluice)'
      else
         object.tags.name = object.tags['name'] .. ' (sluice)'
      end
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
      if ( object.tags['name'] == nil ) then
         object.tags.name = '(derelict canal)'
      end
   end

-- ----------------------------------------------------------------------------
-- Intermittent water
-- ----------------------------------------------------------------------------
   if ((( object.tags["waterway"] ~= nil      )   or
        ( object.tags["natural"]  ~= nil      ))  and
       (  object.tags["intermittent"] == "yes" )) then
      if ( object.tags['name'] == nil ) then
         object.tags.name = '(int)'
      else
         object.tags.name = object.tags['name'] .. ' (int)'
      end
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

      if ( object.tags['name'] == nil ) then
         object.tags.name = '(' .. object.tags["man_made"] .. ')'
      else
         object.tags.name = object.tags['name'] .. ' (' .. object.tags["man_made"] .. ')'
      end

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
-- Things that are both towers and monuments or memorials 
-- should render as the latter.
-- ----------------------------------------------------------------------------
   if ((  object.tags["man_made"]  == "tower"     ) and
       (( object.tags["historic"]  == "memorial" )  or
        ( object.tags["historic"]  == "monument" ))) then
      object.tags["man_made"] = nil
   end

-- ----------------------------------------------------------------------------
-- historic=monument
-- ----------------------------------------------------------------------------
   if ( object.tags["historic"]   == "monument"     ) then
      object.tags["historic"] = "memorial"

      if ( object.tags['name'] == nil ) then
         object.tags.name = '(monument)'
      else
         object.tags.name = object.tags['name'] .. ' (monument)'
      end
   end

   if ( object.tags["tourism"] == "gallery" ) then
      object.tags["amenity"] = nil
      object.tags["tourism"] = "museum"

      if ( object.tags['name'] == nil ) then
         object.tags.name = '(gallery)'
      else
         object.tags.name = object.tags['name'] .. ' (gallery)'
      end
   end

   if ( object.tags["tourism"] == "museum" ) then
      object.tags["amenity"] = nil

      if ( object.tags['name'] == nil ) then
         object.tags.name = '(museum)'
      else
         object.tags.name = object.tags['name'] .. ' (museum)'
      end
   end

   if ( object.tags["tourism"] == "attraction" ) then

      if ( object.tags['name'] == nil ) then
         object.tags.name = '(tourist attraction)'
      else
         object.tags.name = object.tags['name'] .. ' (tourist attraction)'
      end
   end

   if ( object.tags["tourism"] == "artwork" ) then

      if ( object.tags['name'] == nil ) then
         object.tags.name = '(artwork)'
      else
         object.tags.name = object.tags['name'] .. ' (artwork)'
      end
   end

   if ( object.tags["amenity"] == "arts_centre" ) then

      if ( object.tags['name'] == nil ) then
         object.tags.name = '(arts centre)'
      else
         object.tags.name = object.tags['name'] .. ' (arts centre)'
      end
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
 
      if ( object.tags['name'] == nil ) then
         object.tags.name = '(historic mine)'
      else
         object.tags.name = object.tags['name'] .. ' (historic mine)'
      end
   end

-- ----------------------------------------------------------------------------
-- Then other spellings of mineshaft
-- ----------------------------------------------------------------------------
   if (( object.tags["man_made"] == "mine"       )  or
       ( object.tags["man_made"] == "mineshaft"  )  or
       ( object.tags["man_made"] == "mine_shaft" )) then
      object.tags["man_made"] = "thing"

      if ( object.tags['name'] == nil ) then
         object.tags.name = '(mine)'
      else
         object.tags.name = object.tags['name'] .. ' (mine)'
      end
   end

-- ----------------------------------------------------------------------------
-- palaeolontological_site
-- ----------------------------------------------------------------------------
   if ( object.tags["geological"] == "palaeontological_site" ) then
      object.tags["historic"] = "palaeontological_site"
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
         if ( object.tags['name'] == nil ) then
            object.tags.name = '(standing stone)'
         else
            object.tags.name = object.tags['name'] .. ' (standing stone)'
         end
      end
   end

   if (( object.tags["historic"] == "marker"          ) or
       ( object.tags["historic"] == "plaque"          ) or
       ( object.tags["historic"] == "memorial_plaque" ) or
       ( object.tags["historic"] == "blue_plaque"     )) then
      object.tags["historic"] = nil
      object.tags["man_made"] = "thing"

      if ( object.tags['name'] == nil ) then
         object.tags.name = '(historic plaque)'
      else
         object.tags.name = object.tags['name'] .. ' (historic plaque)'
      end
   end

   if ( object.tags["historic"] == "pillar" ) then
      object.tags["barrier"] = "bollard"
      object.tags["historic"] = nil
   end

   if (( object.tags["historic"] == "cairn" ) or
       ( object.tags["man_made"] == "cairn" )) then
      object.tags["man_made"] = "thing"
      object.tags["historic"] = nil

      if ( object.tags['name'] == nil ) then
         object.tags.name = '(cairn)'
      else
         object.tags.name = object.tags['name'] .. ' (cairn)'
      end
   end

   if ((  object.tags["historic"]   == "chimney"  ) or
       (  object.tags["man_made"]   == "chimney"  ) or
       (  object.tags["building"]   == "chimney"  ) or
       (( object.tags["building"]   == "tower"   )  and
        ( object.tags["tower:type"] == "chimney" ))) then
      object.tags["man_made"] = "thing"
      object.tags["historic"] = nil

      if ( object.tags['name'] == nil ) then
         object.tags.name = '(chimney)'
      else
         object.tags.name = object.tags['name'] .. ' (chimney)'
      end
   end

-- ----------------------------------------------------------------------------
-- hazard=plant is fairly rare, but render as a nonspecific historic dot.
-- ----------------------------------------------------------------------------
   if ((( object.tags["hazard"]  == "plant"                    )  or
        ( object.tags["hazard"]  == "toxic_plant"              )) and
       (( object.tags["species"] == "giant_hogweed"            )  or
        ( object.tags["species"] == "Heracleum mantegazzianum" )  or
        ( object.tags["taxon"]   == "Heracleum mantegazzianum" ))) then
      object.tags["man_made"] = "thing"

      if ( object.tags['name'] == nil ) then
         object.tags.name = '(hogweed)'
      else
         object.tags.name = object.tags['name'] .. ' (hogweed)'
      end
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
   if (( object.tags["man_made"]   == "ventilation_shaft" ) or
       ( object.tags["building"]   == "air_shaft"         ) or
       ( object.tags["man_made"]   == "air_shaft"         ) or
       ( object.tags["tunnel"]     == "air_shaft"         ) or
       ( object.tags["historic"]   == "air_shaft"         ) or
       ( object.tags["railway"]    == "ventilation_shaft" ) or
       ( object.tags["tunnel"]     == "ventilation_shaft" ) or
       ( object.tags["tunnel"]     == "ventilation shaft" ) or
       ( object.tags["building"]   == "ventilation_shaft" ) or
       ( object.tags["building"]   == "vent_shaft"        ) or
       ( object.tags["man_made"]   == "vent_shaft"        ) or
       ( object.tags["tower:type"] == "vent"              ) or
       ( object.tags["man_made"]   == "tunnel_vent"       )) then
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
       ( object.tags["bridleway"] == "mounting_block"       ) or
       ( object.tags["historic"]  == "mounting_block"       ) or
       ( object.tags["horse"]     == "mounting_block"       ) or
       ( object.tags["horse"]     == "mounting block"       ) or
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
-- Not quite the same as style.lua
--
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

-- Eventually, once there is some local data to support it, an "operator:type=military" check will go here.

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
        if ( object.tags['name'] == nil ) then
            object.tags.name = '(' .. information_appendix .. ')'
        else
            object.tags.name = object.tags['name'] .. ' (' .. information_appendix .. ')'
        end
    end

-- ----------------------------------------------------------------------------
-- Point weirs are sent through as points with a name of "weir"
-- ----------------------------------------------------------------------------
    if ( object.tags['waterway'] == 'weir' ) then
        object.tags["man_made"] = "thing"
        object.tags["waterway"] = nil

        if ( object.tags['name'] == nil ) then
            object.tags.name = '(weir)'
        else
            object.tags.name = object.tags['name'] .. ' (weir)'
        end
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
   if ((  object.tags["highway"] == "byway"       ) or
       (  object.tags["highway"] == "gallop"      ) or
       (  object.tags["highway"] == "unsurfaced"  ) or
       (( object.tags["golf"]    == "track"      )  and
        ( object.tags["highway"] == nil         ))) then
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
-- pathwide / path choice below:
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

    if ( designation_appendix ~= '' ) then
        if ( object.tags['name'] == nil ) then
            object.tags.name = '(' .. designation_appendix .. ')'
        else
            object.tags.name = object.tags['name'] .. ' (' .. designation_appendix .. ')'
        end
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
        if ( object.tags['name'] == nil ) then
            object.tags.name = '(I)'
        else
            object.tags.name = object.tags['name'] .. ' (I)'
        end
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
            if ( object.tags['name'] == nil ) then
                object.tags.name = '(' .. leaf_type_appendix .. ')'
            else
                object.tags.name = object.tags['name'] .. ' (' .. leaf_type_appendix .. ')'
            end
        end
    end

-- ----------------------------------------------------------------------------
-- Fence, hedge, wall
-- ----------------------------------------------------------------------------
    if ( object.tags['barrier'] == 'fence' ) then
        if ( object.tags['name'] == nil ) then
            object.tags.name = '(fence)'
        else
            object.tags.name = object.tags['name'] .. ' (fence)'
        end
    end

    if ( object.tags['barrier'] == 'hedge' ) then
        if ( object.tags['name'] == nil ) then
            object.tags.name = '(hedge)'
        else
            object.tags.name = object.tags['name'] .. ' (hedge)'
        end
    end

    if ( object.tags['barrier'] == 'wall' ) then
        if ( object.tags['name'] == nil ) then
            object.tags.name = '(wall)'
        else
            object.tags.name = object.tags['name'] .. ' (wall)'
        end
    end

-- ----------------------------------------------------------------------------
-- Linear weirs are sent through as "county lines" with a name of "weir"
-- Likewise floating barriers.
-- ----------------------------------------------------------------------------
    if ( object.tags['waterway'] == 'weir' ) then
        object.tags["barrier"] = "wall"
        object.tags["waterway"] = nil

        if ( object.tags['name'] == nil ) then
            object.tags.name = '(weir)'
        else
            object.tags.name = object.tags['name'] .. ' (weir)'
        end
    end

    if ( object.tags['waterway'] == 'floating_barrier' ) then
        object.tags["barrier"] = "wall"
        object.tags["waterway"] = nil

        if ( object.tags['name'] == nil ) then
            object.tags.name = '(floating barrier)'
        else
            object.tags.name = object.tags['name'] .. ' (floating barrier)'
        end
    end

-- ----------------------------------------------------------------------------
-- Display "waterway=leat" and "waterway=spillway" etc. as drain.
-- man_made=spillway tends to be used on areas, hence show as natural=water.
-- ----------------------------------------------------------------------------
   if ( object.tags["waterway"] == "leat" )  then
      object.tags["waterway"] = "drain"

      if ( object.tags['name'] == nil ) then
          object.tags.name = '(leat)'
      else
          object.tags.name = object.tags['name'] .. ' (leat)'
      end
   end

   if ( object.tags["waterway"] == "spillway" )  then
      object.tags["waterway"] = "drain"

      if ( object.tags['name'] == nil ) then
          object.tags.name = '(spillway)'
      else
          object.tags.name = object.tags['name'] .. ' (spillway)'
      end
   end

   if ( object.tags["waterway"] == "aqueduct" )  then
      object.tags["waterway"] = "drain"

      if ( object.tags['name'] == nil ) then
          object.tags.name = '(aqueduct)'
      else
          object.tags.name = object.tags['name'] .. ' (aqueduct)'
      end
   end

   if ( object.tags["waterway"] == "fish_pass" )  then
      object.tags["waterway"] = "drain"

      if ( object.tags['name'] == nil ) then
          object.tags.name = '(fish pass)'
      else
          object.tags.name = object.tags['name'] .. ' (fish pass)'
      end
   end

   if ((  object.tags["waterway"] == "canal"      )  and
       (( object.tags["usage"]    == "headrace"  )   or
        ( object.tags["usage"]    == "spillway"  ))) then
      object.tags["waterway"] = "drain"

      if ( object.tags['name'] == nil ) then
          object.tags.name = '(canal)'
      else
          object.tags.name = object.tags['name'] .. ' (canal)'
      end
   end

   if ( object.tags["man_made"] == "spillway" ) then
      object.tags["natural"] = "water"
      object.tags["man_made"] = nil

      if ( object.tags['name'] == nil ) then
          object.tags.name = '(spillway)'
      else
          object.tags.name = object.tags['name'] .. ' (spillway)'
      end
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
