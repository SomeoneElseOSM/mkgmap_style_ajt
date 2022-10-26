-- ----------------------------------------------------------------------------
-- Apply "name" transformations to ways for "map style 03"
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- "all" function
-- ----------------------------------------------------------------------------
function process_all(object)
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
-- Append O if no smoothness
-- ----------------------------------------------------------------------------
        track_appendix = ''

        if ( object.tags['surface'] == nil ) then
            track_appendix = 'U'
        end

        if ( object.tags['smoothness'] == nil ) then
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
-- Append O if no smoothness
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

        if ( object.tags['smoothness'] == nil ) then
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
