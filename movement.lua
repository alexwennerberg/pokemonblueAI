module("movement", package.seeall)
require "util"
require "battle"
require "mem"
require "map"


function walk(direction)
    temp = map.generate_tile_table()
    util.button(direction, 0, 4)
    util.skipframes(6)
    map.update_map(temp)
    util.skipframes(6)
end

function interact_object()
    while(mem.value("movement_disabled") == 0) do
      util.button("A")
    end
    while(mem.value("movement_disabled") == 1) do
      util.button("A")
      util.skipframes(100)
    end
end

