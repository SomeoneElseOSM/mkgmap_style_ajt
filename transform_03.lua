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
         object.tags["landuse"] = "industrialbuilding"
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
-- Map various landuse to park
-- ----------------------------------------------------------------------------
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

--
-- "node" function
--
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
-- isn't otherwise rendered (and really should no longer be used), so change 
-- to track (which is what it probably will be).
--
-- "gallop" makes sense as a tag (it really isn't like anything else), but for
-- rendering change to "track".  "unsurfaced" makes less sense; change to
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
-- Where a wide width is specified on a normally narrow path, render as wider
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
-- Where a narrow width is specified on a normally wide track, render as
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
-- Render narrow tertiary roads as unclassified
-- ----------------------------------------------------------------------------
   if (( object.tags["highway"]    == "tertiary"   )  and
       ((( tonumber(object.tags["width"])    or 4 ) <=  3 ) or
        (( tonumber(object.tags["maxwidth"]) or 4 ) <=  3 ))) then
      object.tags["highway"] = "unclassified"
   end

-- ----------------------------------------------------------------------------
-- Render bus-only service roads tagged as "highway=busway" as service roads.
-- ----------------------------------------------------------------------------
   if (object.tags["highway"] == "busway") then
      object.tags["highway"] = "service"
   end

-- ----------------------------------------------------------------------------
-- Remove name from footway=sidewalk (we expect it to be rendered via the
-- road that this is a sidewalk for), or "is_sidepath=yes".
-- ----------------------------------------------------------------------------
   if ((( object.tags["footway"]     == "sidewalk" )  or
        ( object.tags["is_sidepath"] == "yes"      )) and
       (  object.tags["name"]    ~= nil             )) then
      object.tags["name"] = nil
   end

-- ----------------------------------------------------------------------------
-- Tunnel values - render as "yes" if appropriate.
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
-- Quality Control tagging on ways
--
-- Append M to roads if no speed limit defined
-- Append L if not known if lit
-- Append S if not known if sidewalk
-- Append V if known if sidewalk but known if verge
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
            ( object.tags['path']     ~= 'sidewalk' )) then
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
        if ( object.tags['foot'] == nil ) then
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
