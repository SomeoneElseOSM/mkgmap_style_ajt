-- ----------------------------------------------------------------------------
-- transform_03.lua
--
-- Copyright (C) 2018-2024  Andy Townsend
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- Apply "name" transformations to ways for "map style 03"
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- "all" function
-- ----------------------------------------------------------------------------
function process_all( objtype, object )
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
-- Treat "closed:" as "disused:"
-- ----------------------------------------------------------------------------
   if (( object.tags["closed:amenity"]     ~= nil ) and
       ( object.tags["disused:amenity"] == nil )) then
      object.tags["disused:amenity"] = object.tags["closed:amenity"]
   end

   if (( object.tags["closed:shop"]     ~= nil ) and
       ( object.tags["disused:shop"] == nil )) then
      object.tags["disused:shop"] = object.tags["closed:shop"]
   end

-- ----------------------------------------------------------------------------
-- Treat "status=abandoned" as "disused=yes"
-- ----------------------------------------------------------------------------
   if ( object.tags["status"] == "abandoned" ) then
      object.tags["disused"] = "yes"
   end

-- ----------------------------------------------------------------------------
-- If we have an est_width but no width, use the est_width
-- ----------------------------------------------------------------------------
   if (( object.tags["width"]     == nil  ) and
       ( object.tags["est_width"] ~= nil  )) then
      object.tags["width"] = object.tags["est_width"]
   end

-- ----------------------------------------------------------------------------
-- If name does not exist but name:en does, use it.
-- ----------------------------------------------------------------------------
   if (( object.tags["name"]    == nil ) and
       ( object.tags["name:en"] ~= nil )) then
      object.tags["name"] = object.tags["name:en"]
   end

-- ----------------------------------------------------------------------------
-- Move refs to consider as "official" to official_ref
-- ----------------------------------------------------------------------------
   if (( object.tags["official_ref"]          == nil ) and
       ( object.tags["highway_authority_ref"] ~= nil )) then
      object.tags["official_ref"]          = object.tags["highway_authority_ref"]
      object.tags["highway_authority_ref"] = nil
   end

   if (( object.tags["official_ref"] == nil ) and
       ( object.tags["highway_ref"]  ~= nil )) then
      object.tags["official_ref"] = object.tags["highway_ref"]
      object.tags["highway_ref"]  = nil
   end

   if (( object.tags["official_ref"] == nil ) and
       ( object.tags["admin_ref"]    ~= nil )) then
      object.tags["official_ref"] = object.tags["admin_ref"]
      object.tags["admin_ref"]    = nil
   end

   if (( object.tags["official_ref"] == nil ) and
       ( object.tags["admin:ref"]    ~= nil )) then
      object.tags["official_ref"] = object.tags["admin:ref"]
      object.tags["admin:ref"]    = nil
   end

   if (( object.tags["official_ref"] == nil              ) and
       ( object.tags["loc_ref"]      ~= nil              ) and
       ( object.tags["loc_ref"]      ~= object.tags["ref"] )) then
      object.tags["official_ref"] = object.tags["loc_ref"]
      object.tags["loc_ref"]    = nil
   end

-- ----------------------------------------------------------------------------
-- If "disused=yes" is set on highways, remove the highway tag.
-- ----------------------------------------------------------------------------
   if (( object.tags["highway"] ~= nil   ) and
       ( object.tags["disused"] == "yes" )) then
      object.tags["highway"] = nil
   end

-- ----------------------------------------------------------------------------
-- "highway=proposed" and "highway=construction" - append any proposed or 
-- construction value
-- ----------------------------------------------------------------------------
   if (( object.tags["highway"] == "proposed"     ) or
       ( object.tags["highway"] == "construction" )) then
      if ( object.tags["proposed"] ~= nil ) then
         object = append_nonqa( object, object.tags["proposed"] )
      end

      if ( object.tags["construction"] ~= nil ) then
         object = append_nonqa( object, object.tags["construction"] )
      end
   end

-- ----------------------------------------------------------------------------
-- Cater for unusual link values on the off chance
-- ----------------------------------------------------------------------------
   if ( object.tags["highway"] == "living_street_link" ) then
      object.tags["highway"] = "living_street"
   end

   if ( object.tags["highway"] == "service_link" ) then
      object.tags["highway"] = "service"
   end

-- ----------------------------------------------------------------------------
-- By default, trunk roads are mapped to roads you can't walk along, as if 
-- it was in Germany.
-- If there's a sidewalk, obviously you can, so map to primary.
-- ----------------------------------------------------------------------------
   if (((  object.tags["highway"]           == "trunk"          )  or
        (  object.tags["highway"]           == "trunk_link"     )) and
       ((( object.tags["sidewalk"]          ~= nil             )   and
         ( object.tags["sidewalk"]          ~= "no"            )   and
         ( object.tags["sidewalk"]          ~= "none"          ))  or
        (( object.tags["sidewalk:left"]     ~= nil             )   and
         ( object.tags["sidewalk:left"]     ~= "no"            )   and
         ( object.tags["sidewalk:left"]     ~= "none"          ))  or 
        (( object.tags["sidewalk:right"]    ~= nil             )   and
         ( object.tags["sidewalk:right"]    ~= "no"            )   and
         ( object.tags["sidewalk:right"]    ~= "none"          ))  or 
        (( object.tags["sidewalk:both"]     ~= nil             )   and
         ( object.tags["sidewalk:both"]     ~= "no"            )   and
         ( object.tags["sidewalk:both"]     ~= "none"          ))  or
        (( object.tags["sidewalk:separate"] ~= nil             )   and
         ( object.tags["sidewalk:separate"] ~= "no"            )   and
         ( object.tags["sidewalk:separate"] ~= "none"          )))) then
      object.tags["highway"] = "primary"
   end

-- ----------------------------------------------------------------------------
-- Move unsigned road refs to the name, in brackets.
-- ----------------------------------------------------------------------------
   if (( object.tags["highway"] == "motorway"          ) or
       ( object.tags["highway"] == "motorway_link"     ) or
       ( object.tags["highway"] == "trunk"             ) or
       ( object.tags["highway"] == "trunk_link"        ) or
       ( object.tags["highway"] == "primary"           ) or
       ( object.tags["highway"] == "primary_link"      ) or
       ( object.tags["highway"] == "secondary"         ) or
       ( object.tags["highway"] == "secondary_link"    ) or
       ( object.tags["highway"] == "tertiary"          ) or
       ( object.tags["highway"] == "tertiary_link"     ) or
       ( object.tags["highway"] == "unclassified"      ) or
       ( object.tags["highway"] == "unclassified_link" ) or
       ( object.tags["highway"] == "residential"       ) or
       ( object.tags["highway"] == "residential_link"  ) or
       ( object.tags["highway"] == "service"           ) or
       ( object.tags["highway"] == "road"              ) or
       ( object.tags["highway"] == "track"             ) or
       ( object.tags["highway"] == "cycleway"          ) or
       ( object.tags["highway"] == "bridleway"         ) or
       ( object.tags["highway"] == "footway"           ) or
       ( object.tags["highway"] == "path"              )) then
      if ( object.tags["name"] == nil   ) then
         if (( object.tags["ref"]        ~= nil  ) and
             ( object.tags["ref:signed"] == "no" )) then
            object.tags["name"]       = "(" .. object.tags["ref"] .. ")"
            object.tags["ref"]        = nil
            object.tags["ref:signed"] = nil
	 else
            if ( object.tags["official_ref"] ~= nil  ) then
               object.tags["name"]         = "(" .. object.tags["official_ref"] .. ")"
               object.tags["official_ref"] = nil
            end
         end
      else
         if (( object.tags["name:signed"] == "no"   ) or
             ( object.tags["unsigned"]    == "yes"  )) then
            object.tags["name"] = "(" .. object.tags["name"]
            object.tags["name:signed"] = nil

            if ( object.tags["ref:signed"] == "no" ) then
               if ( object.tags["ref"] ~= nil ) then
                  object.tags["name"]       = object.tags["name"] .. ", " .. object.tags["ref"]
               end

               object.tags["ref"]        = nil
               object.tags["ref:signed"] = nil
            else
               if ( object.tags["official_ref"] ~= nil  ) then
                  object.tags["name"]         = object.tags["name"] .. ", " .. object.tags["official_ref"]
                  object.tags["official_ref"] = nil
               end
            end

            object.tags["name"] = object.tags["name"] .. ")"
         else
            if (( object.tags["ref"]        ~= nil  ) and
                ( object.tags["ref:signed"] == "no" )) then
               object.tags["name"]       = object.tags["name"] .. " (" .. object.tags["ref"] .. ")"
               object.tags["ref"]        = nil
               object.tags["ref:signed"] = nil
            else
               if ( object.tags["official_ref"] ~= nil  ) then
                  object.tags["name"]         = object.tags["name"] .. " (" .. object.tags["official_ref"] .. ")"
                  object.tags["official_ref"] = nil
               end
            end
         end
      end
   end

-- ----------------------------------------------------------------------------
-- Add "area=yes" if "place=square" - we can't rely on a list of polygon tags
-- to do that for us.
-- ----------------------------------------------------------------------------
   if (( object.tags["place"]   == "square" ) and
       ( object.tags["highway"] ~= nil      )) then
      object.tags["area"] = "yes"
   end

-- ----------------------------------------------------------------------------
-- natural=tree
-- in "points" as "0x6600"
-- 0x6600 is searchable via "Geographic Points / Land Features"
-- ----------------------------------------------------------------------------
   if ( object.tags["natural"] == "tree" ) then
      object = append_nonqa( object, object.tags["natural"] )
   end

-- ----------------------------------------------------------------------------
-- landuse=forest
-- natural=wood
-- (and a few outlier tags for the same thing)
-- Both are in "points" as "0x6618" and in polygons as "0x50"
-- On landuse=forest, append main tag and operator (if set)
-- On natural=wood, append B, C, M or just "()", based on leaf_type.
-- "0x6618" is searchable via "Geographic Points / Manmade Places"
-- A mid-green colour is used in QMapShack.
-- A "woodland" land cover appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if ( object.tags["natural"] == "forest" ) then
      object.tags["landuse"] = "forest"
      object.tags["natural"] = nil
   end

   if ( object.tags["boundary"] == "forest" ) then
      object.tags["landuse"] = "forest"
      object.tags["boundary"] = nil
   end

   if (( object.tags["landuse"] == "forest"   ) or
       ( object.tags["landuse"] == "forestry" )) then
      object = append_nonqa( object, object.tags["landuse"] )

      if ( object.tags["operator"] ~= nil ) then
         object = append_nonqa( object, object.tags["operator"] )
      end
   end

   if ( object.tags["natural"] == "wood" ) then
      leaf_type_appendix = ""

      if ( object.tags["leaf_type"] == "broadleaved" ) then
         leaf_type_appendix = "B"
      end

      if ( object.tags["leaf_type"] == "needleleaved" ) then
         leaf_type_appendix = "C"
      end

      if ( object.tags["leaf_type"] == "mixed" ) then
         leaf_type_appendix = "M"
      end

      if ( leaf_type_appendix ~= nil ) then
         object = append_nonqa( object, leaf_type_appendix ) 
      end
   end

-- ----------------------------------------------------------------------------
-- Remove "real_ale" tag on industrial and craft breweries that aren't also
-- a pub, bar, restaurant, cafe etc. or hotel.
-- ----------------------------------------------------------------------------
   if ((( object.tags["industrial"] == "brewery" ) or
        ( object.tags["craft"]      == "brewery" )) and
       (  object.tags["real_ale"]   ~= nil        ) and
       (  object.tags["real_ale"]   ~= "maybe"    ) and
       (  object.tags["real_ale"]   ~= "no"       ) and
       (  object.tags["amenity"]    == nil        ) and
       (  object.tags["tourism"]    ~= "hotel"    )) then
      object.tags["real_ale"] = nil
      object.tags["real_cider"] = nil
   end

-- ----------------------------------------------------------------------------
-- Remove "shop" tag on industrial or craft breweries.
-- We pick one thing to display them as, and in this case it's "brewery"...
-- ----------------------------------------------------------------------------
   if ((( object.tags["industrial"] == "brewery" ) or
        ( object.tags["craft"]      == "brewery" ) or
        ( object.tags["craft"]      == "cider"   )) and
       (  object.tags["shop"]       ~= nil        )) then
      object.tags["shop"] = nil
   end

-- ----------------------------------------------------------------------------
-- Mistaggings for wastewater_plant
-- "(sewage)" is appended below.
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

-- ----------------------------------------------------------------------------
-- Bus depots
-- "0x6405  Civil" is in points as "amenity=bus_depot" 
-- and is searchable via "Geographic Points / Manmade Places"
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"]    == "bus_depot" ) then
      object = append_nonqa( object, "amenity" )
      object = append_nonqa( object, object.tags["amenity"] )
      object.tags["landuse"] = nil
      object = building_or_landuse( objtype, object )
   end

   if (( object.tags["landuse"]    == "industrial"             ) and
       ( object.tags["industrial"] == "bus_depot"              )) then
      object = append_nonqa( object, object.tags["landuse"] )
      object = append_nonqa( object, object.tags["industrial"] )
      object.tags["landuse"] = nil
      object.tags["amenity"] = "bus_depot"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Other depots and fuel depots etc.
-- "0x6405  Civil" is in points as "amenity=depot" 
-- and is searchable via "Geographic Points / Manmade Places"
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"]    == "depot"      ) or
       ( object.tags["amenity"]    == "fuel_depot" ) or
       ( object.tags["amenity"]    == "scrapyard"  )) then
      object = append_nonqa( object, "amenity" )
      object = append_nonqa( object, object.tags["amenity"] )
      object.tags["amenity"] = "depot"
      object.tags["landuse"] = nil
      object = building_or_landuse( objtype, object )
   end

   if ((  object.tags["landuse"]    == "industrial"          ) and
       (( object.tags["industrial"] == "depot"              )  or
        ( object.tags["industrial"] == "fuel_depot"         ))) then
      object = append_nonqa( object, object.tags["landuse"] )
      object = append_nonqa( object, object.tags["industrial"] )
      object.tags["landuse"] = nil
      object.tags["amenity"] = "depot"
      object = building_or_landuse( objtype, object )
   end

   if (  object.tags["landuse"] == "depot" ) then
      object = append_nonqa( object, "landuse" )
      object = append_nonqa( object, object.tags["landuse"] )
      object.tags["landuse"] = nil
      object.tags["amenity"] = "depot"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Various industrial landuse
-- Add a suffix for any existing landuse=industrial, and also for some other
-- tags that map through.
-- This tag is also used by the building_or_landuse function (no suffix there
-- obviously as it's not representing industrial landuse there)
--
-- Also append suffix for landuse=brownfield and landuse=construction
-- 0x0c is used in polygons for these
-- ----------------------------------------------------------------------------
   if ((( object.tags["landuse"]    == "industrial"             )  and
        ( object.tags["industrial"] ~= "bus_depot"              )  and
        ( object.tags["industrial"] ~= "depot"                  )) or
       (  object.tags["landuse"]    == "brownfield"              ) or
       (  object.tags["landuse"]    == "construction"            )) then
      object = append_nonqa( object, object.tags["landuse"] )
      object.tags["landuse"] = "industrial"
   end

   if (( object.tags["craft"]      == "bakery"                 ) or
       ( object.tags["craft"]      == "distillery"             ) or
       ( object.tags["craft"]      == "sawmill"                )) then
      object = append_nonqa( object, object.tags["craft"] )
      object.tags["craft"] = nil
      object.tags["landuse"] = "industrial"
   end

   if (( object.tags["industrial"] == "auto_wrecker"           ) or 
       ( object.tags["industrial"] == "automotive_industry"    ) or 
       ( object.tags["industrial"] == "bakery"                 ) or 
       ( object.tags["industrial"] == "checkpoint"             ) or 
       ( object.tags["industrial"] == "chemical"               ) or 
       ( object.tags["industrial"] == "concrete_plant"         ) or 
       ( object.tags["industrial"] == "construction"           ) or 
       ( object.tags["industrial"] == "distillery"             ) or 
       ( object.tags["industrial"] == "distributor"            ) or 
       ( object.tags["industrial"] == "electrical"             ) or 
       ( object.tags["industrial"] == "engineering"            ) or
       ( object.tags["industrial"] == "factory"                ) or 
       ( object.tags["industrial"] == "fish_farm"              ) or 
       ( object.tags["industrial"] == "furniture"              ) or 
       ( object.tags["industrial"] == "gas"                    ) or 
       ( object.tags["industrial"] == "haulage"                ) or
       ( object.tags["industrial"] == "machine_shop"           ) or
       ( object.tags["industrial"] == "machinery"              ) or
       ( object.tags["industrial"] == "metal_finishing"        ) or
       ( object.tags["industrial"] == "mobile_equipment"       ) or
       ( object.tags["industrial"] == "oil"                    ) or
       ( object.tags["industrial"] == "packaging"              ) or
       ( object.tags["industrial"] == "sawmill"                ) or
       ( object.tags["industrial"] == "scaffolding"            ) or 
       ( object.tags["industrial"] == "scrap_yard"             ) or 
       ( object.tags["industrial"] == "shop_fitters"           ) or 
       ( object.tags["industrial"] == "waste_handling"         ) or 
       ( object.tags["industrial"] == "warehouse"              ) or
       ( object.tags["industrial"] == "woodworking"            ) or
       ( object.tags["industrial"] == "yard"                   ) or 
       ( object.tags["industrial"] == "yes"                    )) then
      object = append_nonqa( object, object.tags["industrial"] )
   end

   if (( object.tags["man_made"]   == "gas_station"            ) or
       ( object.tags["man_made"]   == "gas_works"              ) or
       ( object.tags["man_made"]   == "water_treatment"        )) then
      object = append_nonqa( object, object.tags["man_made"] )
      object.tags["man_made"] = nil
      object.tags["landuse"] = "industrial"
   end

   if ( object.tags["power"]      == "plant"                  ) then
      object = append_nonqa( object, object.tags["power"] )
      object.tags["power"] = nil
      object.tags["landuse"] = "industrial"
   end

   if ( object.tags["parking"]   == "depot" ) then
      object = append_nonqa( object, object.tags["parking"] )
      object.tags["landuse"] = "industrial"
      object.tags["parking"] = nil
   end

-- ----------------------------------------------------------------------------
-- Add suffix for landfill
-- 0x0c is used in polygons
-- ----------------------------------------------------------------------------
   if ( object.tags["landuse"] == "landfill" ) then
      object = append_nonqa( object, object.tags["landuse"] )
   end

-- ----------------------------------------------------------------------------
-- Handle spoil heaps as landfill
-- ----------------------------------------------------------------------------
   if ( object.tags["man_made"] == "spoil_heap" ) then
      object = append_nonqa( object, object.tags["man_made"] )
      object.tags["landuse"] = "landfill"
      object.tags["man_made"] = nil
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
-- man_made=marker etc.
-- For historic markers see "Historic markers" below.
-- In "points" as "0x4c00"
-- "0x4c00" is searchable via "Geographic Points / Manmade Places"
-- No icon is visible in QMapShack
-- A "tourist information" icon appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if ( object.tags["man_made"] == "marker" ) then
      object = append_nonqa( object, "marker" )
   end

-- ----------------------------------------------------------------------------
-- amenity=bbq and other small amenities
-- "man_made=thing" is in "points" as "0x2f14"
-- "0x2f14" is searchable via "Others / Social Service"
-- A dot appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"]       == "hunting_stand" )   and
       ( object.tags["hunting_stand"] == "grouse_butt"   )) then
      object.tags["amenity"] = object.tags["hunting_stand"]
   end

   if ( object.tags["man_made"] == "grouse_butt" ) then
      object.tags["amenity"] = object.tags["man_made"]
      object.tags["man_made"] = nil
   end

   if ((  object.tags["amenity"] == "bbq"             ) or
       (  object.tags["amenity"] == "compressed_air"  ) or
       (  object.tags["amenity"] == "grit_bin"        ) or
       (  object.tags["amenity"] == "grouse_butt"     ) or
       (  object.tags["amenity"] == "hunting_stand"   ) or
       (( object.tags["amenity"] == "waste_basket"   )  and
        ( object.tags["highway"] ==  nil             )) or
       (  object.tags["amenity"] == "watering_place"  )) then
      object = append_nonqa( object, object.tags["amenity"] )
      object.tags["man_made"] = "thing"
      object.tags["amenity"] = nil
   end

-- ----------------------------------------------------------------------------
-- Non-utility posts
-- (for utility posts see below)
-- ----------------------------------------------------------------------------
   if (( object.tags["marker"]   == "post"  ) and
       (( object.tags["utility"] == nil    )  or
        ( object.tags["utility"] == "yes"  ))) then
      object = append_nonqa( object, "post" )
      object.tags["man_made"] = "marker"
   end

-- ----------------------------------------------------------------------------
-- Handle various sorts of milestones.
-- man_made=marker
-- In "points" as "0x4c00"
-- "0x4c00" is searchable via "Geographic Points / Manmade Places"
-- A "tourist information" icon appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if (( object.tags["historic"] == "milestone" )  or
       ( object.tags["historic"] == "milepost"  )  or
       ( object.tags["highway"]  == "milestone" )  or
       ( object.tags["railway"]  == "milestone" )  or
       ( object.tags["waterway"] == "milestone" )) then
      object = append_nonqa( object, "milestone" )
      object.tags["man_made"] = "marker"
   end

-- ----------------------------------------------------------------------------
-- Aerial markers for pipelines etc. and other utilities
-- Non-utility marker posts are handled above
-- Non-utility "marker=yes", "marker=pedestal", "marker=plate" and 
-- "marker=pole" are ignored.
-- In "points" as "0x4c00"
-- "0x4c00" is searchable via "Geographic Points / Manmade Places"
-- No icon is visible in QMapShack
-- A "tourist information" icon appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if ((   object.tags["marker"]   == "aerial"           ) or
       (   object.tags["marker"]   == "pipeline"         ) or
       (   object.tags["man_made"] == "marker"           ) or
       (   object.tags["man_made"] == "pipeline_marker"  ) or
       (   object.tags["pipeline"] == "marker"           ) or
       ((( object.tags["marker"]   == "post"           )   or
         ( object.tags["marker"]   == "yes"            )   or
         ( object.tags["marker"]   == "pedestal"       )   or
         ( object.tags["marker"]   == "plate"          )   or
         ( object.tags["marker"]   == "pole"           ))  and
        ( object.tags["utility"]   ~= nil               )  and
        ( object.tags["utility"]   ~= "yes"             ))) then
      object = append_nonqa( object, "utility/pipeline marker" )

      if ( object.tags["utility"] ~= nil ) then
         append_nonqa( object, object.tags["utility"] )
      end

      if ( object.tags["ref"] ~= nil ) then
         append_nonqa( object, object.tags["ref"] )
      end

      object.tags["man_made"] = "marker"
   end

-- ----------------------------------------------------------------------------
-- Boundary stones.  If they're already tagged as tourism=attraction, remove
-- that tag.
-- Note that "marker=stone" (for "non boundary stones") are handled elsewhere.
-- ----------------------------------------------------------------------------
   if (( object.tags["historic"]    == "boundary_stone"  )  or
       ( object.tags["historic"]    == "boundary_marker" )  or
       ( object.tags["man_made"]    == "boundary_marker" )  or
       ( object.tags["man_made"]    == "boundary_stone"  )  or
       ( object.tags["marker"]      == "boundary_stone"  )  or
       ( object.tags["boundary"]    == "marker"          )  or
       ( object.tags["designation"] == "March Stone"     )) then
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

      object = append_nonqa( object, "historic stone" )
   end

   if (( object.tags["historic"]   == "bullaun_stone" ) or
       ( object.tags["historic"]   == "stone"         )) then
      object = append_nonqa( object, "historic" )
      object = append_nonqa( object, object.tags["historic"] )
      object.tags["man_made"] = "marker"

      if ( object.tags["inscription"] ~= nil ) then
         object = append_nonqa( object, object.tags["inscription"] )
      end
   end

-- ----------------------------------------------------------------------------
-- Some tumuli are tagged as tombs, so dig those out first.
-- ----------------------------------------------------------------------------
   if (( object.tags["historic"] == "tomb"    ) and
       ( object.tags["tomb"]     == "tumulus" )) then
         object.tags["historic"]            = "archaeological_site"
         object.tags["archaeological_site"] = "tumulus"
   end

   if ((   object.tags["historic"]            == "standing_stone"        ) or
       ((  object.tags["historic"]            == "archaeological_site"  )  and
        (( object.tags["archaeological_site"] == "standing_stone"      )   or
         ( object.tags["archaeological_site"] == "megalith"            )   or
         ( object.tags["site_type"]           == "standing_stone"      )   or
         ( object.tags["site_type"]           == "megalith"            )))) then
      object.tags["man_made"] = "marker"

      if ( object.tags["inscription"] ~= nil ) then
         object = append_nonqa( object, object.tags["inscription"] )
      end

      object = append_nonqa( object, "standing stone" )
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
-- Telephone boxes and former telephone boxes
--
-- amenity=telephone
-- In "points" as "0x5100"
-- "0x5100" is searchable via "Geographic Points / Manmade Places",
-- No icon appears in QMapShack
-- A "telephone" icon appears on a GPSMAP64s
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
       (  object.tags["booth"]           == "K4 Post Office"  )  or
       (  object.tags["booth"]           == "K6"              )  or
       (  object.tags["booth"]           == "K8"              )  or
       (  object.tags["telephone_kiosk"] == "K6"              )  or
       (  object.tags["man_made"]        == "telephone_box"   )  or
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
      	 object = append_nonqa( object, object.tags["amenity"] )

         if ( object.tags["colour"] ~= nil ) then
      	    object = append_nonqa( object, object.tags["colour"] )
         end

         object.tags["amenity"] = "telephone"
         object.tags["tourism"] = nil
         object.tags["emergency"] = nil
      else
         if ( object.tags["emergency"] == "defibrillator" ) then
            object.tags["amenity"] = "telephone"
      	    object = append_nonqa( object, "fmr phone defib" )
         else
            if (( object.tags["amenity"] == "public_bookcase" )  or
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
-- amenity=courthouse
-- In "points" as "0x3004"
-- "0x3004" is searchable via "Community / Court House"
-- A "public building" icon appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if (  object.tags["amenity"] == "courthouse" ) then
      object = append_nonqa( object, object.tags["amenity"] )
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Community Centres etc.
-- "0x3005" is searchable via "Community / Community Center"
-- ----------------------------------------------------------------------------
   if (((   object.tags["building"] == "community_centre"     )  or
        (   object.tags["building"] == "scout_hut"            )  or
        (   object.tags["building"] == "clubhouse"            )  or
        (   object.tags["building"] == "club_house"           )  or
        ((  object.tags["building"] ~= nil                   )   and
         (( object.tags["name"]     == "Scout Hut"          )    or
          ( object.tags["name"]     == "Scout hut"          )    or
          ( object.tags["name"]     == "Scout Hall"         )))) and
       ((   object.tags["amenity"]  == nil                    )  and
        (   object.tags["leisure"]  == nil                    )  and
        (   object.tags["office"]   == nil                    )  and
        (   object.tags["shop"]     == nil                    ))) then
      object.tags["amenity"] = object.tags["building"]
   end

   if ((  object.tags["leisure"]  == "social_club"          ) or
       (( object.tags["leisure"]  == "sport"               )  and
        ( object.tags["sport"]    ~= "golf"                ))) then
      object.tags["amenity"] = object.tags["leisure"]
   end

   if ( object.tags["healthcare"]  == "health_centre" ) then
      object.tags["amenity"] = object.tags["healthcare"]
   end

   if (( object.tags["amenity"]  == "care_home"                ) or
       ( object.tags["amenity"]  == "childcare"                ) or
       ( object.tags["amenity"]  == "childrens_centre"         ) or
       ( object.tags["amenity"]  == "church_hall"              ) or
       ( object.tags["amenity"]  == "club"                     ) or
       ( object.tags["amenity"]  == "club_house"               ) or
       ( object.tags["amenity"]  == "clubhouse"                ) or
       ( object.tags["amenity"]  == "community_centre"         ) or
       ( object.tags["amenity"]  == "community_hall"           ) or
       ( object.tags["amenity"]  == "dancing_school"           ) or
       ( object.tags["amenity"]  == "daycare"                  ) or
       ( object.tags["amenity"]  == "function_room"            ) or
       ( object.tags["amenity"]  == "health_centre"            ) or
       ( object.tags["amenity"]  == "hospice"                  ) or
       ( object.tags["amenity"]  == "medical_centre"           ) or
       ( object.tags["amenity"]  == "nursery"                  ) or
       ( object.tags["amenity"]  == "nursery_school"           ) or
       ( object.tags["amenity"]  == "nursing_home"             ) or
       ( object.tags["amenity"]  == "outdoor_education_centre" ) or
       ( object.tags["amenity"]  == "preschool"                ) or
       ( object.tags["amenity"]  == "public_bath"              ) or
       ( object.tags["amenity"]  == "residential_home"         ) or
       ( object.tags["amenity"]  == "retirement_home"          ) or
       ( object.tags["amenity"]  == "scout_hall"               ) or
       ( object.tags["amenity"]  == "scout_hut"                ) or
       ( object.tags["amenity"]  == "sheltered_housing"        ) or
       ( object.tags["amenity"]  == "social_centre"            ) or
       (( object.tags["amenity"]  == "social_facility"        )  and
        ( object.tags["social_facility"] == nil               )) or
       ( object.tags["amenity"]  == "social_club"              ) or
       ( object.tags["amenity"]  == "sport"                    ) or
       ( object.tags["amenity"]  == "working_mens_club"        ) or
       ( object.tags["amenity"]  == "youth_centre"             ) or
       ( object.tags["amenity"]  == "youth_club"               )) then
      object = append_nonqa( object, object.tags["amenity"] )

      if ( object.tags["community_centre"]  ~= nil ) then
         object = append_nonqa( object, object.tags["community_centre"] )
      end

      if ( object.tags["community_centre:for"]  ~= nil ) then
         object = append_nonqa( object, object.tags["community_centre:for"] )
      end

      if ( object.tags["social_centre"]  ~= nil ) then
         object = append_nonqa( object, object.tags["social_centre"] )
      end

      if ( object.tags["social_centre:for"]  ~= nil ) then
         object = append_nonqa( object, object.tags["social_centre:for"] )
      end

      if ( object.tags["social_facility"]  ~= nil ) then
         object = append_nonqa( object, object.tags["social_facility"] )
      end

      if ( object.tags["social_facility:for"]  ~= nil ) then
         object = append_nonqa( object, object.tags["social_facility:for"] )
      end

      if ( object.tags["club"]  ~= nil ) then
         object = append_nonqa( object, object.tags["club"] )
      end

      object.tags["amenity"] = "community_centre"
      object = building_or_landuse( objtype, object )
   end

   if (( object.tags["club"]     == "scout"                ) or
       ( object.tags["club"]     == "scouts"               ) or
       ( object.tags["club"]     == "sport"                ) or
       ((( object.tags["club"]    == "yes"               )   or
         ( object.tags["club"]    == "social"            )   or
         ( object.tags["club"]    == "freemasonry"       )   or
         ( object.tags["club"]    == "sailing"           )   or
         ( object.tags["club"]    == "youth"             )   or
         ( object.tags["club"]    == "politics"          )   or
         ( object.tags["club"]    == "veterans"          )   or
         ( object.tags["club"]    == "social_club"       )   or
         ( object.tags["club"]    == "music"             )   or
         ( object.tags["club"]    == "working_men"       )   or
         ( object.tags["club"]    == "yachting"          )   or
         ( object.tags["club"]    == "tennis"            )   or
         ( object.tags["club"]    == "army_cadets"       )   or
         ( object.tags["club"]    == "sports"            )   or
         ( object.tags["club"]    == "rowing"            )   or
         ( object.tags["club"]    == "football"          )   or
         ( object.tags["club"]    == "snooker"           )   or
         ( object.tags["club"]    == "fishing"           )   or
         ( object.tags["club"]    == "sea_scout"         )   or
         ( object.tags["club"]    == "conservative"      )   or
         ( object.tags["club"]    == "golf"              )   or
         ( object.tags["club"]    == "cadet"             )   or
         ( object.tags["club"]    == "youth_movement"    )   or
         ( object.tags["club"]    == "bridge"            )   or
         ( object.tags["club"]    == "bowling"           )   or
         ( object.tags["club"]    == "air_cadets"        )   or
         ( object.tags["club"]    == "scuba_diving"      )   or
         ( object.tags["club"]    == "model_railway"     )   or
         ( object.tags["club"]    == "boat"              )   or
         ( object.tags["club"]    == "card_games"        )   or
         ( object.tags["club"]    == "girlguiding"       )   or
         ( object.tags["club"]    == "guide"             )   or
         ( object.tags["club"]    == "photography"       )   or
         ( object.tags["club"]    == "sea_cadets"        )   or
         ( object.tags["club"]    == "theatre"           )   or
         ( object.tags["club"]    == "women"             )   or
         ( object.tags["club"]    == "charity"           )   or
         ( object.tags["club"]    == "bowls"             )   or
         ( object.tags["club"]    == "military"          )   or
         ( object.tags["club"]    == "model_aircraft"    )   or
         ( object.tags["club"]    == "labour_club"       )   or
         ( object.tags["club"]    == "boxing"            )   or
         ( object.tags["club"]    == "game"              )   or
         ( object.tags["club"]    == "automobile"        ))  and
        (  object.tags["leisure"] == nil                  )  and
        (  object.tags["amenity"] == nil                  )  and
        (  object.tags["shop"]    == nil                  )  and
        (  object.tags["name"]    ~= nil                  )) or
       ((  object.tags["club"]    == "cricket"            )  and
        (  object.tags["leisure"] == nil                  )  and
        (  object.tags["amenity"] == nil                  )  and
        (  object.tags["shop"]    == nil                  )  and
        (  object.tags["landuse"] == nil                  )  and
        (  object.tags["name"]    ~= nil                  ))) then
      object = append_nonqa( object, object.tags["club"] )
      object.tags["amenity"] = "community_centre"
      object = building_or_landuse( objtype, object )
   end

   if (( object.tags["leisure"]        == nil            )  and
       ( object.tags["amenity"]        == nil            )  and
       ( object.tags["shop"]           == nil            )  and
       ( object.tags["dance:teaching"] == "yes"          )) then
      object.tags["leisure"] = "dance:teaching"
   end

   if (( object.tags["sport"]    == "yoga"               )  and
       ( object.tags["shop"]     == nil                  )  and
       ( object.tags["amenity"]  == nil                  )) then
      object.tags["leisure"] = object.tags["sport"]
   end

   if (( object.tags["leisure"]  == "club"                 ) or
       ( object.tags["leisure"]  == "dance"                ) or
       ( object.tags["leisure"]  == "dance:teaching"       ) or
       ( object.tags["leisure"]  == "climbing"             ) or
       ( object.tags["leisure"]  == "high_ropes_course"    ) or
       ( object.tags["leisure"]  == "hackerspace"          ) or
       ( object.tags["leisure"]  == "sailing_club"         ) or
       ( object.tags["leisure"]  == "yoga"                 )) then
      object = append_nonqa( object, object.tags["leisure"] )
      object.tags["amenity"] = "community_centre"
      object = building_or_landuse( objtype, object )
   end

   if ((( object.tags["amenity"]         == nil                    )  or
        ( object.tags["amenity"]         == "social_facility"      )) and
       (( object.tags["social_facility"] == "group_home"           )   or
        ( object.tags["social_facility"] == "nursing_home"         )   or
        ( object.tags["social_facility"] == "assisted_living"      )   or
        ( object.tags["social_facility"] == "care_home"            )   or
        ( object.tags["social_facility"] == "shelter"              )   or
        ( object.tags["social_facility"] == "day_care"             )   or
        ( object.tags["social_facility"] == "day_centre"           )   or
        ( object.tags["social_facility"] == "food_bank"            )   or
        ( object.tags["social_facility"] == "outreach"             )   or
        ( object.tags["social_facility"] == "residential_home"     ))) then
      object = append_nonqa( object, object.tags["social_facility"] )
      object.tags["amenity"] = "community_centre"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- barrier=border_control
-- government=customs
-- Both are in "points" as "0x3006" 
-- "0x3006" is searchable via "Community / Border Crossing"
-- A unique icon appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if ( object.tags["barrier"] == "border_control"   ) then
      object = append_nonqa( object, object.tags["barrier"] )
      object = building_or_landuse( objtype, object )
   end

   if ( object.tags["government"]  == "customs" ) then
      object = append_nonqa( object, object.tags["government"] )
      object.tags["government"] = "customs"
      object.tags["amenity"] = nil
      object.tags["office"] = nil
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Government offices
-- "0x3007" is searchable via "Community / Government Office"
-- ----------------------------------------------------------------------------
   if (( object.tags["office"] == "government"     ) or
       ( object.tags["office"] == "police"         ) or
       ( object.tags["office"] == "administrative" ) or
       ( object.tags["office"] == "register"       ) or
       ( object.tags["office"] == "council"        ) or
       ( object.tags["office"] == "drainage_board" ) or
       ( object.tags["office"] == "forestry"       ) or
       ( object.tags["office"] == "justice"        )) then
      object = append_nonqa( object, object.tags["office"] )
      object.tags["amenity"] = nil
      object.tags["office"] = "government"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- amenity=public_building
-- "0x3007" is searchable via "Community / Government Office"
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "public_building" ) then
      object = append_nonqa( object, object.tags["amenity"] )
      object.tags["amenity"]    = nil
      object.tags["office"]     = "government"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- amenity=prison
-- "0x3007" is searchable via "Community / Government Office"
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "prison" ) then
      object = append_nonqa( object, object.tags["amenity"] )
      object.tags["amenity"]    = nil
      object.tags["office"]     = "government"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Show various diplomatic things
-- Embassies and embassy-adjacent things first.
-- "0x3007" is searchable via "Community / Government Office"
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "embassy" ) then
      object.tags["diplomatic"] = object.tags["amenity"]
      object.tags["amenity"]    = nil
   end

   if ((  object.tags["diplomatic"] == "embassy"            )  and
       (( object.tags["embassy"]    == nil                 )   or
        ( object.tags["embassy"]    == "yes"               ))) then
      object.tags["diplomatic"] = "embassy"
   end

   if ((  object.tags["diplomatic"] == "embassy"            )  and
       (( object.tags["embassy"]    == "high_commission"   )   or
        ( object.tags["embassy"]    == "nunciature"        )   or
        ( object.tags["embassy"]    == "delegation"        ))) then
      object.tags["diplomatic"] = object.tags["embassy"]
   end

   if ((  object.tags["diplomatic"] == "consulate"          )  and
       (( object.tags["consulate"]  == nil                 )   or
        ( object.tags["consulate"]  == "yes"               ))) then
      object.tags["diplomatic"] = "consulate"
   end

   if ( object.tags["consulate"]  == "consulate_general" ) then
      object.tags["diplomatic"] = object.tags["consulate"]
   end

   if (( object.tags["diplomatic"] == "embassy"               ) or
       ( object.tags["diplomatic"] == "consulate"             ) or
       ( object.tags["diplomatic"] == "high_commission"       ) or
       ( object.tags["diplomatic"] == "nunciature"            ) or
       ( object.tags["diplomatic"] == "delegation"            ) or
       ( object.tags["diplomatic"] == "consulate_general"     ) or
       ( object.tags["diplomatic"] == "embassy;consulate"     ) or
       ( object.tags["diplomatic"] == "embassy;mission"       ) or
       ( object.tags["diplomatic"] == "consulate;embassy"     )) then

      if ( object.tags["country"] == nil ) then
         object.tags["country"] = "unknown"
      end

      object = append_nonqa( object, object.tags["diplomatic"] .. " " .. object.tags["country"] )
      object.tags["amenity"]    = nil
      object.tags["diplomatic"] = nil
      object.tags["office"]     = "government"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- More diplomatic things
-- Offices and office-adjacent things next.
-- ----------------------------------------------------------------------------
   if ((  object.tags["diplomatic"] == "embassy"              )  and
       ( object.tags["embassy"]     == "residence"            )) then
      object.tags["diplomatic"] = "residence"
   end

   if ((  object.tags["diplomatic"] == "embassy"              )  and
       (( object.tags["embassy"]     == "branch_embassy"     )   or
        ( object.tags["embassy"]    == "mission"             ))) then
      object.tags["diplomatic"] = object.tags["embassy"]
   end

   if ((  object.tags["diplomatic"] == "consulate"            )  and
       (( object.tags["consulate"]  == "consular_office"     )   or
        ( object.tags["consulate"]  == "residence"           )   or
        ( object.tags["consulate"]  == "consular_agency"     ))) then
      object.tags["diplomatic"] = object.tags["consulate"]
   end

   if ((   object.tags["diplomatic"] == "permanent_mission"     ) or
       (   object.tags["diplomatic"] == "trade_delegation"      ) or
       (   object.tags["diplomatic"] == "liaison"               ) or
       (   object.tags["diplomatic"] == "non_diplomatic"        ) or
       (   object.tags["diplomatic"] == "mission"               ) or
       (   object.tags["diplomatic"] == "trade_mission"         ) or
       (   object.tags["diplomatic"] == "residence"             ) or
       (   object.tags["diplomatic"] == "branch_embassy"        ) or
       (   object.tags["diplomatic"] == "consulate"             ) or
       (   object.tags["diplomatic"] == "consular_office"       ) or
       (   object.tags["diplomatic"] == "consular_agency"       )) then

      if ( object.tags["country"] == nil ) then
         object.tags["country"] = "unknown"
      end

      object = append_nonqa( object, object.tags["diplomatic"] .. " " .. object.tags["country"] )
      object.tags["amenity"]    = nil
      object.tags["diplomatic"] = nil

-- ----------------------------------------------------------------------------
-- "office" is set to something that will definitely display here, just in case
-- it was set to some value that would not.
-- ----------------------------------------------------------------------------
      object.tags["office"] = "yes"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- amenity=fire_station
-- "0x3008" is searchable via "Community / Fire Department"
-- ----------------------------------------------------------------------------
   if (  object.tags["emergency"]  == "fire_station" ) then
      object.tags["amenity"] = object.tags["emergency"]
   end

   if ( object.tags["amenity"]  == "fire_station" ) then
      object = append_nonqa( object, object.tags["amenity"] )
      object.tags["office"] = nil
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- landuse=harbour and leisure=marina
-- In "points" as "0x4300", in "polygons" as "0x09"
-- "0x4300" is searchable via "Geographic Points / Water Features"
-- An "anchor" icon appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if ( object.tags["landuse"]  == "harbour" ) then
      object = append_nonqa( object, object.tags["landuse"] )
      object.tags["leisure"] = "marina"
   end

   if ( object.tags["leisure"]  == "marina" ) then
      object = append_nonqa( object, object.tags["leisure"] )
   end

-- ----------------------------------------------------------------------------
-- leisure=nature_reserve
-- In "points" as "0x6612", in "polygons" as "0x18"
-- "0x6612" is searchable via "Geographic Points / Land Features"
-- An dot appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if ( object.tags["leisure"]  == "nature_reserve" ) then
      object = append_nonqa( object, object.tags["leisure"] )
   end

-- ----------------------------------------------------------------------------
-- man_made=petroleum_well
-- This might be either a building or not.
-- ----------------------------------------------------------------------------
   if ( object.tags["man_made"] == "petroleum_well" ) then
      object = append_nonqa( object, "petroleum well" )
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- man_made=pumping_station
-- This might be either a building or not.
-- ----------------------------------------------------------------------------
   if ( object.tags["man_made"] == "pumping_station" ) then
      object = append_nonqa( object, "pumping station" )
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- man_made=reservoir_covered
-- Always treat as a building.
-- ----------------------------------------------------------------------------
   if ( object.tags["man_made"] == "reservoir_covered" ) then
      object = append_nonqa( object, "reservoir covered" )
      object.tags["building"] = "yes"
   end

-- ----------------------------------------------------------------------------
-- man_made=water_works
-- This might be either a building or not.
-- ----------------------------------------------------------------------------
   if ( object.tags["man_made"] == "water_works" ) then
      object = append_nonqa( object, "water works" )
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- man_made=works
-- This might be either a building or not.
-- ----------------------------------------------------------------------------
   if ( object.tags["man_made"] == "works" ) then
      object = append_nonqa( object, "works" )
      object = building_or_landuse( objtype, object )
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
-- 0x6511 is searchable via "Geographic Points / Water Features"
-- ----------------------------------------------------------------------------
   if ( object.tags["man_made"] == "water_well" ) then
      object.tags["natural"] = "spring"
      object = append_nonqa( object, "well" )
   end

-- ----------------------------------------------------------------------------
-- cave_of_debouchement
-- 0x6511 is searchable via "Geographic Points / Water Features"
-- ----------------------------------------------------------------------------
   if ( object.tags["waterway"]   == "cave_of_debouchement" ) then
      object.tags["natural"] = "spring"
      object = append_nonqa( object, object.tags["waterway"] )
   end

-- ----------------------------------------------------------------------------
-- amenity=drinking_water
-- In "points" as "0x5000"
-- "0x5000" is searchable via "Geographic Points / Water Features"
-- A "water tap" icon appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "drinking_water" ) then
      object = append_nonqa( object, object.tags["amenity"] )
   end

-- ----------------------------------------------------------------------------
-- man_made=water_tap
-- Mapped through to amenity=drinking_water (in "points", see elsewhere).
-- ----------------------------------------------------------------------------
   if (( object.tags["man_made"] == "water_tap" ) and
       ( object.tags["amenity"]  == nil         )) then
      object.tags["amenity"] = "drinking_water"
      object.tags["man_made"] = nil
      object = append_nonqa( object, "tap" )
   end

-- ----------------------------------------------------------------------------
-- amenity=fountain
-- Mapped through to 0x6509 ("Geyser") in "points".
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "fountain" ) then
      object = append_nonqa( object, object.tags["amenity"] )
   end

-- ----------------------------------------------------------------------------
-- amenity=grave_yard
-- landuse=cemetery
-- Both are in "points" as "0x6403" 
-- "0x6403" is searchable via "Geographic Points / Manmade Places",
-- A gravestone icon appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if ( object.tags["landuse"] == "grave_yard" ) then
      object.tags["amenity"] = object.tags["landuse"]
      object.tags["landuse"] = nil
   end

   if ( object.tags["amenity"] == "grave_yard" ) then
      object = append_nonqa( object, object.tags["amenity"] )
   end

   if ( object.tags["landuse"] == "cemetery" ) then
      object = append_nonqa( object, object.tags["landuse"] )
   end

-- ----------------------------------------------------------------------------
-- Beer gardens etc.
-- Set tags so that these can be handled below.
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
   end

-- ----------------------------------------------------------------------------
-- We don't show landuse=farmland here (yet)
-- We also don't show farmland processed in style.lua as "landuse=farmgrass"
-- We do process meadows here that would process as "farmgrass" so that
-- they don't (yet) get handled as meadows.
-- ----------------------------------------------------------------------------
   if ((  object.tags["landuse"]  == "meadow"        ) and
       (( object.tags["meadow"]   == "agricultural" )  or
        ( object.tags["meadow"]   == "paddock"      )  or
        ( object.tags["meadow"]   == "pasture"      )  or
        ( object.tags["meadow"]   == "agriculture"  )  or
        ( object.tags["meadow"]   == "hay"          )  or
        ( object.tags["meadow"]   == "managed"      )  or
        ( object.tags["meadow"]   == "cut"          )  or
        ( object.tags["animal"]   == "pig"          )  or
        ( object.tags["animal"]   == "sheep"        )  or
        ( object.tags["animal"]   == "cow"          )  or
        ( object.tags["animal"]   == "cattle"       )  or
        ( object.tags["animal"]   == "chicken"      )  or
        ( object.tags["animal"]   == "horse"        )  or
        ( object.tags["farmland"] == "field"        )  or
        ( object.tags["farmland"] == "pasture"      )  or
        ( object.tags["farmland"] == "crofts"       ))) then
      object.tags["landuse"] = nil
   end

-- ----------------------------------------------------------------------------
-- natural=scrub that is actually tagged as that
-- Not in points, in polygons as "0x4f".
-- Various other things map to natural=scrub below, with other appended names.
-- ----------------------------------------------------------------------------
   if ( object.tags["natural"] == "scrub" ) then
      object = append_nonqa( object, object.tags["natural"] )
   end

-- ----------------------------------------------------------------------------
-- Send parks through with "park" as a suffix.
--
-- In points:
-- "park" has a single tree icon
-- 0x2c06 is searchable via "Attractions / Park or Garden"
--
-- "unnamed_park" has a dot icon
-- 0x6600 is searchable via "Geographic Points / Land Features"
--
-- In polygons both are mapped to 0x17 resolution 20
-- ----------------------------------------------------------------------------
   if ( object.tags["leisure"] == "park" ) then
      if ( object.tags["name"] == nil ) then
         object.tags["leisure"] = "unnamed_park"
      else
         object.tags["leisure"] = "park"
      end

      object = append_nonqa( object, "park" )
   end

-- ----------------------------------------------------------------------------
-- Map various landuse to "park" or "unnamed_park"
--
-- In points:
-- "park" has a single tree icon
-- 0x2c06 is searchable via "Attractions / Park or Garden"
--
-- "unnamed_park" has a dot icon
-- 0x6600 is searchable via "Geographic Points / Land Features"
--
-- In polygons both are mapped to 0x17 resolution 20
-- ----------------------------------------------------------------------------
-- Render various synonyms for leisure=common.
-- ----------------------------------------------------------------------------
   if (( object.tags["landuse"]          == "common"   ) or
       ( object.tags["leisure"]          == "common"   ) or
       ( object.tags["designation"]      == "common"   ) or
       ( object.tags["amenity"]          == "common"   ) or
       ( object.tags["protection_title"] == "common"   )) then
      if ( object.tags["name"] == nil ) then
         object.tags["leisure"] = "unnamed_park"
      else
         object.tags["leisure"] = "park"
      end

      object.tags["landuse"] = nil
      object.tags["amenity"] = nil
      object = append_nonqa( object, "common" )
   end

-- ----------------------------------------------------------------------------
-- Map various landuse to "park" or "unnamed_park"
--
-- In points:
-- "park" has a single tree icon
-- 0x2c06 is searchable via "Attractions / Park or Garden"
--
-- "unnamed_park" has a dot icon
-- 0x6600 is searchable via "Geographic Points / Land Features"
--
-- In polygons both are mapped to 0x17 resolution 20
-- ----------------------------------------------------------------------------
   if ((  object.tags["leisure"]         == "outdoor_seating" ) and
       (( object.tags["surface"]         == "grass"          ) or
        ( object.tags["beer_garden"]     == "yes"            ) or
        ( object.tags["outdoor_seating"] == "garden"         ))) then
      object.tags["leisure"] = "garden"
      object.tags["garden"] = "beer_garden"
   end

   if ( object.tags["leisure"]   == "garden" ) then
      if ( object.tags["name"] == nil ) then
         object.tags["leisure"] = "unnamed_park"
      else
         object.tags["leisure"] = "park"
      end

      if ( object.tags["garden"] == "beer_garden" ) then
      	 object = append_nonqa( object, "beer garden" )
      else
      	 object = append_nonqa( object, "garden" )
      end
   end

   if (( object.tags["leisure"]   == "outdoor_seating" ) and
       ( object.tags["surface"]   == "grass"           )) then
      if ( object.tags["name"] == nil ) then
         object.tags["leisure"] = "unnamed_park"
      else
         object.tags["leisure"] = "park"
      end

      object = append_nonqa( object, "outdoor grass" )
   end

-- ----------------------------------------------------------------------------
-- recreation grounds
--
-- In points:
-- "park" has a single tree icon
-- 0x2c06 is searchable via "Attractions / Park or Garden"
--
-- "unnamed_park" has a dot icon
-- 0x6600 is searchable via "Geographic Points / Land Features"
--
-- In polygons both are mapped to 0x17 resolution 20
-- ----------------------------------------------------------------------------
   if (( object.tags["landuse"] == "recreation_ground" ) or
       ( object.tags["leisure"] == "recreation_ground" )) then
      if ( object.tags["name"] == nil ) then
         object.tags["leisure"] = "unnamed_park"
      else
         object.tags["leisure"] = "park"
      end

      object.tags["landuse"] = nil
      object = append_nonqa( object, "rec" )
   end

-- ----------------------------------------------------------------------------
-- Various sorts of grass (and similar)
--
-- In points:
-- "park" has a single tree icon
-- 0x2c06 is searchable via "Attractions / Park or Garden"
--
-- "unnamed_park" has a dot icon
-- 0x6600 is searchable via "Geographic Points / Land Features"
--
-- In polygons both are mapped to 0x17 resolution 20
-- ----------------------------------------------------------------------------
   if ( object.tags["landcover"] == "grass" ) then
      object.tags["landcover"] = nil
      object.tags["landuse"] = "grass"
   end

   if ( object.tags["leisure"] == "playground" ) then
      object.tags["landuse"] = object.tags["leisure"]
   end

   if (( object.tags["landuse"]   == "grass"         ) or
       ( object.tags["landuse"]   == "college_court" ) or
       ( object.tags["landuse"]   == "conservation"  ) or
       ( object.tags["landuse"]   == "flowerbed"     ) or
       ( object.tags["landuse"]   == "greenfield"    ) or
       ( object.tags["landuse"]   == "meadow"        ) or
       ( object.tags["landuse"]   == "playground"    ) or
       ( object.tags["landuse"]   == "village_green" )) then
      if ( object.tags["name"] == nil ) then
         object.tags["leisure"] = "unnamed_park"
      else
         object.tags["leisure"] = "park"
      end

      object = append_nonqa( object, object.tags["landuse"] )

      if ( object.tags["meadow"] ~= nil ) then
	 object = append_nonqa( object, object.tags["meadow"] )
      end

      object.tags["landuse"] = nil
   end

-- ----------------------------------------------------------------------------
-- These all map to meadow in the web maps
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- Various tags for showgrounds
--
-- In points:
-- "park" has a single tree icon
-- 0x2c06 is searchable via "Attractions / Park or Garden"
--
-- "unnamed_park" has a dot icon
-- 0x6600 is searchable via "Geographic Points / Land Features"
--
-- In polygons both are mapped to 0x17 resolution 20
-- Other tags are suppressed to prevent them appearing ahead of "landuse"
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"] == "showground"   ) or
       ( object.tags["leisure"] == "showground"   ) or
       ( object.tags["amenity"] == "show_ground"  ) or
       ( object.tags["amenity"] == "show_grounds" )) then
      if ( object.tags["name"] == nil ) then
         object.tags["leisure"] = "unnamed_park"
      else
         object.tags["leisure"] = "park"
      end

      object.tags["amenity"] = nil
      object = append_nonqa( object, "showground" )
   end

   if ( object.tags["amenity"]   == "festival_grounds" ) then
      if ( object.tags["name"] == nil ) then
         object.tags["leisure"] = "unnamed_park"
      else
         object.tags["leisure"] = "park"
      end

      object.tags["amenity"] = nil
      object = append_nonqa( object, "festival grounds" )
   end

   if ( object.tags["amenity"]   == "car_boot_sale" ) then
      if ( object.tags["name"] == nil ) then
         object.tags["leisure"] = "unnamed_park"
      else
         object.tags["leisure"] = "park"
      end

      object.tags["amenity"] = nil
      object = append_nonqa( object, "car boot sale" )
   end
-- ----------------------------------------------------------------------------
-- (end of list that maps to meadow)
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- Treat harbour=yes as landuse=harbour, if not already landuse.
-- ----------------------------------------------------------------------------
   if (( object.tags["harbour"] == "yes" ) and
       ( object.tags["landuse"] == nil   )) then
      object.tags["landuse"] = "harbour"
   end

-- ----------------------------------------------------------------------------
-- landuse=field is rarely used.  It is mapped through to landuse=farmland here, 
-- although that is not currently shown.
-- ----------------------------------------------------------------------------
   if (object.tags["landuse"]   == "field") then
      object.tags["landuse"] = "farmland"
   end

-- ----------------------------------------------------------------------------
-- Append suffix for landuse=commercial
-- 0x0c is used in polygons
-- ----------------------------------------------------------------------------
   if (object.tags["landuse"]   == "commercial") then
      object = append_nonqa( object, object.tags["landuse"] )
   end

-- ----------------------------------------------------------------------------
-- highway=services 
-- This is translated to commercial landuse - any overlaid parking
-- can then be seen in QMapShack 
-- and will be searchable via "Auto Services / Parking" on a GPSMap64s.
-- landuse=commercial is in polygons as "0x0c"
-- "0x0c" is not searchable via All POIs
-- The name and suffix are visible in QMapShack and on a GPSMAP64s
--
-- highway=rest_area is translated lower down to amenity=parking.
-- ----------------------------------------------------------------------------
   if ( object.tags["highway"] == "services" ) then
      object = append_nonqa( object, object.tags["highway"] )
      object.tags["landuse"] = "commercial"
      object.tags["highway"] = nil
   end

-- ----------------------------------------------------------------------------
-- man_made=pier is translated to commercial landusein order to avoid it 
-- falling into a "catch-all" for man_made.
-- ----------------------------------------------------------------------------
   if ( object.tags["man_made"] == "pier" ) then
      object = append_nonqa( object, object.tags["man_made"] )
      object.tags["landuse"] = "commercial"
      object.tags["man_made"] = nil
   end

-- ----------------------------------------------------------------------------
-- Other mappings to "commercial" landuse 
-- ----------------------------------------------------------------------------
   if (( object.tags["landuse"]      == "churchyard"               ) or
       ( object.tags["landuse"]      == "religious"                ) or
       ( object.tags["landuse"]      == "aquaculture"              ) or
       ( object.tags["landuse"]      == "fishfarm"                 )) then
      object = append_nonqa( object, object.tags["landuse"] )
      object.tags["landuse"] = "commercial"
   end

   if ( object.tags["leisure"]      == "racetrack"                ) then
      object = append_nonqa( object, object.tags["leisure"] )
      object.tags["landuse"] = "commercial"
      object.tags["leisure"] = nil
   end

   if ( object.tags["seamark:type"] == "marine_farm"              ) then
      object = append_nonqa( object, object.tags["seamark:type"] )
      object.tags["landuse"] = "commercial"
      object.tags["seamark:type"] = nil
   end

-- ----------------------------------------------------------------------------
-- Scout camps etc.
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"]   == "scout_camp"     ) or
       ( object.tags["landuse"]   == "scout_camp"     )) then
      if ( object.tags["name"] == nil ) then
         object.tags["leisure"] = "unnamed_park"
      else
         object.tags["leisure"] = "park"
      end

      object = append_nonqa( object, "scout camp" )
   end

   if ( object.tags["leisure"]   == "fishing" ) then
      if ( object.tags["name"] == nil ) then
         object.tags["leisure"] = "unnamed_park"
      else
         object.tags["leisure"] = "park"
      end

      object = append_nonqa( object, "fishing" )
   end

   if ( object.tags["leisure"]   == "outdoor_centre" ) then
      if ( object.tags["name"] == nil ) then
         object.tags["leisure"] = "unnamed_park"
      else
         object.tags["leisure"] = "park"
      end

      object = append_nonqa( object, "outdoor centre" )
   end
-- ----------------------------------------------------------------------------
-- (end of things that map to park)
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- Some people tag beach resorts as beaches - remove "beach_resort" there.
-- ----------------------------------------------------------------------------
   if (( object.tags["leisure"] == "beach_resort" ) and
       ( object.tags["natural"] == "beach"        )) then
      object.tags["leisure"] = nil
   end

-- ----------------------------------------------------------------------------
-- These all map to farmyard in the web maps
-- ----------------------------------------------------------------------------
   if ( object.tags["landuse"] == "farmyard" ) then
      object = append_nonqa( object, object.tags["landuse"] )
   end

-- ----------------------------------------------------------------------------
-- Change landuse=greenhouse_horticulture to farmyard.
-- ----------------------------------------------------------------------------
   if ( object.tags["landuse"] == "greenhouse_horticulture" ) then
      object = append_nonqa( object, object.tags["landuse"] )
      object.tags["landuse"] = "farmyard"
   end

-- ----------------------------------------------------------------------------
-- Also map man_made=bunker_silo through to farmyard here
-- ----------------------------------------------------------------------------
   if ( object.tags["man_made"] == "bunker_silo" ) then
      object = append_nonqa( object, object.tags["man_made"] )
      object.tags["landuse"] = "farmyard"
      object.tags["man_made"] = nil
   end

   if ( object.tags["amenity"] == "feeding_place" ) then
      object = append_nonqa( object, object.tags["amenity"] )
      object.tags["landuse"] = "farmyard"
      object.tags["amenity"] = nil
   end

   if ( object.tags["animal"] == "horse_walker" ) then
      object = append_nonqa( object, object.tags["animal"] )
      object.tags["landuse"] = "farmyard"
      object.tags["animal"] = nil
   end

-- ----------------------------------------------------------------------------
-- (end of things that map to farmyard)
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- Send stadiums and pitches through with e.g. "pitch" as a suffix, 
-- with the sport appended to the name.
-- 0x2c08 is searchable via "Recreation/Attractions / Arena or Track"
-- ----------------------------------------------------------------------------
   if (( object.tags["leisure"] == "stadium"        ) or
       ( object.tags["leisure"] == "pitch"          ) or
       ( object.tags["leisure"] == "practice_pitch" ) or
       ( object.tags["leisure"] == "track"          )) then
      object = append_nonqa( object, object.tags["leisure"] )
      object.tags["leisure"] = "pitch"

      if ( object.tags["sport"] ~= nil ) then
         object = append_nonqa( object, object.tags["sport"] )
	 object.tags["sport"] = nil
      end
   end

-- ----------------------------------------------------------------------------
-- leisure=dog_park is used a few times.  Map to pitch to differentiate from
-- underlying park.
-- 0x2c08 is searchable via "Recreation/Attractions / Arena or Track"
-- ----------------------------------------------------------------------------
   if ( object.tags["leisure"] == "dog_park" ) then
      object.tags["leisure"] = "pitch"
      object = append_nonqa( object, "dog park" )
   end

-- ----------------------------------------------------------------------------
-- Show skate parks etc. (that aren't skate shops) as pitches.
-- For leisure=pitch, the "polygons" file appends "sport" if present 
-- and so does the equivalent of 
-- 'object = append_nonqa( object, "skateboard" )'
-- 0x2c08 is searchable via "Recreation/Attractions / Arena or Track"
-- ----------------------------------------------------------------------------
   if ((( object.tags["sport"]   == "skateboard" )   or
        ( object.tags["sport"]   == "skating"    ))  and
       (  object.tags["shop"]    == nil           )  and
       (  object.tags["leisure"] == nil           )) then
      object.tags["leisure"] = "pitch"
   end

-- ----------------------------------------------------------------------------
-- Bird hides and similar features
-- tourism=information
-- In "points" as "0x4c00"
-- "0x4c00" is searchable via "Geographic Points / Manmade Places"
-- A "tourist information" icon appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"] == "bird_hide"     ) or
       ( object.tags["amenity"] == "wildlife_hide" )) then
      object.tags["leisure"] = object.tags["amenity"]
      object.tags["amenity"] = nil
   end

   if ( object.tags["man_made"] == "wildlife_hide" ) then
      object.tags["leisure"] = object.tags["man_made"]
      object.tags["man_made"] = nil
   end

   if (( object.tags["leisure"] == "bird_hide"     )  or
       ( object.tags["leisure"] == "wildlife_hide" )) then
      object = append_nonqa( object, object.tags["leisure"] )
      object.tags["tourism"] = "information"
      object.tags["leisure"] = nil
   end

-- ----------------------------------------------------------------------------
-- Attempt to do something sensible with trees
--
-- There are a few 10s of natural=forest; treat them the same
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
      (  object.tags["landcover"] == "trees"       ) or
      (( object.tags["natural"]   == "tree_group" )  and
       ( object.tags["landuse"]   == nil          )  and
       ( object.tags["leisure"]   == nil          ))) then
      object.tags["landuse"] = nil
      object.tags["natural"] = "wood"
   end

-- ----------------------------------------------------------------------------
-- Handle these as bicycle_rental:
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "bicycle_parking;bicycle_rental" ) then
      object.tags["amenity"] = "bicycle_rental"
   end

-- ----------------------------------------------------------------------------
-- Various ground transportation features
--
-- Show unspecified "public_transport=station" as "railway=halt"
-- These are normally one of amenity=bus_station, railway=station or
--  aerialway=station.  If they are none of these at least sow them as something.
--
-- Railway, bus, ferry, bicycle_rental:
-- "0x2f08" is searchable via "Transportation / Ground Transportation"
-- These values are all also in "points", as the same Garmin ID, for example:
-- "railway=station {name '${name}'} [0x2f08 resolution 20]"
-- "bicycle_rental" is also in the brand / operator logic below.
-- We also send "building=train_station" through to make them searchable as 
-- stations; the suffix will show which is which.
--
-- "Tourism:
-- "0x2c04" is searchable via "Attractions / Landmark"
-- ----------------------------------------------------------------------------
   if (( object.tags["railway"] == "halt"    ) or
       ( object.tags["railway"] == "station" )) then
      object = append_nonqa( object, "railway" )
      object = append_nonqa( object, object.tags["railway"] )

      if (( object.tags["usage"]             == "tourism"   ) or
          ( object.tags["railway:miniature"] == "station"   ) or
          ( object.tags["station"]           == "miniature" ) or
          ( object.tags["tourism"]           == "yes"       )) then
         object.tags["railway"] = "tourismstation"
         object.tags["tourism"] = nil
      end

      object = building_or_landuse( objtype, object )
   end

   if (( object.tags["building"]          == "train_station" ) and
       ( object.tags["name"]              ~= nil             ) and
       ( object.tags["shop"]              == nil             ) and
       ( object.tags["office"]            == nil             ) and
       ( object.tags["tourism"]           == nil             ) and
       ( object.tags["historic:railway"]  == nil             )) then
      object.tags["railway"] = "station"
      object = append_nonqa( object, "building" )
      object = append_nonqa( object, object.tags["building"] )
      object = building_or_landuse( objtype, object )
   end

   if (( object.tags["public_transport"] == "station" ) and
       ( object.tags["amenity"]          == nil       ) and
       ( object.tags["railway"]          == nil       ) and
       ( object.tags["aerialway"]        == nil       )) then
      object = append_nonqa( object, "public_transport" )
      object = append_nonqa( object, object.tags["public_transport"] )
      object.tags["railway"] = "halt"

      if (( object.tags["usage"]             == "tourism"   ) or
          ( object.tags["railway:miniature"] == "station"   ) or
          ( object.tags["station"]           == "miniature" ) or
          ( object.tags["tourism"]           == "yes"       )) then
         object.tags["railway"] = "tourismstation"
         object.tags["tourism"] = nil
      end

      object = building_or_landuse( objtype, object )
   end

   if (( object.tags["aerialway"] == "station" ) and
       ( object.tags["amenity"]   == nil       ) and
       ( object.tags["railway"]   == nil       )) then
      object = append_nonqa( object, "aerialway" )
      object = append_nonqa( object, object.tags["aerialway"] )
      object.tags["railway"] = "halt"

      if (( object.tags["usage"]             == "tourism"   ) or
          ( object.tags["railway:miniature"] == "station"   ) or
          ( object.tags["station"]           == "miniature" ) or
          ( object.tags["tourism"]           == "yes"       )) then
         object.tags["railway"] = "tourismstation"
         object.tags["tourism"] = nil
      end

      object = building_or_landuse( objtype, object )
   end

   if (( object.tags["amenity"] == "bus_station"    )  or
       ( object.tags["amenity"] == "ferry_terminal" )  or
       ( object.tags["amenity"] == "bicycle_rental" )) then
      object = append_nonqa( object, object.tags["amenity"] )
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Various "transit" features
-- "0x2f17" is searchable via "Transportation / Transit"
-- These values are all also in "points", as the same Garmin ID
--
-- Some people tag shelter or waste_basket on bus_stop.  
-- We render just bus_stop (the waste_basket code above handles this).
-- 
-- Also concatenate a couple of names for bus stops so that the most useful ones
-- are displayed.
-- ----------------------------------------------------------------------------
   if ( object.tags["railway"] == "tram_stop" ) then
      object = append_nonqa( object, object.tags["railway"] )
      object.tags["amenity"] = nil
      object = building_or_landuse( objtype, object )
   end

   if ( object.tags["amenity"] == "bus_stop" ) then
      object.tags["highway"] = object.tags["amenity"]
      object.tags["amenity"] = nil
   end

-- ----------------------------------------------------------------------------
-- If a bus stop pole exists but it's known to be disused, indicate that
-- ----------------------------------------------------------------------------
   if (( object.tags["disused:highway"]    == "bus_stop" ) and
       ( object.tags["physically_present"] == "yes"      )) then
      object.tags["highway"] = "bus_stop"
      object = append_nonqa( object, "disused" )
      object.tags["physically_present"] = nil
   end

-- ----------------------------------------------------------------------------
-- Many "naptan:Indicator" are "opp" or "adj", but some are "Stop XYZ" or
-- various other bits and pieces.  See 
-- https://taginfo.openstreetmap.org/keys/naptan%3AIndicator#values
-- We remove overly long ones.
-- Similarly, long "ref" values.
-- ----------------------------------------------------------------------------
   if (( object.tags["naptan:Indicator"] ~= nil           ) and
       ( string.len( object.tags["naptan:Indicator"]) > 3 )) then
      object.tags["naptan:Indicator"] = nil
   end

   if (( object.tags["highway"] == "bus_stop" ) and
       ( object.tags["ref"]     ~= nil        ) and
       ( string.len( object.tags["ref"]) > 3  )) then
      object.tags["ref"] = nil
   end

-- ----------------------------------------------------------------------------
-- Concatenate a couple of names for bus stops so that the most useful ones
-- are displayed.
-- ----------------------------------------------------------------------------
   if ( object.tags["highway"] == "bus_stop" ) then
      if ( object.tags["name"] ~= nil ) then
         if (( object.tags["bus_speech_output_name"] ~= nil                                ) and
             ( not string.find( object.tags["name"], object.tags["bus_speech_output_name"], 1, true ))) then
            object.tags["name"] = object.tags["name"] .. " / " .. object.tags["bus_speech_output_name"]
         end

         if (( object.tags["bus_display_name"] ~= nil                                ) and
             ( not string.find( object.tags["name"], object.tags["bus_display_name"], 1, true ))) then
            object.tags["name"] = object.tags["name"] .. " / " .. object.tags["bus_display_name"]
         end
      end

      if ( object.tags["name"] == nil ) then
         if ( object.tags["ref"] == nil ) then
            if ( object.tags["naptan:Indicator"] ~= nil ) then
               object.tags["name"] = object.tags["naptan:Indicator"]
            end
         else -- ref not nil
            if ( object.tags["naptan:Indicator"] == nil ) then
               object.tags["name"] = object.tags["ref"]
            else
               object.tags["name"] = object.tags["ref"] .. " " .. object.tags["naptan:Indicator"]
            end
         end
      else -- name not nil
         if ( object.tags["ref"] == nil ) then
            if ( object.tags["naptan:Indicator"] ~= nil ) then
               object.tags["name"] = object.tags["name"] .. " " .. object.tags["naptan:Indicator"]
            end
         else -- neither name nor ref nil
            if ( object.tags["naptan:Indicator"] == nil ) then
               object.tags["name"] = object.tags["name"] .. " " .. object.tags["ref"]
            else -- naptan:Indicator not nil
               object.tags["name"] = object.tags["name"] .. " " .. object.tags["ref"] .. " " .. object.tags["naptan:Indicator"]
            end
         end
      end

      object = append_nonqa( object, object.tags["highway"] )
      object.tags["amenity"] = nil

-- ----------------------------------------------------------------------------
-- Various tags that mean there is no physical bus stop pole.
-- ----------------------------------------------------------------------------
      if (( object.tags["flag"]               == "no"  ) or
          ( object.tags["pole"]               == "no"  ) or
          ( object.tags["physically_present"] == "no"  )) then
         object = append_nonqa( object, "no flag" )
      end

-- ----------------------------------------------------------------------------
-- NaPTAN customary stops.  There may be no flag.
-- ----------------------------------------------------------------------------
      if ( object.tags["naptan:BusStopType"] == "CUS" ) then
         object = append_nonqa( object, "CUS" )
      end

-- ----------------------------------------------------------------------------
-- Is there a departures board, and if so what sort?
-- Confusinging both "departures_board" and "passenger_information_display"
-- need to be checked here (and there is a hodge-podge of values).
-- For speech output, it's "departures_board:speech_output" or 
-- "passenger_information_display:speech_output".
-- Finally, "qdb" is used for QA for timetables that have not been surveyed
-- to see if there is a departures board or not, and for various potentially
-- incomplete combinations such as "realtime departures board, 
-- but no info on speech output".
-- ----------------------------------------------------------------------------
      if (( object.tags["departures_board"]              == "realtime"                     ) or
          ( object.tags["departures_board"]              == "timetable; realtime"          ) or
          ( object.tags["departures_board"]              == "realtime;timetable"           ) or
          ( object.tags["departures_board"]              == "timetable;realtime"           ) or
          ( object.tags["departures_board"]              == "realtime_multiline"           ) or
          ( object.tags["departures_board"]              == "realtime,timetable"           ) or
          ( object.tags["departures_board"]              == "multiline"                    ) or
          ( object.tags["departures_board"]              == "realtime_multiline;timetable" ) or
          ( object.tags["passenger_information_display"] == "realtime"                     )) then
         if (( object.tags["departures_board:speech_output"]              == "yes" ) or
             ( object.tags["passenger_information_display:speech_output"] == "yes" )) then
            object = append_nonqa( object, "rts" )
         else
            object = append_nonqa( object, "rt" )

            if (( object.tags["departures_board:speech_output"]              ~= "no" ) and
                ( object.tags["passenger_information_display:speech_output"] ~= "no" )) then
               object = append_qa( object, "qdb" )
            end
         end
      else
         if (( object.tags["departures_board"]              == "timetable"        ) or
             ( object.tags["departures_board"]              == "schedule"         ) or
             ( object.tags["departures_board"]              == "separate"         ) or
             ( object.tags["departures_board"]              == "paper timetable"  ) or
             ( object.tags["departures_board"]              == "yes"              ) or
             ( object.tags["passenger_information_display"] == "timetable"        ) or
             ( object.tags["passenger_information_display"] == "yes"              )) then
            if (( object.tags["departures_board:speech_output"]              == "yes" ) or
                ( object.tags["passenger_information_display:speech_output"] == "yes" )) then
               object = append_nonqa( object, "tts" )
            else
               object = append_nonqa( object, "tt" )
            end
         else
-- ----------------------------------------------------------------------------
-- If we expect there might be some sort of departures board, and there isn't,
-- Add a QA note to look for it.
-- ----------------------------------------------------------------------------
            if (( object.tags["flag"]                          ~= "no"  ) and
                ( object.tags["pole"]                          ~= "no"  ) and
                ( object.tags["physically_present"]            ~= "no"  ) and
                ( object.tags["naptan:BusStopType"]            ~= "CUS" ) and
                ( object.tags["departures_board"]              == nil   ) and
                ( object.tags["passenger_information_display"] == nil   ) and
                ( object.tags["disused:highway"]               == nil   )) then
               object = append_qa( object, "qdb" )
            end
         end
      end

      object = building_or_landuse( objtype, object )
   end

   if ( object.tags["amenity"] == "taxi" ) then
      object = append_nonqa( object, object.tags["amenity"] )
      object = building_or_landuse( objtype, object )
   end

   if (( object.tags["aeroway"] == "gate"             ) or
       ( object.tags["aeroway"] == "parking_position" )) then
      object = append_nonqa( object, "aeroway" )
      object = append_nonqa( object, object.tags["aeroway"] )

      if ( object.tags["ref"] ~= nil ) then
         object = append_nonqa( object, object.tags["ref"] )
      end

      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- "cafe" - consolidation of lesser used tags
-- Done here because we suppress some that are not accessible before 
-- processing beer tags.
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
-- Don't show pubs, cafes or restaurants if you can't actually get to them.
-- ----------------------------------------------------------------------------
   if ((( object.tags["amenity"] == "pub"        ) or
        ( object.tags["amenity"] == "cafe"       ) or
        ( object.tags["amenity"] == "restaurant" )) and
       (  object.tags["access"]  == "no"          )) then
      object.tags["amenity"] = nil
   end

-- ----------------------------------------------------------------------------
-- Suppress historic tag on pubs.
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"]  == "pub"     ) and
       ( object.tags["historic"] ~= nil       )) then
      object.tags["historic"] = nil
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

   if ((  object.tags["abandoned:amenity"] == "pub"             )   or
       (  object.tags["amenity:disused"]   == "pub"             )   or
       (  object.tags["disused"]           == "pub"             )   or
       (  object.tags["disused:pub"]       == "yes"             )   or
       (  object.tags["former_amenity"]    == "former_pub"      )   or
       (  object.tags["former_amenity"]    == "pub"             )   or
       (  object.tags["former_amenity"]    == "old_pub"         )   or
       (  object.tags["former:amenity"]    == "pub"             )   or
       (  object.tags["old_amenity"]       == "pub"             )) then
      object.tags["amenity"] = "disused_pub"
      object.tags["amenity:disused"] = nil
      object.tags["disused"] = nil
      object.tags["disused:pub"] = nil
      object.tags["former_amenity"] = nil
      object.tags["old_amenity"] = nil
   end

   if (( object.tags["historic"] == "pub" ) and
       ( object.tags["amenity"]  == nil   ) and
       ( object.tags["shop"]     == nil   )) then
      object.tags["disused:amenity"] = "pub"
      object.tags["historic"] = nil
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

-- ----------------------------------------------------------------------------
-- Note that any "disused:amenity=pub" that has survived to here will be 
-- handled by the vacant shops logic below; no need to explicitly handle it 
-- here.
--
-- It will then go through "building_or_landuse" and "man_made=thing" will be
-- assigned to nodes (which would not otherwise appear).  
-- Ways with a building tag will not be searchable, even on "All POIs" but
-- will appear as buildings.
-- Ways without a building tag will not be searchable, even on "All POIs" but
-- will appear as landuse.
-- ----------------------------------------------------------------------------

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
-- Change some common semicolon values to the first in the list - bar
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "bar;restaurant" ) then
      object.tags["amenity"] = "bar"
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
-- Craft Cider
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if ((  object.tags["craft"]   == "cider"    ) or
       (( object.tags["craft"]   == "brewery" )  and
        ( object.tags["product"] == "cider"   ))) then
      object = append_nonqa( object, "craft cider" )
      object.tags["shop"] = "specialty"
      object.tags["craft"] = nil
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Craft breweries
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if (( object.tags["craft"] == "brewery"       ) or
       ( object.tags["craft"] == "brewery;cider" )) then
      object = append_nonqa( object, "craft brewery" )
      object.tags["shop"] = "specialty"
      object.tags["craft"] = nil
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Industrial breweries
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if ( object.tags["industrial"] == "brewery" ) then
      object = append_nonqa( object, "industrial brewery" )
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
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
-- Live or dead pub?  y (yes) or      	     	 	  B (bar) or P (pub)
--                    n (no), or			  Shown as vacant
--                    c (closed due to covid)		  Shown as vacant (with description)
-- Letter to aid searching                                Q
-- Real ale?          y (yes)  	   	       	  	  R
--                    n	(no)				  N
--                    d (don't know)           		  V
-- Food 	      y (yes)                             F
--                    d (don't know)                      -
-- Noncarpeted floor  y (yes)                             L
--                    d (don't know)                      -
-- Microbrewery	      y                                   UB
--                    n or d                              -
-- Micropub	      y                                   UP
--                    n or d                              -
-- Accommodation      y                                   A
--                    n or d                              -
-- Beer Garden	      g (beer garden), 			  G
--                    o (outside seating), 		  O
--                    d (don't know)			  -
-- Wheelchair	      y (yes)                             WY
--                    l (limited)                         WL
--                    n (no)                              WN
--                    d                                   -
-- 
-- For mkgmap, we don't use different icons beyond "restaurant"
-- We do use appendices to the name.
-- Initially, set some object flags that we will use later.
-- ----------------------------------------------------------------------------
   if (( object.tags["description:floor"] ~= nil                  ) or
       ( object.tags["floor:material"]    == "brick"              ) or
       ( object.tags["floor:material"]    == "concrete"           ) or
       ( object.tags["floor:material"]    == "grubby carpet"      ) or
       ( object.tags["floor:material"]    == "lino"               ) or
       ( object.tags["floor:material"]    == "lino;carpet"        ) or
       ( object.tags["floor:material"]    == "lino;rough_wood"    ) or
       ( object.tags["floor:material"]    == "lino;tiles;stone"   ) or
       ( object.tags["floor:material"]    == "rough_wood"         ) or
       ( object.tags["floor:material"]    == "rough_wood;stone"   ) or
       ( object.tags["floor:material"]    == "rough_wood;tiles"   ) or
       ( object.tags["floor:material"]    == "slate"              ) or
       ( object.tags["floor:material"]    == "slate;carpet"       ) or
       ( object.tags["floor:material"]    == "stone"              ) or
       ( object.tags["floor:material"]    == "stone;carpet"       ) or
       ( object.tags["floor:material"]    == "stone;rough_carpet" ) or
       ( object.tags["floor:material"]    == "stone;rough_wood"   ) or
       ( object.tags["floor:material"]    == "tiles"              ) or
       ( object.tags["floor:material"]    == "tiles;rough_wood"   )) then
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
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Does a pub really serve food?
-- Below we check for "any food value but no".
-- Here we exclude certain food values from counting towards displaying the "F"
-- that says a pub serves food.  As far as I am concerned, sandwiches, pies,
-- or even one of Michael Gove's scotch eggs would count as "food" but a packet
-- of crisps would not.
-- ----------------------------------------------------------------------------
   if ((  object.tags["amenity"] == "pub"         ) and
       (( object.tags["food"]    == "snacks"     ) or
        ( object.tags["food"]    == "bar_snacks" ))) then
      object.tags["food"] = "no"
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
      beer_appendix = ""

      if ( object.tags["amenity"] == "bar" ) then
         beer_appendix = "B"
      else
         if ( object.tags["amenity"] == "pub" ) then
            beer_appendix = "P"
         end
      end

      if ( beer_appendix == nil ) then
         beer_appendix = "QR"
      else
         beer_appendix = beer_appendix .. "QR"
      end

      if (( object.tags["food"] ~= nil  ) and
          ( object.tags["food"] ~= "no" )) then
         beer_appendix = beer_appendix .. "F"
      end

      if ( object.tags["noncarpeted"] == "yes"  ) then
         beer_appendix = beer_appendix .. "L"
      end

      if ( object.tags["microbrewery"] == "yes"  ) then
         beer_appendix = beer_appendix .. "UB"
      end

      if ( object.tags["micropub"] == "yes"  ) then
         beer_appendix = beer_appendix .. "UP"
      end

      if (( object.tags["accommodation"] ~= nil  ) and
          ( object.tags["accommodation"] ~= "no" )) then
         beer_appendix = beer_appendix .. "A"
      end

      if ( object.tags["beer_garden"] == "yes" ) then
         beer_appendix = beer_appendix .. "G"
      else
         if ( object.tags["outdoor_seating"] == "yes" ) then
            beer_appendix = beer_appendix .. "O"
         end
      end

      if ( object.tags["wheelchair"] == "yes" ) then
         beer_appendix = beer_appendix .. "WY"
      else
         if ( object.tags["wheelchair"] == "limited" ) then
            beer_appendix = beer_appendix .. "WL"
         else
            if ( object.tags["wheelchair"] == "no" ) then
               beer_appendix = beer_appendix .. "WN"
            end
         end
      end

      if ( beer_appendix ~= "" ) then
         if ( object.tags["name"] == nil ) then
            object.tags.name = "(" .. beer_appendix .. ")"
         else
            object.tags.name = object.tags["name"] .. " (" .. beer_appendix .. ")"
         end
      end

      object = building_or_landuse( objtype, object )
   end

   if ((( object.tags["amenity"] == "bar" )  or
        ( object.tags["amenity"] == "pub" )) and
       (( object.tags["real_ale"] == "no" )  or
        ( object.tags["real_ale"] == nil  ))) then
      beer_appendix = ""

      if ( object.tags["amenity"] == "bar" ) then
         beer_appendix = "B"
      else
         if ( object.tags["amenity"] == "pub" ) then
            beer_appendix = "P"
         end
      end

      if ( beer_appendix == nil ) then
         beer_appendix = "Q"
      else
         beer_appendix = beer_appendix .. "Q"
      end

      if (  object.tags["real_ale"] == "no" ) then
         beer_appendix = beer_appendix .. "N"
      else
         beer_appendix = beer_appendix .. "V"
      end

      if (( object.tags["food"] ~= nil  ) and
          ( object.tags["food"] ~= "no" )) then
         beer_appendix = beer_appendix .. "F"
      end

      if ( object.tags["noncarpeted"] == "yes"  ) then
         beer_appendix = beer_appendix .. "L"
      end

      if ( object.tags["microbrewery"] == "yes"  ) then
         beer_appendix = beer_appendix .. "UB"
      end

      if ( object.tags["micropub"] == "yes"  ) then
         beer_appendix = beer_appendix .. "UP"
      end

      if (( object.tags["accommodation"] ~= nil  ) and
          ( object.tags["accommodation"] ~= "no" )) then
         beer_appendix = beer_appendix .. "A"
      end

      if ( object.tags["beer_garden"] == "yes" ) then
         beer_appendix = beer_appendix .. "G"
      else
         if ( object.tags["outdoor_seating"] == "yes" ) then
            beer_appendix = beer_appendix .. "O"
         end
      end

      if ( beer_appendix ~= "" ) then
         object = append_nonqa( object, beer_appendix )
      end

      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Cafes with accommodation and without
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "cafe" ) then
      if (( object.tags["accommodation"] ~= nil  ) and
          ( object.tags["accommodation"] ~= "no" )) then
         object = append_nonqa( object, "cafe with rooms" )
      else
         object = append_nonqa( object, "cafe" )
      end

      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Post Offices and postboxes
-- "0x2f05" is searchable as "Community / Post Office"
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"] == "post_office" ) or
       ( object.tags["amenity"] == "post_box"    )) then
      object = append_nonqa( object, object.tags["amenity"] )
      object.tags["amenity"] = "post_office"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Show building societies as banks.  Also shop=bank and credit unions.
-- Also ATMs, and things that are both banks and ATMs.
-- Also "other money shops"
-- "0x2f06" is searchable as "Community / Bank or ATM"
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"] == "bank"             ) or
       ( object.tags["amenity"] == "building_society" ) or
       ( object.tags["amenity"] == "credit_union"     ) or
       ( object.tags["amenity"] == "atm"              ) or
       ( object.tags["amenity"] == "financial_advice" ) or
       ( object.tags["amenity"] == "bureau_de_change" )) then
      object.tags["shop"] = object.tags["amenity"]
   end

   if (( object.tags["office"]  == "finance"             ) or
       ( object.tags["office"]  == "financial_services"  ) or
       ( object.tags["office"]  == "financial_advisor"   )) then
      object.tags["shop"] = object.tags["office"]
   end

   if (( object.tags["shop"]   == "bank"                ) or
       ( object.tags["shop"]   == "atm"                 ) or
       ( object.tags["shop"]   == "bank;atm"            ) or
       ( object.tags["shop"]   == "building_society"    ) or
       ( object.tags["shop"]   == "credit_union"        ) or
       ( object.tags["shop"]   == "finance"             ) or
       ( object.tags["shop"]   == "financial"           ) or
       ( object.tags["shop"]   == "financial_advice"    ) or
       ( object.tags["shop"]   == "financial_advisor"   ) or
       ( object.tags["shop"]   == "financial_advisors"  ) or
       ( object.tags["shop"]   == "financial_services"  ) or
       ( object.tags["shop"]   == "money_transfer"      ) or
       ( object.tags["shop"]   == "mortgage"            )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["amenity"] = "bank"
      object.tags["shop"] = nil
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- doctors
-- Various mistagging, comma and semicolon healthcare
-- 0x3002 appears on GPSMap64s as "Hospital" 
-- ----------------------------------------------------------------------------
   if ((( object.tags["healthcare"] == "doctor"               )   or
        ( object.tags["healthcare"] == "doctor;pharmacy"      )   or
        ( object.tags["healthcare"] == "general_practitioner" ))  and
       (  object.tags["amenity"]    == nil                     )) then
      object.tags["amenity"] = object.tags["healthcare"]
   end

   if (( object.tags["amenity"] == "doctor"                  ) or
       ( object.tags["amenity"] == "doctor;pharmacy"         ) or
       ( object.tags["amenity"] == "doctors"                 ) or
       ( object.tags["amenity"] == "doctors; pharmacy"       ) or
       ( object.tags["amenity"] == "general_practitioner"    ) or
       ( object.tags["amenity"] == "surgery"                 )) then
      object = append_nonqa( object, object.tags["amenity"] )
      object.tags["amenity"] = "doctors"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- police
-- 0x3001 is searchable via "Community / Police Station"
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "police" ) then
      object = append_nonqa( object, object.tags["amenity"] )
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Dentists were not previously handled but are now passed through as doctors 
-- with a suffix.
-- 0x3002 appears on GPSMap64s as "Hospital" 
-- ----------------------------------------------------------------------------
   if (((   object.tags["healthcare"]            == "dentist"    )  or
        ((  object.tags["healthcare:speciality"] == "dentistry" )   and
         (( object.tags["healthcare"]            == "yes"      )    or
          ( object.tags["healthcare"]            == "centre"   )    or
          ( object.tags["healthcare"]            == "clinic"   )))) and
       (   object.tags["amenity"]    == nil                       )) then
      object.tags["amenity"]    = "dentist"
      object.tags["healthcare"] = nil
   end

   if ( object.tags["amenity"] == "dentist" ) then
      object.tags["amenity"] = "doctors"
      object = append_nonqa( object, "dentist" )
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Hospitals
-- ----------------------------------------------------------------------------
   if (( object.tags["healthcare"] == "hospital" ) and
       ( object.tags["amenity"]    == nil        )) then
      object.tags["amenity"] = "hospital"
   end

   if ( object.tags["amenity"] == "hospital" ) then
      object = append_nonqa( object, "hospital" )
      object = building_or_landuse( objtype, object )
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
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- "department_store" consolidation.
-- "0x2e01" is searchable as "Shopping / Department"
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"] == "department_store" ) or
       ( object.tags["shop"] == "department"       )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "department_store"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- If something is mapped both as a supermarket and a pharmacy, suppress the
-- tags for the latter.
-- "0x2e02" is searchable as "Shopping / Grocery"
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"]    == "supermarket" ) and
       ( object.tags["amenity"] == "pharmacy"    )) then
      object.tags["amenity"] = nil
   end

   if ( object.tags["shop"] == "supermarket" ) then
      object = append_nonqa( object, object.tags["shop"] )
      object = append_eco( object )
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- General Stores
-- This is a subset of the "Shops that we don't know the type of" 
-- "shopnonspecific" mappings from style.lua.
-- "0x2e03" is searchable as "Shopping / General Merchandise"
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"] == "general"       ) or
       ( object.tags["shop"] == "general_store" )) then
      object = append_nonqa( object, object.tags["shop"] )
      object = append_eco( object )
      object.tags["shop"] = "general"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Variety Stores
-- "0x2e03" is searchable as "Shopping / General Merchandise"
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"]   == "variety"       ) or
       ( object.tags["shop"]   == "pound"         ) or
       ( object.tags["shop"]   == "thrift"        ) or
       ( object.tags["shop"]   == "variety_store" ) or
       ( object.tags["shop"]   == "discount"      )) then
      object = append_nonqa( object, object.tags["shop"] )
      object = append_eco( object )
      object.tags["shop"] = "general"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Shop groups
-- "0x2e04" in points is searchable as "Shopping / Shopping Center"
-- 0x08 is used in polygons for most shops and landuse=retail
-- ----------------------------------------------------------------------------
   if ((( object.tags["amenity"] == "marketplace"    )  and
        ( object.tags["name"]    ~= nil              )) or
       (  object.tags["amenity"] == "market"          ) or
       (  object.tags["amenity"] == "food_court"      )) then
      object.tags["shop"] = object.tags["amenity"]
      object.tags["amenity"] = nil
   end

   if (( object.tags["landuse"] == "retail" ) and
       ( object.tags["name"]    ~= nil      ) and
       ( object.tags["shop"]    == nil      )) then
      object.tags["shop"] = "retail area"
   end

   if (( object.tags["shop"] == "mall"            ) or
       ( object.tags["shop"] == "shopping_centre" ) or
       ( object.tags["shop"] == "market"          ) or
       ( object.tags["shop"] == "food_court"      ) or
       ( object.tags["shop"] == "retail area"     )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"]    = "mall"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Pharmacies
-- 0x2e05 "Shopping / Pharmacy or Chemist"
-- ----------------------------------------------------------------------------
   if ((  object.tags["amenity"]    == "pharmacy"                    ) or
       (( object.tags["healthcare"] == "pharmacy"                   )  and
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
      object = building_or_landuse( objtype, object )
   end

   if ( object.tags["amenity"] == "pharmacy" ) then
      object = append_nonqa( object, "pharmacy" )
   end

   if ( object.tags["shop"] == "chemist" ) then
      object = append_nonqa( object, "chemist" )
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Add suffix to libraries and public bookcases
-- "0x2c03" is searchable via "Community / Library"
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "library" ) then
      object = append_nonqa( object, "library" )
      object = building_or_landuse( objtype, object )
   end

   if ( object.tags["amenity"] == "public_bookcase" ) then
      object.tags["amenity"] = "library"
      object = append_nonqa( object, "book exchange" )
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Various educational institutions
-- "0x2c03" is searchable via "Community / School"
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"] == "childcare"        ) or
       ( object.tags["amenity"] == "childrens_centre" ) or
       ( object.tags["amenity"] == "preschool"        ) or
       ( object.tags["amenity"] == "kindergarten"     ) or
       ( object.tags["amenity"] == "nursery"          ) or
       ( object.tags["amenity"] == "nursery_school"   ) or
       ( object.tags["amenity"] == "school"           ) or
       ( object.tags["amenity"] == "college"          ) or
       ( object.tags["amenity"] == "university"       ) or
       ( object.tags["amenity"] == "education_centre" )) then
      object = append_nonqa( object, object.tags["amenity"] )
      object.tags["amenity"] = "school"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Various clocks
-- man_made=thing
-- In "points" as "0x2f14"
-- "0x2f14" is searchable via "Others / Social Service"
-- A dot appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if ((( object.tags["amenity"] == "clock"   )  and
        ( object.tags["display"] == "sundial" )) or
       (  object.tags["amenity"] == "sundial"  )) then
      object.tags["man_made"] = "thing"
      object.tags["amenity"] = nil
      object = append_nonqa( object, "sundial" )
   end

-- ----------------------------------------------------------------------------
-- We show entrances as "man_made=thing".
-- Unfortunately "entrance=main" seems to be significantly misused in some 
-- areas, so we need to check for the absense of lots of other tags.
-- In "points" as "0x2f14"
-- "0x2f14" is searchable via "Others / Social Service"
-- A dot appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if ((( object.tags["entrance"]         == "main"                   ) or
        ( object.tags["building"]         == "entrance"               ) or
        ( object.tags["entrance"]         == "entrance"               ) or
        ( object.tags["public_transport"] == "entrance"               ) or
        ( object.tags["railway"]          == "entrance"               ) or
        ( object.tags["railway"]          == "train_station_entrance" ) or
        ( object.tags["school"]           == "entrance"               )) and
       (  object.tags["amenity"]          == nil                       ) and
       (  object.tags["barrier"]          == nil                       ) and
       (  object.tags["building"]         == nil                       ) and
       (  object.tags["craft"]            == nil                       ) and
       (  object.tags["highway"]          == nil                       ) and
       (  object.tags["office"]           == nil                       ) and
       (  object.tags["shop"]             == nil                       ) and
       (  object.tags["tourism"]          == nil                       )) then
      object.tags["man_made"] = "thing"
      object.tags["amenity"] = nil
      object = append_nonqa( object, "entrance" )
   end

-- ----------------------------------------------------------------------------
-- Bicycle repair stations not in phone boxes.
-- See above for phone box ones.
-- man_made=thing
-- In "points" as "0x2f14"
-- "0x2f14" is searchable via "Others / Social Service"
-- A dot appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "bicycle_repair_station" ) then
      object = append_nonqa( object, object.tags["amenity"] )
      object.tags["man_made"] = "thing"
      object.tags["amenity"] = nil
   end

-- ----------------------------------------------------------------------------
-- Various types of traffic light controlled crossings
-- ----------------------------------------------------------------------------
   if ((( object.tags["crossing"] == "traffic_signals"         )  or
        ( object.tags["crossing"] == "toucan"                  )  or
        ( object.tags["crossing"] == "puffin"                  )  or
        ( object.tags["crossing"] == "traffic_signals;island"  )  or
        ( object.tags["crossing"] == "traffic_lights"          )  or
        ( object.tags["crossing"] == "island;traffic_signals"  )  or
        ( object.tags["crossing"] == "signals"                 )  or
        ( object.tags["crossing"] == "pegasus"                 )  or
        ( object.tags["crossing"] == "pedestrian_signals"      )  or
        ( object.tags["crossing"] == "light_controlled"        )  or
        ( object.tags["crossing"] == "light controlled"        )) and
       (  object.tags["highway"]  == nil                        )) then
      object.tags["highway"] = "traffic_signals"
      object.tags["crossing"] = nil
   end

-- ----------------------------------------------------------------------------
-- Crossings, emergency parking bays, passing places and traffic_signals
-- ----------------------------------------------------------------------------
   if (( object.tags["highway"] == "crossing"        ) or
       ( object.tags["highway"] == "emergency_bay"   ) or
       ( object.tags["highway"] == "mini_roundabout" ) or
       ( object.tags["highway"] == "passing_place"   ) or
       ( object.tags["highway"] == "traffic_signals" ) or
       ( object.tags["highway"] == "turning_circle"  )) then
      object = append_nonqa( object, object.tags["highway"] )
      object.tags["man_made"] = "thing"
      object.tags["highway"] = nil
   end

-- ----------------------------------------------------------------------------
-- Detect ladders
-- ----------------------------------------------------------------------------
   if (( object.tags["man_made"] == "ladder"   ) and
       ( object.tags["highway"]  == nil        )) then
      object = append_nonqa( object, object.tags["man_made"] )
      object.tags["man_made"] = "thing"
      object.tags["ladder"]  = nil
   end

-- ----------------------------------------------------------------------------
-- highway=motorway_junction
-- In points as "0x2000"
-- QMapShack understands "0x2000" and displays the text
-- Does not appear to be searchable or in All POIs on a GPSMAP64s
-- No icon appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if ( object.tags["highway"] == "motorway_junction" ) then
      if ( object.tags["name:signed"] == "no" ) then
         object.tags["name"] = nil
      end

      object = append_nonqa( object, object.tags["highway"] )

      if (( object.tags["ref"]        ~= nil  ) and
          ( object.tags["ref:signed"] ~= "no" )) then
         object = append_nonqa( object, object.tags["ref"] )
      end
   end

-- ----------------------------------------------------------------------------
-- Other leisure.  These are mapped to "man_made=thing" just to
-- make them searchable.  In "points" as "0x2f14"
-- "0x2f14" is searchable via "Others / Social Service"
-- A dot appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if ( object.tags["sport"] == "model_aerodrome" ) then
      object = append_nonqa( object, object.tags["sport"] )

      if (( object.tags["leisure"]  == nil ) and
          ( object.tags["club"]     == nil ) and
          ( object.tags["landuse"]  == nil )) then
         object.tags["man_made"] = "thing"
         object.tags["sport"] = nil
      end
   end

   if ( object.tags["leisure"] == "firepit" ) then
      object = append_nonqa( object, object.tags["leisure"] )
      object.tags["man_made"] = "thing"
      object.tags["leisure"] = nil
   end

   if ( object.tags["tourism"]  == "trail_riding_station" ) then
      object = append_nonqa( object, object.tags["tourism"] )
      object.tags["man_made"] = "thing"
      object.tags["tourism"] = nil
   end

-- ----------------------------------------------------------------------------
-- Theme parks
-- We only bother with these if they have a name.  Ones without a name may be
-- "amusement" areas in e.g. a larger holiday park.
-- "0x2c01" is searchable via "Attractions / Amusement Park or T"
-- ----------------------------------------------------------------------------
   if ( object.tags["tourism"] == "theme_park" ) then
      if ( object.tags["name"] == nil ) then
         object.tags["tourism"] = nil
      else
         object = append_nonqa( object, "theme park" )
      end
   end

-- ----------------------------------------------------------------------------
-- tourism=zoo and tourism=aquarium (both are in "points")
-- "0x2c07" is searchable via "Attractions / Zoo or Aquarium"
-- ----------------------------------------------------------------------------
   if (( object.tags["tourism"] == "zoo"      ) or
       ( object.tags["tourism"] == "aquarium" )) then
      object = append_nonqa( object, object.tags["tourism"] )
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- amenity=conference_centre etc.
-- "0x2c09" is searchable via "Attractions / Hall or Auditorium"
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"]  == "events_venue"         ) or
       ( object.tags["amenity"]  == "exhibition_centre"    ) or
       ( object.tags["amenity"]  == "conference_centre"    )) then
      object = append_nonqa( object, object.tags["amenity"] )
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- landuse=allotments and landuse=orchard
-- Mapped through to "0x4e" ("orchard"), append suffix.
-- See also "vineyard" below.
-- ----------------------------------------------------------------------------
   if (( object.tags["landuse"] == "allotments" ) or
       ( object.tags["landuse"] == "orchard"    )) then
      object = append_nonqa( object, object.tags["landuse"] )
   end

-- ----------------------------------------------------------------------------
-- craft=winery
-- "0x2c0a" is searchable via "Attractions / Winery"
-- That is in "points" for craft=winery and landuse=vineyard.
-- In addition there is 0x4e ("orchard") in polygons, used for 
-- landuse=allotments, landuse=orchard and landuse=vineyard
-- A "woodland" land cover appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if ( object.tags["craft"] == "winery" ) then
      object = append_nonqa( object, object.tags["craft"] )
      object = building_or_landuse( objtype, object )
   end

   if ( object.tags["landuse"] == "vineyard" ) then
      object = append_nonqa( object, object.tags["landuse"] )
   end

-- ----------------------------------------------------------------------------
-- amenity=place_of_worship
-- "0x2c0b" is searchable via "Community / Place of Worship"
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "place_of_worship" ) then

      if ( object.tags["religion"] == nil ) then
         object = append_nonqa( object, object.tags["amenity"] )
      else
         object = append_nonqa( object, object.tags["religion"] )
      end

      if ( object.tags["denomination"] ~= nil ) then
         object = append_nonqa( object, object.tags["denomination"] )
      end

      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Clock towers
-- man_made=tower
-- In "points" as "0x6411"
-- "0x6411" is searchable via "Others / Social Service".
-- A dot appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if (((  object.tags["man_made"]   == "tower"        )  and
        (( object.tags["tower:type"] == "clock"       )   or
         ( object.tags["building"]   == "clock_tower" )   or
         ( object.tags["amenity"]    == "clock"       ))) or
       ((  object.tags["amenity"]    == "clock"        )  and
        (  object.tags["support"]    == "tower"        ))) then
      object = append_nonqa( object, "clocktower" )
      object.tags["man_made"] = "tower"
      object.tags["tourism"] = nil
   end

   if ((  object.tags["amenity"]    == "clock"         )  and
       (( object.tags["support"]    == "pedestal"     )   or
        ( object.tags["support"]    == "pole"         )   or
        ( object.tags["support"]    == "stone_pillar" )   or
        ( object.tags["support"]    == "plinth"       )   or
        ( object.tags["support"]    == "column"       ))) then
      object = append_nonqa( object, "pedestal clock" )
      object.tags["man_made"] = "tower"
      object.tags["tourism"] = nil
   end

-- ----------------------------------------------------------------------------
-- Disused aerodromes etc. - handle disused=yes.
-- ----------------------------------------------------------------------------
   if (( object.tags["aeroway"]        == "aerodrome" ) and
       ( object.tags["disused"]        == "yes"       )) then
      object.tags["aeroway"] = nil
      object.tags["disused:aeroway"] = "aerodrome"
   end

   if (( object.tags["aeroway"]        == "runway" ) and
       ( object.tags["disused"]        == "yes"       )) then
      object.tags["aeroway"] = nil
      object.tags["disused:aeroway"] = "runway"
   end

   if (( object.tags["aeroway"]        == "taxiway" ) and
       ( object.tags["disused"]        == "yes"       )) then
      object.tags["aeroway"] = nil
      object.tags["disused:aeroway"] = "taxiway"
   end

-- ----------------------------------------------------------------------------
-- Helipads
-- aeroway=helipad is in "points"
-- 0x5904 is searchable via "Geographic Points / Manmade Places"
-- ----------------------------------------------------------------------------
   if ( object.tags["aeroway"] == "helipad" ) then
      object = append_nonqa( object, object.tags["aeroway"] )
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Aerodrome size.
--
-- Large public airports with an iata code should be shown as "real airports".  
-- gliding clubs etc. should appear as public sport airports; 
-- miltiary ones appear as generic tourist attractions.
-- all go through "building_or_landuse" at the end.
-- "0x2f04" is searchable via "Transportation / Air Transportation"
-- "0x2d0b" is searchable via "Recreation / public sport airport"
-- "0x2c04" is searchable via "Attractions / Landmark"
--
-- Heliports are similar to airports, except an icao code (present on many
-- more airports) can also determine that a heliport is "public".
-- ----------------------------------------------------------------------------
   if ( object.tags["aeroway"] == "heliport" ) then
      object = append_nonqa( object, object.tags["aeroway"] )
      object.tags["aeroway"] = "aerodrome"

      if (( object.tags["iata"]  == nil )  and
          ( object.tags["icao"]  ~= nil )) then
         object.tags["iata"] = object.tags["icao"]
      end
   end

   if ( object.tags["aeroway"] == "aerodrome" ) then
      if (( object.tags["iata"]           ~= nil         ) and
          ( object.tags["aerodrome:type"] ~= "military"  ) and
          ( object.tags["landuse"]        ~= "military"  ) and
          ( object.tags["military"]       == nil         )) then
         object = append_nonqa( object, object.tags["iata"] )
         object = append_nonqa( object, object.tags["aeroway"] )
      else
         if (( object.tags["aerodrome:type"] ~= "military"  ) and
             ( object.tags["military"]       == nil         )) then
            object = append_nonqa( object, "airstrip" )
            object.tags["sport"] = "airport"
            object.tags["aeroway"] = nil
         else
            object = append_nonqa( object, "military" )
            object = append_nonqa( object, object.tags["aeroway"] )
            object.tags["aeroway"] = "military"
         end
      end

      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Grass aprons and taxiways are not shown as regular aprons and taxiways.
-- ----------------------------------------------------------------------------
   if (( object.tags["aeroway"] == "apron"  ) and
       ( object.tags["surface"] == "grass"  )) then
      object.tags["landuse"] = "grass"
      object.tags["aeroway"] = nil
   end

   if (( object.tags["aeroway"] == "taxiway"  ) and
       ( object.tags["surface"] == "grass"    )) then
      object.tags["highway"] = "track"
      object.tags["aeroway"] = nil
   end

-- ----------------------------------------------------------------------------
-- aeroway=runway
-- aeroway=taxiway
-- In "lines as "0x27"
-- "0x27" is not searchable, even via "All POIs"
-- Visible as a red line in QMapShack
-- A white line appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if (( object.tags["aeroway"] == "runway"  ) or
       ( object.tags["aeroway"] == "taxiway" )) then
      if ( object.tags["ref"] ~= nil ) then
         object = append_nonqa( object, object.tags["ref"] )
      end

      object = append_nonqa( object, object.tags["aeroway"] )
   end

-- ----------------------------------------------------------------------------
-- Airports etc.
-- "0x2f04" is searchable via "Transportation / Air Transportation"
-- "aerodrome", "terminal" are all also in "points", 
-- as the same Garmin ID
-- ----------------------------------------------------------------------------
   if ( object.tags["aeroway"] == "terminal" ) then
      object = append_nonqa( object, object.tags["aeroway"] )
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Aircraft control towers
-- man_made=tower
-- In "points" as "0x6411"
-- "0x6411" is searchable via "Others / Social Service".
-- A dot appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if (((  object.tags["man_made"]   == "tower"             )   and
        (( object.tags["tower:type"] == "aircraft_control" )    or
         ( object.tags["service"]    == "aircraft_control" )))  or
       (   object.tags["aeroway"]    == "control_tower"      )) then
      object = append_nonqa( object, "control tower" )
      object.tags["man_made"] = "tower"
      object.tags["building"] = "yes"
      object.tags["tourism"] = nil
   end

   if ((( object.tags["man_made"]   == "tower"              )   or
        ( object.tags["man_made"]   == "monitoring_station" ))  and
       (( object.tags["tower:type"] == "radar"              )   or
        ( object.tags["tower:type"] == "weather_radar"      ))) then
      object = append_nonqa( object, "radar tower" )
      object.tags["man_made"] = "tower"
      object.tags["building"] = "yes"
      object.tags["tourism"] = nil
   end

-- ----------------------------------------------------------------------------
-- All the domes in the UK are radomes.
-- ----------------------------------------------------------------------------
   if (( object.tags["man_made"]            == "tower"   ) and
       (( object.tags["tower:construction"] == "dome"   )  or
        ( object.tags["tower:construction"] == "dish"   ))) then
      object = append_nonqa( object, "radar dome" )
      object.tags["man_made"] = "tower"
      object.tags["building"] = "yes"
      object.tags["tourism"] = nil
   end

   if (( object.tags["man_made"]   == "tower"                ) and
       ( object.tags["tower:type"] == "firefighter_training" )) then
      object = append_nonqa( object, "firefighter tower" )
      object.tags["man_made"] = "tower"
      object.tags["building"] = "yes"
      object.tags["tourism"] = nil
   end

   if ((((  object.tags["man_made"]    == "tower"             )  and
         (( object.tags["tower:type"]  == "church"           )   or
          ( object.tags["tower:type"]  == "square"           )   or
          ( object.tags["tower:type"]  == "campanile"        )   or
          ( object.tags["tower:type"]  == "bell_tower"       ))) or
        (   object.tags["man_made"]    == "campanile"          )) and
       ((   object.tags["amenity"]     == nil                  )  or
        (   object.tags["amenity"]     ~= "place_of_worship"   ))) then
      object = append_nonqa( object, "church tower" )
      object.tags["man_made"] = "tower"
      object.tags["tourism"] = nil
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
      object = append_nonqa( object, "church spire" )
      object.tags["man_made"] = "tower"
      object.tags["building"] = "yes"
      object.tags["tourism"] = nil
   end

-- ----------------------------------------------------------------------------
-- man_made=mast
-- In "points" as "0x6411"
-- "0x6411" is searchable via "Others / Social Service".
-- A dot appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if (( object.tags["man_made"] == "phone_mast"           ) or
       ( object.tags["man_made"] == "radio_mast"           ) or
       ( object.tags["man_made"] == "communications_mast"  ) or
       ( object.tags["man_made"] == "communications_tower" ) or
       ( object.tags["man_made"] == "transmitter"          ) or
       ( object.tags["man_made"] == "antenna"              ) or
       ( object.tags["man_made"] == "mast"                 )) then
      object = append_nonqa( object, object.tags["man_made"] )
      object.tags["man_made"] = "mast"
      object.tags["tourism"] = nil
   end

   if ( object.tags["man_made"] == "tower" ) then
      object.tags["tourism"] = nil
      object = append_nonqa( object, "tower" )
   end

-- ----------------------------------------------------------------------------
-- water towers
-- ----------------------------------------------------------------------------
   if ( object.tags["man_made"] == "water_tower" ) then
      object = append_nonqa( object, object.tags["man_made"] )
      object.tags["man_made"] = "tower"
      object.tags["building"] = "yes"
   end

-- ----------------------------------------------------------------------------
-- man_made=maypole
-- ----------------------------------------------------------------------------
   if ((  object.tags["man_made"] == "maypole"   ) or
       (  object.tags["historic"] == "maypole"   )) then
      object = append_nonqa( object, "maypole" )
      object.tags["man_made"] = "mast"
      object.tags["tourism"] = nil
   end

-- ----------------------------------------------------------------------------
-- highway=streetlamp
-- ----------------------------------------------------------------------------
   if ( object.tags["highway"] == "street_lamp" ) then
      object.tags["man_made"] = "thing"

      if ( object.tags["lamp_type"] == "gaslight" ) then
      	 object = append_nonqa( object, "gas lamp" )
      else
      	 object = append_nonqa( object, "streetlight" )
      end
   end

-- ----------------------------------------------------------------------------
-- Left luggage
-- man_made=thing
-- In "points" as "0x2f14"
-- "0x2f14" is searchable via "Others / Social Service"
-- A dot appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"] == "left_luggage"    ) or
       ( object.tags["amenity"] == "luggage_locker"  )) then
      object = append_nonqa( object, object.tags["amenity"] )
      object.tags["man_made"]  = "thing"
      object.tags["amenity"] = nil
      object.tags["shop"]    = nil
   end

-- ----------------------------------------------------------------------------
-- Parcel lockers
-- man_made=thing
-- In "points" as "0x2f14"
-- "0x2f14" is searchable via "Others / Social Service"
-- A dot appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if ((   object.tags["amenity"]         == "parcel_locker"                   )  or
       ((  object.tags["amenity"]         == "vending_machine"                )   and
        (( object.tags["vending"]         == "parcel_pickup;parcel_mail_in"  )    or
         ( object.tags["vending"]         == "parcel_mail_in;parcel_pickup"  )    or
         ( object.tags["vending"]         == "parcel_mail_in"                )    or
         ( object.tags["vending"]         == "parcel_pickup"                 )    or
         ( object.tags["vending_machine"] == "parcel_pickup"                 )))  or
       (   object.tags["amenity"]         == "parcel_box"                      )  or
       (   object.tags["amenity"]         == "parcel_pickup"                   )) then
      object.tags["man_made"]  = "thing"
      object.tags["amenity"]  = nil
      object = append_nonqa( object, "parcel locker" )
   end

-- ----------------------------------------------------------------------------
-- Append certain "vending" values to name
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "vending_machine" ) then
      object.tags["man_made"]  = "thing"
      object.tags["amenity"]  = nil

      if (( object.tags["vending"] == "bottle_return"  ) or
          ( object.tags["vending"] == "excrement_bags" )) then
         object = append_nonqa( object, object.tags["vending"] )
      end
   end

-- ----------------------------------------------------------------------------
-- If a farm shop doesn't have a name but does have named produce, map across
-- to vending machine (handled immediately below), and also the produce into
-- "vending" for consideration  below.
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
-- These are mapped through to "specialty retail" with a "vending" suffix.
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if (  object.tags["amenity"] == "vending_machine"  ) then
      object.tags["shop"] = "specialty"
      object.tags["amenity"]  = nil
      object = append_nonqa( object, "vending" )

      if ( object.tags["vending"] ~= nil ) then
         object = append_nonqa( object, object.tags["vending"] )
      end
   end

-- ----------------------------------------------------------------------------
-- Show amenity=piano and amenity=musical_instrument
-- man_made=thing
-- In "points" as "0x2f14"
-- "0x2f14" is searchable via "Others / Social Service"
-- A dot appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "piano" ) then
      object.tags["man_made"]  = "thing"
      object.tags["amenity"]  = nil
      object = append_nonqa( object, "piano" )
   end

   if ( object.tags["amenity"] == "musical_instrument" ) then
      object.tags["man_made"]  = "thing"
      object.tags["amenity"]  = nil
      object = append_nonqa( object, "musical instrument" )
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
-- Show motorcycle_parking areas, and 
-- show for-pay motorcycle_parking areas differently.
-- man_made=thing
-- In "points" as "0x2f14"
-- "0x2f14" is searchable via "Others / Social Service"
-- A dot appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if ((  object.tags["amenity"] == "motorcycle_parking"  ) or
       (( object.tags["amenity"] == "parking"            )  and
        ( object.tags["parking"] == "motorcycle"         ))) then
      object.tags["man_made"] = "thing"
      object = append_nonqa( object, "motorcycle parking" )

      if (( object.tags["fee"]     ~= nil               )  and
          ( object.tags["fee"]     ~= "no"              )  and
          ( object.tags["fee"]     ~= "0"               )) then
         object = append_nonqa( object, "pay" )
      end
   end

-- ----------------------------------------------------------------------------
-- Scooter rental
-- All legal scooter rental / scooter parking in UK are private; these are the
-- the tags currently used.
-- man_made=thing
-- In "points" as "0x2f14"
-- "0x2f14" is searchable via "Others / Social Service"
-- A dot appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if ((  object.tags["amenity"]                 == "escooter_rental"        ) or
       (  object.tags["amenity"]                 == "scooter_parking"        ) or
       (  object.tags["amenity"]                 == "kick-scooter_rental"    ) or
       (  object.tags["amenity"]                 == "small_electric_vehicle" ) or
       ((  object.tags["amenity"]                == "parking"               )  and
        (( object.tags["parking"]                == "e-scooter"            )   or
         ( object.tags["small_electric_vehicle"] == "designated"           ))) or
       ((  object.tags["amenity"]                == "bicycle_parking"       )  and
        (  object.tags["small_electric_vehicle"] == "designated"            ))) then
      object = append_nonqa( object, "small_electric_vehicle parking" )
      object.tags["man_made"] = "thing"
      object.tags["amenity"]  = nil

      if ( object.tags["network"] ~= nil ) then
         object = append_nonqa( object, "network" )
      end
   end

-- ----------------------------------------------------------------------------
-- Show amenity=layby as parking.
-- highway=rest_area is used a lot in the UK for laybies, so map that over too.
-- Show for-pay parking areas differently.
-- 0x2f0b "Auto Services / Parking"
-- ----------------------------------------------------------------------------
   if ( object.tags["highway"] == "rest_area" ) then
      object.tags["amenity"] = object.tags["highway"]
   end

   if (( object.tags["amenity"] == "parking"   ) or
       ( object.tags["amenity"] == "layby"     ) or
       ( object.tags["amenity"] == "rest_area" )) then
      object = append_nonqa( object, object.tags["amenity"] )

      if ((  object.tags["amenity"] == "parking"  ) and
          (( object.tags["fee"]     ~= nil       )  and
           ( object.tags["fee"]     ~= "no"      )  and
           ( object.tags["fee"]     ~= "0"       ))) then
         object = append_nonqa( object, "pay" )
      end

      object.tags["amenity"] = "parking"
   end

-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- Show bicycle_parking areas, and 
-- show for-pay bicycle_parking areas differently.
-- man_made=thing
-- In "points" as "0x2f14"
-- "0x2f14" is searchable via "Others / Social Service"
-- A dot appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "bicycle_parking" ) then
      object.tags["man_made"] = "thing"
      object = append_nonqa( object, "bicycle parking" )

      if (( object.tags["fee"]     ~= nil               )  and
          ( object.tags["fee"]     ~= "no"              )  and
          ( object.tags["fee"]     ~= "0"               )) then
         object = append_nonqa( object, "pay" )
      end
   end

-- ----------------------------------------------------------------------------
-- Render for-pay toilets differently to free ones, and if male vs female is
-- known, show that too.
-- 0x2f0c is searchable via "Auto Services / Rest Area or Tourist I"
-- An alternative, 0x4e00 is searchable via "Geographic Points / Manmade Places",
-- but lots of other things also appear in there too, so this is used instead.
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "toilets" ) then
      if (( object.tags["fee"]     ~= nil       )  and
          ( object.tags["fee"]     ~= "no"      )  and
          ( object.tags["fee"]     ~= "0"       )) then
         if (( object.tags["male"]   == "yes" ) and
             ( object.tags["female"] ~= "yes" )) then
            object = append_nonqa( object, "pay m" )
         else
            if (( object.tags["female"] == "yes"       ) and
                ( object.tags["male"]   ~= "yes"       )) then
               object = append_nonqa( object, "pay w" )
            else
               object = append_nonqa( object, "pay" )
            end
         end
      else
         if (( object.tags["male"]   == "yes" ) and
             ( object.tags["female"] ~= "yes" )) then
	    object = append_nonqa( object, "free m" )
         else
            if (( object.tags["female"] == "yes"       ) and
                ( object.tags["male"]   ~= "yes"       )) then
	       object = append_nonqa( object, "free w" )
            else
	       object = append_nonqa( object, "free" )
            end
         end
      end
   end

-- ----------------------------------------------------------------------------
-- Handle potentially conflicting leisure tags.
-- Remove sport tags from genuinely disused facilities
-- ----------------------------------------------------------------------------
   if (( object.tags["leisure"]         ~= nil  ) and
       ( object.tags["disused:leisure"] ~= nil  )) then
      object.tags["disused:leisure"] = nil
   end

   if ( object.tags["disused:leisure"] ~= nil  ) then
      object.tags["sport"] = nil
   end

-- ----------------------------------------------------------------------------
-- Cinemas
-- "0x2d03" is searchable via "Entertainment / Movie Theater"
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"]   == "cinema"   ) then
      object = append_nonqa( object, object.tags["amenity"] )
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Casinos
-- "0x2d04" is searchable via "Entertainment / Casino"
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"]   == "casino"   ) then
      object = append_nonqa( object, object.tags["amenity"] )
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Various non-beach natural seaside things
-- natural=sand is in polygons as 0x13.  It shows as a dot on grey, unlike 
-- the "beach" point which appears as a desert island.
-- "natural=sand" is also added to golf bunkers below.
-- ----------------------------------------------------------------------------
   if (( object.tags["natural"]   == "sand"    ) or 
       ( object.tags["natural"]   == "mud"     ) or
       ( object.tags["natural"]   == "shingle" )) then
      object = append_nonqa( object, object.tags["natural"] )

      if ( object.tags["tidal"] == "yes" ) then
         object = append_nonqa( object, "tidal" )
      end

      object.tags["natural"] = "sand"
   end

-- ----------------------------------------------------------------------------
-- Golf (and sandpits)
-- "0x2d05" is searchable via "Recreation / Golf Course"
-- Note that with potentially indoor things we call building_or_landuse; with
-- obviously outdoor ones we do not.
-- ----------------------------------------------------------------------------
   if (( object.tags["leisure"] == "sport" ) and
       ( object.tags["sport"]   == "golf"  )) then
      object.tags["leisure"] = "golf_course"
      object.tags["sport"] = nil
   end

   if ( object.tags["leisure"] == "golf_course"  ) then
      object = append_nonqa( object, object.tags["leisure"] )
   end

   if (( object.tags["leisure"]  == "miniature_golf"       ) or
       (( object.tags["leisure"] == "indoor_golf"         )  and
        ( object.tags["amenity"]  == nil                  ))) then
      object = append_nonqa( object, object.tags["leisure"] )
      object.tags["leisure"] = "golf_course"
      object = building_or_landuse( objtype, object )
   end

   if (( object.tags["golf"]    == "bunker" )  and
       ( object.tags["natural"] == nil      )) then
      object.tags["natural"] = "sand"
      object = append_nonqa( object, "bunker" )
   end

   if (( object.tags["playground"] == "sandpit" )  and
       ( object.tags["natural"]    == nil       )) then
      object.tags["natural"] = "sand"
      object = append_nonqa( object, "sandpit" )
   end

-- ----------------------------------------------------------------------------
-- "unnamed_park" has a dot icon
-- 0x6600 is searchable via "Geographic Points / Land Features"
-- ----------------------------------------------------------------------------
   if ( object.tags["golf"] == "tee" ) then
      object = append_nonqa( object, "tee" )

      if ( object.tags["ref"] ~= nil ) then
         object = append_nonqa( object, object.tags["ref"] )
      end

      object.tags["leisure"] = "unnamed_park"
   end

-- ----------------------------------------------------------------------------
-- "unnamed_park" has a dot icon
-- 0x6600 is searchable via "Geographic Points / Land Features"
-- ----------------------------------------------------------------------------
   if ( object.tags["golf"] == "green" ) then
      object.tags["leisure"] = "unnamed_park"
      object.tags["name"] = object.tags["ref"]
      object = append_nonqa( object, "green" )
   end

-- ----------------------------------------------------------------------------
-- "unnamed_park" has a dot icon
-- 0x6600 is searchable via "Geographic Points / Land Features"
-- ----------------------------------------------------------------------------
   if ( object.tags["golf"] == "fairway" ) then
      object.tags["leisure"] = "unnamed_park"
      object.tags["name"] = object.tags["ref"]
      object = append_nonqa( object, "fairway" )
   end

   if ( object.tags["golf"] == "pin" ) then
      object.tags["man_made"] = "thing"
      object.tags["name"] = object.tags["ref"]
      object = append_nonqa( object, "pin" )
   end

   if (( object.tags["golf"]    == "rough" ) and
       ( object.tags["natural"] == nil     )) then
      object.tags["natural"] = "scrub"
      object = append_nonqa( object, "golf rough" )
   end

-- ----------------------------------------------------------------------------
-- 0x2c08 is searchable via "Recreation/Attractions / Arena or Track"
-- ----------------------------------------------------------------------------
   if (( object.tags["golf"]    == "driving_range" ) and
       ( object.tags["leisure"] == nil             )) then
      object.tags["leisure"] = "pitch"
      object = append_nonqa( object, "driving range" )
   end

   if (( object.tags["golf"]    == "path" ) and
       ( object.tags["highway"] == nil    )) then
      object.tags["highway"] = "path"
   end

   if (( object.tags["golf"]    == "practice" ) and
       ( object.tags["leisure"] == nil        )) then
      object.tags["leisure"] = "unnamed_park"
      object = append_nonqa( object, "golf practice" )
   end

-- ----------------------------------------------------------------------------
-- Skiing
-- "0x2d06" is searchable via "Recreation / Skiing Center or Reso"
-- ----------------------------------------------------------------------------
   if ( object.tags["sport"] == "skiing" ) then
      object = append_nonqa( object, object.tags["sport"] )
      object.tags["amenity"] = nil
      object.tags["landuse"] = nil
      object.tags["leisure"] = nil
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Bowling Alleys
-- Pitches are handled above (see "0x2c08"); any sport tags used there 
-- have been removed.
-- "0x2d07" is searchable via "Recreation / Bowling Center"
-- ----------------------------------------------------------------------------
   if ( object.tags["leisure"] == "bowling_alley" ) then
      object.tags["sport"] = object.tags["leisure"]
   end

   if (( object.tags["sport"] == "bowls"         ) or
       ( object.tags["sport"] == "9pin"          ) or
       ( object.tags["sport"] == "10pin"         ) or
       ( object.tags["sport"] == "bowling"       ) or
       ( object.tags["sport"] == "bowling_alley" )) then
      object = append_nonqa( object, object.tags["sport"] )
      object.tags["amenity"] = nil
      object.tags["leisure"] = nil
      object.tags["sport"] = "10pin"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Ice Skating
-- "0x2d08" is searchable via "Recreation / Ice Skating"
-- ----------------------------------------------------------------------------
   if ( object.tags["leisure"] == "ice_rink"  ) then
      object = append_nonqa( object, object.tags["leisure"] )
      object.tags["amenity"] = nil
      object.tags["sport"] = nil
      object = building_or_landuse( objtype, object )
   end

   if ( object.tags["sport"] == "ice_skating" ) then
      object.tags["amenity"] = nil
      object.tags["leisure"] = "ice_rink"
      object = append_nonqa( object, object.tags["sport"] )
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Swimming pools
-- Some swimming pools do not have "sport=swimming", so set that here.
-- "0x2d09" is searchable via "Recreation / Swimming Pool"
-- ----------------------------------------------------------------------------
   if ((( object.tags["leisure"] == "pool"           ) or
        ( object.tags["leisure"] == "swimming"       ) or
        ( object.tags["leisure"] == "swimming_area"  ) or
        ( object.tags["leisure"] == "swimming_pool"  )) and
       (  object.tags["sport"]   == nil               )) then
      object.tags["sport"] = "swimming"
   end

   if (( object.tags["sport"]  == "swimming"  ) and
       ( object.tags["access"] ~= "private"   ) and
       ( object.tags["access"] ~= "no"        )) then
      object = append_nonqa( object, object.tags["sport"] )
      object.tags["amenity"] = nil
      object.tags["leisure"] = nil
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- leisure centres and sports centres
-- If an actual sport is more appropriate, it should have been handled above,
-- and "amenity" and "leisure" cleared so as not to drop into here.
-- "0x2d0a" is searchable via "Recreation / Sports or Fitness Cen"
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"] == "dojo"           ) or
       ( object.tags["amenity"] == "leisure_centre" ) or
       ( object.tags["amenity"] == "gym"            )) then
      object.tags["leisure"] = object.tags["amenity"]
   end

   if ( object.tags["highway"] == "trailhead" ) then
      object.tags["leisure"] = object.tags["highway"]
   end

   if (( object.tags["leisure"] == "bleachers"       ) or
       ( object.tags["leisure"] == "dojo"            ) or
       ( object.tags["leisure"] == "fitness_centre"  ) or
       ( object.tags["leisure"] == "fitness_station" ) or
       ( object.tags["leisure"] == "gym"             ) or
       ( object.tags["leisure"] == "leisure_centre"  ) or
       ( object.tags["leisure"] == "sports_centre"   ) or
       ( object.tags["leisure"] == "trailhead"       )) then
      object = append_nonqa( object, object.tags["leisure"] )

      if ( object.tags["sport"] ~= nil ) then
         object = append_nonqa( object, object.tags["sport"] )
	 object.tags["sport"] = nil
      end

      object.tags["leisure"] = "sports_centre"
      object.tags["amenity"] = nil
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Playground stuff
-- ----------------------------------------------------------------------------
   if ((  object.tags["leisure"]    == nil            )  and
       (( object.tags["playground"] == "swing"       )   or
        ( object.tags["playground"] == "basketswing" ))) then
      object.tags["man_made"] = "thing"
      object = append_nonqa( object, "playground swing" )
   end

   if (( object.tags["leisure"]    == nil         )  and
       ( object.tags["playground"] == "structure" )) then
      object.tags["man_made"] = "thing"
      object = append_nonqa( object, "playground structure" )
   end

   if (( object.tags["leisure"]    == nil             )  and
       ( object.tags["playground"] == "climbingframe" )) then
      object.tags["man_made"] = "thing"
      object = append_nonqa( object, "playground climbing frame" )
   end

   if (( object.tags["leisure"]    == nil     )  and
       ( object.tags["playground"] == "slide" )) then
      object.tags["man_made"] = "thing"
      object = append_nonqa( object, "playground slide" )
   end

   if (( object.tags["leisure"]    == nil       )  and
       ( object.tags["playground"] == "springy" )) then
      object.tags["man_made"] = "thing"
      object = append_nonqa( object, "playground springy" )
   end

   if (( object.tags["leisure"]    == nil       )  and
       ( object.tags["playground"] == "zipwire" )) then
      object.tags["man_made"] = "thing"
      object = append_nonqa( object, "playground zipwire" )
   end

   if (( object.tags["leisure"]    == nil      )  and
       ( object.tags["playground"] == "seesaw" )) then
      object.tags["man_made"] = "thing"
      object = append_nonqa( object, "playground seesaw" )
   end

   if (( object.tags["leisure"]    == nil          )  and
       ( object.tags["playground"] == "roundabout" )) then
      object.tags["man_made"] = "thing"
      object = append_nonqa( object, "playground roundabout" )
   end

   if (( object.tags["leisure"]    == nil          )  and
       ( object.tags["playground"] == "trampoline" )) then
      object.tags["man_made"] = "thing"
      object = append_nonqa( object, "playground trampoline" )
   end

-- ----------------------------------------------------------------------------
-- The "OpenRailwayMap" crowd prefer the less popular railway:preserved=yes
-- instead of railway=preserved (which has the advantage of still allowing
-- e.g. narrow_gauge in addition to rail).
-- After this change a suffix will be added in ott.process_way
-- ----------------------------------------------------------------------------
   if (( object.tags["railway:preserved"] == "yes" ) and
       ( object.tags["railway"]           == nil   )) then
      object.tags["railway"] = "preserved"
   end

-- ----------------------------------------------------------------------------
-- Aerialways
-- These are handled as aerialway=yes in "lines" as "default linear thing" 0x1d.
-- ----------------------------------------------------------------------------
   if (( object.tags["aerialway"] == "cable_car"  ) or
       ( object.tags["aerialway"] == "chair_lift" ) or
       ( object.tags["aerialway"] == "drag_lift"  ) or
       ( object.tags["aerialway"] == "gondola"    ) or
       ( object.tags["aerialway"] == "goods"      ) or
       ( object.tags["aerialway"] == "j-bar"      ) or
       ( object.tags["aerialway"] == "platter"    ) or
       ( object.tags["aerialway"] == "rope_tow"   ) or
       ( object.tags["aerialway"] == "t-bar"      )) then
      object = append_nonqa( object, "aerialway" )
      object = append_nonqa( object, object.tags["aerialway"] )
      object.tags["aerialway"] = "yes"
   end

-- ----------------------------------------------------------------------------
-- Slipways
-- Linear slipways are handled in "lines" as "default linear thing" 0x1d.
-- Point slipways are changed elsewhere to "man_made=thing"
-- ----------------------------------------------------------------------------
   if ( object.tags["leisure"] == "slipway" ) then
      object = append_nonqa( object, "slipway" )
   end

-- ----------------------------------------------------------------------------
-- Waterfalls
-- In points as "0x6508"
-- ----------------------------------------------------------------------------
   if ( object.tags["natural"] == "waterfall" ) then
      object.tags["waterway"] = "waterfall"
   end

-- ----------------------------------------------------------------------------
-- waterway=lock_gate
-- In points file as "0x1607"
-- "0x1607" does not appear in All POIs and is not searchable
-- No icon visible in QMapShack
-- A unique icon ("a white exclamation mark") appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if ( object.tags["waterway"] == "lock_gate" ) then
      object = append_nonqa( object, "lock gate" )
   end

-- ----------------------------------------------------------------------------
-- waterway=sluice_gate etc. - send through as man_made=thing and append name
-- In points as "0x6511".
-- "0x6511" is searchable via "Geographic Points / Water Features"
-- No icon appears in QMapShack
-- A dot appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if ((  object.tags["waterway"]     == "sluice_gate"      ) or
       (  object.tags["waterway"]     == "sluice"           ) or
       (( object.tags["waterway"]     == "flow_control"    )  and
        ( object.tags["flow_control"] == "sluice_gate"     ))) then
      object = append_nonqa( object, "sluice" )
      object.tags["natural"] = "spring"
   end

-- ----------------------------------------------------------------------------
-- ford=yes
-- A suffix, but no tag changes, is used for fords that are ways.
-- man_made=thing is added to nodes
-- "man_made=thing" is in "points" as "0x2f14"
-- "0x2f14" is searchable via "Others / Social Service"
-- A dot appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if (( object.tags["ford"] == "ford"           ) or
       ( object.tags["ford"] == "intermittent"   ) or
       ( object.tags["ford"] == "seasonal"       ) or
       ( object.tags["ford"] == "stream"         ) or
       ( object.tags["ford"] == "tidal"          ) or
       ( object.tags["ford"] == "yes"            ) or
       ( object.tags["ford"] == "Tidal_Causeway" )) then
      object = append_nonqa( object, "ford" )

      if (( object.tags["ford"] ~= "ford" ) and
          ( object.tags["ford"] ~= "yes"  )) then
         object = append_nonqa( object, object.tags["ford"] )
      end

      if ( objtype == "n" ) then
         object.tags["man_made"] = "thing"
      end
   end

-- ----------------------------------------------------------------------------
-- ford=stepping_stones
-- A suffix, but no tag changes, is used for ways.
-- man_made=thing is added to nodes
-- "man_made=thing" is in "points" as "0x2f14"
-- "0x2f14" is searchable via "Others / Social Service"
-- A dot appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if ( object.tags["ford"] == "stepping_stones" ) then
      object = append_nonqa( object, object.tags["ford"] )

      if ( objtype == "n" ) then
         object.tags["man_made"] = "thing"
      end
   end

-- ----------------------------------------------------------------------------
-- Abandoned railways etc.
-- Appropriate suffixes are added, then
-- all then are passed through to the style as "railway=abandoned" with an
-- appropriate suffix.
-- ----------------------------------------------------------------------------
   if ((( object.tags["railway:historic"] == "rail"           )  or
        ( object.tags["historic"]         == "inclined_plane" )  or
        ( object.tags["historic"]         == "tramway"        )) and
       (  object.tags["building"]         == nil               ) and
       (  object.tags["highway"]          == nil               ) and
       (  object.tags["railway"]          == nil               ) and
       (  object.tags["waterway"]         == nil               )) then
      if ( object.tags["railway:historic"] ~= nil ) then
         object = append_nonqa( object, "railway:historic" )
         object = append_nonqa( object, object.tags["railway:historic"] )
      end

      if ( object.tags["historic"] ~= nil ) then
         object = append_nonqa( object, "historic" )
         object = append_nonqa( object, object.tags["historic"] )
      end

      object.tags["railway"] = "abandoned"
   end

   if ( object.tags["railway"] == "abandoned" ) then
      object = append_nonqa( object, "abrly" )
   end

   if (( object.tags["railway"] == "dismantled" ) or
       ( object.tags["railway"] == "razed"      )) then
      object.tags["railway"] = "abandoned"
      object = append_nonqa( object, "dismrly" )
   end

   if ( object.tags["railway"] == "disused" ) then
      object.tags["railway"] = "abandoned"
      object = append_nonqa( object, "disurly" )
   end

   if ( object.tags["railway"] == "construction" ) then
      object.tags["railway"] = "abandoned"
      object = append_nonqa( object, "constrly" )
   end

-- ----------------------------------------------------------------------------
-- Render bus guideways as "a sort of railway"
-- ----------------------------------------------------------------------------
   if (object.tags["highway"] == "bus_guideway") then
      object.tags["highway"] = nil
      object.tags["railway"] = "abandoned"
      object = append_nonqa( object, "bus guideway" )
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
       ( object.tags["abandoned"]          == "waterway=canal"  ) or
       (( object.tags["historic"]          == "moat"           )  and
        ( object.tags["natural"]           == nil              )  and
        ( object.tags["man_made"]          == nil              )  and
        ( object.tags["waterway"]          == nil              )  and
        ( object.tags["area"]              ~= "yes"            ))) then
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
      object = append_nonqa( object, "derelict canal" )
   end

-- ----------------------------------------------------------------------------
-- Intermittent water
-- ----------------------------------------------------------------------------
   if ((( object.tags["waterway"] ~= nil      )   or
        ( object.tags["natural"]  ~= nil      ))  and
       (  object.tags["intermittent"] == "yes" )) then
      object = append_nonqa( object, "int" )
   end

-- ----------------------------------------------------------------------------
-- Various man_made things as normal buildings
-- The man_made tag is appended to the name.
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
       ( object.tags["man_made"]   == "street_cabinet"   ) or
       ( object.tags["man_made"]   == "aeroplane"        ) or
       ( object.tags["man_made"]   == "helicopter"       )) then
      object.tags["building"] = "yes"
      object = append_nonqa( object, object.tags["man_made"] )
      object.tags["man_made"] = nil
   end

-- ----------------------------------------------------------------------------
-- Disused buildings
-- "man_made=thing" is in "points" as "0x2f14"
-- "0x2f14" is searchable via "Others / Social Service"
-- ----------------------------------------------------------------------------
   if (( object.tags["disused:building"] ~= nil  )  and
       ( object.tags["disused:building"] ~= "no" )  and
       ( object.tags["building"]         == nil  )) then
      object = append_nonqa( object, "disused:building" )
      object = append_nonqa( object, object.tags["disused:building"] )
      object.tags["man_made"] = "thing"
   end

-- ----------------------------------------------------------------------------
-- Various tags are used for milk churn stands
-- "man_made=thing" is in "points" as "0x2f14"
-- "0x2f14" is searchable via "Others / Social Service"
-- ----------------------------------------------------------------------------
   if ((  object.tags["man_made"] == "milk_churn_stand" ) or
       (  object.tags["memorial"] == "milk_churn_stand" ) or
       (  object.tags["historic"] == "milk_churn_stand" )) then
      object = append_nonqa( object, "milk_churn_stand" )
      object.tags["man_made"] = "thing"
      object.tags["historic"] = nil
      object.tags["memorial"] = nil
   end

-- ----------------------------------------------------------------------------
-- Map man_made=monument to historic=monument (handled below) if no better tag
-- exists.
-- ----------------------------------------------------------------------------
   if (( object.tags["man_made"] == "monument" )  and
       ( object.tags["historic"] == nil       )) then
      object.tags["historic"] = "memorial"
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
   if ((( object.tags["natural"]   == "hill"         )  or
        ( object.tags["natural"]   == "peak"         )) and
       (( object.tags["man_made"]  == "cairn"        )  or
        ( object.tags["man_made"]  == "survey_point" ))) then
      object.tags["man_made"] = nil
   end

-- ----------------------------------------------------------------------------
-- Convert "natural=saltmarsh" into something we can handle below
-- ----------------------------------------------------------------------------
   if ( object.tags["natural"] == "saltmarsh" ) then
      if ( object.tags["wetland"] == "tidalflat" ) then
         object.tags["tidal"] = "yes"
      else
         object.tags["tidal"] = "no"
      end

      object.tags["natural"] = "wetland"
      object.tags["wetland"] = "saltmarsh"
   end

-- ----------------------------------------------------------------------------
-- natural=peak
-- natural=volcano
-- natural=col
-- natural=rocks
-- man_made=survey_point
-- In points as "0x6616"
-- "0x6616" is searchable via "Geographic Points / Land Features"
-- A "mountain" icon is used.
--
-- natural=rock
-- In points as "0x6614"
-- "0x6614" is searchable via "Geographic Points / Land Features"
-- A dot is used.
--
-- natural=wetland
-- In points as "0x6613", in polygons as "0x51"
-- "0x6613" is searchable via "Geographic Points / Water Features". 
-- "0x6613" appears as a dot.  "0x51" appears as marsh in QMapShack and 
-- on a GPSMAP64s.
-- ----------------------------------------------------------------------------
   if (( object.tags["natural"]   == "peak"    )  or
       ( object.tags["natural"]   == "volcano" )  or
       ( object.tags["natural"]   == "col"     )  or
       ( object.tags["natural"]   == "rocks"   )  or
       ( object.tags["natural"]   == "rock"    )) then
      object = append_nonqa( object, object.tags["natural"] )
   end

   if ( object.tags["natural"]   == "wetland" ) then
      if ( object.tags["wetland"] ~= nil ) then
         object = append_nonqa( object, object.tags["wetland"] )
      end

      if ( object.tags["surface"] ~= nil ) then
         object = append_nonqa( object, object.tags["surface"] )
      end

      if ( object.tags["tidal"] == "yes" ) then
         object = append_nonqa( object, "tidal" )
      end

      object = append_nonqa( object, object.tags["natural"] )
   end

   if (( object.tags["natural"]   == "bare_rock" )  or
       ( object.tags["natural"]   == "scree"     )) then
      object = append_nonqa( object, object.tags["natural"] )

      if ( object.tags["tidal"] == "yes" ) then
         object = append_nonqa( object, "tidal" )
      end

      object.tags["natural"] = "rock"
   end

   if ( object.tags["man_made"]   == "survey_point"  )  then
      object = append_nonqa( object, object.tags["man_made"] )
   end

-- ----------------------------------------------------------------------------
-- place=island
-- In points as "0x650c".  Normally it would be in polygons as "0x53", but
-- this is removed so that the "island of Great Britain" is not displayed over
-- the top of everything else.
-- Does not appear in QMapShack.
-- "0x650c" is searchable via "Geographic Points / Water Features". 
-- "0x650c" appears as a dot on GPSMap64s.
-- ----------------------------------------------------------------------------
   if ( object.tags["place"] == "island" ) then
      object = append_nonqa( object, object.tags["place"] )
   end

-- ----------------------------------------------------------------------------
-- tourism=picnic_site
-- In points as "0x4a00".  
-- Does not appear in QMapShack.
-- "0x4a00" is searchable via "Geographic Points / Manmade Places". 
-- "0x4a00" appears as a picnic site on GPSMap64s.
-- ----------------------------------------------------------------------------
   if ( object.tags["tourism"] == "picnic_site" ) then
      object = append_nonqa( object, object.tags["tourism"] )
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
-- Render historic=memorial, wayside_cross and wayside_shrine
-- "0x2c02" points are searchable via "Attractions / Museum or Historical"
-- "0x0d" polygons don't appear to be searchable directly, but the 
-- "map polygons to points" logic means they're searchable as points.
-- ----------------------------------------------------------------------------
   if ( object.tags["historic"]   == "memorial" ) then
      object = append_nonqa( object, object.tags["historic"] )

      if (( object.tags["memorial:type"] ~= nil )  and
          ( object.tags["memorial"]      == nil )) then
         object.tags["memorial"] = object.tags["memorial:type"]
      end

      if (( object.tags["memorial"] == "cross"           )  or
          ( object.tags["memorial"] == "mercat_cross"    )  or
          ( object.tags["memorial"] == "war_memorial"    )  or
          ( object.tags["memorial"] == "plaque"          )  or
          ( object.tags["memorial"] == "blue_plaque"     )  or
          ( object.tags["memorial"] == "pavement plaque" )  or
          ( object.tags["memorial"] == "statue"          )  or
          ( object.tags["memorial"] == "sculpture"       )  or
          ( object.tags["memorial"] == "stone"           )) then
         object = append_nonqa( object, object.tags["memorial"] )
         object.tags["historic"] = "memorial"
      end
   end

   if (( object.tags["historic"] == "wayside_cross"  ) or
       ( object.tags["historic"] == "wayside_shrine" )) then
      object = append_nonqa( object, object.tags["historic"] )
      object.tags["historic"] = "memorial"
   end

-- ----------------------------------------------------------------------------
-- Map geoglyphs to memorials.
-- "0x2c02" points are searchable via "Attractions / Museum or Historical"
-- "0x0d" polygons don't appear to be searchable directly, but the 
-- "map polygons to points" logic means they're searchable as points.
-- ----------------------------------------------------------------------------
   if ( object.tags["man_made"] == "geoglyph" ) then
      object = append_nonqa( object,object.tags["man_made"] )
      object.tags["historic"] = "memorial"
      object.tags["man_made"] = nil
   end

-- ----------------------------------------------------------------------------
-- historic=monument
-- "0x2c02" points are searchable via "Attractions / Museum or Historical"
-- "0x0d" polygons don't appear to be searchable directly, but the 
-- "map polygons to points" logic means they're searchable as points.
-- ----------------------------------------------------------------------------
   if ( object.tags["historic"]   == "monument"     ) then
      object.tags["historic"] = "memorial"
      object = append_nonqa( object,"monument" )
   end

-- ----------------------------------------------------------------------------
-- tourism=museum is in "points" as "0x2c02"
-- "0x2c02" is searchable via "Attractions / Museum or Historical"
-- A "museum" icon appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if ( object.tags["tourism"] == "museum" ) then
      object.tags["amenity"] = nil
      object = append_nonqa( object, "museum" )
   end

   if ( object.tags["tourism"] == "gallery" ) then
      object.tags["amenity"] = nil
      object.tags["tourism"] = "museum"
      object = append_nonqa( object, "gallery" )
   end

-- ----------------------------------------------------------------------------
-- tourism=artwork is in "points" as "0x2c04"
-- "0x2c02" is searchable via "Attractions / Landmark"
-- A "camera" icon appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if ( object.tags["tourism"] == "artwork" ) then
      object = append_nonqa( object, "artwork" )
   end

-- ----------------------------------------------------------------------------
-- Mineshafts
-- First make sure that we treat historic ones as historic
--
-- historic=ruins is in "points" as "0x2c02"
-- "0x2c02" is searchable via "Attractions / Museum or Historical"
-- A "museum" icon appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if ((  object.tags["disused:man_made"] == "mine"       )  or
       (  object.tags["disused:man_made"] == "mineshaft"  )  or
       (  object.tags["disused:man_made"] == "mine_shaft" )  or
       (( object.tags["man_made"] == "mine"              )  or
        ( object.tags["man_made"] == "mineshaft"         )  or
        ( object.tags["man_made"] == "mine_shaft"        )) and
       (( object.tags["historic"] == "yes"               )  or
        ( object.tags["historic"] == "mine"              )  or
        ( object.tags["historic"] == "mineshaft"         )  or
        ( object.tags["historic"] == "mine_shaft"        ))) then
      object.tags["historic"] = "ruins"
      object.tags["man_made"] = nil
      object.tags["tourism"]  = nil
      object = append_nonqa( object, "historic mine" ) 
   end

-- ----------------------------------------------------------------------------
-- Then other spellings of mineshaft
-- ----------------------------------------------------------------------------
   if (( object.tags["man_made"] == "mine"       )  or
       ( object.tags["man_made"] == "mineshaft"  )  or
       ( object.tags["man_made"] == "mine_shaft" )) then
      object.tags["man_made"] = "thing"
      object = append_nonqa( object, "mine" ) 
   end

-- ----------------------------------------------------------------------------
-- A special case to check before the "vacant shops" check further down -
-- potentially remove disused:amenity=graveyard
-- Also check that historic cemeteraries are not also tagged as non-historic.
-- ----------------------------------------------------------------------------
   if (( object.tags["disused:amenity"] == "grave_yard" ) and
       ( object.tags["landuse"]         == "cemetery"   )) then
      object.tags["disused:amenity"] = nil
   end

   if ((( object.tags["historic"] == "cemetery"   ) or
        ( object.tags["historic"] == "grave_yard" )) and
       (  object.tags["landuse"]  == "cemetery"    )) then
      object.tags["historic"] = nil
   end

-- ----------------------------------------------------------------------------
-- Ensure historic things are shown.
-- There's no distinction here between building / almost a building / 
-- not a building as there is with the web maps.
--
-- historic=ruins is in "points" as "0x2c02"
-- "0x2c02" is searchable via "Attractions / Museum or Historical"
-- A "museum" icon appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"]  == "pinfold"    )  and
       ( object.tags["historic"] == nil          )) then
      object.tags["historic"] = object.tags["amenity"]
      object.tags["amenity"]  = nil
   end

   if (( object.tags["building"] == "pillbox"    )  and
       ( object.tags["historic"] == nil          )) then
      object.tags["historic"] = object.tags["building"]
   end

   if (( object.tags["disused:amenity"] == "grave_yard" ) and
       ( object.tags["landuse"]         ~= "cemetery"   ) and
       ( object.tags["historic"]        == nil          )) then
      object.tags["historic"] = object.tags["disused:amenity"]
   end

   if (( object.tags["disused:military"] == "bunker" ) and
       ( object.tags["historic"]         == nil      ) and
       ( object.tags["military"]         == nil      )) then
      object.tags["historic"] = object.tags["disused:military"]
   end

   if (( object.tags["military"] == "bunker" ) and
       ( object.tags["building"] == "bunker" ) and
       ( object.tags["disused"]  == "yes"    ) and
       ( object.tags["historic"] == nil      )) then
      object.tags["historic"] = object.tags["military"]
   end

-- ----------------------------------------------------------------------------
-- If a historic monastery etc. is still active, remove the historic tag.
-- ----------------------------------------------------------------------------
   if ((   object.tags["historic"] == "abbey"            ) or
       (   object.tags["historic"] == "cathedral"        ) or
       (   object.tags["historic"] == "monastery"        ) or
       (   object.tags["historic"] == "priory"           ) or
       ((  object.tags["historic"] == "ruins"            )  and
        (( object.tags["ruins"] == "abbey"              )  or
         ( object.tags["ruins"] == "cathedral"          )  or
         ( object.tags["ruins"] == "monastery"          )  or
         ( object.tags["ruins"] == "priory"             )))) then
      if ( object.tags["amenity"] == "place_of_worship" ) then
         object.tags["historic"] = nil
      end
   end

-- ----------------------------------------------------------------------------
-- If a historic church etc. is something else, remove the historic tag.
-- ----------------------------------------------------------------------------
   if (( object.tags["historic"] == "chapel"           )  or
       ( object.tags["historic"] == "church"           )  or
       ( object.tags["historic"] == "place_of_worship" )  or
       ( object.tags["historic"] == "wayside_chapel"   )) then
      if (( object.tags["amenity"]  ~= nil ) or
          ( object.tags["shop"]     ~= nil )) then
         object.tags["historic"] = nil
      end
   end

-- ----------------------------------------------------------------------------
-- "historic=industrial" has been used as a modifier for all sorts.  
-- We're not interested in most of these but do display a generic historical
-- marker for some.
-- ----------------------------------------------------------------------------
   if ( object.tags["historic"] == "industrial" ) then
      if (( object.tags["building"] ~= nil ) or
          ( object.tags["man_made"] ~= nil ) or
          ( object.tags["waterway"] ~= nil ) or
          ( object.tags["name"]     == nil )) then
         object.tags["historic"] = nil
      end
   end

-- ----------------------------------------------------------------------------
-- Detect former kilns tagged as "ruins:man_made". 
-- ----------------------------------------------------------------------------
   if ( object.tags["ruins:man_made"] == "kiln" ) then
      object.tags["historic"]       = "kiln"
      object.tags["ruins:man_made"] = nil
   end

-- ----------------------------------------------------------------------------
-- Detect former kilns tagged as "ruins:man_made". 
-- ----------------------------------------------------------------------------
   if ((( object.tags["railway"]          == "water_crane" ) or
        ( object.tags["disused:railway"]  == "water_crane" )) and
       (( object.tags["historic"]         == nil           )  or
        ( object.tags["historic"]         == "yes"         ))) then
      object.tags["historic"] = "water_crane"
   end

-- ----------------------------------------------------------------------------
-- Various historic items
-- ----------------------------------------------------------------------------
   if (( object.tags["historic"] == "abbey"                     ) or
       ( object.tags["historic"] == "aircraft"                  ) or
       ( object.tags["historic"] == "aircraft_wreck"            ) or
       ( object.tags["historic"] == "almshouse"                 ) or
       ( object.tags["historic"] == "anchor"                    ) or
       ( object.tags["historic"] == "bakery"                    ) or
       ( object.tags["historic"] == "barrow"                    ) or
       ( object.tags["historic"] == "baths"                     ) or
       ( object.tags["historic"] == "battlefield"               ) or
       ( object.tags["historic"] == "battery"                   ) or
       ( object.tags["historic"] == "bridge_site"               ) or
       ( object.tags["historic"] == "building"                  ) or
       ( object.tags["historic"] == "bunker"                    ) or
       ( object.tags["historic"] == "camp"                      ) or
       ( object.tags["historic"] == "cannon"                    ) or
       ( object.tags["historic"] == "castle"                    ) or
       ( object.tags["historic"] == "cathedral"                 ) or
       ( object.tags["historic"] == "celtic_cross"              ) or
       ( object.tags["historic"] == "cemetery"                  ) or
       ( object.tags["historic"] == "chapel"                    ) or
       ( object.tags["historic"] == "church"                    ) or
       ( object.tags["historic"] == "city_gate"                 ) or
       ( object.tags["historic"] == "clochan"                   ) or
       ( object.tags["historic"] == "country_mansion"           ) or
       ( object.tags["historic"] == "cross"                     ) or
       ( object.tags["historic"] == "deserted_medieval_village" ) or
       ( object.tags["historic"] == "dovecote"                  ) or
       ( object.tags["historic"] == "drinking_fountain"         ) or
       ( object.tags["historic"] == "earthworks"                ) or
       ( object.tags["historic"] == "folly"                     ) or
       ( object.tags["historic"] == "fort"                      ) or
       ( object.tags["historic"] == "fortification"             ) or
       ( object.tags["historic"] == "gate"                      ) or
       ( object.tags["historic"] == "gate_house"                ) or
       ( object.tags["historic"] == "grave"                     ) or
       ( object.tags["historic"] == "grave_yard"                ) or
       ( object.tags["historic"] == "grinding_mill"             ) or
       ( object.tags["historic"] == "hall"                      ) or
       ( object.tags["historic"] == "heritage_building"         ) or
       ( object.tags["historic"] == "high_cross"                ) or
       ( object.tags["historic"] == "house"                     ) or
       ( object.tags["historic"] == "ice_house"                 ) or
       ( object.tags["historic"] == "icon"                      ) or
       ( object.tags["historic"] == "industrial"                ) or
       ( object.tags["historic"] == "jail"                      ) or
       ( object.tags["historic"] == "kiln"                      ) or
       ( object.tags["historic"] == "lime_kiln"                 ) or
       ( object.tags["historic"] == "locomotive"                ) or
       ( object.tags["historic"] == "manor"                     ) or
       ( object.tags["historic"] == "mansion"                   ) or
       ( object.tags["historic"] == "martello_tower"            ) or
       ( object.tags["historic"] == "martello_tower;bunker"     ) or
       ( object.tags["historic"] == "market_cross"              ) or
       ( object.tags["historic"] == "mill"                      ) or
       ( object.tags["historic"] == "millstone"                 ) or
       ( object.tags["historic"] == "mine"                      ) or
       ( object.tags["historic"] == "mine_adit"                 ) or
       ( object.tags["historic"] == "mine_level"                ) or
       ( object.tags["historic"] == "mine_shaft"                ) or
       ( object.tags["historic"] == "monastery"                 ) or
       ( object.tags["historic"] == "monastic_grange"           ) or
       ( object.tags["historic"] == "monument"                  ) or
       ( object.tags["historic"] == "mound"                     ) or
       ( object.tags["historic"] == "naval_mine"                ) or
       ( object.tags["historic"] == "oratory"                   ) or
       ( object.tags["historic"] == "palace"                    ) or
       ( object.tags["historic"] == "pillbox"                   ) or
       ( object.tags["historic"] == "pillory"                   ) or
       ( object.tags["historic"] == "pinfold"                   ) or
       ( object.tags["historic"] == "place_of_worship"          ) or
       ( object.tags["historic"] == "police_call_box"           ) or
       ( object.tags["historic"] == "pound"                     ) or
       ( object.tags["historic"] == "priory"                    ) or
       ( object.tags["historic"] == "prison"                    ) or
       ( object.tags["historic"] == "protected_building"        ) or
       ( object.tags["historic"] == "rath"                      ) or
       ( object.tags["historic"] == "residence"                 ) or
       ( object.tags["historic"] == "roundhouse"                ) or
       ( object.tags["historic"] == "round_tower"               ) or
       ( object.tags["historic"] == "ruins"                     ) or
       ( object.tags["historic"] == "sawmill"                   ) or
       ( object.tags["historic"] == "shelter"                   ) or
       ( object.tags["historic"] == "ship"                      ) or
       ( object.tags["historic"] == "smithy"                    ) or
       ( object.tags["historic"] == "sound_mirror"              ) or
       ( object.tags["historic"] == "stately_home"              ) or
       ( object.tags["historic"] == "statue"                    ) or
       ( object.tags["historic"] == "stocks"                    ) or
       ( object.tags["historic"] == "tank"                      ) or
       ( object.tags["historic"] == "tau_cross"                 ) or
       ( object.tags["historic"] == "theatre"                   ) or
       ( object.tags["historic"] == "toll_house"                ) or
       ( object.tags["historic"] == "tomb"                      ) or
       ( object.tags["historic"] == "tower"                     ) or
       ( object.tags["historic"] == "tower_house"               ) or
       ( object.tags["historic"] == "trough"                    ) or
       ( object.tags["historic"] == "tumulus"                   ) or
       ( object.tags["historic"] == "vehicle"                   ) or
       ( object.tags["historic"] == "village"                   ) or
       ( object.tags["historic"] == "village_pump"              ) or
       ( object.tags["historic"] == "water_crane"               ) or
       ( object.tags["historic"] == "water_pump"                ) or
       ( object.tags["historic"] == "watermill"                 ) or
       ( object.tags["historic"] == "wayside_chapel"            ) or
       ( object.tags["historic"] == "well"                      ) or
       ( object.tags["historic"] == "windmill"                  ) or
       ( object.tags["historic"] == "wreck"                     )) then
      object.tags["tourism"] = nil

      if ( object.tags["name"] == nil ) then
         object.tags.name = "(historic " .. object.tags["historic"] .. ")"
      else
         object.tags.name = object.tags["name"] .. " (historic " .. object.tags["historic"] .. ")"
      end

      object.tags["historic"] = "ruins"

      if ( object.tags["archaeological_site"]  ~= nil ) then
         object = append_nonqa( object, object.tags["archaeological_site"] ) 
      end

      if ( object.tags["fortification_type"]  ~= nil ) then
         object = append_nonqa( object, object.tags["fortification_type"] ) 
      end

      if ( object.tags["historic:civilization"]  ~= nil ) then
         object = append_nonqa( object, object.tags["historic:civilization"] ) 
      end

      if ( object.tags["ruins"]  ~= nil ) then
         object = append_nonqa( object, object.tags["ruins"] ) 
      end

      if ( object.tags["tower:type"]  ~= nil ) then
         object = append_nonqa( object, object.tags["tower:type"] ) 
      end

      if ( object.tags["castle_type"]  ~= nil ) then
         object = append_nonqa( object, object.tags["castle_type"] ) 
      end
   end

-- ----------------------------------------------------------------------------
-- If something is tagged as both an archaelogical site and a place, lose the
-- place tag.
-- ----------------------------------------------------------------------------
   if (( object.tags["historic"] == "archaeological_site" )  and
       ( object.tags["place"]    ~= nil                   )) then
      object.tags["place"] = nil
   end

-- ----------------------------------------------------------------------------
-- historic=archaeological_site
-- In "points" as "0x2c02"
-- "0x2c02" is searchable via "Attractions / Museum or Historical"
-- A "museum" icon appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if (( object.tags["historic"] == "archaeological_site" )  and
       ( object.tags["landuse"]  == nil                   )) then
      object.tags["tourism"] = nil

      if ( object.tags["megalith_type"] == "standing_stone" ) then
         object = append_nonqa( object, "standing stone" ) 
      else
         object = append_nonqa( object, "archaeological site" ) 
      end

      if ( object.tags["archaeological_site"]  ~= nil ) then
         object = append_nonqa( object, object.tags["archaeological_site"] ) 
      end

      if ( object.tags["fortification_type"]  ~= nil ) then
         object = append_nonqa( object, object.tags["fortification_type"] ) 
      end

      if ( object.tags["historic:civilization"]  ~= nil ) then
         object = append_nonqa( object, object.tags["historic:civilization"] ) 
      end
   end

-- ----------------------------------------------------------------------------
-- palaeolontological_site
-- ----------------------------------------------------------------------------
   if ( object.tags["geological"] == "palaeontological_site" ) then
      object.tags["historic"] = "archaeological_site"
      object = append_nonqa( object, "palaeontological site" ) 
   end

-- ----------------------------------------------------------------------------
-- historic=icon shouldn't supersede amenity or tourism tags.
-- ----------------------------------------------------------------------------
   if (( object.tags["historic"] == "icon" ) and
       ( object.tags["amenity"]  == nil    ) and
       ( object.tags["tourism"]  == nil    )) then
      object.tags["historic"] = nil
      object.tags["man_made"] = "thing"
      object = append_nonqa( object, "historic icon" )
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
      object = append_nonqa( object, "chimney" )
      object.tags["man_made"] = "tower"
      object.tags["historic"] = nil
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
   if (( object.tags["bridge"] == "aqueduct"           ) or
       ( object.tags["bridge"] == "bailey"             ) or
       ( object.tags["bridge"] == "boardwalk"          ) or
       ( object.tags["bridge"] == "building_passage"   ) or
       ( object.tags["bridge"] == "cantilever"         ) or
       ( object.tags["bridge"] == "chain"              ) or
       ( object.tags["bridge"] == "covered"            ) or
       ( object.tags["bridge"] == "foot"               ) or
       ( object.tags["bridge"] == "footbridge"         ) or
       ( object.tags["bridge"] == "gangway"            ) or
       ( object.tags["bridge"] == "low_water_crossing" ) or
       ( object.tags["bridge"] == "movable"            ) or
       ( object.tags["bridge"] == "pier"               ) or
       ( object.tags["bridge"] == "plank"              ) or
       ( object.tags["bridge"] == "plank_bridge"       ) or
       ( object.tags["bridge"] == "pontoon"            ) or
       ( object.tags["bridge"] == "rope"               ) or
       ( object.tags["bridge"] == "swing"              ) or
       ( object.tags["bridge"] == "trestle"            ) or
       ( object.tags["bridge"] == "undefined"          ) or
       ( object.tags["bridge"] == "viaduct"            )) then
      object.tags["bridge"] = "yes"
   end

-- ----------------------------------------------------------------------------
-- Remove some combinations of bridge
-- ----------------------------------------------------------------------------
   if ((  object.tags["bridge"]  == "yes"          ) and
       (( object.tags["barrier"] == "cattle_grid" )  or
        ( object.tags["barrier"] == "stile"       ))) then
      object.tags["barrier"] = nil
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
       ( object.tags["tunnel"] == "flooded"             ) or
       ( object.tags["tunnel"] == "building_passage"    )) then
      object.tags["tunnel"] = "yes"
   end

-- ----------------------------------------------------------------------------
-- The code to handle various sorts of ways of supplying electricity is 
-- borrowed from the web maps' "style.lua".  We later move these to appropriate
-- Garmin menus.
--
-- Alleged petrol stations that only do fuel:electricity are probably 
-- actually charging stations.
--
-- The combination of "amenity=fuel, electricity, no diesel" is as good as
-- we can make  it without guessing based on brand.  "fuel, electricity,
-- some sort of petrol, no diesel" is not a thing in the UK/IE data currently.
-- Similarly, electric waterway=fuel are charging stations.
--
-- Show vending machines that sell petrol as fuel.
-- One UK/IE example, on an airfield, and "UL91" finds it.
--
-- Show aeroway=fuel as amenity=fuel.  All so far in UK/IE are 
-- general aviation.
--
-- Show waterway=fuel as fuel as well.
--
-- Once we've got those out of the way, detect amenity=fuel that also sell
-- electricity, hydrogen and LPG.
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"]          == "fuel" ) and
       ( object.tags["fuel:electricity"] == "yes"  )  and
       ( object.tags["fuel:diesel"]      == nil    )) then
      object.tags["amenity"] = "charging_station"
   end

   if (( object.tags["waterway"]         == "fuel" ) and
       ( object.tags["fuel:electricity"] == "yes"  )) then
      object.tags["amenity"] = "charging_station"
      object.tags["waterway"] = nil
   end

   if (( object.tags["amenity"] == "vending_machine" ) and
       ( object.tags["vending"] == "fuel"            )  and
       ( object.tags["fuel"]    == "UL91"            )) then
      object.tags["amenity"] = "fuel"
   end

   if ( object.tags["aeroway"] == "fuel" ) then
      object.tags["aeroway"] = nil
      object.tags["amenity"] = "fuel"
   end

   if ( object.tags["waterway"] == "fuel" ) then
      object.tags["amenity"] = "fuel"
      object.tags["waterway"] = nil
   end

-- ----------------------------------------------------------------------------
-- amenity=fuel and shop=convenience
--
-- Garmin has two codes for amenity=fuel:
-- 0x2e06 for amenity=fuel & shop=convenience ("Shopping / Convenience" and
-- "Fuel Services / Convenience")
-- 0x2f01 for just amenity=fuel on its own. ("Fuel Services / Auto Fuel")
-- Both are labelled "convenience", which is confusing, since
-- 0x2e0e is just shop=convenience on its own.
--
-- We ensure all our combined amenity=fuel and shop=convenience appear under
-- "Fuel Services / Auto Fuel", but append the shop type as a suffix.
-- We append "fuel" as a suffix here and (if appropriate) other alternative 
-- fuel types too.
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "fuel" ) then
      object = append_nonqa( object, object.tags["amenity"] )

      if ( object.tags["shop"] ~= nil  ) then
         object = append_nonqa( object, object.tags["shop"] )
         object.tags["shop"] = nil
      end

      object = building_or_landuse( objtype, object )
   end

   if (( object.tags["amenity"]          == "fuel" ) and
       ( object.tags["fuel:electricity"] == "yes"  )  and
       ( object.tags["fuel:diesel"]      == "yes"  )) then
      object = append_nonqa( object, "E" )
   end

   if ((  object.tags["amenity"]  == "fuel"  ) and
       (( object.tags["fuel:H2"]  == "yes"  )  or
        ( object.tags["fuel:LH2"] == "yes"  ))) then
      object = append_nonqa( object, "H2" )
   end

   if ((  object.tags["amenity"]  == "fuel"  ) and
       (( object.tags["LPG"]      == "yes"  )  or
        ( object.tags["fuel"]     == "lpg"  )  or
        ( object.tags["fuel:lpg"] == "yes"  ))) then
      object = append_nonqa( object, "LPG" )
   end

-- ----------------------------------------------------------------------------
-- Change amenity=charging_station to amenity=fuel so that it is searchable
-- 0x2f01 is searchable via "Fuel Services / Auto Fuel"
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"]  == "charging_station" ) then
      object = append_nonqa( object, object.tags["amenity"] )
      object.tags["amenity"] = "fuel"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Render windmill buildings and former windmills as windmills.
-- ----------------------------------------------------------------------------
   if (( object.tags["man_made"] == "watermill") or
       ( object.tags["man_made"] == "windmill" )) then
      if (( object.tags["disused"]           == "yes"  ) or
          ( object.tags["watermill:disused"] == "yes"  ) or
          ( object.tags["windmill:disused"]  == "yes"  )) then
         object.tags["historic"] = object.tags["man_made"]
         object.tags["man_made"] = nil
      else
         object.tags["historic"] = nil
      end
   end

   if ((( object.tags["disused:man_made"] == "watermill")  or
        ( object.tags["disused:man_made"] == "windmill" )) and
       (  object.tags["amenity"]          == nil         ) and
       (  object.tags["man_made"]         == nil         ) and
       (  object.tags["shop"]             == nil         )) then
      object.tags["historic"] = object.tags["disused:man_made"]
      object.tags["disused:man_made"] = nil
   end

-- ----------------------------------------------------------------------------
-- Render (windmill buildings and former windmills) that are not something 
-- else as historic windmills.
-- ----------------------------------------------------------------------------
   if ((  object.tags["historic"] == "ruins"      ) and
       (( object.tags["ruins"]    == "watermill" )  or
        ( object.tags["ruins"]    == "windmill"  ))) then
      object.tags["historic"] = object.tags["ruins"]
      object.tags["ruins"] = "yes"
   end

   if (((   object.tags["building"] == "watermill"        )  or
        (   object.tags["building"] == "former_watermill" )) and
       ((   object.tags["amenity"]  == nil                 ) and
        (   object.tags["man_made"] == nil                 ) and
        ((  object.tags["historic"] == nil                )  or
         (  object.tags["historic"] == "restoration"      )  or
         (  object.tags["historic"] == "heritage"         )  or
         (  object.tags["historic"] == "industrial"       )  or
         (  object.tags["historic"] == "tower"            )))) then
      object.tags["historic"] = "watermill"
   end

   if (((   object.tags["building"] == "windmill"        )  or
        (   object.tags["building"] == "former_windmill" )) and
       ((   object.tags["amenity"]  == nil                ) and
        (   object.tags["man_made"] == nil                ) and
        ((  object.tags["historic"] == nil               )  or
         (  object.tags["historic"] == "restoration"     )  or
         (  object.tags["historic"] == "heritage"        )  or
         (  object.tags["historic"] == "industrial"      )  or
         (  object.tags["historic"] == "tower"           )))) then
      object.tags["historic"] = "windmill"
   end

   if ((( object.tags["historic"] == "watermill"        )  or
        ( object.tags["man_made"] == "watermill"        )  or
        ( object.tags["building"] == "watermill"        )  or
        ( object.tags["building"] == "former_watermill" )) and
       (  object.tags["amenity"]  == nil                )) then
      object.tags["man_made"] = "thing"
      object.tags["building"] = "watermill"
      object.tags["tourism"] = nil
      object = append_nonqa( object, "watermill" )

      if ( object.tags["historic"]  ~= nil ) then
         object = append_nonqa( object, object.tags["historic"] ) 
      end
   end

   if ((( object.tags["historic"] == "windmill"        )  or
        ( object.tags["man_made"] == "windmill"        )  or
        ( object.tags["building"] == "windmill"        )  or
        ( object.tags["building"] == "former_windmill" )) and
       (  object.tags["amenity"]  == nil                )) then
      object.tags["man_made"] = "thing"
      object.tags["building"] = "windmill"
      object.tags["tourism"] = nil
      object = append_nonqa( object, "windmill" )

      if ( object.tags["historic"]  ~= nil ) then
         object = append_nonqa( object, object.tags["historic"] ) 
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
      object = append_nonqa( object, object.tags["tpuk_ref"] )
   end

-- ----------------------------------------------------------------------------
-- Disused railway platforms
-- ----------------------------------------------------------------------------
   if (( object.tags["railway"] == "platform" ) and
       ( object.tags["disused"] == "yes"       )) then
      object.tags["railway"] = nil
      object.tags["disused:railway"] = "platform"
   end

-- ----------------------------------------------------------------------------
-- Suppress Underground railway platforms
-- ----------------------------------------------------------------------------
   if (( object.tags["railway"]  == "platform"    ) and
       ( object.tags["location"] == "underground" )) then
      object.tags["railway"] = nil
   end

-- ----------------------------------------------------------------------------
-- If railway platforms have no name but do have a ref, use it.
-- Railway platforms with a name probably don't need to have the ref appended.
-- ----------------------------------------------------------------------------
   if (( object.tags["railway"] == "platform" ) and
       ( object.tags["name"]    == nil        ) and
       ( object.tags["ref"]     ~= nil        )) then
      object = append_nonqa( object, "Platform " .. object.tags["ref"] )
      object.tags["ref"]  = nil
   end

-- ----------------------------------------------------------------------------
-- natural=water
-- In points as "0x650d", in polygons as "0x3c"
-- QMapShack doesn't seem to understand "0x650d" 
-- but "0x3c" appears as "large lake"
-- On a GPSMAP64s, "0x650d" appears in "Geographic Points / Water Features"
--
-- landuse=reservoir
-- In points as "0x650f", in polygons as "0x3f"
-- QMapShack understands "0x650f" and "0x3f" as "medium lake"
-- On a GPSMAP64s, "0x650f" appears in "Geographic Points / Water Features"
--
-- landuse=basin
-- In points as "0x6603", in polygons as "0x3f"
-- QMapShack understands "0x6603" and "0x3f" as water.
-- On a GPSMAP64s, "0x6603" appears in "Geographic Points / Land Features"
--
-- Firstly, let's reorganise tags if needed so that the rest of the lua can 
-- understand what we are dealing with:
-- ----------------------------------------------------------------------------
   if ( object.tags["man_made"] == "lagoon"  ) then
      object.tags["natural"] = "water"
      object.tags["water"] = "lagoon"
      object.tags["landuse"] = nil
      object.tags["man_made"] = nil
   end

   if ((( object.tags["natural"]  == "water"     )  and
        ( object.tags["water"]    == "reservoir" )) or
       (  object.tags["man_made"] == "reservoir"  )) then
      object.tags["landuse"] = "reservoir"
      object.tags["natural"] = nil
      object.tags["man_made"] = nil
   end

-- ----------------------------------------------------------------------------
-- Suppress "name" on riverbanks mapped as "natural=water"
-- ----------------------------------------------------------------------------
   if ((  object.tags["natural"]   == "water"   ) and
       (( object.tags["water"]     == "river"  )  or
        ( object.tags["water"]     == "canal"  )  or
        ( object.tags["water"]     == "stream" )  or
        ( object.tags["water"]     == "ditch"  )  or
        ( object.tags["water"]     == "lock"   )  or
        ( object.tags["water"]     == "drain"  ))) then
      object.tags["name"] = nil
   end

-- ----------------------------------------------------------------------------
-- Next, handle wastewater as a suffix, if necessary.
-- ----------------------------------------------------------------------------
   if ((  object.tags["man_made"]       == "wastewater_reservoir"  ) or
       (  object.tags["basin"]          == "wastewater"            ) or
       (( object.tags["landuse"]        == "reservoir"            )  and
        ( object.tags["reservoir_type"] == "sewage"               ))) then
      object = append_nonqa( object, "wastewater" )
      object.tags["landuse"] = "reservoir"
      object.tags["man_made"] = nil
   end

-- ----------------------------------------------------------------------------
-- Finally append water type or landuse suffix if appropriate.
-- Regular natural=water without a water type doesn't get a suffix.
-- Also don't add a suffix for common linear types, as the centroid may be 
-- often outside the area.
-- ----------------------------------------------------------------------------
   if ( object.tags["natural"] == "water"  ) then
      if (( object.tags["water"] ~= nil      ) and
          ( object.tags["water"] ~= "river"  ) and
          ( object.tags["water"] ~= "canal"  ) and
          ( object.tags["water"] ~= "stream" ) and
          ( object.tags["water"] ~= "ditch"  ) and
          ( object.tags["water"] ~= "drain"  )) then
         object = append_nonqa( object, object.tags["water"] )
      end

      object.tags["natural"] = "water"
   end

   if (( object.tags["landuse"]   == "reservoir"  ) or
       ( object.tags["landuse"]   == "basin"      )) then
      object = append_nonqa( object, object.tags["landuse"] )

      if ( object.tags["basin"] ~= nil ) then
         object = append_nonqa( object, object.tags["basin"] )
      end

      if ( object.tags["reservoir"] ~= nil ) then
         object = append_nonqa( object, object.tags["reservoir"] )
      end

      if ( object.tags["reservoir_type"] ~= nil ) then
         object = append_nonqa( object, object.tags["reservoir_type"] )
      end
   end

-- ----------------------------------------------------------------------------
-- natural=beach
-- In points as "0x6604", not in polygons.
-- QMapShack understands "0x6604"
-- On a GPSMAP64s, "0x6604" appears in "Geographic Points / Land Features"
-- A "desert island" icon is used.
--
-- natural=cave_entrance
-- In points as "0x6601", not in polygons.
-- QMapShack understands "0x6601"
-- On a GPSMAP64s, "0x6601" appears in "Geographic Points / Land Features"
-- A dot is used.
--
-- natural=cliff
-- In points as "0x6607", in lines as "0x1d" ("county border").
-- QMapShack understands "0x6607" and "0x1d".
-- On a GPSMAP64s, "0x6607" appears in "Geographic Points / Land Features"
-- A dot is used for nodes.  Ways appear as a narrow solid line.
-- ----------------------------------------------------------------------------
   if ( object.tags["natural"]   == "beach" ) then
      object = append_nonqa( object, object.tags["natural"] )

      if ( object.tags["tidal"] == "yes" ) then
         object = append_nonqa( object, "tidal" )
      end

      object.tags["natural"] = "beach"
   end

   if (( object.tags["natural"]   == "cave_entrance" ) or
       ( object.tags["natural"]   == "cliff"         )) then
      object = append_nonqa( object, object.tags["natural"] )
   end

-- ----------------------------------------------------------------------------
-- Show wind turbines and wind pumps
-- ----------------------------------------------------------------------------
   if ((   object.tags["man_made"]         == "wind_turbine"   ) or
       (   object.tags["generator:method"] == "wind_turbine"   ) or
       ((  object.tags["man_made"]         == "tower"         )  and
        (  object.tags["power"]            == "generator"     )  and
        (( object.tags["power_source"]     == "wind"         )   or
         ( object.tags["generator:source"] == "wind"         )   or
         ( object.tags["generator:method"] == "wind_turbine" )   or
         ( object.tags["plant:source"]     == "wind"         )   or
         ( object.tags["generator:method"] == "wind"         )))) then
      object.tags["man_made"] = "tower"

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
-- man_made=thing
-- In "points" as "0x2f14"
-- "0x2f14" is searchable via "Others / Social Service"
-- A dot appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if (( object.tags["building"]   == "air_shaft"         ) or
       ( object.tags["man_made"]   == "air_shaft"         ) or
       ( object.tags["tunnel"]     == "air_shaft"         ) or
       ( object.tags["historic"]   == "air_shaft"         ) or
       ( object.tags["man_made"]   == "ventilation_shaft" ) or
       ( object.tags["railway"]    == "ventilation_shaft" ) or
       ( object.tags["tunnel"]     == "ventilation_shaft" ) or
       ( object.tags["tunnel"]     == "ventilation shaft" ) or
       ( object.tags["building"]   == "ventilation_shaft" ) or
       ( object.tags["building"]   == "vent_shaft"        ) or
       ( object.tags["man_made"]   == "vent_shaft"        ) or
       ( object.tags["tower:type"] == "vent"              ) or
       ( object.tags["tower:type"] == "ventilation_shaft" )) then
      object.tags["man_made"] = "thing"

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(vent shaft)"
      else
         object.tags["name"] = object.tags["name"] .. " (vent shaft)"
      end
   end

-- ----------------------------------------------------------------------------
-- Horse mounting blocks
-- man_made=thing
-- In "points" as "0x2f14"
-- "0x2f14" is searchable via "Others / Social Service"
-- A dot appears on a GPSMAP64s
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
-- 0x6511 is searchable via "Geographic Points / Water Features"
-- ----------------------------------------------------------------------------
   if ((  object.tags["man_made"]                  == "monitoring_station"  ) and
       (( object.tags["monitoring:water_level"]    == "yes"                )  or
        ( object.tags["monitoring:water_flow"]     == "yes"                )  or
        ( object.tags["monitoring:water_velocity"] == "yes"                ))) then
      object = append_nonqa( object, "water monitoring" )
      object.tags["natural"] = "spring"
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
-- Waste transfer stations
-- First, try and identify mistagged ones.
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"] == "waste_transfer_station" ) and
       ( object.tags["recycling_type"] == "centre"          )) then
      object.tags["amenity"] = "recycling"
   end

-- ----------------------------------------------------------------------------
-- Next, treat "real" waste transfer stations as industrial.  We remove the 
-- amenity tag here because there's no icon for amenity=waste_transfer_station;
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "waste_transfer_station" ) then
      object.tags["amenity"] = nil
      object.tags["landuse"] = "industrial"
      object = append_nonqa( object, "waste transfer station" )
   end

-- ----------------------------------------------------------------------------
-- Recycling bins and recycling centres.
-- Any recycling object without recycling_type is assumed to be a bin.
-- "amenity=recycling" is in "points" as "0x2f15" 
-- and is searchable via "Community / Utility"
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "recycling" ) then
      if ( object.tags["recycling_type"] == "centre" ) then
         object = append_nonqa( object, "recycling centre" )
      else
         object = append_nonqa( object, "recycling bins" )
      end
   end

-- ----------------------------------------------------------------------------
-- Waste disposal
-- We set the tag to "amenity=recycling" which is in "points" as "0x2f15"
-- and is searchable via "Community / Utility"
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "waste_disposal" ) then
      object.tags["amenity"] = "recycling"
      object = append_nonqa( object, "waste disposal" )
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
-- railway=transfer_station - show as "halt"
-- This is for Manulla Junction, https://www.openstreetmap.org/node/5524753168
-- ----------------------------------------------------------------------------
   if ( object.tags["railway"] == "transfer_station" ) then
      object.tags["railway"] = "halt"
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
-- Hotels
-- "0x2b01" is searchable via "Lodging / Motel or Motel"
-- ----------------------------------------------------------------------------
   if ((  object.tags["tourism"]    == "hotel"  ) or
       ( object.tags["tourism"]     == "motel"  )) then
      object = append_nonqa( object, object.tags["tourism"] )
      object.tags["leisure"] = nil
      object.tags["tourism"] = "hotel"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- B&Bs
-- "0x2b02" is searchable via "Lodging / Bed and Breakfast or"
-- ----------------------------------------------------------------------------
   if ((  object.tags["tourism"]     == "bed_and_breakfast"  ) or
       (( object.tags["tourism"]     == "guest_house"       ) and
        ( object.tags["guest_house"] == "bed_and_breakfast" ))) then
      object = append_nonqa( object, "bed and breakfast" )
      object.tags["leisure"] = nil
      object.tags["tourism"] = "bed_and_breakfast"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Various guest house synonyms
-- "0x2b02" is searchable via "Lodging / Bed and Breakfast or"
-- ----------------------------------------------------------------------------
   if (( object.tags["tourism"]   == "guest_house"             ) or
       ( object.tags["tourism"]   == "self_catering"           ) or
       ( object.tags["tourism"]   == "apartment"               ) or
       ( object.tags["tourism"]   == "apartments"              ) or
       ( object.tags["tourism"]   == "holiday_cottage"         ) or
       ( object.tags["tourism"]   == "cottage"                 ) or
       ( object.tags["tourism"]   == "holiday_village"         ) or
       ( object.tags["tourism"]   == "holiday_park"            ) or
       ( object.tags["tourism"]   == "accommodation"           ) or
       ( object.tags["tourism"]   == "holiday_lets"            ) or
       ( object.tags["tourism"]   == "holiday_let"             ) or
       ( object.tags["tourism"]   == "Holiday Lodges"          ) or
       ( object.tags["tourism"]   == "aparthotel"              )) then
      object = append_nonqa( object, object.tags["tourism"] )
      object.tags["leisure"] = nil
      object.tags["tourism"] = "guest_house"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Resorts
-- "0x2b04" is searchable via "Lodging / Resort"
-- ----------------------------------------------------------------------------
   if (( object.tags["tourism"]  == "resort"         ) or
       ( object.tags["tourism"]  == "spa_resort"     )) then
      object = append_nonqa( object, object.tags["tourism"] )
      object.tags["leisure"] = nil
      object.tags["tourism"] = "resort"
      object = building_or_landuse( objtype, object )
   end

   if (( object.tags["leisure"] == "resort"         ) or
       ( object.tags["leisure"] == "beach_resort"   ) or
       ( object.tags["leisure"] == "adventure_park" ) or
       ( object.tags["leisure"] == "water_park"     ) or
       ( object.tags["leisure"] == "summer_camp"    )) then
      object = append_nonqa( object, object.tags["leisure"] )
      object.tags["leisure"] = nil
      object.tags["tourism"] = "resort"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- camp_sites etc.
-- "0x2b05" is searchable via "Lodging / Campground"
-- ----------------------------------------------------------------------------
   if (( object.tags["tourism"] == "camp_site"  ) or
       ( object.tags["tourism"] == "camping"    )) then
      object = append_nonqa( object, object.tags["tourism"] )
      object.tags["leisure"] = nil
      object.tags["tourism"] = "camp_site"
   end

   if (( object.tags["tourism"] == "caravan_site"              ) or
       ( object.tags["tourism"] == "caravan_site;camp_site"    )) then
      object = append_nonqa( object, object.tags["tourism"] )
      object.tags["leisure"] = nil
      object.tags["tourism"] = "caravan_site"
   end

-- ----------------------------------------------------------------------------
-- Chalets
--
-- Depending on other tags, these will be treated as singlechalet 0x2b02
-- or as resort 0x2b04
--
-- We assume that tourism=chalet on a node is a self-contained chalet or 
-- chalet park, and deserves one entry on the search menu as some sort of 
-- accommodation that is not "resort".
--
-- We assume that tourism=chalet on a way with no building tag is a 
-- self-contained chalet park, and deserves one entry on the search menu as 
-- "resort".
--
-- We assume that tourism=chalet on a way with a building tag is a 
-- self-contained chalet or chalet within a resort, and deserves one entry on 
-- the search menu as some sort of accommodation that is not "resort".
-- ----------------------------------------------------------------------------
   if ( object.tags["tourism"] == "chalet" ) then
      object = append_nonqa( object, object.tags["tourism"] )
      object.tags["leisure"] = nil

      if ( object.tags["name"] == nil ) then
         object.tags["tourism"] = "singlechalet"
      else
         if ( objtype == "n" ) then
            object.tags["tourism"] = "singlechalet"
         else
            if ( object.tags["building"] == nil ) then
               object.tags["tourism"] = "resort"
            else
               object.tags["tourism"] = "singlechalet"
            end
         end
      end

      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- hostels and similar
-- "0x2b05" is searchable via "Lodging / Campground"
-- (GPSMap64s; FWIW this seems like a bug)
-- ----------------------------------------------------------------------------
   if (( object.tags["tourism"] == "hostel"             ) or
       ( object.tags["tourism"] == "adventure_holiday"  ) or
       ( object.tags["tourism"] == "wilderness_hut"     ) or
       ( object.tags["tourism"] == "cabin"              ) or
       ( object.tags["tourism"] == "alpine_hut"         )) then
      object = append_nonqa( object, object.tags["tourism"] )
      object.tags["leisure"] = nil
      object.tags["tourism"] = "hostel"
   end

-- ----------------------------------------------------------------------------
-- Beacons - render historic ones, not radio ones.
-- "0x2f14" is searchable via "Others / Social Service"
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
-- Show historic railway stations.
-- "0x2f14" is searchable via "Others / Social Service"
-- ----------------------------------------------------------------------------
   if ((( object.tags["abandoned:railway"] == "station"             )  or
        ( object.tags["disused:railway"]   == "station"             )  or
        ( object.tags["historic:railway"]  == "station"             )  or
        ( object.tags["historic"]          == "railway_station"     )  or
        ( object.tags["railway"]           == "demolished_colliery" )  or
        ( object.tags["railway"]           == "colliery_site"       )) and
       (  object.tags["tourism"]           ~= "information"      )) then
      object = append_nonqa( object, "historic station" )
      object.tags["man_made"] = "thing"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- landuse=military, and other military things
-- landuse=military is in "points" as "0x640b" and in polygons as "0x04"
-- "0x640b" is searchable via "Geographic Points / Manmade Places" 
-- A unique "tank" icon appears on a GPSMAP64s.  Landuse appears as dark grey.
--
-- If a "landuse=military" tag already exists, add a suffix for it.
-- Also add a "landuse=military" tag if no pre-existing landuse tag on 
-- military things.
-- ----------------------------------------------------------------------------
   if ( object.tags["landuse"]  == "military" )  then
      object = append_nonqa( object, object.tags["landuse"] )
   end

   if (( object.tags["landuse"]  == nil )  and
       ( object.tags["military"] ~= nil )) then
      object.tags["landuse"] = "military"
   end

-- ----------------------------------------------------------------------------
-- Ensure that military bunkers are also buildings
-- ----------------------------------------------------------------------------
   if ( object.tags["military"] == "bunker" )  then
      object.tags["building"] = "yes"
   end

-- ----------------------------------------------------------------------------
-- Apply suffixes to military items
-- Things that were already "landuse=military" will have had a "military" 
-- suffix added above; this adds a suffix for the particular military tag.
-- ----------------------------------------------------------------------------
   if ( object.tags["landuse"] == "military" )  then
      if ( object.tags["military"] ~= nil ) then
         object = append_nonqa( object, object.tags["military"] )
      end

      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Theatres
-- "0x2d01" is searchable via "Entertainment / Live Theater"
-- Note that there is a special case for concert halls below.
-- ----------------------------------------------------------------------------
   if ( object.tags["theatre:type"] == "concert_hall" ) then
      object.tags["theatre"] = object.tags["theatre:type"]
   end

   if (( object.tags["amenity"] == "theatre"      ) and
       ( object.tags["theatre"] ~= "concert_hall" )) then
      object = append_nonqa( object, object.tags["amenity"] )
      object = building_or_landuse( objtype, object )
   end

   if ( object.tags["amenity"] == "arts_centre" ) then
      object = append_nonqa( object, object.tags["amenity"] )
      object.tags["amenity"] = "theatre"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Nightclubs
-- "0x2d02" is searchable via "Entertainment / Bar or Nightclub"
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"]   == "nightclub"   ) then
      object = append_nonqa( object, object.tags["amenity"] )
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Concert halls, theatres as concert halls, and music venues
-- "0x2c09" is searchable via "Attractions / Hall or Auditorium"
-- Note that there normal theatres are above.
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"] == "theatre"      )  and
       ( object.tags["theatre"] == "concert_hall" )) then
      object.tags["amenity"] = object.tags["theatre"]
      object = building_or_landuse( objtype, object )
   end

   if (( object.tags["leisure"] == "bandstand"   ) or
       ( object.tags["leisure"] == "music_venue" )) then
      object.tags["amenity"] = object.tags["leisure"]
      object.tags["leisure"] = nil
   end

   if ((  object.tags["amenity"] == "bandstand"     ) or
       (  object.tags["amenity"] == "concert_hall"  ) or
       (  object.tags["amenity"] == "music_venue"   )) then
      object = append_nonqa( object, object.tags["amenity"] )
      object.tags["amenity"] = "concert_hall"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- man_made=levee
-- Often it's combined with highway though, and that is handled separately.
-- ----------------------------------------------------------------------------
   if ((( object.tags["barrier"]    == "flood_bank"    )  or
        ( object.tags["barrier"]    == "bund"          )  or
        ( object.tags["barrier"]    == "mound"         )  or
        ( object.tags["barrier"]    == "ridge"         )  or
        ( object.tags["barrier"]    == "embankment"    )  or
        ( object.tags["man_made"]   == "dyke"          )  or
        ( object.tags["man_made"]   == "levee"         )  or
        ( object.tags["embankment"] == "yes"           )  or
        ( object.tags["barrier"]    == "berm"          )  or
        ( object.tags["natural"]    == "ridge"         )  or
        ( object.tags["natural"]    == "earth_bank"    )  or
        ( object.tags["natural"]    == "arete"         )) and
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
-- map "alleged shrubberies" as scrub, with a suffix
-- "0x4f" comes through as a different green to most other ones.
-- ----------------------------------------------------------------------------
   if ( object.tags["natural"] == "shrubbery" ) then
      object = append_nonqa( object, object.tags["natural"] )
      object.tags["natural"] = "scrub"
   end

-- ----------------------------------------------------------------------------
-- barrier=ditch; handle as waterway=ditch.
-- ----------------------------------------------------------------------------
   if ( object.tags["barrier"] == "ditch" ) then
      object.tags["waterway"] = "ditch"
      object.tags["barrier"]  = nil
   end

-- ----------------------------------------------------------------------------
-- waterway=ditch, waterway=stream, waterway=brook, waterway=tidal_channel
-- Apparently there are a few "waterway=brook" in the UK.  Render as stream.
-- 0x18 is used in lines.
-- ----------------------------------------------------------------------------
   if (( object.tags["waterway"] == "ditch"            ) or
       ( object.tags["waterway"] == "stream"           ) or
       ( object.tags["waterway"] == "brook"            ) or
       ( object.tags["waterway"] == "drainage_channel" ) or
       ( object.tags["waterway"] == "tidal_channel"    )) then
      object = append_nonqa( object, object.tags["waterway"] )
      object.tags["waterway"] = "stream"
   end

-- ----------------------------------------------------------------------------
-- waterway=drain, waterway=canal.
-- 0x1f is used in lines.
-- waterway=river: Also 0x1f, but no name suffix written.
-- ----------------------------------------------------------------------------
   if (( object.tags["waterway"] == "drain" ) or
       ( object.tags["waterway"] == "canal" )) then
      object = append_nonqa( object, object.tags["waterway"] )
      object.tags["waterway"] = "river"
   end

-- ----------------------------------------------------------------------------
-- Each of the three gate types is handled in the style "points" file as the 
-- same value with a "G" symbol.
-- "0x2f0f" is searchable via "Others / Garmin Dealer"
-- For each gate, choose which of the two gate icons to used based on tagging.
-- A suffix is always used for kissing gates
-- ----------------------------------------------------------------------------
   if  (( object.tags["barrier"]   == "gate"                  )   and
        ( object.tags["gate"]      == "kissing"               )) then
      object.tags["barrier"] = "kissing_gate"
   end

   if ((  object.tags["barrier"]   == "kissing_gate"           )  or
       (  object.tags["barrier"]   == "turnstile"              )  or
       (  object.tags["barrier"]   == "full-height_turnstile"  )  or
       (  object.tags["barrier"]   == "kissing_gate;gate"      )  or
       (  object.tags["barrier"]   == "toll_booth"             )) then
      object = append_nonqa( object, object.tags["barrier"] )
      object.tags["barrier"] = "kissing_gate"

      if (( object.tags["gate"]   == "locked"      ) or
          ( object.tags["locked"] == "permanently" ) or
          ( object.tags["locked"] == "yes"         ) or
          ( object.tags["status"] == "locked"      )) then
         object = append_nonqa( object, "locked" )
      end
   end

-- ----------------------------------------------------------------------------
-- lift gates
-- A suffix is always used for lift gates
-- ----------------------------------------------------------------------------
   if (( object.tags["barrier"] == "lift_gate"        ) or
       ( object.tags["barrier"] == "ticket_barrier"   ) or
       ( object.tags["barrier"] == "ticket"           ) or
       ( object.tags["barrier"] == "security_control" ) or
       ( object.tags["barrier"] == "checkpoint"       ) or
       ( object.tags["barrier"] == "gatehouse"        )) then
      object = append_nonqa( object, object.tags["barrier"] )
      object.tags["barrier"] = "lift_gate"

      if (( object.tags["gate"]   == "locked"      ) or
          ( object.tags["locked"] == "permanently" ) or
          ( object.tags["locked"] == "yes"         ) or
          ( object.tags["status"] == "locked"      )) then
         object = append_nonqa( object, "locked" )
      end
   end

-- ----------------------------------------------------------------------------
-- Other gates
-- "sally_port" is mapped to gate largely because of misuse in the data.
-- A suffix is used for other gates if they are not just "barrier=gate"
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
       ( object.tags["barrier"]   == "snow_gate"             )  or
       ( object.tags["barrier"]   == "door"                  )) then

      if (( object.tags["barrier"] ~= "gate" ) or
          ( objtype                == "w"    )) then
         object = append_nonqa( object, object.tags["barrier"] )
      end

      object.tags["barrier"] = "gate"

      if (( object.tags["gate"]   == "locked"      ) or
          ( object.tags["locked"] == "permanently" ) or
          ( object.tags["locked"] == "yes"         ) or
          ( object.tags["status"] == "locked"      )) then
         object = append_nonqa( object, "locked" )
      end
   end

-- ----------------------------------------------------------------------------
-- barrier=cycle_barrier etc.  Render various cycle barrier synonyms
-- In points at "0x660f"
-- "0x660f" is searchable in "Geographic Points / Land Features"
-- No icon appears in QMapShack
-- A dot appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if (( object.tags["barrier"]   == "cycle_barrier"         )  or
       ( object.tags["barrier"]   == "chicane"               )  or
       ( object.tags["barrier"]   == "squeeze"               )  or
       ( object.tags["barrier"]   == "motorcycle_barrier"    )  or
       ( object.tags["barrier"]   == "horse_barrier"         )  or
       ( object.tags["barrier"]   == "horse_stile"           )  or
       ( object.tags["barrier"]   == "a_frame"               )  or
       ( object.tags["barrier"]   == "bar"                   )) then
      object = append_nonqa( object, object.tags["barrier"] )
      object.tags["barrier"] = "cycle_barrier"
   end

-- ----------------------------------------------------------------------------
-- barrier=cattle_grid
-- "man_made=thing" is in "points" as "0x2f14"
-- "0x2f14" is searchable via "Others / Social Service"
-- A dot appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if ( object.tags["barrier"]   == "cattle_grid" ) then
      object = append_nonqa( object, object.tags["barrier"] )
      object.tags["man_made"] = "thing"
   end

-- ----------------------------------------------------------------------------
-- barrier=bollard (etc.) that otherwise would not have a suffix
-- In "points" as "0x660f".
-- "0x660f" is searchable in "Geographic Points / Land Features"
-- No icon appears in QMapShack
-- A dot appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if (( object.tags["man_made"]  == "concrete_post" ) or
       ( object.tags["man_made"]  == "marker_post"   ) or
       ( object.tags["man_made"]  == "post"          )) then
      object.tags["barrier"] = object.tags["man_made"]
      object.tags["man_made"] = nil
   end

   if (( object.tags["barrier"]  == "block"          ) or
       ( object.tags["barrier"]  == "bollard"        ) or
       ( object.tags["barrier"]  == "bollards"       ) or
       ( object.tags["barrier"]  == "bus_trap"       ) or
       ( object.tags["barrier"]  == "car_trap"       ) or
       ( object.tags["barrier"]  == "concrete_post"  ) or
       ( object.tags["barrier"]  == "dragons_teeth"  ) or
       ( object.tags["barrier"]  == "gate_pier"      ) or
       ( object.tags["barrier"]  == "gate_post"      ) or
       ( object.tags["barrier"]  == "hoarding"       ) or
       ( object.tags["barrier"]  == "marker_post"    ) or
       ( object.tags["barrier"]  == "pole"           ) or
       ( object.tags["barrier"]  == "post"           ) or
       ( object.tags["barrier"]  == "rising_bollard" ) or
       ( object.tags["barrier"]  == "step"           ) or
       ( object.tags["barrier"]  == "steps"          ) or
       ( object.tags["barrier"]  == "stone"          ) or
       ( object.tags["barrier"]  == "sump_buster"    ) or
       ( object.tags["barrier"]  == "tank_trap"      ) or
       ( object.tags["barrier"]  == "yes"            )) then
      object = append_nonqa( object, object.tags["barrier"] )
      object.tags["barrier"] = "bollard"
   end

-- ----------------------------------------------------------------------------
-- barrier=stile etc.  Render various stile synonyms
-- In points at "0x660f"
-- "0x660f" is searchable in "Geographic Points / Land Features"
-- No icon appears in QMapShack
-- A dot appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if (( object.tags["barrier"]   == "stile"           )  or
       ( object.tags["barrier"]   == "squeeze_stile"   )  or
       ( object.tags["barrier"]   == "ramblers_gate"   )  or
       ( object.tags["barrier"]   == "squeeze_point"   )  or
       ( object.tags["barrier"]   == "step_over"       )  or
       ( object.tags["barrier"]   == "stile;gate"      )) then
      object = append_nonqa( object, object.tags["barrier"] )

      if ( object.tags["dog_gate"] == "yes" ) then
         object = append_nonqa( object, "dog gate" )
      end

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
-- Show loungers as benches
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "lounger" ) then
      object = append_nonqa( object, object.tags["amenity"] )
      object.tags["amenity"] = "bench"
   end

-- ----------------------------------------------------------------------------
-- Show picnic tables as benches
-- ----------------------------------------------------------------------------
   if ( object.tags["leisure"] == "picnic_table" ) then
      object = append_nonqa( object, object.tags["leisure"] )
      object.tags["amenity"] = "bench"
      object.tags["leisure"] = nil
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
   if (( object.tags["historic"]      == "memorial" ) and
       ( object.tags["memorial:type"] == "plate"    )) then
      object = append_nonqa( object, "memorial plate" )
      object.tags["man_made"] = "thing"
   end

-- ----------------------------------------------------------------------------
-- Memorial graves and graveyards
-- ----------------------------------------------------------------------------
   if ((  object.tags["historic"]   == "memorial"     ) and
       (( object.tags["memorial"]   == "grave"       )  or
        ( object.tags["memorial"]   == "graveyard"   ))) then
      object.tags["historic"] = nil
      object.tags["man_made"] = "thing"
      object = append_nonqa( object, "memorial grave" )
   end

-- ----------------------------------------------------------------------------
-- Memorial obelisks
-- ----------------------------------------------------------------------------
   if ((   object.tags["man_made"]      == "obelisk"     ) or
       (   object.tags["landmark"]      == "obelisk"     ) or
       ((  object.tags["historic"]      == "memorial"   ) and
        (( object.tags["memorial"]      == "obelisk"   )  or
         ( object.tags["memorial:type"] == "obelisk"   )))) then
      object.tags["man_made"] = "thing"
      object = append_nonqa( object, "obelisk" )
   end

-- ----------------------------------------------------------------------------
-- Render shop=newsagent as shop=convenience
-- It's near enough in meaning I think.  Likewise kiosk (bit of a stretch,
-- but nearer than anything else)
-- "0x2e0e" is searchable via "Shopping / 2nd Convenience in list, after Computer"
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"]   == "convenience"         ) or
       ( object.tags["shop"]   == "newsagent"           ) or
       ( object.tags["shop"]   == "kiosk"               ) or
       ( object.tags["shop"]   == "forecourt"           ) or
       ( object.tags["shop"]   == "food"                ) or
       ( object.tags["shop"]   == "grocery"             ) or
       ( object.tags["shop"]   == "grocer"              ) or
       ( object.tags["shop"]   == "frozen_food"         ) or
       ( object.tags["shop"]   == "convenience;alcohol" )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "convenience"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- shoe shops
-- "0x2e07" is searchable via "Shopping / Apparel"
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"] == "shoes"        ) or
       ( object.tags["shop"] == "footwear"     )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "shoes"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- "clothes" consolidation.  "baby_goods" is here because there will surely
-- be some clothes there!
-- Various not-really-clothes things best rendered as clothes are also here.
-- "0x2e07" is searchable via "Shopping / Apparel"
-- ----------------------------------------------------------------------------
   if (( object.tags["craft"]   == "tailor"                  ) or
       ( object.tags["craft"]   == "dressmaker"              )) then
      object.tags["shop"] = object.tags["craft"]
   end

   if (( object.tags["shop"] == "clothes"      ) or
       ( object.tags["shop"] == "fashion"      ) or
       ( object.tags["shop"] == "boutique"     ) or
       ( object.tags["shop"] == "vintage"      ) or
       ( object.tags["shop"] == "bridal"       ) or
       ( object.tags["shop"] == "wedding"      ) or
       ( object.tags["shop"] == "baby_goods"   ) or
       ( object.tags["shop"] == "baby"         ) or
       ( object.tags["shop"] == "dance"        ) or
       ( object.tags["shop"] == "clothes_hire" ) or
       ( object.tags["shop"] == "clothing"     ) or
       ( object.tags["shop"] == "hat"          ) or
       ( object.tags["shop"] == "hats"         ) or
       ( object.tags["shop"] == "wigs"         ) or
       ( object.tags["shop"] == "tailor"       ) or
       ( object.tags["shop"] == "dressmaker"   )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "clothes"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- "electronics"
-- Looking at the tagging of shop=electronics, there's a fair crossover with 
-- electrical.
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if ( object.tags["craft"]   == "electronics_repair" ) then
      object.tags["shop"] = object.tags["craft"]
      object.tags["craft"] = nil
   end

   if ( object.tags["amenity"]   == "electronics_repair" ) then
      object.tags["shop"] = object.tags["amenity"]
      object.tags["amenity"] = nil
   end

   if (( object.tags["shop"]    == "electronics"             ) or
       ( object.tags["shop"]    == "electronics_repair"      )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- "electrical" consolidation
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if (( object.tags["trade"]   == "electrical"              ) or
       ( object.tags["name"]    == "City Electrical Factors" )) then
      object = append_nonqa( object, "electrical" )
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

   if (( object.tags["craft"] == "electrician"         ) or
       ( object.tags["craft"] == "electrician;plumber" )) then
      object.tags["shop"] = object.tags["office"]
   end

   if ( object.tags["office"] == "electrician" ) then
      object.tags["shop"] = object.tags["office"]
   end

   if (( object.tags["shop"]    == "appliance"               ) or
       ( object.tags["shop"]    == "appliances"              ) or
       ( object.tags["shop"]    == "domestic_appliances"     ) or
       ( object.tags["shop"]    == "electrical"              ) or
       ( object.tags["shop"]    == "electrical_repair"       ) or
       ( object.tags["shop"]    == "electrical_supplies"     ) or
       ( object.tags["shop"]    == "electricals"             ) or
       ( object.tags["shop"]    == "electrician"             ) or
       ( object.tags["shop"]    == "electrician;plumber"     ) or
       ( object.tags["shop"]    == "gadget"                  ) or
       ( object.tags["shop"]    == "radiotechnics"           ) or
       ( object.tags["shop"]    == "sewing_machines"         ) or
       ( object.tags["shop"]    == "tv_repair"               ) or
       ( object.tags["shop"]    == "vacuum_cleaner"          ) or
       ( object.tags["shop"]    == "white_goods"             )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- amenity=boat_rental
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if ( object.tags["shop"] == "boat_rental" ) then
      object.tags["amenity"] = object.tags["shop"]
   end

   if ( object.tags["amenity"]   == "boat_rental" ) then
      object = append_nonqa( object, object.tags["amenity"] )
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- shop=tattoo
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"]   == "tattoo"          ) or
       ( object.tags["shop"]   == "piercing"        ) or
       ( object.tags["shop"]   == "tattoo;piercing" ) or
       ( object.tags["shop"]   == "piercing;tattoo" ) or
       ( object.tags["shop"]   == "body_piercing"   ) or
       ( object.tags["shop"]   == "yes;piercing"    ) or
       ( object.tags["shop"]   == "piercings"       )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- shop=musical_instrument
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"]   == "musical_instrument" ) or
       ( object.tags["shop"]   == "piano"              )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- shop=locksmith
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if ( object.tags["craft"] == "locksmith" ) then
      object.tags["shop"] = object.tags["craft"]
   end

   if ( object.tags["shop"] == "locksmith"  ) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- "funeral" consolidation.  All of these spellings currently in use in the UK
-- "0x2e0a" is searchable via "Shopping / Specialty Retail".
-- Also stonemasons.
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"] == "funeral"             ) or
       ( object.tags["amenity"] == "funeral_directors"   ) or
       ( object.tags["amenity"] == "undertaker"          )) then
      object.tags["shop"]    = object.tags["amenity"]
      object.tags["amenity"] = nil
   end

   if ( object.tags["craft"]   == "stonemason" ) then
      object.tags["shop"]  = object.tags["craft"]
      object.tags["craft"] = nil
   end

   if (( object.tags["office"]  == "funeral_director"    ) or
       ( object.tags["office"]  == "funeral_directors"   )) then
      object.tags["shop"]   = object.tags["office"]
      object.tags["office"] = nil
   end

   if (( object.tags["shop"]    == "funeral"             ) or
       ( object.tags["shop"]    == "funeral_director"    ) or
       ( object.tags["shop"]    == "funeral_directors"   ) or
       ( object.tags["shop"]    == "gravestone"          ) or
       ( object.tags["shop"]    == "memorials"           ) or
       ( object.tags["shop"]    == "monumental_mason"    ) or
       ( object.tags["shop"]    == "stonemason"          ) or
       ( object.tags["shop"]    == "undertaker"          )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Various single food item, other food and other shops
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"]   == "cake"              ) or
       ( object.tags["shop"]   == "chocolate"         ) or
       ( object.tags["shop"]   == "milk"              ) or
       ( object.tags["shop"]   == "cheese"            ) or
       ( object.tags["shop"]   == "cheese;wine"       ) or
       ( object.tags["shop"]   == "wine;cheese"       ) or
       ( object.tags["shop"]   == "dairy"             ) or
       ( object.tags["shop"]   == "eggs"              ) or
       ( object.tags["shop"]   == "catering"          ) or
       ( object.tags["shop"]   == "fishmonger"        ) or
       ( object.tags["shop"]   == "spices"            ) or
       ( object.tags["shop"]   == "nuts"              ) or
       ( object.tags["shop"]   == "delicatessen"      ) or
       ( object.tags["shop"]   == "deli"              ) or
       ( object.tags["shop"]   == "outdoor"           ) or
       ( object.tags["shop"]   == "sweets"            ) or
       ( object.tags["shop"]   == "sweet"             ) or
       ( object.tags["shop"]   == "confectionery"     ) or
       ( object.tags["shop"]   == "charity"           ) or
       ( object.tags["shop"]   == "funeral_directors" ) or
       ( object.tags["shop"]   == "greengrocer"       ) or
       ( object.tags["shop"]   == "fish"              ) or
       ( object.tags["shop"]   == "seafood"           )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "specialty"
      object = append_eco( object )
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Photo shops etc.
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if ( object.tags["craft"]  == "photographer" ) then
      object.tags["shop"] = object.tags["craft"]
   end

   if ( object.tags["office"]  == "photography" ) then
      object.tags["shop"] = object.tags["office"]
   end

   if (( object.tags["shop"]    == "camera"             ) or
       ( object.tags["shop"]    == "photo_studio"       ) or
       ( object.tags["shop"]    == "photographer"       ) or
       ( object.tags["shop"]    == "photographic"       ) or
       ( object.tags["shop"]    == "photography"        )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Lenders of last resort - send to specialty rather than bank.
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"] == "pawnbroker"         ) or
       ( object.tags["shop"] == "money"              ) or
       ( object.tags["shop"] == "money_lender"       ) or
       ( object.tags["shop"] == "loan_shark"         ) or
       ( object.tags["shop"] == "cash"               )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- toys and games etc.
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"]   == "toys"           ) or
       ( object.tags["shop"]   == "model"          ) or
       ( object.tags["shop"]   == "games"          ) or
       ( object.tags["shop"]   == "hobby"          ) or
       ( object.tags["shop"]   == "fancy_dress"    )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- office=estate_agent.  Also letting_agent
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "estate_agent"      ) then
      object.tags["shop"] = object.tags["amenity"]
      object.tags["amenity"] = nil
   end

   if (( object.tags["office"]  == "estate_agent"      ) or
       ( object.tags["office"]  == "letting_agent"     )) then
      object.tags["shop"] = object.tags["office"]
      object.tags["office"] = nil
   end

   if (( object.tags["shop"]    == "estate_agent"      ) or
       ( object.tags["shop"]    == "letting_agent"     ) or
       ( object.tags["shop"]    == "council_house"     )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- travel agents
-- the name is usually characteristic
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if ( object.tags["office"] == "travel_agent"  ) then
      object.tags["shop"] = "travel_agent"
   end

   if (( object.tags["shop"]   == "travel_agent"  ) or
       ( object.tags["shop"]   == "travel_agency" ) or
       ( object.tags["shop"]   == "travel"        )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- "jewellery" consolidation.  "jewelry" is in the database, until recently
-- "jewellery" was too.  The style handles "jewellery", hence the change here.
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if (( object.tags["craft"] == "jeweller"         ) or
       ( object.tags["craft"] == "jewellery_repair" ) or
       ( object.tags["craft"] == "engraver"         ))then
      object.tags["shop"] = object.tags["craft"]
   end

   if (( object.tags["shop"] == "jewelry"                 ) or
       ( object.tags["shop"] == "jewelry;pawnbroker"      ) or
       ( object.tags["shop"] == "yes;jewelry;e-cigarette" ) or
       ( object.tags["shop"] == "jewelry;sunglasses"      ) or
       ( object.tags["shop"] == "jeweller"                ) or
       ( object.tags["shop"] == "yes;jewelry"             ) or
       ( object.tags["shop"] == "jewelry;art;crafts"      ) or
       ( object.tags["shop"] == "jewelry;fabric"          ) or
       ( object.tags["shop"] == "watch"                   ) or
       ( object.tags["shop"] == "watches"                 ) or
       ( object.tags["shop"] == "jewellery_repair"        ) or
       ( object.tags["shop"] == "engraver"                )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- "optician" consolidation
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"] == "optician"    ) or
       ( object.tags["amenity"] == "optometrist" )) then
      object.tags["shop"] = object.tags["amenity"]
   end

   if ( object.tags["craft"] == "optician" ) then
      object.tags["shop"] = object.tags["craft"]
   end

   if ( object.tags["healthcare"]  == "optometrist" ) then
      object.tags["shop"] = object.tags["healthcare"]
   end

   if ( object.tags["office"] == "optician" ) then
      object.tags["shop"] = object.tags["office"]
   end

   if (( object.tags["shop"] == "optician"    ) or
       ( object.tags["shop"] == "optometrist" )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "specialty"
      object.tags["amenity"] = nil
      object.tags["craft"] = nil
      object.tags["healthcare"] = nil
      object.tags["office"] = nil
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- chiropodists etc.
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"]     == "chiropodist"                  ) or
       ( object.tags["amenity"]     == "chiropractor"                 ) or
       ( object.tags["amenity"]     == "physiotherapist"              ) or
       ( object.tags["amenity"]     == "podiatrist"                   ) or
       ( object.tags["amenity"]     == "healthcare"                   ) or
       ( object.tags["amenity"]     == "clinic"                       )) then
      object = append_nonqa( object, object.tags["amenity"] )
      object.tags["shop"] = "specialty"
      object.tags["amenity"] = nil
      object.tags["craft"] = nil
      object.tags["healthcare"] = nil
      object.tags["office"] = nil
      object = building_or_landuse( objtype, object )
   end

   if (( object.tags["building"]    == "nursing_home"                 ) or
       ( object.tags["building"]    == "preschool"                    ) or
       ( object.tags["building"]    == "health_centre"                ) or
       ( object.tags["building"]    == "medical_centre"               )) then
      object = append_nonqa( object, object.tags["building"] )
      object.tags["shop"] = "specialty"
      object.tags["amenity"] = nil
      object.tags["craft"] = nil
      object.tags["healthcare"] = nil
      object.tags["office"] = nil
      object = building_or_landuse( objtype, object )
   end

   if ( object.tags["craft"]       == "counsellor"                   ) then
      object = append_nonqa( object, object.tags["craft"] )
      object.tags["shop"] = "specialty"
      object.tags["amenity"] = nil
      object.tags["craft"] = nil
      object.tags["healthcare"] = nil
      object.tags["office"] = nil
      object = building_or_landuse( objtype, object )
   end

   if (( object.tags["healthcare"]  == "audiologist"                  ) or
       ( object.tags["healthcare"]  == "blood_bank"                   ) or
       ( object.tags["healthcare"]  == "blood_donation"               ) or
       ( object.tags["healthcare"]  == "centre"                       ) or
       ( object.tags["healthcare"]  == "chiropodist"                  ) or
       ( object.tags["healthcare"]  == "chiropractor"                 ) or
       ( object.tags["healthcare"]  == "clinic"                       ) or
       ( object.tags["healthcare"]  == "clinic;doctor"                ) or
       ( object.tags["healthcare"]  == "cosmetic"                     ) or
       ( object.tags["healthcare"]  == "cosmetic_surgery"             ) or
       ( object.tags["healthcare"]  == "counselling"                  ) or
       ( object.tags["healthcare"]  == "dentures"                     ) or
       ( object.tags["healthcare"]  == "department"                   ) or
       ( object.tags["healthcare"]  == "diagnostics"                  ) or
       ( object.tags["healthcare"]  == "dialysis"                     ) or
       ( object.tags["healthcare"]  == "drug_rehabilitation"          ) or
       ( object.tags["healthcare"]  == "hearing"                      ) or
       ( object.tags["healthcare"]  == "hearing_care"                 ) or
       ( object.tags["healthcare"]  == "hospice"                      ) or
       ( object.tags["healthcare"]  == "massage"                      ) or
       ( object.tags["healthcare"]  == "medical_imaging"              ) or
       ( object.tags["healthcare"]  == "mental_health"                ) or
       ( object.tags["healthcare"]  == "midwife"                      ) or
       ( object.tags["healthcare"]  == "nursing_home"                 ) or
       ( object.tags["healthcare"]  == "occupational_therapist"       ) or
       ( object.tags["healthcare"]  == "ocular_prosthetics"           ) or
       ( object.tags["healthcare"]  == "osteopath"                    ) or
       ( object.tags["healthcare"]  == "physiotherapist"              ) or
       ( object.tags["healthcare"]  == "physiotherapist;podiatrist"   ) or
       ( object.tags["healthcare"]  == "physiotherapy"                ) or
       ( object.tags["healthcare"]  == "podiatrist"                   ) or
       ( object.tags["healthcare"]  == "podiatrist;chiropodist"       ) or
       ( object.tags["healthcare"]  == "podiatry"                     ) or
       ( object.tags["healthcare"]  == "psychotherapist"              ) or
       ( object.tags["healthcare"]  == "rehabilitation"               ) or
       ( object.tags["healthcare"]  == "speech_therapist"             ) or
       ( object.tags["healthcare"]  == "sports_massage_therapist"     ) or
       ( object.tags["healthcare"]  == "tattoo_removal"               ) or
       ( object.tags["healthcare"]  == "therapy"                      ) or
       ( object.tags["healthcare"]  == "trichologist"                 )) then
      object = append_nonqa( object, object.tags["healthcare"] )
      object.tags["shop"] = "specialty"
      object.tags["amenity"] = nil
      object.tags["craft"] = nil
      object.tags["healthcare"] = nil
      object.tags["office"] = nil
      object = building_or_landuse( objtype, object )
   end

   if ( object.tags["office"]      == "medical_supply"               ) then
      object = append_nonqa( object, object.tags["office"] )
      object.tags["shop"] = "specialty"
      object.tags["amenity"] = nil
      object.tags["craft"] = nil
      object.tags["healthcare"] = nil
      object.tags["office"] = nil
      object = building_or_landuse( objtype, object )
   end

   if (( object.tags["residential"] == "nursing_home"                 ) or
       ( object.tags["residential"] == "care_home"                    ) or
       ( object.tags["residential"] == "residential_home"             ) or
       ( object.tags["residential"] == "sheltered_housing"            )) then
      object = append_nonqa( object, object.tags["residential"] )
      object.tags["shop"] = "specialty"
      object.tags["amenity"] = nil
      object.tags["craft"] = nil
      object.tags["healthcare"] = nil
      object.tags["office"] = nil
      object = building_or_landuse( objtype, object )
   end

   if (( object.tags["shop"]        == "hearing_aids"                 ) or
       ( object.tags["shop"]        == "medical_supply"               ) or
       ( object.tags["shop"]        == "mobility"                     ) or
       ( object.tags["shop"]        == "disability"                   ) or
       ( object.tags["shop"]        == "chiropodist"                  ) or
       ( object.tags["shop"]        == "osteopath"                    ) or
       ( object.tags["shop"]        == "physiotherapist"              ) or
       ( object.tags["shop"]        == "physiotherapy"                ) or
       ( object.tags["shop"]        == "clinic"                       ) or
       ( object.tags["shop"]        == "dentures"                     ) or
       ( object.tags["shop"]        == "denture"                      )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "specialty"
      object.tags["amenity"] = nil
      object.tags["craft"] = nil
      object.tags["healthcare"] = nil
      object.tags["office"] = nil
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Defibrillators and other emergency features
-- "0x2f14" is searchable via "Others / Social Service"
-- ----------------------------------------------------------------------------
   if ( object.tags["emergency"] == "defibrillator" ) then
      object = append_nonqa( object, object.tags["emergency"] )
      object.tags["man_made"] = "thing"
      object = building_or_landuse( objtype, object )
   end

   if ( object.tags["emergency"] == "fire_extinguisher" ) then
      object = append_nonqa( object, object.tags["emergency"] )
      object.tags["man_made"] = "thing"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Water emergency features are sent through as springs with 
-- an appropriate suffix.
-- 0x6511 is searchable via "Geographic Points / Water Features"
-- ----------------------------------------------------------------------------
   if (( object.tags["emergency"]        == "rescue_equipment" )  and
       ( object.tags["rescue_equipment"] == "lifering"         )) then
      object = append_nonqa( object, object.tags["rescue_equipment"] )
      object.tags["natural"] = "spring"
      object = building_or_landuse( objtype, object )
   end

   if (( object.tags["emergency"] == "flotation device" ) or
       ( object.tags["emergency"] == "lifevest"         ) or
       ( object.tags["emergency"] == "life_ring"        )) then
      object = append_nonqa( object, object.tags["emergency"] )
      object.tags["natural"] = "spring"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Shopmobility
-- Note that "shop=mobility" is something that _sells_ mobility aids, and is
-- handled as shop=nonspecific for now.
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if ((   object.tags["amenity"]  == "mobility"                 ) or
       (   object.tags["amenity"]  == "mobility_equipment_hire"  ) or
       (   object.tags["amenity"]  == "mobility_aids_hire"       ) or
       (   object.tags["amenity"]  == "shop_mobility"            )) then
      object.tags["shop"] = object.tags["amenity"]
      object.tags["amenity"] = nil
   end

   if (((( object.tags["shop"]     == "yes"                    )   or
         ( object.tags["shop"]     == "mobility"               )   or
         ( object.tags["building"] == "yes"                    )   or
         ( object.tags["building"] == "unit"                   ))  and
        (( object.tags["name"]     == "Shopmobility"           )   or
         ( object.tags["name"]     == "Shop Mobility"          )))) then
      object.tags["shop"] = "shopmobility"
   end

   if ((   object.tags["shop"]  == "mobility"                    ) or
       (   object.tags["shop"]  == "mobility_equipment_hire"     ) or
       (   object.tags["shop"]  == "mobility_aids_hire"          ) or
       (   object.tags["shop"]  == "mobility_scooter"            ) or
       (   object.tags["shop"]  == "shopmobility"                ) or
       (   object.tags["shop"]  == "shop_mobility"               )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Mappings to shop=boat
-- "0x2f09" is searchable via "Others / Marine Services"
-- ----------------------------------------------------------------------------
   if ( object.tags["craft"]  == "boatbuilder" ) then
      object.tags["shop"] = object.tags["craft"]
      object.tags["craft"] = nil
   end

   if (( object.tags["shop"] == "boat"           ) or
       ( object.tags["shop"] == "boat_repair"    ) or
       ( object.tags["shop"] == "boatbuilder"    ) or
       ( object.tags["shop"] == "chandler"       ) or
       ( object.tags["shop"] == "chandlery"      ) or
       ( object.tags["shop"] == "marine"         ) or
       ( object.tags["shop"] == "ship_chandler"  )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "boat"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Other shops
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"] == "gallery"                 ) or
       ( object.tags["amenity"] == "art_gallery"             ) or
       ( object.tags["amenity"] == "internet_cafe"           ) or
       ( object.tags["amenity"] == "training"                ) or
       ( object.tags["amenity"] == "tutoring_centre"         ) or
       ( object.tags["amenity"] == "stripclub"               ) or
       ( object.tags["amenity"] == "courier"                 )) then
      object.tags["shop"] = object.tags["amenity"]
   end

   if (( object.tags["craft"]   == "cobbler"                 ) or
       ( object.tags["craft"]   == "shoemaker"               ) or
       ( object.tags["craft"]   == "gunsmith"                ) or
       ( object.tags["craft"]   == "builder"                 )) then
      object.tags["shop"] = object.tags["craft"]
   end

   if (( object.tags["office"]  == "auctioneer" ) or
       ( object.tags["office"]  == "tutoring"   )) then
      object.tags["shop"] = object.tags["office"]
   end

   if ( object.tags["tourism"] == "gallery" ) then
      object.tags["shop"] = object.tags["tourism"]
   end

   if ((  object.tags["amenity"]  == nil                   )  and
       (( object.tags["training"] == "dance"              )   or
        ( object.tags["training"] == "language"           )   or
        ( object.tags["training"] == "performing_arts"    ))) then
      object.tags["shop"] = object.tags["training"] .. " training"
   end

   if (( object.tags["shop"]    == "card"                     ) or
       ( object.tags["shop"]    == "cards"                    ) or
       ( object.tags["shop"]    == "greeting_card"            ) or
       ( object.tags["shop"]    == "greeting_cards"           ) or
       ( object.tags["shop"]    == "greetings_cards"          ) or
       ( object.tags["shop"]    == "greetings"                ) or
       ( object.tags["shop"]    == "card;gift"                ) or
       ( object.tags["shop"]    == "shoemaker"                ) or
       ( object.tags["shop"]    == "watch_repair"             ) or
       ( object.tags["shop"]    == "cleaning"                 ) or
       ( object.tags["shop"]    == "collector"                ) or
       ( object.tags["shop"]    == "coins"                    ) or
       ( object.tags["shop"]    == "erotic"                   ) or
       ( object.tags["shop"]    == "service"                  ) or
       ( object.tags["shop"]    == "tobacco"                  ) or
       ( object.tags["shop"]    == "tobacconist"              ) or
       ( object.tags["shop"]    == "ticket"                   ) or
       ( object.tags["shop"]    == "insurance"                ) or
       ( object.tags["shop"]    == "gallery"                  ) or
       ( object.tags["shop"]    == "plumber"                  ) or
       ( object.tags["shop"]    == "builder"                  ) or
       ( object.tags["shop"]    == "builders"                 ) or
       ( object.tags["shop"]    == "trophy"                   ) or
       ( object.tags["shop"]    == "communication"            ) or
       ( object.tags["shop"]    == "communications"           ) or
       ( object.tags["shop"]    == "internet"                 ) or
       ( object.tags["shop"]    == "internet_cafe"            ) or
       ( object.tags["shop"]    == "recycling"                ) or
       ( object.tags["shop"]    == "gun"                      ) or
       ( object.tags["shop"]    == "weapons"                  ) or
       ( object.tags["shop"]    == "pyrotechnics"             ) or
       ( object.tags["shop"]    == "hunting"                  ) or
       ( object.tags["shop"]    == "military_surplus"         ) or
       ( object.tags["shop"]    == "fireworks"                ) or
       ( object.tags["shop"]    == "auction"                  ) or
       ( object.tags["shop"]    == "auction_house"            ) or
       ( object.tags["shop"]    == "religion"                 ) or
       ( object.tags["shop"]    == "gas"                      ) or
       ( object.tags["shop"]    == "fuel"                     ) or
       ( object.tags["shop"]    == "energy"                   ) or
       ( object.tags["shop"]    == "coal_merchant"            ) or
       ( object.tags["shop"]    == "ironing"                  ) or
       ( object.tags["shop"]    == "gallery"                  ) or
       ( object.tags["shop"]    == "internet_cafe"            ) or
       ( object.tags["shop"]    == "training"                 ) or
       ( object.tags["shop"]    == "tutoring"                 ) or
       ( object.tags["shop"]    == "stripclub"                ) or
       ( object.tags["shop"]    == "courier"                  ) or
       ( object.tags["shop"]    == "cobbler"                  ) or
       ( object.tags["shop"]    == "shoemaker"                ) or
       ( object.tags["shop"]    == "gunsmith"                 ) or
       ( object.tags["shop"]    == "auctioneer"               ) or
       ( object.tags["shop"]    == "tutoring_centre"          ) or
       ( object.tags["shop"]    == "performing_arts training" ) or
       ( object.tags["shop"]    == "telecommunication"        ) or
       ( object.tags["shop"]    == "cannabis"                 )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Suppress unnamed shop=yes.
-- There are surprisingly many of these.
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"]    == "yes" ) and
       ( object.tags["name"]    == nil   )) then
      object.tags["shop"] = nil
   end

-- ----------------------------------------------------------------------------
-- Shops that we don't know the type of.  Things such as "hire" are here 
-- because we don't know "hire of what".
-- "wood" is here because it's used for different sorts of shops.
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "rental"          ) then
      object.tags["shop"] = object.tags["amenity"]
   end

   if ( object.tags["craft"]   == "yes"             ) then
      object.tags["shop"] = "unknown craft"
   end

   if ( object.tags["office"]  == "rental"          ) then
      object.tags["shop"] = object.tags["office"]
   end

-- ----------------------------------------------------------------------------
-- Some suffixes make no sense to send through, so change them here:
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"]    == "yes"             ) or
       ( object.tags["shop"]    == "fixme"           )) then
      object.tags["shop"] = "unknown"
   end

   if ((  object.tags["shop"]     == "unknown"          ) or
       (  object.tags["shop"]     == "unknown craft"    ) or
       (  object.tags["shop"]     == "hire"             ) or
       (  object.tags["shop"]     == "rental"           ) or
       (  object.tags["shop"]     == "second_hand"      ) or
       (  object.tags["shop"]     == "junk"             ) or
       (  object.tags["shop"]     == "retail"           ) or
       (  object.tags["shop"]     == "trade"            ) or
       (  object.tags["shop"]     == "cash_and_carry"   ) or
       (  object.tags["shop"]     == "wholesale"        ) or
       (  object.tags["shop"]     == "wood"             ) or
       (  object.tags["shop"]     == "childrens"        ) or
       (  object.tags["shop"]     == "factory_outlet"   ) or
       (  object.tags["shop"]     == "specialist"       ) or
       (  object.tags["shop"]     == "specialist_shop"  ) or
       (( object.tags["shop"]     == "agrarian"        )  and
        ( object.tags["agrarian"] == nil               )) or
       (  object.tags["shop"]     == "repair"           )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- "fast_food" consolidation of lesser used tags.  
-- Also render fish and chips etc. with a unique icon.
-- ----------------------------------------------------------------------------
   if ( object.tags["shop"] == "fast_food" ) then
      object.tags["amenity"] = "fast_food"
   end

-- ----------------------------------------------------------------------------
-- Cuisine tagging.  'Food and Drink' menu.
-- Garmin's default categories only has one "Fast Food", but in UK/IE there is
-- more variety of fast food than there is of restaurants.
-- In order to use all the categories there are some "deliberately misfiled"
--
-- Menu entry      ID      Maps to                           Which means
-- n/a             0x2a00  amenity=restaurant                Restaurants not elsewhere
-- American	   0x2a01  amenity=fast_food_burger          Burger-led fast food
-- Asian	   0x2a02  				     Not currently used
-- Barbeque	   0x2a03  amenity=fast_food_chicken         Chicken-led fast food
-- Chinese	   0x2a04  amenity=fast_food_chinese         Chinese or similar fast food
-- Deli or Bakery  0x2a05  shop=bakery		             Bakery
-- International   0x2a06  amenity=fast_food_kebab	     Kebab-led fast food
-- Fast Food	   0x2a07  fast_food_pie	     	     Pie-led fast food
-- Italian	   0x2a08  amenity=restaurant_italian        Italian Restaurant
-- Mexican	   0x2a09  amenity=fast_food_indian          Curry-led fast food
-- Pizza	   0x2a0a  amenity=fast_food_pizza           Italian or similar fast food
-- Seafood	   0x2a0b  amenity=fast_food_fish_and_chips  Fish and Chips-led fast food
-- Steak or Grill  0x2a0c  amenity=restaurant_steak    	     Steak Restaurant
-- Bagel or Donut  0x2a0d  fast_food_ice_cream		     Ice Cream Parlours
-- Cafe or Diner   0x2a0e  amenity=cafe etc.		     Cafe
-- French	   0x2a0f  amenity=restaurant_indian  	     Indian Restaurant
-- German	   0x2a10  amenity=restaurant_chinese  	     Chinese or similar Restaurant
-- British Isles   0x2a11  amenity=pub;amenity=bar	     Pubs and bars
-- Other	   0x2a12  				     Not currently used
--                 0x2a13                                    Not currently used
--                 0x2a14                                    Not currently used
-- ----------------------------------------------------------------------------
-- American	   0x2a01  amenity=fast_food_burger    Burger-led fast food
-- ----------------------------------------------------------------------------
   if ((( object.tags["amenity"] == "fast_food"                           )   or
        ( object.tags["amenity"] == "restaurant"                          ))  and
       (( object.tags["cuisine"] == "burger"                              )   or
        ( object.tags["cuisine"] == "american"                            )   or
        ( object.tags["cuisine"] == "diner"                               )   or
        ( object.tags["cuisine"] == "burger;sandwich"                     )   or
        ( object.tags["cuisine"] == "burger;kebab;pizza"                  )   or
        ( object.tags["cuisine"] == "burger;fish_and_chips;kebab;pizza"   )   or
        ( object.tags["cuisine"] == "burger;fish_and_chips"               )   or
        ( object.tags["cuisine"] == "burger;indian;kebab;pizza"           )   or
        ( object.tags["cuisine"] == "burger;pizza"                        )   or
        ( object.tags["cuisine"] == "burger;kebab"                        )   or
        ( object.tags["cuisine"] == "burger;chicken"                      )   or
        ( object.tags["cuisine"] == "burger;chicken;kebab"                )   or
        ( object.tags["cuisine"] == "burger;chicken;pizza"                )   or
        ( object.tags["cuisine"] == "burger;chicken;fish_and_chips;kebab" )   or
        ( object.tags["cuisine"] == "burger;pizza;kebab"                  )   or
        ( object.tags["cuisine"] == "burger;chicken;indian;kebab;pizza"   )   or
        ( object.tags["cuisine"] == "burger;chicken;kebab;pizza"          ))) then

      if ( object.tags["amenity"] == "restaurant" ) then
         object = append_nonqa( object, object.tags["amenity"] )
      end

      object = append_nonqa( object, object.tags["cuisine"] )
      object = append_accomm( object )
      object.tags["amenity"] = "fast_food_burger"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Asian	   0x2a02  				     Not currently used
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- Barbeque	   0x2a03  amenity=fast_food_chicken   Chicken-led fast food
-- ----------------------------------------------------------------------------
   if ((  object.tags["amenity"] == "fast_food"               )  and
       (( object.tags["cuisine"] == "chicken"                )   or
        ( object.tags["cuisine"] == "chicken;portuguese"     )   or
        ( object.tags["cuisine"] == "chicken;pizza"          )   or
        ( object.tags["cuisine"] == "chicken;burger;pizza"   )   or
        ( object.tags["cuisine"] == "chicken;kebab"          )   or
        ( object.tags["cuisine"] == "chicken;grill"          )   or
        ( object.tags["cuisine"] == "chicken;fish_and_chips" )   or
        ( object.tags["cuisine"] == "fried_chicken"          )   or
        ( object.tags["cuisine"] == "wings"                  ))) then
      object = append_nonqa( object, object.tags["cuisine"] )
      object.tags["amenity"] = "fast_food_chicken"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Chinese	   0x2a04  amenity=fast_food_chinese   Chinese or similar fast food
-- ----------------------------------------------------------------------------
   if ((  object.tags["amenity"] == "fast_food"               )  and
       (( object.tags["cuisine"] == "chinese"                )   or
        ( object.tags["cuisine"] == "thai"                   )   or
        ( object.tags["cuisine"] == "chinese;thai"           )   or
        ( object.tags["cuisine"] == "chinese;thai;malaysian" )   or
        ( object.tags["cuisine"] == "thai;chinese"           )   or
        ( object.tags["cuisine"] == "asian"                  )   or
        ( object.tags["cuisine"] == "japanese"               )   or
        ( object.tags["cuisine"] == "japanese;sushi"         )   or
        ( object.tags["cuisine"] == "sushi;japanese"         )   or
        ( object.tags["cuisine"] == "japanese;korean"        )   or
        ( object.tags["cuisine"] == "korean;japanese"        )   or
        ( object.tags["cuisine"] == "vietnamese"             )   or
        ( object.tags["cuisine"] == "korean"                 )   or
        ( object.tags["cuisine"] == "ramen"                  )   or
        ( object.tags["cuisine"] == "noodle"                 )   or
        ( object.tags["cuisine"] == "noodle;ramen"           )   or
        ( object.tags["cuisine"] == "malaysian"              )   or
        ( object.tags["cuisine"] == "malaysian;chinese"      )   or
        ( object.tags["cuisine"] == "indonesian"             )   or
        ( object.tags["cuisine"] == "cantonese"              )   or
        ( object.tags["cuisine"] == "chinese;cantonese"      )   or
        ( object.tags["cuisine"] == "chinese;asian"          )   or
        ( object.tags["cuisine"] == "oriental"               )   or
        ( object.tags["cuisine"] == "chinese;english"        )   or
        ( object.tags["cuisine"] == "chinese;japanese"       )   or
        ( object.tags["cuisine"] == "sushi"                  ))) then
      object = append_nonqa( object, object.tags["cuisine"] )
      object.tags["amenity"] = "fast_food_chinese"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- International   0x2a06  amenity=fast_food_kebab	     Kebab-led fast food
-- ----------------------------------------------------------------------------
   if ((  object.tags["amenity"] == "fast_food"             ) and
       (( object.tags["cuisine"] == "kebab"                )  or
        ( object.tags["cuisine"] == "kebab;pizza"          )  or
        ( object.tags["cuisine"] == "kebab;pizza;burger"   )  or
        ( object.tags["cuisine"] == "kebab;burger;pizza"   )  or
        ( object.tags["cuisine"] == "kebab;burger;chicken" )  or
        ( object.tags["cuisine"] == "kebab;burger"         )  or
        ( object.tags["cuisine"] == "kebab;fish_and_chips" )  or
        ( object.tags["cuisine"] == "turkish"              ))) then
      object = append_nonqa( object, object.tags["cuisine"] )
      object.tags["amenity"] = "fast_food_kebab"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Fast Food	   0x2a07  fast_food_pie	     	     Pie-led fast food
-- ----------------------------------------------------------------------------
   if ((  object.tags["amenity"] == "fast_food"      )  and
       (( object.tags["cuisine"] == "pasties"       )   or
        ( object.tags["cuisine"] == "pasty"         )   or
        ( object.tags["cuisine"] == "cornish_pasty" )   or
        ( object.tags["cuisine"] == "pie"           )   or
        ( object.tags["cuisine"] == "pies"          ))) then
      object = append_nonqa( object, object.tags["cuisine"] )
      object.tags["amenity"] = "fast_food_pie"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Italian Restaurants
-- Italian	   0x2a08  amenity=restaurant_italian  Italian Restaurant
-- ----------------------------------------------------------------------------
   if ((  object.tags["amenity"] == "restaurant"     )  and
       (( object.tags["cuisine"] == "italian"       )   or
        ( object.tags["cuisine"] == "pizza"         )   or
        ( object.tags["cuisine"] == "mediterranean" ))) then
      object = append_nonqa( object, object.tags["cuisine"] )
      object = append_accomm( object )
      object.tags["amenity"] = "restaurant_italian"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Mexican	   0x2a09  amenity=fast_food_indian    Curry-led fast food
-- ----------------------------------------------------------------------------
   if ((  object.tags["amenity"] == "fast_food"            ) and
       (( object.tags["cuisine"] == "indian"              )  or
        ( object.tags["cuisine"] == "curry"               )  or
        ( object.tags["cuisine"] == "nepalese"            )  or
        ( object.tags["cuisine"] == "nepalese;indian"     )  or
        ( object.tags["cuisine"] == "indian;nepalese"     )  or
        ( object.tags["cuisine"] == "bangladeshi"         )  or
        ( object.tags["cuisine"] == "indian;bangladeshi"  )  or
        ( object.tags["cuisine"] == "bangladeshi;indian"  )  or
        ( object.tags["cuisine"] == "indian;curry"        )  or
        ( object.tags["cuisine"] == "indian;kebab"        )  or
        ( object.tags["cuisine"] == "indian;kebab;burger" )  or
        ( object.tags["cuisine"] == "indian;thai"         )  or
        ( object.tags["cuisine"] == "curry;indian"        )  or
        ( object.tags["cuisine"] == "pakistani"           )  or
        ( object.tags["cuisine"] == "indian;pakistani"    )  or
        ( object.tags["cuisine"] == "tandoori"            )  or
        ( object.tags["cuisine"] == "afghan"              )  or
        ( object.tags["cuisine"] == "sri_lankan"          )  or
        ( object.tags["cuisine"] == "punjabi"             )  or
        ( object.tags["cuisine"] == "indian;pizza"        ))) then
      object = append_nonqa( object, object.tags["cuisine"] )
      object.tags["amenity"] = "fast_food_indian"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Italian Fast Food
-- Pizza	   0x2a0a  amenity=fast_food_pizza   Italian or similar fast food
-- ----------------------------------------------------------------------------
   if ((  object.tags["amenity"] == "fast_food"                   )  and
       (( object.tags["cuisine"] == "pizza"                      )   or
        ( object.tags["cuisine"] == "italian"                    )   or
        ( object.tags["cuisine"] == "pasta"                      )   or
        ( object.tags["cuisine"] == "pizza;pasta"                )   or
        ( object.tags["cuisine"] == "pizza;italian"              )   or
        ( object.tags["cuisine"] == "italian;pizza"              )   or
        ( object.tags["cuisine"] == "pizza;kebab"                )   or
        ( object.tags["cuisine"] == "pizza;burger"               )   or
        ( object.tags["cuisine"] == "pizza;chicken"              )   or
        ( object.tags["cuisine"] == "pizza;indian"               )   or
        ( object.tags["cuisine"] == "pizza;fish_and_chips"       )   or
        ( object.tags["cuisine"] == "pizza;kebab;burger"         )   or
        ( object.tags["cuisine"] == "pizza;kebab;burger;chicken" )   or
        ( object.tags["cuisine"] == "pizza;kebab;chicken"        )   or
        ( object.tags["cuisine"] == "pizza;burger;kebab"         )   or
        ( object.tags["cuisine"] == "italian_pizza"              ))) then
      object = append_nonqa( object, object.tags["cuisine"] )
      object.tags["amenity"] = "fast_food_pizza"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Seafood	   0x2a0b  amenity=fast_food_fish_and_chips  Fish and Chips-led fast food
-- ----------------------------------------------------------------------------
   if ((( object.tags["amenity"] == "fast_food"                         )  or
        ( object.tags["amenity"] == "restaurant"                        )) and
       (( object.tags["cuisine"] == "fish_and_chips"                    )  or
        ( object.tags["cuisine"] == "chinese;fish_and_chips"            )  or
        ( object.tags["cuisine"] == "fish"                              )  or
        ( object.tags["cuisine"] == "fish_and_chips;chinese"            )  or
        ( object.tags["cuisine"] == "fish_and_chips;indian"             )  or
        ( object.tags["cuisine"] == "fish_and_chips;kebab"              )  or
        ( object.tags["cuisine"] == "fish_and_chips;pizza;kebab"        )  or
        ( object.tags["cuisine"] == "fish_and_chips;pizza;burger;kebab" )  or
        ( object.tags["cuisine"] == "fish_and_chips;pizza"              ))) then

      if ( object.tags["amenity"] == "restaurant" ) then
         object = append_nonqa( object, object.tags["amenity"] )
      end

      object = append_nonqa( object, object.tags["cuisine"] )
      object = append_accomm( object )
      object.tags["amenity"] = "fast_food_fish_and_chips"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Steak Restaurants
-- Steak or Grill  0x2a0c  amenity=restaurant_steak    	     Steak Restaurant
-- ----------------------------------------------------------------------------
   if ((  object.tags["amenity"] == "restaurant"   )  and
       (( object.tags["cuisine"] == "steak_house" )   or
        ( object.tags["cuisine"] == "grill"       )   or
        ( object.tags["cuisine"] == "brazilian"   )   or
        ( object.tags["cuisine"] == "argentinian" ))) then
      object = append_nonqa( object, object.tags["cuisine"] )
      object.tags["amenity"] = "restaurant_steak"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Bagel or Donut  0x2a0d  fast_food_ice_cream		     Ice Cream Parlours
-- ----------------------------------------------------------------------------
   if ((  object.tags["shop"]    == "ice_cream"                        )  or
       (  object.tags["amenity"] == "ice_cream"                        )) then
      object.tags["amenity"] = "fast_food"
      object.tags["cuisine"] = "ice_cream"
      object.tags["shop"] = nil
   end

   if ((  object.tags["amenity"] == "fast_food"                        )  and
       (( object.tags["cuisine"] == "ice_cream"                       )   or
        ( object.tags["cuisine"] == "ice_cream;cake;coffee"           )   or
        ( object.tags["cuisine"] == "ice_cream;cake;sandwich"         )   or
        ( object.tags["cuisine"] == "ice_cream;coffee_shop"           )   or
        ( object.tags["cuisine"] == "ice_cream;coffee;waffle"         )   or
        ( object.tags["cuisine"] == "ice_cream;donut"                 )   or
        ( object.tags["cuisine"] == "ice_cream;pizza"                 )   or
        ( object.tags["cuisine"] == "ice_cream;sandwich"              )   or
        ( object.tags["cuisine"] == "ice_cream;tea;coffee"            ))) then
      object = append_nonqa( object, object.tags["cuisine"] )
      object.tags["amenity"] = "fast_food_ice_cream"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- What web maps show as "amenity=fast_food_coffee"
-- Cafe or Diner   0x2a0e  amenity=cafe etc.		     Cafe
-- ----------------------------------------------------------------------------
   if ((  object.tags["amenity"] == "fast_food"                  )  and
       (( object.tags["cuisine"] == "coffee"                    )   or
        ( object.tags["cuisine"] == "coffee_shop"               )   or
        ( object.tags["cuisine"] == "coffee_shop;sandwich"      )   or
        ( object.tags["cuisine"] == "coffee_shop;local"         )   or
        ( object.tags["cuisine"] == "coffee_shop;regional"      )   or
        ( object.tags["cuisine"] == "coffee_shop;cake"          )   or
        ( object.tags["cuisine"] == "coffee_shop;sandwich;cake" )   or
        ( object.tags["cuisine"] == "coffee_shop;breakfast"     )   or
        ( object.tags["cuisine"] == "coffee_shop;italian"       )   or
        ( object.tags["cuisine"] == "cake;coffee_shop"          )   or
        ( object.tags["cuisine"] == "coffee_shop;ice_cream"     ))) then
      object = append_nonqa( object, object.tags["cuisine"] )
      object.tags["amenity"] = "cafe"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- What web maps show as "amenity=fast_food_sandwich"
-- Cafe or Diner   0x2a0e  amenity=cafe etc.		     Cafe
-- ----------------------------------------------------------------------------
   if ((  object.tags["amenity"] == "fast_food"             )  and
       (( object.tags["cuisine"] == "sandwich"             )   or
        ( object.tags["cuisine"] == "sandwich;bakery"      )   or
        ( object.tags["cuisine"] == "sandwich;coffee_shop" ))) then
      object = append_nonqa( object, object.tags["cuisine"] )
      object.tags["amenity"] = "cafe"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Indian Restaurants
-- French	   0x2a0f  amenity=restaurant_indian  Indian Restaurant
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"] == "restaurant"  )  and
       ( object.tags["cuisine"] == "indian"      )) then
      object = append_nonqa( object, object.tags["cuisine"] )
      object = append_accomm( object )
      object.tags["amenity"] = "restaurant_indian"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Chinese or similar Restaurants
-- German	   0x2a10  amenity=restaurant_indian  Chinese or similar Restaurant
-- ----------------------------------------------------------------------------
   if ((  object.tags["amenity"] == "restaurant"      ) and
       (( object.tags["cuisine"] == "chinese"        )  or
        ( object.tags["cuisine"] == "thai"           )  or
        ( object.tags["cuisine"] == "asian"          )  or
        ( object.tags["cuisine"] == "japanese"       )  or
        ( object.tags["cuisine"] == "vietnamese"     )  or
        ( object.tags["cuisine"] == "korean"         )  or
        ( object.tags["cuisine"] == "sushi;japanese" ))) then
      object = append_nonqa( object, object.tags["cuisine"] )
      object = append_accomm( object )
      object.tags["amenity"] = "restaurant_chinese"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Other Restaurants and fast food.
-- Anything with a recognisable cuisine that we want to handle separately will 
-- have had a different amenity tag set above.
-- 0x2a00  amenity=fast_food  amenity=restaurant
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"] == "fast_food"  )  or
       ( object.tags["amenity"] == "restaurant" )) then
      object = append_nonqa( object, object.tags["amenity"] )

      if ( object.tags["cuisine"] ~= nil ) then
         object = append_nonqa( object, object.tags["cuisine"] )
      end

      object = append_accomm( object )
      object.tags["amenity"] = "restaurant"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Other	   0x2a12  				     Not currently used
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- man_made=flagpole
-- A different suffix is used depending on whether they are military or not.
-- "operator" is cleared before being picked up by the "operator" logic below.
-- ----------------------------------------------------------------------------
   if ( object.tags["man_made"] == "flagpole" ) then
      object.tags["man_made"] = "thing"

      if (( object.tags["operator"] == "Ministry of Defence" )   or
          ( object.tags["operator"] == "MOD"                 )) then
         object = append_nonqa( object, "military flagpole" )
      else
         object = append_nonqa( object, "flagpole" )
      end

      object.tags["operator"] = nil
   end

-- ----------------------------------------------------------------------------
-- Windsocks
-- ----------------------------------------------------------------------------
   if (( object.tags["aeroway"]  == "windsock" ) or
       ( object.tags["landmark"] == "windsock" ) or
       ( object.tags["man_made"] == "windsock" )) then
      object.tags["man_made"] = "thing"
      object = append_nonqa( object, "windsock" )
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
-- "0x2e08" is searchable as "Shopping / House and Garden"
-- ----------------------------------------------------------------------------
   if ( object.tags["landuse"] == "plant_nursery"              ) then
      object.tags["shop"] = object.tags["landuse"]
   end

   if (( object.tags["shop"]    == "garden_centre"              ) or
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
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"]    = "garden_centre"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Show shop=hardware stores etc. as shop=doityourself
-- Also Homeware shops
-- "0x2e09" is searchable as "Shopping / Home Furnishings"
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "plant_hire;tool_hire" ) then
      object.tags["shop"] = object.tags["amenity"]
      object.tags["amenity"] = nil
   end

   if (( object.tags["craft"]  == "signmaker"             ) or
       ( object.tags["craft"]  == "roofer"                ) or
       ( object.tags["craft"]  == "floorer"               ) or
       ( object.tags["craft"]  == "window_construction"   ) or
       ( object.tags["craft"]  == "framing"               ) or
       ( object.tags["craft"]  == "glaziery"              ) or
       ( object.tags["craft"]  == "plumber"               ) or
       ( object.tags["craft"]  == "carpenter"             ) or
       ( object.tags["craft"]  == "decorator"             ) or
       ( object.tags["craft"]  == "furniture"             ) or
       ( object.tags["craft"]  == "furniture_maker"       ) or
       ( object.tags["craft"]  == "upholsterer"           )) then
      object.tags["shop"] = object.tags["craft"]
      object.tags["craft"] = nil
   end

   if ( object.tags["office"]  == "industrial_supplies"  ) then
      object.tags["shop"] = object.tags["office"]
      object.tags["office"] = nil
   end

   if (( object.tags["shop"]   == "doityourself"                ) or
       ( object.tags["shop"]   == "bathroom"                    ) or
       ( object.tags["shop"]   == "bathroom_furnishing"         ) or
       ( object.tags["shop"]   == "bathrooms"                   ) or
       ( object.tags["shop"]   == "bed"                         ) or
       ( object.tags["shop"]   == "bed;carpet"                  ) or
       ( object.tags["shop"]   == "bedding"                     ) or
       ( object.tags["shop"]   == "bedroom"                     ) or
       ( object.tags["shop"]   == "blinds"                      ) or
       ( object.tags["shop"]   == "brewing"                     ) or
       ( object.tags["shop"]   == "builders_merchant"           ) or
       ( object.tags["shop"]   == "builders_merchants"          ) or
       ( object.tags["shop"]   == "building_materials"          ) or
       ( object.tags["shop"]   == "building_supplies"           ) or
       ( object.tags["shop"]   == "carpenter"                   ) or
       ( object.tags["shop"]   == "carpet"                      ) or
       ( object.tags["shop"]   == "carpet;bed"                  ) or
       ( object.tags["shop"]   == "ceramics"                    ) or
       ( object.tags["shop"]   == "chair"                       ) or
       ( object.tags["shop"]   == "clock"                       ) or
       ( object.tags["shop"]   == "clocks"                      ) or
       ( object.tags["shop"]   == "conservatories"              ) or
       ( object.tags["shop"]   == "conservatory"                ) or
       ( object.tags["shop"]   == "cookery"                     ) or
       ( object.tags["shop"]   == "cookware"                    ) or
       ( object.tags["shop"]   == "country_store"               ) or
       ( object.tags["shop"]   == "curtain"                     ) or
       ( object.tags["shop"]   == "decorating"                  ) or
       ( object.tags["shop"]   == "decorator"                   ) or
       ( object.tags["shop"]   == "equestrian"                  ) or
       ( object.tags["shop"]   == "equipment_hire"              ) or
       ( object.tags["shop"]   == "fencing"                     ) or
       ( object.tags["shop"]   == "fireplace"                   ) or
       ( object.tags["shop"]   == "fitted_furniture"            ) or
       ( object.tags["shop"]   == "floor"                       ) or
       ( object.tags["shop"]   == "floor_covering"              ) or
       ( object.tags["shop"]   == "floorer"                     ) or
       ( object.tags["shop"]   == "flooring"                    ) or
       ( object.tags["shop"]   == "floors"                      ) or
       ( object.tags["shop"]   == "frame"                       ) or
       ( object.tags["shop"]   == "frame;restoration"           ) or
       ( object.tags["shop"]   == "framing"                     ) or
       ( object.tags["shop"]   == "furnace"                     ) or
       ( object.tags["shop"]   == "furnishing"                  ) or
       ( object.tags["shop"]   == "furnishings"                 ) or
       ( object.tags["shop"]   == "furniture"                   ) or
       ( object.tags["shop"]   == "garage"                      ) or
       ( object.tags["shop"]   == "gates"                       ) or
       ( object.tags["shop"]   == "glass"                       ) or
       ( object.tags["shop"]   == "glassware"                   ) or
       ( object.tags["shop"]   == "glazier"                     ) or
       ( object.tags["shop"]   == "glaziery"                    ) or
       ( object.tags["shop"]   == "glazing"                     ) or
       ( object.tags["shop"]   == "hardware"                    ) or
       ( object.tags["shop"]   == "hardware_rental"             ) or
       ( object.tags["shop"]   == "home"                        ) or
       ( object.tags["shop"]   == "home_improvement"            ) or
       ( object.tags["shop"]   == "homeware"                    ) or
       ( object.tags["shop"]   == "homewares"                   ) or
       ( object.tags["shop"]   == "household"                   ) or
       ( object.tags["shop"]   == "houseware"                   ) or
       ( object.tags["shop"]   == "industrial_supplies"         ) or
       ( object.tags["shop"]   == "interior"                    ) or
       ( object.tags["shop"]   == "interior_decoration"         ) or
       ( object.tags["shop"]   == "interior_design"             ) or
       ( object.tags["shop"]   == "interiors"                   ) or
       ( object.tags["shop"]   == "ironmonger"                  ) or
       ( object.tags["shop"]   == "kitchen"                     ) or
       ( object.tags["shop"]   == "kitchen;bathroom"            ) or
       ( object.tags["shop"]   == "kitchen;bathroom_furnishing" ) or
       ( object.tags["shop"]   == "kitchenware"                 ) or
       ( object.tags["shop"]   == "lighting"                    ) or
       ( object.tags["shop"]   == "luggage"                     ) or
       ( object.tags["shop"]   == "mattress"                    ) or
       ( object.tags["shop"]   == "paint"                       ) or
       ( object.tags["shop"]   == "picture_framing"             ) or
       ( object.tags["shop"]   == "picture_framer"              ) or
       ( object.tags["shop"]   == "plant_hire"                  ) or
       ( object.tags["shop"]   == "plant_hire;tool_hire"        ) or
       ( object.tags["shop"]   == "plumbers_merchant"           ) or
       ( object.tags["shop"]   == "plumbing"                    ) or
       ( object.tags["shop"]   == "roofer"                      ) or
       ( object.tags["shop"]   == "roofing"                     ) or
       ( object.tags["shop"]   == "saddlery"                    ) or
       ( object.tags["shop"]   == "shed"                        ) or
       ( object.tags["shop"]   == "sheds"                       ) or
       ( object.tags["shop"]   == "sign"                        ) or
       ( object.tags["shop"]   == "signmaker"                   ) or
       ( object.tags["shop"]   == "signs"                       ) or
       ( object.tags["shop"]   == "signwriter"                  ) or
       ( object.tags["shop"]   == "stone"                       ) or
       ( object.tags["shop"]   == "stove"                       ) or
       ( object.tags["shop"]   == "stoves"                      ) or
       ( object.tags["shop"]   == "swimming_pool"               ) or
       ( object.tags["shop"]   == "tile"                        ) or
       ( object.tags["shop"]   == "tiles"                       ) or
       ( object.tags["shop"]   == "timber"                      ) or
       ( object.tags["shop"]   == "tool_hire"                   ) or
       ( object.tags["shop"]   == "tools"                       ) or
       ( object.tags["shop"]   == "upholsterer"                 ) or
       ( object.tags["shop"]   == "upholstery"                  ) or
       ( object.tags["shop"]   == "waterbed"                    ) or
       ( object.tags["shop"]   == "window_blind"                ) or
       ( object.tags["shop"]   == "window_construction"         ) or
       ( object.tags["shop"]   == "windows"                     ) or
       ( object.tags["shop"]   == "doors"                       )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"]    = "doityourself"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- hairdresser;beauty
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"] == "hairdresser"        ) or
       ( object.tags["shop"] == "hairdresser;beauty" )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- sports
-- The name is often characteristic,
-- If it's definitely a shop, clear "sport" here so that no sport in "points"
-- is accidentally matched.
-- "0x2e12" is searchable via "Shopping / Sporting Goods"
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"]   == "sports"            ) or
       ( object.tags["shop"]   == "golf"              ) or
       ( object.tags["shop"]   == "scuba_diving"      ) or
       ( object.tags["shop"]   == "water_sports"      ) or
       ( object.tags["shop"]   == "fishing"           ) or
       ( object.tags["shop"]   == "fishing_tackle"    ) or
       ( object.tags["shop"]   == "angling"           ) or
       ( object.tags["shop"]   == "fitness_equipment" ) or
       ( object.tags["shop"]   == "fitness"           )) then
      object = append_nonqa( object, object.tags["shop"] )

      if (( object.tags["shop"]   == "sports" ) and
          ( object.tags["sport"]  ~= nil      )) then
         object = append_nonqa( object, object.tags["sport"] )
      end

      object.tags["shop"] = "sports"
      object.tags["sport"] = nil
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- e-cigarette
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"]   == "vaping"      ) or
       ( object.tags["shop"]   == "vape_shop"   ) or
       ( object.tags["shop"]   == "e-cigarette" )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Currently handle beauty salons etc. as just generic beauty.  Also "chemist"
-- Mostly these have names that describe the business, so less need for a
-- specific icon.
-- "0x2e05" is shown as 'Shopping / Pharmacy or Chemist'
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"]      == "spa" ) then
      object.tags["shop"] = object.tags["amenity"]
   end

   if (( object.tags["club"]    == "health"               )  and
       ( object.tags["leisure"] == nil                    )  and
       ( object.tags["amenity"] == nil                    )  and
       ( object.tags["name"]    ~= nil                    )) then
      object.tags["shop"] = "health club"
   end

   if (( object.tags["leisure"]      == "spa"               ) or
       ( object.tags["leisure"]      == "tanning_salon"     )) then
      object.tags["shop"] = object.tags["leisure"]
   end

   if ( object.tags["tourism"]      == "spa" ) then
      object.tags["shop"] = object.tags["tourism"]
   end

   if (( object.tags["shop"]         == "beauty"            ) or
       ( object.tags["shop"]         == "beauty_salon"      ) or
       ( object.tags["shop"]         == "spa"               ) or
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
       ( object.tags["shop"]         == "health_and_beauty" ) or
       ( object.tags["shop"]         == "health club"       ) or
       ( object.tags["shop"]         == "tanning_salon"     )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "chemist"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Betting Shops etc.
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- See also "casino", which is elsewhere.
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"] == "betting"             ) or
       ( object.tags["amenity"] == "gambling"            ) or
       ( object.tags["amenity"] == "lottery"             ) or
       ( object.tags["amenity"] == "amusements"          ) or
       ( object.tags["amenity"] == "amusement"           )) then
      object.tags["shop"] = object.tags["amenity"]
      object.tags["amenity"] = nil
   end

   if (( object.tags["leisure"] == "gambling"            ) or
       ( object.tags["leisure"] == "amusement_arcade"    ) or
       ( object.tags["leisure"] == "video_arcade"        ) or
       ( object.tags["leisure"] == "adult_gaming_centre" )) then
      object.tags["shop"] = object.tags["leisure"]
      object.tags["leisure"] = nil
   end

   if (( object.tags["shop"]    == "bookmaker"           ) or
       ( object.tags["shop"]    == "betting"             ) or
       ( object.tags["shop"]    == "gambling"            ) or
       ( object.tags["shop"]    == "lottery"             ) or
       ( object.tags["shop"]    == "amusements"          ) or
       ( object.tags["shop"]    == "amusement"           ) or
       ( object.tags["shop"]    == "amusement_arcade"    ) or
       ( object.tags["shop"]    == "video_arcade"        ) or
       ( object.tags["shop"]    == "adult_gaming_centre" )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- "Non-electrical" electronics
-- "0x2e0c" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"]  == "security"         ) or
       ( object.tags["shop"]  == "survey"           ) or
       ( object.tags["shop"]  == "survey_equipment" ) or       
       ( object.tags["shop"]  == "hifi"             )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- shop=computer
-- shop=mobile_phone
-- "0x2e0b" is searchable via "Shopping / Computer or Software"
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"]  == "computer"        ) or
       ( object.tags["shop"]  == "computer_games"  ) or
       ( object.tags["shop"]  == "video_games"     ) or
       ( object.tags["shop"]  == "computer_repair" ) or
       ( object.tags["shop"]  == "mobile_phone"    ) or
       ( object.tags["shop"]  == "phone"           ) or
       ( object.tags["shop"]  == "phone_repair"    ) or
       ( object.tags["shop"]  == "telephone"       )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "computer"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- shop=butcher
-- "0x2e0c" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"]  == "butcher"             ) or
       ( object.tags["shop"]  == "butcher;greengrocer" )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "butcher"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- gift and other tat shops, antiques, art.
-- "0x2e10" is searchable via "Shopping / Gift/Antique/Art"
-- ----------------------------------------------------------------------------
   if (( object.tags["craft"]  == "artist"   ) or
       ( object.tags["craft"]  == "pottery"  ) or
       ( object.tags["craft"]  == "sculptor" )) then
      object.tags["shop"] = object.tags["craft"]
   end

   if (( object.tags["shop"]   == "gift"                ) or
       ( object.tags["shop"]   == "souvenir"            ) or
       ( object.tags["shop"]   == "souvenirs"           ) or
       ( object.tags["shop"]   == "leather"             ) or
       ( object.tags["shop"]   == "luxury"              ) or
       ( object.tags["shop"]   == "candle"              ) or
       ( object.tags["shop"]   == "candles"             ) or
       ( object.tags["shop"]   == "sunglasses"          ) or
       ( object.tags["shop"]   == "tourist"             ) or
       ( object.tags["shop"]   == "tourism"             ) or
       ( object.tags["shop"]   == "bag"                 ) or
       ( object.tags["shop"]   == "balloon"             ) or
       ( object.tags["shop"]   == "accessories"         ) or
       ( object.tags["shop"]   == "beach"               ) or
       ( object.tags["shop"]   == "magic"               ) or
       ( object.tags["shop"]   == "surf"                ) or
       ( object.tags["shop"]   == "party"               ) or
       ( object.tags["shop"]   == "party_goods"         ) or
       ( object.tags["shop"]   == "christmas"           ) or
       ( object.tags["shop"]   == "fashion_accessories" ) or
       ( object.tags["shop"]   == "antiques"            ) or
       ( object.tags["shop"]   == "art"                 ) or
       ( object.tags["shop"]   == "craft"               ) or
       ( object.tags["shop"]   == "art_supplies"        ) or
       ( object.tags["shop"]   == "pottery"             ) or
       ( object.tags["shop"]   == "sculptor"            ) or
       ( object.tags["shop"]   == "duty_free"           )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "gift"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Record,CD,Video and Music shops
-- "0x2e11" is searchable via "Shopping / Record/CD/Video"
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"]   == "music"               ) or
       ( object.tags["shop"]   == "music;video"         ) or
       ( object.tags["shop"]   == "records"             ) or
       ( object.tags["shop"]   == "record"              ) or
       ( object.tags["shop"]   == "audio_video"         ) or
       ( object.tags["shop"]   == "video"               )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "music"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Various alcohol shops
-- "0x2e13" is searchable via "Shopping / Wine & Liquor"
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"]    == "alcohol"         ) or
       ( object.tags["shop"]    == "beer"            ) or
       ( object.tags["shop"]    == "off_licence"     ) or
       ( object.tags["shop"]    == "off_license"     ) or
       ( object.tags["shop"]    == "wine"            ) or
       ( object.tags["shop"]    == "whisky"          )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "alcohol"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Farm shops
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if ( object.tags["shop"] == "farm" ) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Show pastry shops as bakeries
-- "0x2a05" is searchable via "Food and Drink / Deli or Bakery"
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"] == "bakery" ) or
       ( object.tags["shop"] == "pastry" )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "bakery"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Shops that sell coffee etc.
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"]    == "beverages"       ) or
       ( object.tags["shop"]    == "coffee"          ) or
       ( object.tags["shop"]    == "tea"             )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Copyshops
-- Various photo, camera, copy and print shops
-- Various "printer" offices
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"]    == "printer"           ) then
      object.tags["shop"] = object.tags["amenity"]
   end

   if (( object.tags["craft"]      == "printer"    ) or
       ( object.tags["craft"]      == "printmaker" ) or
       ( object.tags["craft"]      == "print_shop" )) then
      object.tags["shop"] = object.tags["craft"]
   end

   if (( object.tags["office"]     == "printer"           ) or
       ( object.tags["office"]     == "design"            )) then
      object.tags["shop"] = object.tags["office"]
   end

   if (( object.tags["shop"]    == "printing"           ) or
       ( object.tags["shop"]    == "print"              ) or
       ( object.tags["shop"]    == "printer"            ) or
       ( object.tags["shop"]    == "copyshop"           ) or
       ( object.tags["shop"]    == "printer_ink"        ) or
       ( object.tags["shop"]    == "printers"           ) or
       ( object.tags["shop"]    == "design"             ) or
       ( object.tags["shop"]    == "printmaker"         ) or
       ( object.tags["shop"]    == "print_shop"         )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- fabric and wool etc.
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if ( object.tags["craft"]   == "embroiderer" ) then
      object.tags["shop"] = object.tags["craft"]
   end

   if (( object.tags["shop"]   == "fabric"               ) or
       ( object.tags["shop"]   == "linen"                ) or
       ( object.tags["shop"]   == "household_linen"      ) or
       ( object.tags["shop"]   == "linens"               ) or
       ( object.tags["shop"]   == "haberdashery"         ) or
       ( object.tags["shop"]   == "sewing"               ) or
       ( object.tags["shop"]   == "needlecraft"          ) or
       ( object.tags["shop"]   == "embroidery"           ) or
       ( object.tags["shop"]   == "knitting"             ) or
       ( object.tags["shop"]   == "wool"                 ) or
       ( object.tags["shop"]   == "yarn"                 ) or
       ( object.tags["shop"]   == "alteration"           ) or
       ( object.tags["shop"]   == "clothing_alterations" ) or
       ( object.tags["shop"]   == "embroiderer"          )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- health_food etc., and also "non-medical medical" and "woo" shops.
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if ( object.tags["name"] == "Holland and Barrett" ) then
      object.tags["shop"] = "health_food"
   end

   if (( object.tags["shop"]       == "health_food"             ) or
       ( object.tags["shop"]       == "health"                  ) or
       ( object.tags["shop"]       == "organic"                 ) or
       ( object.tags["shop"]       == "supplements"             ) or
       ( object.tags["shop"]       == "nutrition_supplements"   ) or
       ( object.tags["shop"]       == "dietary_supplements"     )) then
      object = append_nonqa( object, object.tags["shop"] )
      object = append_eco( object )
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

   if (( object.tags["shop"]       == "alternative_medicine"    ) or
       ( object.tags["shop"]       == "massage"                 ) or
       ( object.tags["shop"]       == "herbalist"               ) or
       ( object.tags["shop"]       == "herbal_medicine"         ) or
       ( object.tags["shop"]       == "chinese_medicine"        ) or
       ( object.tags["shop"]       == "new_age"                 ) or
       ( object.tags["shop"]       == "alternative_health"      ) or
       ( object.tags["healthcare"] == "alternative"             ) or
       ( object.tags["shop"]       == "acupuncture"             ) or
       ( object.tags["healthcare"] == "acupuncture"             ) or
       ( object.tags["shop"]       == "aromatherapy"            ) or
       ( object.tags["shop"]       == "meditation"              ) or
       ( object.tags["shop"]       == "esoteric"                )) then
      object = append_nonqa( object, "alt health" )
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- books
-- the name is often characteristic
-- "0x2e14" is searchable via "Shopping / Book Store"
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"]   == "books"           ) or
       ( object.tags["shop"]   == "comics"          ) or
       ( object.tags["shop"]   == "comic"           ) or
       ( object.tags["shop"]   == "anime"           ) or
       ( object.tags["shop"]   == "maps"            )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "books"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- stationery
-- the name is often characteristic
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"]   == "stationery"      ) or
       ( object.tags["shop"]   == "office_supplies" )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- pets and pet services
-- Often the names are punningly characteristic (e.g. "Bark-in-Style" 
-- dog grooming).
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"] == "dog_grooming"            ) or
       ( object.tags["amenity"] == "veterinary"              ) or
       ( object.tags["amenity"] == "animal_boarding"         ) or
       ( object.tags["amenity"] == "cattery"                 ) or
       ( object.tags["amenity"] == "kennels"                 ) or
       ( object.tags["amenity"] == "animal_shelter"          )) then
      object.tags["shop"] = object.tags["amenity"]
   end

   if (( object.tags["animal"]  == "shelter"                 ) or
       ( object.tags["animal"]  == "wellness"                )) then
      object.tags["shop"] = "animal " .. object.tags["animal"]
   end

   if ( object.tags["craft"]   == "dog_grooming" ) then
      object.tags["shop"] = object.tags["craft"]
   end

   if (( object.tags["shop"]    == "pet"                     ) or
       ( object.tags["shop"]    == "pet;garden"              ) or
       ((  object.tags["shop"]     == "agrarian"                        )  and
        (( object.tags["agrarian"] == "feed"                           )  or
         ( object.tags["agrarian"] == "yes"                            )  or
         ( object.tags["agrarian"] == "feed;fertilizer;seed;pesticide" )  or
         ( object.tags["agrarian"] == "feed;seed"                      )  or
         ( object.tags["agrarian"] == "feed;pesticide;seed"            )  or
         ( object.tags["agrarian"] == "feed;tools"                     )  or
         ( object.tags["agrarian"] == "feed;tools;fuel;firewood"       ))) or
       ( object.tags["shop"]    == "aquatics"                ) or
       ( object.tags["shop"]    == "aquarium"                ) or
       ( object.tags["shop"]    == "pet_supplies"            ) or
       ( object.tags["shop"]    == "pet_care"                ) or
       ( object.tags["shop"]    == "pet_food"                ) or
       ( object.tags["shop"]    == "pet_grooming"            ) or
       ( object.tags["shop"]    == "dog_grooming"            ) or
       ( object.tags["shop"]    == "pet;corn"                ) or
       ( object.tags["shop"]    == "animal_feed"             ) or
       ( object.tags["shop"]    == "veterinary"              ) or
       ( object.tags["shop"]    == "cattery"                 ) or
       ( object.tags["shop"]    == "kennels"                 ) or
       ( object.tags["shop"]    == "animal_shelter"          ) or
       ( object.tags["shop"]    == "animal shelter"          ) or
       ( object.tags["shop"]    == "animal wellness"         )) then
      object = append_nonqa( object, object.tags["shop"] )

      if ( object.tags["agrarian"] ~= nil ) then
         object = append_nonqa( object, object.tags["agrarian"] )
      end

      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- catalogue shops
-- We have a specfic "general" shop type here, so use that.
-- "0x2e03" is searchable as "Shopping / General Merchandise"
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"] == "catalogue" ) or
       ( object.tags["shop"] == "outpost"   )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "catalogue"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Florists
-- "0x2e0f" is searchable via "Shopping / Florist"
-- ----------------------------------------------------------------------------
   if ( object.tags["shop"]  == "florist" ) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "florist"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Mappings to shop=bicycle
-- "0x2f13" is searchable via "Others / Repair Services"
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"] == "bicycle"          ) or
       ( object.tags["shop"] == "bicycle_repair"   )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "bicycle"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Car Sharing
-- "0x2f0d" is searchable via "Auto Services / Automobile Club"
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "car_sharing" ) then
      object = append_nonqa( object, object.tags["amenity"] )
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Car Wash
-- "0x2f0e" is searchable via "Auto Services / Car Wash"
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "car_wash" ) then
      object = append_nonqa( object, object.tags["amenity"] )
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Emergency phones
-- "0x2f12" is searchable via "Others / Communications"
-- ----------------------------------------------------------------------------
   if ( object.tags["railway"] == "phone" ) then
      object.tags["emergency"] = object.tags["railway"]
   end

   if ( object.tags["emergency"] == "phone" ) then
      object = append_nonqa( object, object.tags["emergency"] )

      if ( object.tags["colour"] ~= nil ) then
         object = append_nonqa( object, object.tags["colour"] )
      end

      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Storage Rental
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if ( object.tags["shop"]    == "storage" ) then
      object.tags["amenity"] = "storage"
   end

   if (( object.tags["amenity"] == "storage"              ) or
       ( object.tags["amenity"] == "self_storage"         ) or
       ( object.tags["office"]  == "storage_rental"       )) then
      object = append_nonqa( object, object.tags["amenity"] )
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Timpson and similar shops.
-- Timpson is brand:wikidata=Q7807658, but all of those are name=Timpson.
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if (( object.tags["craft"]   == "key_cutter"                         ) or
       ( object.tags["craft"]   == "shoe_repair"                        ) or
       ( object.tags["craft"]   == "key_cutter;shoe_repair"             )) then
      object.tags["shop"] = object.tags["craft"]
   end

   if (( object.tags["shop"]    == "shoe_repair"                        ) or
       ( object.tags["shop"]    == "keys"                               ) or
       ( object.tags["shop"]    == "key"                                ) or
       ( object.tags["shop"]    == "cobblers"                           ) or
       ( object.tags["shop"]    == "cobbler"                            ) or
       ( object.tags["shop"]    == "key_cutting"                        ) or
       ( object.tags["shop"]    == "keys_shoerepair"                    ) or
       ( object.tags["shop"]    == "key_cutting;shoe_repair"            ) or
       ( object.tags["shop"]    == "shoe_repair;key_cutting"            ) or
       ( object.tags["shop"]    == "locksmith;dry_cleaning;shoe_repair" ) or
       ( object.tags["shop"]    == "key_cutter"                         ) or
       ( object.tags["shop"]    == "key_cutter;shoe_repair"             )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Taxi offices
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "minicab" ) then
      object.tags["shop"] = object.tags["amenity"]
   end

   if (( object.tags["office"]  == "taxi"    ) or
       ( object.tags["office"]  == "minicab" )) then
      object.tags["shop"] = object.tags["office"]
   end

   if (( object.tags["shop"]    == "taxi"        ) or
       ( object.tags["shop"]    == "minicab"     )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "specialty"
      object.tags["amenity"] = nil
      object.tags["office"]  = nil
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Leisure mappings to "specialty retail" where it is the least worst fit:
-- Things that are leisure and are retail but are not sport 
-- and not an existing category
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"]  == "bingo"        ) or
       ( object.tags["amenity"]  == "escape_game"  ) or
       ( object.tags["amenity"]  == "brothel"      )) then
      object.tags["leisure"] = object.tags["amenity"]
      object.tags["amenity"] = nil
   end

   if ( object.tags["gambling"] == "bingo" ) then
      object.tags["leisure"] = object.tags["gambling"]
      object.tags["amenity"] = nil
   end

   if ((( object.tags["name"]     == "Bingo Hall"           )  or
        ( object.tags["name"]     == "Gala Bingo"           )  or
        ( object.tags["name"]     == "Mecca Bingo"          )  or
        ( object.tags["name"]     == "Castle Bingo"         )) and
       (( object.tags["amenity"]  == nil                    )  and
        ( object.tags["leisure"]  == nil                    )  and
        ( object.tags["office"]   == nil                    )  and
        ( object.tags["shop"]     == nil                    ))) then
      object.tags["leisure"] = "bingo"
   end

   if (( object.tags["leisure"]  == "bingo"                ) or
       ( object.tags["leisure"]  == "bingo_hall"           ) or
       ( object.tags["leisure"]  == "indoor_play"          ) or
       ( object.tags["leisure"]  == "soft_play"            ) or
       ( object.tags["leisure"]  == "escape_game"          ) or
       ( object.tags["leisure"]  == "trampoline_park"      ) or
       ( object.tags["leisure"]  == "trampoline"           ) or
       ( object.tags["leisure"]  == "inflatable_park"      ) or
       ( object.tags["leisure"]  == "sauna"                ) or
       ( object.tags["leisure"]  == "horse_riding"         )) then
      object = append_nonqa( object, object.tags["leisure"] )
      object.tags["shop"] = "specialty"
      object.tags["amenity"] = nil
      object.tags["leisure"]  = nil
      object = building_or_landuse( objtype, object )
   end

   if ( object.tags["sport"]    == "laser_tag" ) then
      object = append_nonqa( object, object.tags["sport"] )
      object.tags["shop"] = "specialty"
      object.tags["amenity"] = nil
      object.tags["leisure"]  = nil
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Mazes
-- ----------------------------------------------------------------------------
   if ((( object.tags["leisure"]    == "maze" ) or
        ( object.tags["attraction"] == "maze" )) and
       (  object.tags["historic"]   == nil     )) then
      object = append_nonqa( object, "maze" )
      object.tags["shop"] = "specialty"
      object.tags["amenity"] = nil
      object.tags["leisure"]  = nil
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Nonspecific car and related shops.
-- On Garmin, car_rental, car_repair,
-- and car_dealer/car_parts are all separate features.
-- 
-- We try and use an appropriate suffix in each case, by first appending a 
-- suffix based on what "shop" is, then setting "shop" to whatever tag is 
-- characteristic for rendering for that item.
--
-- shop=car_rental maps to:
-- "0x2f02" is supposed to be searchable via "Auto Services / Auto Rental"
--
-- Currently, amenity=taxi (see above) among others maps to:
-- "0x2f17" is searchable via "Transportation / Transport Service" and
-- amenity=car_sharing (see above) maps to:
-- "0x2f0d" is searchable via "Auto Services / Automobile Club"
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"] == "car_rental"                   ) or
       ( object.tags["amenity"] == "van_rental"                   ) or
       ( object.tags["amenity"] == "car_rental;bicycle_rental"    ) or
       ( object.tags["amenity"] == "motorcycle_rental"            )) then
      object.tags["shop"] = object.tags["amenity"]
      object.tags["amenity"] = nil
   end

   if (( object.tags["shop"]    == "car_rental"                   ) or
       ( object.tags["shop"]    == "van_rental"                   ) or
       ( object.tags["shop"]    == "car_rental;bicycle_rental"    ) or
       ( object.tags["shop"]    == "motorcycle_rental"            )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "car_rental"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Car parts
-- "0x2f07" is searchable via "Auto Services / Dealer or Auto Parts"
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"]    == "trade"                       )  and
       ( object.tags["trade"]   == "car_parts"                   )) then
      object.tags["shop"] = object.tags["trade"]
      object.tags["trade"] = nil
   end

   if ((  object.tags["shop"]    == "car_parts"                    )  or
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
       (  object.tags["shop"]    == "motor_spares"                 )  or
       (  object.tags["shop"]    == "motor_accessories"            )  or
       (  object.tags["shop"]    == "car_parts;car_repair"         )  or
       (  object.tags["shop"]    == "bicycle;car_parts"            )  or
       (  object.tags["shop"]    == "car_parts;bicycle"            )  or
       (  object.tags["shop"]    == "motorcycle_parts"             )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "car_parts"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Map craft=car_repair etc. to shop=car_repair
-- "0x2f03" is searchable via "Auto Services / Auto Repair"
-- ----------------------------------------------------------------------------
   if (( object.tags["craft"]   == "car_repair"   ) or
       ( object.tags["craft"]   == "coachbuilder" )) then
      object.tags["shop"] = object.tags["craft"]
   end

   if ( object.tags["amenity"] == "vehicle_inspection" ) then
      object = append_nonqa( object, object.tags["amenity"] )
      object.tags["shop"]    = "car_repair"
      object.tags["amenity"] = nil
      object = building_or_landuse( objtype, object )
   end

   if ( object.tags["industrial"] == "truck_repair" ) then
      object = append_nonqa( object, object.tags["industrial"] )
      object.tags["shop"]    = "car_repair"
      object.tags["industrial"] = nil
      object = building_or_landuse( objtype, object )
   end

   if (( object.tags["shop"]    == "car_repair"         )  or
       ( object.tags["shop"]    == "coachbuilder"       )  or
       ( object.tags["shop"]    == "car_service"        )  or
       ( object.tags["shop"]    == "car_bodyshop"       )  or
       ( object.tags["shop"]    == "vehicle_inspection" )  or
       ( object.tags["shop"]    == "mechanic"           )  or
       ( object.tags["shop"]    == "car_repair;car"     )  or
       ( object.tags["shop"]    == "car_repair;tyres"   )  or
       ( object.tags["shop"]    == "tractor_repair"     )  or
       ( object.tags["shop"]    == "tractor_parts"      )  or
       ( object.tags["shop"]    == "truck_repair"       )  or
       ( object.tags["shop"]    == "motorcycle_repair"  )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "car_repair"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- driving school, mapped to "specialty" is a bit of an oddity here.
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "driving_school" ) then
      object = append_nonqa( object, object.tags["amenity"] )
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Mappings to shop=car
-- "0x2f07" is searchable via "Auto Services / Dealer or Auto Parts"
-- ----------------------------------------------------------------------------
   if  ((  object.tags["shop"]    == "agrarian"                                           ) and
        (( object.tags["agrarian"] == "agricultural_machinery"                           )  or
         ( object.tags["agrarian"] == "machine_parts;agricultural_machinery;tools"       )  or
         ( object.tags["agrarian"] == "agricultural_machinery;machine_parts;tools"       )  or
         ( object.tags["agrarian"] == "agricultural_machinery;feed"                      )  or
         ( object.tags["agrarian"] == "agricultural_machinery;machine_parts;tools;signs" )  or
         ( object.tags["agrarian"] == "agricultural_machinery;machine_parts"             )  or
         ( object.tags["agrarian"] == "agricultural_machinery;seed"                      )  or
         ( object.tags["agrarian"] == "machine_parts;agricultural_machinery"             ))) then
      object.tags["shop"] = "car"
      object = append_nonqa( object, "agricultural machinery" )
      object = building_or_landuse( objtype, object )
   end

   if (( object.tags["shop"]    == "car"                          )  or
       ( object.tags["shop"]    == "car;car_repair"               )  or
       ( object.tags["shop"]    == "car_showroom"                 )  or
       ( object.tags["shop"]    == "vehicle"                      )  or
       ( object.tags["shop"]    == "caravan"                      ) or
       ( object.tags["shop"]    == "motorhome"                    ) or
       ( object.tags["shop"]    == "truck"                        ) or
       ( object.tags["shop"]    == "commercial_vehicles"          ) or
       ( object.tags["shop"]    == "commercial_vehicle"           ) or
       ( object.tags["shop"]    == "agricultural_vehicles"        ) or
       ( object.tags["shop"]    == "tractor"                      ) or
       ( object.tags["shop"]    == "tractors"                     ) or
       ( object.tags["shop"]    == "van"                          ) or
       ( object.tags["shop"]    == "forklift_repair"              ) or
       ( object.tags["shop"]    == "motorcycle"                   ) or
       ( object.tags["shop"]    == "atv"                          )) then
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["shop"] = "car"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- "business" and "company" are used as an alternative to "office" and 
-- "industrial" by some people.  Wherever someone has used a more 
-- frequently-used tag we defer to that.
-- ----------------------------------------------------------------------------
   if (( object.tags["business"]   ~= nil  ) and
       ( object.tags["office"]     == nil  ) and
       ( object.tags["shop"]       == nil  ) and
       ( object.tags["playground"] == nil  )) then
      object.tags["office"] = "yes"
      object.tags["business"] = nil
   end

   if (( object.tags["company"]   ~= nil  ) and
       ( object.tags["man_made"]  == nil  ) and
       ( object.tags["office"]    == nil  ) and
       ( object.tags["shop"]      == nil  )) then
      object.tags["office"] = "yes"
      object.tags["company"] = nil
   end

-- ----------------------------------------------------------------------------
-- Non-government (commercial) offices that you might visit for a service.
-- "communication" below seems to be used for marketing / commercial PR.
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- Add unnamedcommercial landuse to give non-building areas a background.
-- ----------------------------------------------------------------------------
   if ( object.tags["healthcare"] == "home_care" ) then
      object.tags["office"] = object.tags["healthcare"]
   end

   if (( object.tags["office"]      == "accountant"              ) or
       ( object.tags["office"]      == "accountants"             ) or
       ( object.tags["office"]      == "advertising"             ) or
       ( object.tags["office"]      == "architect"               ) or
       ( object.tags["office"]      == "association"             ) or
       ( object.tags["office"]      == "builder"                 ) or
       ( object.tags["office"]      == "charity"                 ) or
       ( object.tags["office"]      == "communication"           ) or
       ( object.tags["office"]      == "computer"                ) or
       ( object.tags["office"]      == "consulting"              ) or
       ( object.tags["office"]      == "courier"                 ) or
       ( object.tags["office"]      == "coworking"               ) or
       ( object.tags["office"]      == "coworking_space"         ) or
       ( object.tags["office"]      == "delivery"                ) or
       ( object.tags["office"]      == "design"                  ) or
       ( object.tags["office"]      == "diplomatic"              ) or
       ( object.tags["office"]      == "educational_institution" ) or
       ( object.tags["office"]      == "employment_agency"       ) or
       ( object.tags["office"]      == "engineering"             ) or
       ( object.tags["office"]      == "financial"               ) or
       ( object.tags["office"]      == "graphic_design"          ) or
       ( object.tags["office"]      == "home_care"               ) or
       ( object.tags["office"]      == "hvac"                    ) or
       ( object.tags["office"]      == "insurance"               ) or
       ( object.tags["office"]      == "interior_design"         ) or
       ( object.tags["office"]      == "it"                      ) or
       ( object.tags["office"]      == "laundry"                 ) or
       ( object.tags["office"]      == "lawyer"                  ) or
       ( object.tags["office"]      == "marketing"               ) or
       ( object.tags["office"]      == "marriage_guidance"       ) or
       ( object.tags["office"]      == "newspaper"               ) or
       ( object.tags["office"]      == "ngo"                     ) or
       ( object.tags["office"]      == "organization"            ) or
       ( object.tags["office"]      == "parcel"                  ) or
       ( object.tags["office"]      == "political_party"         ) or
       ( object.tags["office"]      == "politician"              ) or
       ( object.tags["office"]      == "political"               ) or
       ( object.tags["office"]      == "property_maintenance"    ) or
       ( object.tags["office"]      == "quango"                  ) or
       ( object.tags["office"]      == "recruitment"             ) or
       ( object.tags["office"]      == "recruitment_agency"      ) or
       ( object.tags["office"]      == "religion"                ) or
       ( object.tags["office"]      == "security"                ) or
       ( object.tags["office"]      == "serviced_offices"        ) or
       ( object.tags["office"]      == "solicitor"               ) or
       ( object.tags["office"]      == "solicitors"              ) or
       ( object.tags["office"]      == "surveyor"                ) or
       ( object.tags["office"]      == "tax_advisor"             ) or
       ( object.tags["office"]      == "telecommunication"       ) or
       ( object.tags["office"]      == "therapist"               ) or
       ( object.tags["office"]      == "training"                ) or
       ( object.tags["office"]      == "university"              ) or
       ( object.tags["office"]      == "web_design"              )) then
      object = append_nonqa( object, "office" )
      object = append_nonqa( object, object.tags["office"] )
      object.tags["amenity"] = nil
      object.tags["craft"] = nil
      object.tags["office"] = nil
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Other non-government (mostly commercial) office-like places.
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- Add unnamedcommercial landuse to give non-building areas a background.
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"]     == "accountants"             ) or
       ( object.tags["amenity"]     == "advice"                  ) or
       ( object.tags["amenity"]     == "advice_service"          ) or
       ( object.tags["amenity"]     == "convent"                 ) or
       ( object.tags["amenity"]     == "cooking_school"          ) or
       ( object.tags["amenity"]     == "coworking_space"         ) or
       ( object.tags["amenity"]     == "delivery_office"         ) or
       ( object.tags["amenity"]     == "laboratory"              ) or
       ( object.tags["amenity"]     == "lawyer"                  ) or
       ( object.tags["amenity"]     == "medical_laboratory"      ) or
       ( object.tags["amenity"]     == "monastery"               ) or
       ( object.tags["amenity"]     == "music_school"            ) or
       ( object.tags["amenity"]     == "post_depot"              ) or
       ( object.tags["amenity"]     == "research_institute"      ) or
       ( object.tags["amenity"]     == "solicitor"               ) or
       ( object.tags["amenity"]     == "solicitors"              ) or
       ( object.tags["amenity"]     == "sorting_office"          ) or
       ( object.tags["amenity"]     == "studio"                  ) or
       ( object.tags["amenity"]     == "tax_advisor"             )) then
      object = append_nonqa( object, "amenity" )
      object = append_nonqa( object, object.tags["amenity"] )
      object.tags["amenity"] = nil
      object.tags["craft"] = nil
      object.tags["office"] = nil
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- "craft" places you might visit for a service.
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- Add unnamedcommercial landuse to give non-building areas a background.
-- ----------------------------------------------------------------------------
   if (( object.tags["craft"]   == "agricultural_engines"    ) or
       ( object.tags["craft"]   == "atelier"                 ) or
       ( object.tags["craft"]   == "beekeeper"               ) or
       ( object.tags["craft"]   == "blacksmith"              ) or
       ( object.tags["craft"]   == "bookbinder"              ) or
       ( object.tags["craft"]   == "cabinet_maker"           ) or
       ( object.tags["craft"]   == "carpet_layer"            ) or
       ( object.tags["craft"]   == "caterer"                 ) or
       ( object.tags["craft"]   == "cleaning"                ) or
       ( object.tags["craft"]   == "clockmaker"              ) or
       ( object.tags["craft"]   == "confectionery"           ) or
       ( object.tags["craft"]   == "dental_technician"       ) or
       ( object.tags["craft"]   == "engineering"             ) or
       ( object.tags["craft"]   == "gardener"                ) or
       ( object.tags["craft"]   == "handicraft"              ) or
       ( object.tags["craft"]   == "hvac"                    ) or
       ( object.tags["craft"]   == "insulation"              ) or
       ( object.tags["craft"]   == "joiner"                  ) or
       ( object.tags["craft"]   == "metal_construction"      ) or
       ( object.tags["craft"]   == "painter"                 ) or
       ( object.tags["craft"]   == "photographic_laboratory" ) or
       ( object.tags["craft"]   == "plasterer"               ) or
       ( object.tags["craft"]   == "saddler"                 ) or
       ( object.tags["craft"]   == "sailmaker"               ) or
       ( object.tags["craft"]   == "scaffolder"              ) or
       ( object.tags["craft"]   == "tiler"                   ) or
       ( object.tags["craft"]   == "watchmaker"              )) then
      object = append_nonqa( object, "craft" )
      object = append_nonqa( object, object.tags["craft"] )
      object.tags["amenity"] = nil
      object.tags["craft"] = nil
      object.tags["office"] = nil
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Next, office like things mapped as shop, healthcare
-- "0x2e0a" is searchable via "Shopping / Specialty Retail"
-- Add unnamedcommercial landuse to give non-building areas a background.
-- ----------------------------------------------------------------------------
   if (( object.tags["shop"]        == "lawyer"                  ) or
       ( object.tags["shop"]        == "legal"                   ) or
       ( object.tags["shop"]        == "solicitor"               ) or
       ( object.tags["shop"]        == "accountant"              ) or
       ( object.tags["shop"]        == "employment_agency"       ) or
       ( object.tags["shop"]        == "employment"              ) or
       ( object.tags["shop"]        == "jobs"                    ) or
       ( object.tags["shop"]        == "recruitment"             ) or
       ( object.tags["shop"]        == "design"                  ) or
       ( object.tags["shop"]        == "heating"                 )) then
      object = append_nonqa( object, "shop" )
      object = append_nonqa( object, object.tags["shop"] )
      object.tags["amenity"] = nil
      object.tags["craft"] = nil
      object.tags["office"] = nil
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

   if (( object.tags["healthcare"]  == "home_care"  ) or
       ( object.tags["healthcare"]  == "laboratory" )) then
      object = append_nonqa( object, "healthcare" )
      object = append_nonqa( object, object.tags["healthcare"] )
      object.tags["amenity"] = nil
      object.tags["craft"] = nil
      object.tags["office"] = nil
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- man_made=observatory and man_made=telescope
-- This might be either a building or not.
-- ----------------------------------------------------------------------------
   if (( object.tags["man_made"] == "observatory" ) or
       ( object.tags["man_made"] == "telescope"   )) then
      object = append_nonqa( object, object.tags["man_made"] )
      object.tags["amenity"] = nil
      object.tags["craft"] = nil
      object.tags["office"] = nil
      object.tags["shop"] = "specialty"
      object = building_or_landuse( objtype, object )
   end


-- ----------------------------------------------------------------------------
-- Telephone Exchanges
-- ----------------------------------------------------------------------------
   if ((   object.tags["man_made"]   == "telephone_exchange"  )  or
       (   object.tags["amenity"]    == "telephone_exchange"  )  or
       ((  object.tags["building"]   == "telephone_exchange" )   and
        (( object.tags["amenity"]    == nil                 )    and
         ( object.tags["man_made"]   == nil                 )    and
         ( object.tags["office"]     == nil                 ))   or
        (  object.tags["telecom"]    ~= nil                  ))) then
      if ( object.tags["name"] == nil ) then
         object.tags["name"]  = "Telephone Exchange"
      end

      object.tags["amenity"] = nil
      object.tags["man_made"] = nil
      object.tags["office"] = nil
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- If we know that something is a building=office, and it has a name, but is
-- not already known as an amenity, office or shop, add office=nonspecific.
-- ----------------------------------------------------------------------------
   if (( object.tags["building"] == "office" ) and
       ( object.tags["name"]     ~= nil      ) and
       ( object.tags["amenity"]  == nil      ) and
       ( object.tags["office"]   == nil      ) and
       ( object.tags["shop"]     == nil      )) then
      object = append_nonqa( object, "office building" )
      object.tags["man_made"] = nil
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Offices that we don't know the type of.  
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"]    == "office"            ) or
       ( object.tags["commercial"] == "office"            ) or
       ( object.tags["shop"]       == "office"            ) or
       ( object.tags["office"]     == "yes"               )) then
      object.tags["office"] = "office"
   end

   if (( object.tags["office"]     == "company"           ) or
       ( object.tags["office"]     == "research"          ) or
       ( object.tags["office"]     == "office"            )) then
      object = append_nonqa( object, object.tags["office"] )
      object.tags["amenity"] = nil
      object.tags["man_made"] = nil
      object.tags["office"] = nil
      object.tags["shop"] = nil
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- emergency=water_rescue is a poorly-designed key that makes it difficult to
-- tell e.g. lifeboats from lifeboat stations.
-- However, if we've got one of various buildings, it's a lifeboat station.
-- ----------------------------------------------------------------------------
   if (  object.tags["emergency"] == "water_rescue" ) then
      if (( object.tags["building"]  == "boathouse"        ) or
          ( object.tags["building"]  == "commercial"       ) or
          ( object.tags["building"]  == "container"        ) or
          ( object.tags["building"]  == "house"            ) or
          ( object.tags["building"]  == "industrial"       ) or
          ( object.tags["building"]  == "lifeboat_station" ) or
          ( object.tags["building"]  == "no"               ) or
          ( object.tags["building"]  == "office"           ) or
          ( object.tags["building"]  == "public"           ) or
          ( object.tags["building"]  == "retail"           ) or
          ( object.tags["building"]  == "roof"             ) or
          ( object.tags["building"]  == "ruins"            ) or
          ( object.tags["building"]  == "service"          ) or
          ( object.tags["building"]  == "yes"              )) then
         object.tags["emergency"] = "lifeboat_station"
      else
         if (( object.tags["building"]                         == "ship"                ) or
             ( object.tags["seamark:rescue_station:category"]  == "lifeboat_on_mooring" )) then
            object.tags["amenity"]   = "lifeboat"
            object.tags["emergency"] = nil
         else
            object.tags["emergency"] = "lifeboat_station"
         end
      end
   end

-- ----------------------------------------------------------------------------
-- Handling of objects not (yet) tagfiddled to "emergency=water_rescue":
-- Sometimes lifeboats are mapped in the see separately to the 
-- lifeboat station, and sometimes they're tagged _on_ the lifeboat station.
-- If the latter, show the lifeboat station.
-- Also detect lifeboats and coastguards tagged only as seamarks.
-- Lone lifeboats are sent through as "man_made=thing", in "points" as "0x2f14"
-- "0x2f14" is searchable via "Others / Social Service"
--
-- See below for the similar but different tag "emergency=water_rescue_station"
-- which seems to be used on buildings, huts, etc. (not lifeboats).
-- ----------------------------------------------------------------------------
   if (( object.tags["seamark:rescue_station:category"] == "lifeboat_on_mooring" ) and
       ( object.tags["amenity"]                         == nil                   )) then
      object.tags["man_made"] = "thing"
      object = append_nonqa( object, object.tags["seamark:rescue_station:category"] )
      object = building_or_landuse( objtype, object )
   end

   if (( object.tags["seamark:type"] == "coastguard_station" ) and
       ( object.tags["amenity"]      == nil                  )) then
      object = append_nonqa( object, "coastguard station" )
      object = building_or_landuse( objtype, object )
   end

   if ( object.tags["amenity"]   == "lifeboat" ) then
      if ( object.tags["emergency"] == "lifeboat_station" ) then
         object = append_nonqa( object, "lifeboat station" )
      else
         object.tags["man_made"] = "thing"
         object = append_nonqa( object, "lifeboat" )
      end

      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Similarly, various government offices.  
-- "0x3007" is searchable via "Community / Government Office"
-- Add unnamedcommercial landuse to give non-building areas a background.
-- ----------------------------------------------------------------------------
   if ((( object.tags["emergency"] == "ambulance_station" )  or
        ( object.tags["emergency"] == "mountain_rescue"   )  or
        ( object.tags["emergency"] == "rescue_box"        )) and
       ( object.tags["amenity"]   == nil                   )) then
      object.tags["amenity"]   = object.tags["emergency"]
      object.tags["emergency"] = nil
   end

   if ((  object.tags["amenity"]    == "job_centre"              ) or
       (  object.tags["amenity"]    == "jobcentre"               ) or
       (  object.tags["amenity"]    == "public_building"         ) or
       (  object.tags["amenity"]    == "register_office"         ) or
       (  object.tags["amenity"]    == "townhall"                ) or
       (  object.tags["amenity"]    == "village_hall"            ) or
       (  object.tags["amenity"]    == "crematorium"             ) or
       (  object.tags["amenity"]    == "hall"                    ) or
       (  object.tags["amenity"]    == "lifeboat_station"        ) or
       (  object.tags["amenity"]    == "coast_guard"             ) or
       (  object.tags["amenity"]    == "archive"                 ) or
       (  object.tags["amenity"]    == "ambulance_station"       ) or
       (  object.tags["amenity"]    == "mountain_rescue"         ) or
       (  object.tags["amenity"]    == "rescue_box"              )) then
      object = append_nonqa( object, object.tags["amenity"] )
      object.tags["office"] = "government"
      object = building_or_landuse( objtype, object )
   end

   if (  object.tags["building"]   == "village_hall"            ) then
      object = append_nonqa( object, "village hall" )
      object.tags["office"] = "government"
      object = building_or_landuse( objtype, object )
   end

   if ((  object.tags["emergency"]  == "coast_guard"             ) or
       (  object.tags["emergency"]  == "lifeboat_station"        ) or
       (  object.tags["emergency"]  == "lifeguard_tower"         ) or
       (  object.tags["emergency"]  == "water_rescue_station"    ) or
       (  object.tags["emergency"]  == "ses_station"             )) then
      object = append_nonqa( object, object.tags["emergency"] )
      object.tags["office"] = "government"
      object = building_or_landuse( objtype, object )
   end

   if (  object.tags["government"] == "police"                  ) then
      object = append_nonqa( object, object.tags["government"] )
      object.tags["office"] = "government"
      object = building_or_landuse( objtype, object )
   end

   if ((  object.tags["name"]       == "Jobcentre Plus"          ) or
       (  object.tags["name"]       == "JobCentre Plus"          ) or
       (  object.tags["name"]       == "Job Centre Plus"         )) then
      object = append_nonqa( object, "job centre" )
      object.tags["office"] = "government"
      object = building_or_landuse( objtype, object )
   end

   if (( object.tags["emergency"]  == "lifeguard"              )  and
       (( object.tags["lifeguard"] == "base"                  )   or
        ( object.tags["lifeguard"] == "tower"                 ))) then
      object = append_nonqa( object, "lifeguard" )
      object.tags["office"] = "government"
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- Add a suffix for landuse=quarry
-- 0x0c is used in polygons
-- Appears as light grey in QMapShack
-- ----------------------------------------------------------------------------
   if ( object.tags["landuse"] == "quarry" ) then
      object = append_nonqa( object, "quarry" )
   end

-- ----------------------------------------------------------------------------
-- If a quarry is disused, it's still likely a hole in the ground, so render it
-- ----------------------------------------------------------------------------
   if ((( object.tags["disused:landuse"] == "quarry" )  and
        ( object.tags["landuse"]         == nil      )) or
       (( object.tags["historic"]        == "quarry" )  and
        ( object.tags["landuse"]         == nil      )) or
       (( object.tags["landuse"]         == "quarry" )  and
        ( object.tags["disused"]         == "yes"    ))) then
      object.tags["landuse"] = "quarry"
      object = append_nonqa( object, "disused quarry" )
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
      object = append_nonqa( object, "chimney" )
      object.tags["man_made"] = "tower"
      object.tags["tourism"] = nil
   end

   if (( object.tags["man_made"]   == "tower"   )  and
       ( object.tags["tower:type"] == "cooling" )) then
      object = append_nonqa( object, "cooling tower" )
      object.tags["man_made"] = "tower"
      object.tags["tourism"] = nil
   end

   if (( object.tags["man_made"]   == "tower"    ) and
       ( object.tags["tower:type"] == "lighting" )) then
      object = append_nonqa( object, "illumination tower" )
      object.tags["man_made"] = "tower"
      object.tags["tourism"] = nil
   end

   if ((   object.tags["man_made"]           == "tower"       ) and
       ((  object.tags["tower:type"]         == "defensive"  )  or
        (( object.tags["tower:type"]         == nil         )   and
         ( object.tags["tower:construction"] == "stone"     )))) then
      object = append_nonqa( object, "defensive tower" )
      object.tags["man_made"] = "tower"
      object.tags["tourism"] = nil
   end

   if (( object.tags["man_made"]   == "tower"       ) and
       ( object.tags["tower:type"] == "observation" )) then
      object = append_nonqa( object, "observation tower" )
      object.tags["man_made"] = "tower"
      object.tags["tourism"] = nil
   end

-- ----------------------------------------------------------------------------
-- Names for vacant shops
-- ----------------------------------------------------------------------------
   if (((( object.tags["disused:shop"]    ~= nil        )   or
         ( object.tags["disused:amenity"] ~= nil        ))  and
         ( object.tags["disused:amenity"] ~= "fountain"  )  and
         ( object.tags["disused:amenity"] ~= "parking"   )  and
         ( object.tags["shop"]            == nil         )  and
         ( object.tags["amenity"]         == nil         )  and
         ( object.tags["leisure"]         == nil         )) or
       (   object.tags["office"]          == "vacant"     ) or
       (   object.tags["office"]          == "disused"    ) or
       (   object.tags["shop"]            == "disused"    ) or
       (   object.tags["shop"]            == "abandoned"  ) or
       ((  object.tags["shop"]            ~= nil         )  and
        (  object.tags["opening_hours"]   == "closed"    ))) then
      object.tags["shop"] = "vacant"
   end

   if ( object.tags["shop"] == "vacant" ) then
      if (( object.tags["name"]     == nil ) and
          ( object.tags["old_name"] ~= nil )) then
         object.tags["name"]     = object.tags["old_name"]
         object.tags["old_name"] = nil
      end

      if (( object.tags["name"]     == nil ) and
          ( object.tags["former_name"] ~= nil )) then
         object.tags["name"]     = object.tags["former_name"]
         object.tags["former_name"] = nil
      end

      if ( object.tags["name"] == nil ) then
         object.tags["name"] = "(vacant)"
      else
         object.tags["name"] = "(vacant: " .. object.tags["name"] .. ")"
      end

      object.tags["shop"] = nil
      object = building_or_landuse( objtype, object )
   end

-- ----------------------------------------------------------------------------
-- amenity-bench
-- No logic needed here (no need to append suffix)
-- "0x2f10" is searchable as "Others / Personal Service"
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- public transport and animal field shelters
-- amenity=shelter is in points as "0x2f10"
-- "0x2f10" is searchable as "Others / Personal Service"
-- ----------------------------------------------------------------------------
   if (( object.tags["amenity"]      == "shelter"            ) and
       (( object.tags["shelter_type"] == "public_transport" )  or
        ( object.tags["shelter_type"] == "field_shelter"    )  or
        ( object.tags["shelter_type"] == "shopping_cart"    )  or
        ( object.tags["shelter_type"] == "trolley_park"     )  or
        ( object.tags["shelter_type"] == "parking"          )  or
        ( object.tags["shelter_type"] == "animal_shelter"   ))) then
      object = append_nonqa( object, object.tags["shelter_type"] )
      object = building_or_landuse( objtype, object )
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
   if ((( object.tags["sport"]    == "climbing"            )  or
        ( object.tags["sport"]    == "climbing;bouldering" )  or
        ( object.tags["climbing"] == "boulder"             )) and
       (  object.tags["natural"]  ~= "hill"                 ) and
       (  object.tags["natural"]  ~= "peak"                 ) and
       (  object.tags["natural"]  ~= "cliff"                ) and
       (  object.tags["leisure"]  ~= "sports_centre"        ) and
       (  object.tags["leisure"]  ~= "climbing_wall"        ) and
       (  object.tags["shop"]     ~= "sports"               ) and
       (  object.tags["tourism"]  ~= "attraction"           ) and
       (  object.tags["building"] == nil                    ) and
       (  object.tags["man_made"] ~= "tower"                ) and
       (  object.tags["barrier"]  ~= "wall"                 )) then
      object = append_nonqa( object, "climbing" )
      object.tags["man_made"] = "thing"
   end

-- ----------------------------------------------------------------------------
-- man_made=footwear_decontamination
-- ----------------------------------------------------------------------------
   if ( object.tags["man_made"] == "footwear_decontamination" ) then
      object.tags["man_made"] = "thing"
      object = append_nonqa( object, "footwear decontamination" )
   end

-- ----------------------------------------------------------------------------
-- Things that are both viewpoints or attractions and monuments or memorials 
-- should render as the latter.
-- Also handle some other combinations.
-- ----------------------------------------------------------------------------
   if ((( object.tags["tourism"]   == "viewpoint"     )  or
        ( object.tags["tourism"]   == "attraction"    )) and
       (( object.tags["historic"]  == "memorial"      )  or
        ( object.tags["historic"]  == "monument"      )  or
        ( object.tags["natural"]   == "tree"          )  or
        ( object.tags["leisure"]   == "park"          ))) then
      object.tags["tourism"] = nil
   end

   if ((  object.tags["tourism"] == "attraction"  ) and
       (( object.tags["shop"]    ~= nil          )  or
        ( object.tags["amenity"] ~= nil          )  or
        ( object.tags["leisure"] == "park"       ))) then
      object.tags["tourism"] = nil
   end

-- ----------------------------------------------------------------------------
-- We have left tourist attactions until the end, because many other features
-- other can cause the "tourism" tag to be removed.
-- ----------------------------------------------------------------------------
   if ( object.tags["tourism"] == "attraction" ) then
      object = append_nonqa( object, "tourist attraction" )
   end

-- ----------------------------------------------------------------------------
-- Quality Control tagging on all objects
-- Append something to end of name for fixme tags
-- ----------------------------------------------------------------------------
    if (( object.tags["fixme"] ~= nil  ) or
        ( object.tags["FIXME"] ~= nil  )) then
        if ( object.tags["name"] == nil ) then
            object.tags.name = "[fix]"
        else
            object.tags.name = object.tags["name"] .. " [fix]"
        end
    end

    return object
end


-- ----------------------------------------------------------------------------
-- "node" function
-- ----------------------------------------------------------------------------
function ott.process_node( object )
    object = process_all( "n", object )

-- ----------------------------------------------------------------------------
-- Barriers that are different when point are linear are handled here and in 
-- "ott.process_way".  Other barriers are in "process_all".
--
-- barrier=bollard (etc.) that otherwise would not have a suffix
-- In "points" as "0x660f".
-- "0x660f" is searchable in "Geographic Points / Land Features"
-- No icon appears in QMapShack
-- A dot appears on a GPSMAP64s
-- ----------------------------------------------------------------------------
   if (( object.tags["barrier"] == "barrier"    ) or
       ( object.tags["barrier"] == "chain"      ) or
       ( object.tags["barrier"] == "horse_jump" ) or
       ( object.tags["barrier"] == "v_stile"    )) then
      object = append_nonqa( object, object.tags["barrier"] )
      object.tags["barrier"] = "bollard"
   end

-- ----------------------------------------------------------------------------
-- Slipways
-- Linear slipways are handled in "lines" as "default linear thing" 0x1d.
-- Point slipways are mapped to "man_made=thing".
-- ----------------------------------------------------------------------------
   if ( object.tags["leisure"] == "slipway" ) then
      object.tags["man_made"] = "thing"
   end

-- ----------------------------------------------------------------------------
-- Other waterway access points
-- ----------------------------------------------------------------------------
   if (( object.tags["waterway"]   == "access_point"  ) or
       ( object.tags["whitewater"] == "put_in"        ) or
       ( object.tags["whitewater"] == "put_in;egress" ) or
       ( object.tags["canoe"]      == "put_in"        )) then
      object = append_nonqa( object, "canoe put-in" )
      object.tags["man_made"] = "thing"
   end

-- ----------------------------------------------------------------------------
-- Render amenity=information as tourism
-- ----------------------------------------------------------------------------
   if ( object.tags["amenity"] == "information"  ) then
      object.tags["tourism"] = "information"
   end

-- ----------------------------------------------------------------------------
-- Some information boards don't have a "tourism" tag
-- ----------------------------------------------------------------------------
   if (( object.tags["information"]     == "board" ) and
       ( object.tags["disused:tourism"] == nil     ) and
       ( object.tags["ruins:tourism"]   == nil     ) and
       ( object.tags["historic"]        == nil     )) then
      object.tags["tourism"]     = "information"
      object.tags["information"] = "board"
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
   information_appendix = ""

   if ( object.tags["tourism"] == "information" ) then
      if (( object.tags["information"] == "guidepost"                        )   or
          ( object.tags["information"] == "fingerpost"                       )   or
          ( object.tags["information"] == "marker"                           )) then
         information_appendix = "GP"
      end

      if (( object.tags["information"] == "route_marker"                     )  or
          ( object.tags["information"] == "trail_blaze"                      )) then
         information_appendix = "RM"
      end

      if (( object.tags["information"] == "board"                            )  or
          ( object.tags["information"] == "board;map"                        )  or
          ( object.tags["information"] == "citymap"                          )  or
          ( object.tags["information"] == "departure times and destinations" )  or
          ( object.tags["information"] == "electronic_board"                 )  or
          ( object.tags["information"] == "estate_map"                       )  or
          ( object.tags["information"] == "former_telephone_box"             )  or
          ( object.tags["information"] == "hikingmap"                        )  or
          ( object.tags["information"] == "hospital map"                     )  or
          ( object.tags["information"] == "information_board"                )  or
          ( object.tags["information"] == "interpretation"                   )  or
          ( object.tags["information"] == "interpretive_board"               )  or
          ( object.tags["information"] == "leaflet_board"                    )  or
          ( object.tags["information"] == "leaflets"                         )  or
          ( object.tags["information"] == "map"                              )  or
          ( object.tags["information"] == "map and posters"                  )  or
          ( object.tags["information"] == "map;board"                        )  or
          ( object.tags["information"] == "map_board"                        )  or
          ( object.tags["information"] == "nature"                           )  or
          ( object.tags["information"] == "notice_board"                     )  or
          ( object.tags["information"] == "noticeboard"                      )  or
          ( object.tags["information"] == "orientation_map"                  )  or
          ( object.tags["information"] == "sitemap"                          )  or
          ( object.tags["information"] == "tactile_map"                      )  or
          ( object.tags["information"] == "tactile_model"                    )  or
          ( object.tags["information"] == "terminal"                         )  or
          ( object.tags["information"] == "wildlife"                         )) then
         information_appendix = "B"
      end

      if ( object.tags["information"] == "sign" ) then
         information_appendix = "S"
      end

      if ( object.tags["operator"]  == "Peak & Northern Footpaths Society" ) then
         if ( information_appendix == nil ) then
             information_appendix = "PNFS"
         else
             information_appendix = information_appendix .. " PNFS"
         end
      end

      if ( object.tags["operator:type"] == "military" ) then
         if ( information_appendix == nil ) then
             information_appendix = "MIL"
         else
             information_appendix = information_appendix .. " MIL"
         end
      end

      if ( object.tags["guide_type"] == "intermediary" ) then
         if ( information_appendix == nil ) then
             information_appendix = "INT"
         else
             information_appendix = information_appendix .. " INT"
         end
      end

      if ( object.tags["guide_type"] == "destination" ) then
         if ( information_appendix == nil ) then
             information_appendix = "DEST"
         else
             information_appendix = information_appendix .. " DEST"
         end
      end

      if ( object.tags["guidepost_type"] == "PROW" ) then
         if ( information_appendix == nil ) then
             information_appendix = "PROW"
         else
             information_appendix = information_appendix .. " PROW"
         end
      end

      if ( object.tags["guidepost_type"] == "route_marker" ) then
         if ( information_appendix == nil ) then
             information_appendix = "ROUTE"
         else
             information_appendix = information_appendix .. " ROUTE"
         end
      end

      if ( object.tags["guidepost_type"] == "route_marker;PROW" ) then
         if ( information_appendix == nil ) then
             information_appendix = "ROUTE PROW"
         else
             information_appendix = information_appendix .. " ROUTE PROW"
         end
      end
   end

   if ( information_appendix ~= "" ) then
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
-- Point weirs are sent through as springs with a name of "weir"
-- 0x6511 is searchable via "Geographic Points / Water Features"
-- ----------------------------------------------------------------------------
   if ( object.tags["waterway"] == "weir" ) then
      object.tags["natural"] = "spring"
      object.tags["waterway"] = nil
      object = append_nonqa( object, "weir" )
   end

-- ----------------------------------------------------------------------------
-- If lcn_ref exists (for example as a location in a local cycling network),
-- render it via a "man_made" tag if there's no other name tag on that node.
-- ----------------------------------------------------------------------------
   if (( object.tags["lcn_ref"] ~= nil ) and
       ( object.tags["name"]    == nil )) then
      object.tags["man_made"] = "thing"
      object.tags["name"] = object.tags["lcn_ref"]
      object = append_nonqa( object, "lcn_ref" )
   end

   return object.tags
end


-- ----------------------------------------------------------------------------
-- "way" function
-- ----------------------------------------------------------------------------
function ott.process_way( object )
    object = process_all( "w", object )

-- ----------------------------------------------------------------------------
-- From style.lua
--
-- Before processing footways, turn certain corridors into footways
--
-- Note that https://wiki.openstreetmap.org/wiki/Key:indoor defines
-- indoor=corridor as a closed way.  highway=corridor is not documented there
-- but is used for corridors.  We'll only process layer or level 0 (or nil)
-- ----------------------------------------------------------------------------
    if (( object.tags["highway"] == "corridor"  ) and
        (( object.tags["level"]  == nil         )  or
         ( object.tags["level"]  == "0"         )) and
        (( object.tags["layer"]  == nil         )  or
         ( object.tags["layer"]  == "0"         ))) then
       object.tags["highway"] = "path"
   end

-- ----------------------------------------------------------------------------
-- highway=turning_loop on ways to service road
-- "turning_loop" is mostly used on nodes, with one way in UK/IE data.
-- ----------------------------------------------------------------------------
   if ( object.tags["highway"] == "turning_loop" ) then
      object.tags["highway"] = "service"
      object.tags["service"] = "driveway"
   end

-- ----------------------------------------------------------------------------
-- trams and railways
-- 0x14 is used for these in "lines"
-- ----------------------------------------------------------------------------
   if (( object.tags["railway"] == "tram"         ) or
       ( object.tags["railway"] == "subway"       ) or
       ( object.tags["railway"] == "rail"         ) or
       ( object.tags["railway"] == "preserved"    ) or
       ( object.tags["railway"] == "narrow_gauge" ) or
       ( object.tags["railway"] == "light_rail"   )) then
      object = append_nonqa( object, object.tags["railway"] )
   end

-- ----------------------------------------------------------------------------
-- Change miniature railways (not handled in the style file) to narrow_gauge.
-- Also "railway=crane" - render as narrow_gauge railway.
-- After this change a suffix will be added in ott.process_way 
-- ----------------------------------------------------------------------------
   if (( object.tags["railway"] == "miniature" ) or
       ( object.tags["railway"] == "funicular" ) or
       ( object.tags["railway"] == "crane"     )) then
      object = append_nonqa( object, object.tags["railway"] )
      object.tags["railway"] = "narrow_gauge"
   end

-- ----------------------------------------------------------------------------
-- Goods Conveyors - render as narrow_gauge railway.
-- After this change a suffix will be added in ott.process_way
-- ----------------------------------------------------------------------------
   if ( object.tags["man_made"] == "goods_conveyor" ) then
      object = append_nonqa( object, object.tags["man_made"] )
      object.tags["railway"]  = "narrow_gauge"
      object.tags["man_made"] = nil
   end

-- ----------------------------------------------------------------------------
-- map highway=bus_guideway on ways to railway=tram
-- ----------------------------------------------------------------------------
   if ( object.tags["highway"] == "bus_guideway" ) then
      object.tags["railway"] = "tram"
      object.tags["highway"] = nil
      object = append_nonqa( object, object.tags["highway"] )
   end

-- ----------------------------------------------------------------------------
-- Show bus-only service roads tagged as "highway=busway", and escape lanes, 
-- as service roads.
-- ----------------------------------------------------------------------------
   if (( object.tags["highway"] == "busway" ) or
       ( object.tags["highway"] == "escape" )) then
      object.tags["highway"] = "service"
   end

-- ----------------------------------------------------------------------------
-- Different names on each side of the street
-- ----------------------------------------------------------------------------
   if (( object.tags["name:left"]  ~= nil ) and
       ( object.tags["name:right"] ~= nil )) then
      object.tags["name"] = object.tags["name:left"] .. " / " .. object.tags["name:right"]
   end

-- ----------------------------------------------------------------------------
-- Consolidate some rare highway types into track
--
-- The "bywayness" of something should be handled by designation now.  byway
-- isn't otherwise shown (and really should no longer be used), so change 
-- to track (which is what it probably will be).
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
-- Note that "steps" are unchanged by the track / path choice below:
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
-- Treat access=permit as access=no (which is what we have set "private" to 
-- above).
-- ----------------------------------------------------------------------------
   if (( object.tags["access"]  == "permit"       ) or
       ( object.tags["access"]  == "agricultural" ) or
       ( object.tags["access"]  == "forestry"     ) or
       ( object.tags["access"]  == "delivery"     ) or
       ( object.tags["access"]  == "military"     )) then
      object.tags["access"] = "no"
   end

   if ( object.tags["access"]  == "customers" ) then
      object.tags["access"] = "destination"
   end

-- ----------------------------------------------------------------------------
-- The extra information "and"ed with "public_footpath" below checks that
-- "It's access=private and designation=public_footpath, and ordinarily we'd
-- just remove the access=private tag as you ought to be able to walk there,
-- unless there isn't foot=yes/designated to say you can, or there is an 
-- explicit foot=no".
-- ----------------------------------------------------------------------------
   if (((   object.tags["access"]      == "no"                                               )  or
        (   object.tags["access"]      == "destination"                                      )) and
       (((( object.tags["designation"] == "public_footpath"                                )    or
          ( object.tags["designation"] == "core_path"                                      )    or
          ( object.tags["designation"] == "public_footway"                                 )    or
          ( object.tags["designation"] == "public_footpath;permissive_bridleway"           )    or
          ( object.tags["designation"] == "public_footpath;public_cycleway"                )    or
          ( object.tags["designation"] == "PROW"                                           )    or
          ( object.tags["designation"] == "access_land"                                    )    or
          ( object.tags["designation"] == "public_bridleway"                               )    or
          ( object.tags["designation"] == "public_bridleway;public_cycleway"               )    or
          ( object.tags["designation"] == "public_bridleway;public_footpath"               )    or
          ( object.tags["designation"] == "public_cycleway;public_bridleway"               )    or
          ( object.tags["designation"] == "bridleway"                                      )    or
          ( object.tags["designation"] == "restricted_byway"                               )    or
          ( object.tags["designation"] == "public_right_of_way"                            )    or
          ( object.tags["designation"] == "unknown_byway"                                  )    or
          ( object.tags["designation"] == "public_way"                                     )    or
          ( object.tags["designation"] == "orpa"                                           )    or
          ( object.tags["designation"] == "byway_open_to_all_traffic"                      )    or
          ( object.tags["designation"] == "public_byway"                                   )    or
          ( object.tags["designation"] == "byway"                                          )    or
          ( object.tags["designation"] == "carriageway"                                    )    or
          ( object.tags["designation"] == "unclassified_county_road"                       )    or
          ( object.tags["designation"] == "unclassified_country_road"                      )    or
          ( object.tags["designation"] == "unclassified_highway"                           )    or
          ( object.tags["designation"] == "unclassified_road"                              )    or
          ( object.tags["designation"] == "unmade_road"                                    )    or
          ( object.tags["designation"] == "adopted"                                        )    or
          ( object.tags["designation"] == "adopted_highway"                                )    or
          ( object.tags["designation"] == "adopted_highway;public_footpath"                )    or
          ( object.tags["designation"] == "public_highway"                                 )    or
          ( object.tags["designation"] == "unclassified_highway;public_footpath"           )    or
          ( object.tags["designation"] == "unclassified_highway;public_bridleway"          )    or
          ( object.tags["designation"] == "unclassified_highway;restricted_byway"          )    or
          ( object.tags["designation"] == "unclassified_highway;byway_open_to_all_traffic" )    or
          ( object.tags["designation"] == "tertiary_highway"                               )    or
          ( object.tags["designation"] == "tertiary_highway;public_bridleway"              )    or
          ( object.tags["designation"] == "tertiary_highway;restricted_byway"              )    or
          ( object.tags["designation"] == "public_road"                                    ))   and
         (  object.tags["foot"]        ~= nil                                               )   and
         (  object.tags["foot"]        ~= "no"                                              ))  or
        ((( object.tags["highway"]     == "footway"                                        )    or
          ( object.tags["highway"]     == "bridleway"                                      )    or
          ( object.tags["highway"]     == "cycleway"                                       )    or
          ( object.tags["highway"]     == "path"                                           )    or
          ( object.tags["highway"]     == "track"                                          )    or
          ( object.tags["highway"]     == "service"                                        ))   and
         (( object.tags["foot"]        == "permissive"                                     )    or
          ( object.tags["foot"]        == "yes"                                            ))))) then
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
-- Remove name from footway=sidewalk (we expect it to be shown via the
-- road that this is a sidewalk for), or "is_sidepath=yes".
-- ----------------------------------------------------------------------------
   if ((( object.tags["footway"]             == "sidewalk" )  or
        ( object.tags["cycleway"]            == "sidewalk" )  or
	( object.tags["cycleway"]            == "sidepath" )  or
        ( object.tags["is_sidepath"]         == "yes"      )  or
        ( object.tags["is_sidepath:of"]      ~= nil        )  or
        ( object.tags["is_sidepath:of:name"] ~= nil        )  or
        ( object.tags["is_sidepath:of:ref"]  ~= nil        )) and
       (  object.tags["name"]    ~= nil             )) then
      object.tags["name"] = nil
   end

-- ----------------------------------------------------------------------------
-- Display "location=underground" waterways as tunnels.
--
-- There are currently no "location=overground" waterways that are not
-- also "man_made=pipeline".
-- ----------------------------------------------------------------------------
   if ((  object.tags["waterway"] ~= nil            )  and
       (( object.tags["location"] == "underground" )   or
        ( object.tags["covered"]  == "yes"         ))  and
       (  object.tags["tunnel"]   == nil            )) then
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
   designation_appendix = ""

   if (( object.tags["designation"] == "public_footpath"                      ) or
       ( object.tags["designation"] == "footpath"                             ) or
       ( object.tags["designation"] == "public_footpath;permissive_bridleway" ) or
       ( object.tags["designation"] == "public_footpath;public_cycleway"      ) or
       ( object.tags["designation"] == "PROW"                                 ) or
       ( object.tags["designation"] == "public_footway"                       )) then
      designation_appendix = "PF"
   end

   if ( object.tags["designation"] == "access_land"  ) then
      designation_appendix = "AL"
   end

   if ( object.tags["designation"] == "core_path"  ) then
      designation_appendix = "CP"
   end

   if (( object.tags["designation"] == "public_bridleway"                 ) or
       ( object.tags["designation"] == "public_bridleway;public_cycleway" ) or
       ( object.tags["designation"] == "public_bridleway;public_footpath" ) or
       ( object.tags["designation"] == "public_cycleway;public_bridleway" ) or
       ( object.tags["designation"] == "bridleway"                        )) then
      designation_appendix = "PB"
   end

   if (( object.tags["designation"] == "restricted_byway"    ) or
       ( object.tags["designation"] == "unknown_byway"       ) or
       ( object.tags["designation"] == "public_way"          ) or
       ( object.tags["designation"] == "public_right_of_way" )) then
      designation_appendix = "RB"
   end

   if ( object.tags["designation"] == "orpa" ) then
      designation_appendix = "ORPA"
   end

   if (( object.tags["designation"] == "byway_open_to_all_traffic"  ) or
       ( object.tags["designation"] == "public_byway"               ) or
       ( object.tags["designation"] == "byway"                      ) or
       ( object.tags["designation"] == "carriageway"                )) then
      designation_appendix = "BY"
   end

   if (( object.tags["designation"] == "unclassified_country_road"                      ) or
       ( object.tags["designation"] == "unclassified_county_road"                       ) or
       ( object.tags["designation"] == "unclassified_highway"                           ) or
       ( object.tags["designation"] == "unclassified_road"                              ) or
       ( object.tags["designation"] == "unmade_road"                                    ) or
       ( object.tags["designation"] == "public_highway"                                 ) or
       ( object.tags["designation"] == "unclassified_highway;public_fotpath"            ) or
       ( object.tags["designation"] == "unclassified_highway;public_bridleway"          ) or
       ( object.tags["designation"] == "unclassified_highway;byway_open_to_all_traffic" ) or
       ( object.tags["designation"] == "tertiary_highway"                               ) or
       ( object.tags["designation"] == "tertiary_highway;public_bridleway"              ) or
       ( object.tags["designation"] == "tertiary_highway;restricted_byway"              ) or
       ( object.tags["designation"] == "public_road"                                    ) or
       ( object.tags["designation"] == "adopted"                                        ) or
       ( object.tags["designation"] == "adopted_highway"                                ) or
       ( object.tags["designation"] == "adopted_highway;public_footpath"                )) then
      designation_appendix = "UH"
   end

   if (( object.tags["designation"] == "quiet_lane"                      ) or
       ( object.tags["designation"] == "quiet_lane;unclassified_highway" ) or
       ( object.tags["designation"] == "unclassified_highway;quiet_lane" ) or
       ( object.tags["designation"] == "restricted_byway;quiet_lane"     )) then
      if ( designation_appendix == "" ) then
         designation_appendix = "QL"
      else
         object.tags.name = designation_appendix .. " QL"
      end
   end

   if ( designation_appendix ~= "" ) then
      object = append_nonqa( object, designation_appendix )

      if ( object.tags["prow_ref"] ~= nil ) then
         object = append_nonqa( object, object.tags["prow_ref"] )
      end
   end

-- ----------------------------------------------------------------------------
-- End Designation tagging on ways
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- "ladder", "trail_visibility", "informal" and "dog" for footway-service
-- ----------------------------------------------------------------------------
   if (( object.tags["highway"]  == "footway"   ) or
       ( object.tags["highway"]  == "path"      ) or
       ( object.tags["highway"]  == "steps"     ) or
       ( object.tags["highway"]  == "bridleway" ) or
       ( object.tags["highway"]  == "cycleway"  ) or
       ( object.tags["highway"]  == "track"     ) or
       ( object.tags["highway"]  == "service"   )) then
      if ( object.tags["laddder"] == "yes" ) then
         object = append_nonqa( object, "ladder" )
      end

      if (( object.tags["trail_visibility"] == "intermediate" ) or
          ( object.tags["trail_visibility"] == "intermittent" )) then
         object = append_nonqa( object, "TVI" )
      end

      if (( object.tags["trail_visibility"] == "bad"          ) or
          ( object.tags["trail_visibility"] == "poor"         )) then
         object = append_nonqa( object, "TVB" )
      end

      if (( object.tags["trail_visibility"] == "very_bad"     ) or
          ( object.tags["trail_visibility"] == "horrible"     )) then
         object = append_nonqa( object, "TVH" )
      end

      if (( object.tags["trail_visibility"] == "no"           ) or
          ( object.tags["trail_visibility"] == "none"         ) or
          ( object.tags["foot:physical"]    == "no"           )) then
         object = append_nonqa( object, "TVN" )
      end

      if (  object.tags["informal"] == "yes" ) then
         object = append_nonqa( object, "I" )
      end

      if ((  object.tags["flood_prone"]  == "yes"    ) or
          (( object.tags["hazard_prone"] == "yes"   )  and
           ( object.tags["hazard_type"]  == "flood" ))) then
         object = append_nonqa( object, "flood" )
      end

      if ( object.tags["dog"]  == "no" ) then
         object = append_nonqa( object, "nodog" )
      end

      if ( object.tags["dog"]  == "leashed" ) then
         object = append_nonqa( object, "doglead" )
      end
   end

-- ----------------------------------------------------------------------------
-- Make it clear which ways are steps
-- ----------------------------------------------------------------------------
   if ( object.tags["highway"] == "steps" ) then
      object = append_nonqa( object, "steps" )
   end

-- ----------------------------------------------------------------------------
-- Fences and hedges.  For walls see below.
-- These are handled in "lines" as "default linear thing" 0x1d.
-- ----------------------------------------------------------------------------
   if ( object.tags["natural"] == "hedge" ) then
      object.tags["barrier"] = object.tags["natural"]
      object.tags["natural"] = nil
   end

   if (( object.tags["barrier"] == "fence" ) or
       ( object.tags["barrier"] == "hedge" )) then
      object = append_nonqa( object, object.tags["barrier"] )
   end

-- ----------------------------------------------------------------------------
-- Some other things we map through to fence, with a different suffix
-- Note that "kerb" and "obstruction" aren't handled separately as points,
-- so "kerb" or "obstruction" nodes won't appear.
-- ----------------------------------------------------------------------------
   if (( object.tags["barrier"] == "guard_rail"      ) or
       ( object.tags["barrier"] == "hand_rail_fence" ) or
       ( object.tags["barrier"] == "kerb"            ) or
       ( object.tags["barrier"] == "obstruction"     ) or
       ( object.tags["barrier"] == "railing"         ) or
       ( object.tags["barrier"] == "traffic_island"  ) or
       ( object.tags["barrier"] == "wire_fence"      ) or
       ( object.tags["barrier"] == "wood_fence"      )) then
      object = append_nonqa( object, object.tags["barrier"] )
      object.tags["barrier"]  = "fence"
   end

-- ----------------------------------------------------------------------------
-- A gate (unlocked or locked) should have had "gate" appended.
-- If locked, "locked" should also have been appended.
-- All that remains is to set "barrier" to "fence" so that the entry in "lines"
-- will cause it to appear on the map.
-- ----------------------------------------------------------------------------
   if (( object.tags["barrier"] == "gate"        ) or
       ( object.tags["barrier"] == "gate_locked" ) or
       ( object.tags["barrier"] == "lift_gate"   )) then
      object.tags["barrier"]  = "fence"
   end

   if (( object.tags["man_made"]   == "breakwater" ) or
       ( object.tags["man_made"]   == "groyne"     )) then
      object = append_nonqa( object, object.tags["man_made"] )
      object.tags["barrier"]  = "fence"
      object.tags["man_made"] = nil
   end

-- ----------------------------------------------------------------------------
-- Show castle_wall and citywalls as walls with a "city wall" suffix,
-- and regular walls with "wall".
-- Also show tree rows.
-- These are handled in "lines" as "default linear thing" 0x1d.
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

   if ( object.tags["natural"] == "tree_row" ) then
      object = append_nonqa( object, "tree row" )
   end

-- ----------------------------------------------------------------------------
-- Show flood walls and hahas etc. as walls
-- ----------------------------------------------------------------------------
   if (( object.tags["barrier"] == "flood_wall"     ) or
       ( object.tags["barrier"] == "haha"           ) or
       ( object.tags["barrier"] == "jersey_barrier" ) or
       ( object.tags["barrier"] == "retaining_wall" ) or
       ( object.tags["barrier"] == "sea_wall"       )) then
      object = append_nonqa( object, object.tags["barrier"] )
      object.tags["barrier"] = "wall"
   end

-- ----------------------------------------------------------------------------
-- Linear weirs are sent through as "county lines" with a name of "weir"
-- Likewise floating barriers.
-- ----------------------------------------------------------------------------
   if ( object.tags["waterway"] == "weir" ) then
      object.tags["barrier"] = "wall"
      object.tags["waterway"] = nil
      object = append_nonqa( object, "weir" )
   end

   if ( object.tags["waterway"] == "floating_barrier" ) then
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
-- Handle "waterway=mill_pond" as water.
-- ----------------------------------------------------------------------------
   if ( object.tags["waterway"] == "mill_pond" ) then
      object.tags["natural"] = "water"
      object.tags["waterway"] = nil
      object = append_nonqa( object, "mill pond" )
   end

-- ----------------------------------------------------------------------------
-- Pipelines
-- These are handled in "lines".
-- If we know the operator or substance, append those to the name.
-- If still no name, assign "(pipeline)".
-- ----------------------------------------------------------------------------
   if ( object.tags["man_made"] == "pipeline" ) then

      if ( object.tags["operator"] ~= nil ) then
         object = append_nonqa( object, object.tags["operator"] )
      end

      if ( object.tags["substance"] ~= nil ) then
         object = append_nonqa( object, object.tags["substance"] )
      end

      if ( object.tags["name"] == nil ) then
         object.tags.name = "(pipeline)"
      end
   end

-- ----------------------------------------------------------------------------
-- Barriers that are different when point are linear are handled here and in 
-- "ott.process_node".  Other barriers are in "process_all".
--
-- Linear horse_jumps are sent through as "fence" with a suffix
-- Also linear "barrier=barrier"
-- ----------------------------------------------------------------------------
   if (
       ( object.tags["barrier"] == "barrier"    ) or
       ( object.tags["barrier"] == "chain"      ) or
       ( object.tags["barrier"] == "horse_jump" ) or
       ( object.tags["barrier"] == "v_stile"    )) then
      object = append_nonqa( object, object.tags["barrier"] )
      object.tags["barrier"] = "fence"
   end

-- ----------------------------------------------------------------------------
-- Covered highways
-- Raster maps special-case some values and amend rendering based on that, but
-- here we just append and non-nil value.
-- ----------------------------------------------------------------------------
   if (( object.tags["highway"] ~= nil  ) and
       ( object.tags["covered"] ~= nil  ) and
       ( object.tags["covered"] ~= "no" )) then
      object = append_nonqa( object, "covered: " .. object.tags["covered"] )
   end

-- ----------------------------------------------------------------------------
-- Quality Control tagging on ways
--
-- Append M to roads if no speed limit defined
-- Append L if not known if lit
-- Append S if not known if sidewalk
-- Append V no sidewalk, but not known if verge
-- ----------------------------------------------------------------------------
   street_appendix = ""

   if (( object.tags["highway"] == "unclassified"  ) or
       ( object.tags["highway"] == "living_street" ) or
       ( object.tags["highway"] == "residential"   ) or
       ( object.tags["highway"] == "tertiary"      ) or
       ( object.tags["highway"] == "secondary"     ) or
       ( object.tags["highway"] == "primary"       ) or
       ( object.tags["highway"] == "trunk"         )) then
      if ( object.tags["maxspeed"] == nil ) then
          street_appendix = "M"
      end
   end

   if (( object.tags["highway"] == "unclassified"  ) or
       ( object.tags["highway"] == "living_street" ) or
       ( object.tags["highway"] == "residential"   ) or
       ( object.tags["highway"] == "service"       ) or
       ( object.tags["highway"] == "tertiary"      ) or
       ( object.tags["highway"] == "secondary"     ) or
       ( object.tags["highway"] == "primary"       ) or
       ( object.tags["highway"] == "trunk"         )) then
      if ( object.tags["lit"] == nil ) then
         if ( street_appendix == nil ) then
            street_appendix = "L"
         else
            street_appendix = street_appendix .. "L"
         end
      end

-- ----------------------------------------------------------------------------
-- The test here is e.g. "is sidewalk or verge set to anything, including 
-- yes or none".
-- We don't look at individual values because we're looking to add an 
-- "S" or "V" to those roads that don't have sidewalk or verge information 
-- already.
-- ----------------------------------------------------------------------------
      if (( object.tags["sidewalk"]          == nil ) and
          ( object.tags["sidewalk:left"]     == nil ) and 
          ( object.tags["sidewalk:right"]    == nil ) and 
          ( object.tags["sidewalk:both"]     == nil ) and
          ( object.tags["sidewalk:separate"] == nil )) then
         if (( object.tags["verge"]          == nil ) and
             ( object.tags["verge:left"]     == nil ) and
             ( object.tags["verge:right"]    == nil ) and
             ( object.tags["verge:both"]     == nil )) then
            if ( street_appendix == nil ) then
               street_appendix = "S"
            else
               street_appendix = street_appendix .. "S"
            end
         end
      else
         if (( object.tags["sidewalk"] == "no"   ) or
             ( object.tags["sidewalk"] == "none" )) then
            if (( object.tags["verge"]          == nil ) and
                ( object.tags["verge:left"]     == nil ) and
                ( object.tags["verge:right"]    == nil ) and
                ( object.tags["verge:both"]     == nil )) then
               if ( street_appendix == nil ) then
                  street_appendix = "V"
               else
                  street_appendix = street_appendix .. "V"
               end
            end
         end
      end
   end -- if (( object.tags["highway"] == "unclassified"  ) or

    if ( street_appendix ~= "" ) then
        if ( object.tags["name"] == nil ) then
            object.tags.name = "[" .. street_appendix .. "]"
        else
            object.tags.name = object.tags["name"] .. " [" .. street_appendix .. "]"
        end
    end

-- ----------------------------------------------------------------------------
-- Append (RD) to roads tagged as highway=road
-- ----------------------------------------------------------------------------
    if ( object.tags["highway"] == "road"  ) then
        if ( object.tags["name"] == nil ) then
            object.tags.name = "[RD]"
        else
            object.tags.name = object.tags["name"] .. " [RD]"
        end
    end


-- ----------------------------------------------------------------------------
-- QA for footway-bridleway
-- ----------------------------------------------------------------------------
    if (( object.tags["highway"] == "footway"   ) or
        ( object.tags["highway"] == "path"      ) or
        ( object.tags["highway"] == "bridleway" )) then
-- ----------------------------------------------------------------------------
-- Append (A) if an expected foot tag is missing 
-- on things that aren't obviously sidewalks
-- ----------------------------------------------------------------------------
        if (( object.tags["foot"]     == nil        ) and
            ( object.tags["footway"]  ~= "sidewalk" ) and
            ( object.tags["cycleway"] ~= "sidewalk" ) and
            ( object.tags["path"]     ~= "sidewalk" ) and
            ( object.tags["informal"] ~= "yes"      )) then
            if ( object.tags["name"] == nil ) then
                object.tags.name = "[A]"
            else
                object.tags.name = object.tags["name"] .. " [A]"
            end
        end

-- ----------------------------------------------------------------------------
-- Append U to roads if no surface defined
-- Append O if no smoothness (on non-long fords)
-- ----------------------------------------------------------------------------
        track_appendix = ""

        if ( object.tags["surface"] == nil ) then
            track_appendix = "U"
        end

        if (( object.tags["smoothness"] == nil ) and
            ( object.tags["ford"]       == nil )) then
            if ( track_appendix == nil ) then
                track_appendix = "O"
            else
                track_appendix = track_appendix .. "O"
            end
        end

        if ( track_appendix ~= "" ) then
            if ( object.tags["name"] == nil ) then
                object.tags.name = "[" .. track_appendix .. "]"
            else
                object.tags.name = object.tags["name"] .. " [" .. track_appendix .. "]"
            end
        end
    end
-- ----------------------------------------------------------------------------
-- End QA for footway-bridleway
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- QA for track
-- ----------------------------------------------------------------------------
    if ( object.tags["highway"] == "track" ) then
-- ----------------------------------------------------------------------------
-- Append (A) if an expected foot tag is missing
-- ----------------------------------------------------------------------------
        if (( object.tags["foot"]     == nil   ) and
            ( object.tags["informal"] ~= "yes" )) then
            if ( object.tags["name"] == nil ) then
                object.tags.name = "[A]"
            else
                object.tags.name = object.tags["name"] .. " [A]"
            end
        end

-- ----------------------------------------------------------------------------
-- Append U to roads if no surface defined
-- Append G if no tracktype
-- Append O if no smoothness (on non-long fords)
-- ----------------------------------------------------------------------------
        track_appendix = ""

        if ( object.tags["surface"] == nil ) then
            track_appendix = "U"
        end

        if ( object.tags["tracktype"] == nil ) then
            if ( track_appendix == nil ) then
                track_appendix = "G"
            else
                track_appendix = track_appendix .. "G"
            end
        end

        if (( object.tags["smoothness"] == nil ) and
            ( object.tags["ford"]       == nil )) then
            if ( track_appendix == nil ) then
                track_appendix = "O"
            else
                track_appendix = track_appendix .. "O"
            end
        end

        if ( track_appendix ~= "" ) then
            if ( object.tags["name"] == nil ) then
                object.tags.name = "[" .. track_appendix .. "]"
            else
                object.tags.name = object.tags["name"] .. " [" .. track_appendix .. "]"
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
function ott.process_relation( object )
   object = process_all( "r", object )

   if ( object.tags["type"] == "route" ) then
      if (( object.tags["network"] == "iwn" ) and
          ( object.tags["ref"]     ~= nil   )) then
         object.tags["name"] = object.tags["ref"]
      end

      if ((( object.tags["network"] == "iwn"          )  or
           ( object.tags["network"] == "nwn"          )  or
           ( object.tags["network"] == "rwn"          )  or
           ( object.tags["network"] == "lwn"          )  or
           ( object.tags["network"] == "lwn;lcn"      )  or
           ( object.tags["network"] == "lwn;lcn;lhn"  )) and
          (  object.tags["name"]    == nil             ) and
          (  object.tags["colour"]  ~= nil             )) then
         object.tags["name"] = object.tags["colour"]
      end
   end

   return object.tags
end


-- ----------------------------------------------------------------------------
-- "append eco information if relevant" function
-- ----------------------------------------------------------------------------
function append_eco( object )
      if (( object.tags["zero_waste"]         == "yes"                )  or
          ( object.tags["zero_waste"]         == "only"               )  or
          ( object.tags["bulk_purchase"]      == "yes"                )  or
          ( object.tags["bulk_purchase"]      == "only"               )  or
          ( object.tags["reusable_packaging"] == "yes"                )) then
         object = append_nonqa( object, "zero waste" )
      end

    return object
end

-- ----------------------------------------------------------------------------
-- "append accommodation if relevant" function
-- ----------------------------------------------------------------------------
function append_accomm( object )
      if (( object.tags["accommodation"] ~= nil  ) and
          ( object.tags["accommodation"] ~= "no" )) then
         object = append_nonqa( object, "accomm" )
      end

    return object
end

-- ----------------------------------------------------------------------------
-- "append non QA information" function
-- ----------------------------------------------------------------------------
function append_nonqa( object, appendage )
    if ( object.tags["name"] == nil ) then
      object.tags.name = "(" .. appendage .. ")"
    else
      object.tags.name = object.tags["name"] .. " (" .. appendage .. ")"
    end

    return object
end


-- ----------------------------------------------------------------------------
-- "append QA information" function
-- ----------------------------------------------------------------------------
function append_qa( object, appendage )
    if ( object.tags["name"] == nil ) then
      object.tags.name = "[" .. appendage .. "]"
    else
      object.tags.name = object.tags["name"] .. " [" .. appendage .. "]"
    end

    return object
end


-- ----------------------------------------------------------------------------
-- "building or landuse" function
--
-- nodes with no other appropriate tags are mapped to "man_made=thing".
-- For those, "0x2f14" is searchable as "Others / Social Service"
--
-- Many tags (for example, man_made=observatory) may be applied either to a 
-- building or a wider landuse area.  A building or landuse tag is applied:
--
-- Ways with a building tag will not be searchable, even on "All POIs" but
-- will appear as buildings.
-- Ways without a building tag will not be searchable, even on "All POIs" but
-- will appear as landuse.
-- ----------------------------------------------------------------------------
function building_or_landuse( objtype, object )
   if ( objtype == "n" ) then
      if (( object.tags["aeroway"]   == nil  ) and
          ( object.tags["amenity"]   == nil  ) and
          ( object.tags["barrier"]   == nil  ) and
          ( object.tags["craft"]     == nil  ) and
          ( object.tags["emergency"] == nil  ) and
          ( object.tags["highway"]   == nil  ) and
          ( object.tags["historic"]  == nil  ) and
          ( object.tags["landuse"]   == nil  ) and
          ( object.tags["leisure"]   == nil  ) and
          ( object.tags["man_made"]  == nil  ) and
          ( object.tags["natural"]   == nil  ) and
          ( object.tags["office"]    == nil  ) and
          ( object.tags["place"]     == nil  ) and
          ( object.tags["railway"]   == nil  ) and
          ( object.tags["shop"]      == nil  ) and
          ( object.tags["sport"]     == nil  ) and
          ( object.tags["tourism"]   == nil  ) and
          ( object.tags["waterway"]  == nil  )) then
         object.tags["man_made"] = "thing"
      end
   else
      if (( object.tags["building"] == nil  ) or
          ( object.tags["building"] == "no" )) then
         if ( object.tags["landuse"] == nil ) then
            object.tags["landuse"] = "industrial"
         end
      else
         object.tags["building"] = "yes"
      end
   end

   return object
end
