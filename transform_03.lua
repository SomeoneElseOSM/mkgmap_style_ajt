--
-- Apply "name" transformations to ways for "map style 03"
--

--
-- "all" function
--
function process_all(object)
--
-- Quality Control tagging on all objects
-- Append something to end of name for fixme tags
--
    if (( object.tags['fixme'] ~= nil  ) or
        ( object.tags['FIXME'] ~= nil  )) then
        if ( object.tags['name'] == nil ) then
            object.tags.name = '(fix)'
        else
            object.tags.name = object.tags['name'] .. ' (fix)'
        end
    end

    return object
end

--
-- "node" function
--
function ott.process_node(object)
    object = process_all(object)
    return object.tags
end

--
-- "way" function
--
function ott.process_way(object)
    object = process_all(object)
--
-- Designation tagging on ways
--
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

--
-- Quality Control tagging on ways
--
-- Append M to roads if no speed limit defined
-- Append L if not known if lit
-- Append S if not known if sidewalk
-- Append V if known if sidewalk but known if verge
--
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
            object.tags.name = '(' .. street_appendix .. ')'
        else
            object.tags.name = object.tags['name'] .. ' (' .. street_appendix .. ')'
        end
    end

--
-- Append (RD) to roads tagged as highway=road
--
    if ( object.tags['highway'] == 'road'  ) then
        if ( object.tags['name'] == nil ) then
            object.tags.name = '(RD)'
        else
            object.tags.name = object.tags['name'] .. ' (RD)'
        end
    end


--
-- Append (A) if an expected foot tag is missing
--
    if (( object.tags['highway'] == 'footway'   ) or
        ( object.tags['highway'] == 'path'      ) or
        ( object.tags['highway'] == 'bridleway' ) or
        ( object.tags['highway'] == 'track'     )) then
        if ( object.tags['foot'] == nil ) then
            if ( object.tags['name'] == nil ) then
                object.tags.name = '(A)'
            else
                object.tags.name = object.tags['name'] .. ' (A)'
            end
        end
    end

    return object.tags
end

--
-- "relation" function
--
function ott.process_relation(object)
    object = process_all(object)
    return object.tags
end
