--
-- Apply "name" transformations to ways for "map style 03"
--

function process_all(object)
    return object.tags
end

function ott.process_node(object)
    return process_all(object)
end

function ott.process_way(object)
    if (( object.tags['highway'] == 'unclassified'  ) or
        ( object.tags['highway'] == 'living_street' ) or
        ( object.tags['highway'] == 'residential'   ) or
        ( object.tags['highway'] == 'tertiary'      ) or
        ( object.tags['highway'] == 'secondary'     ) or
        ( object.tags['highway'] == 'primary'       ) or
        ( object.tags['highway'] == 'trunk'         )) then

        if ( object.tags['lit'] == nil ) then
            if ( object.tags['name'] == nil ) then
                object.tags.name = ' (L)'
            else
                object.tags.name = object.tags['name'] .. ' (L)'
            end
        end
    end

    return process_all(object)
end

function ott.process_relation(object)
    return process_all(object)
end
