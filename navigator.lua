module("navigator", package.seeall)
require "util"
require "battle"
require "mem"
require "map"


function walk(direction)
    util.button(direction, 0, 4)
    util.skipframes(6)
    print(find_events()) --DON'T DO THIS IF BATTLE STARTED OR IF SOMETHING INTERRUPTED? THIS ONLY WORKS IF NO MENUS COVER THE SCREEN!!
    map.update_map()
    util.skipframes(6)
end

function find_events()--is there something happening other than walking around?
      if mem.battling() then
        return 'battle'
      elseif mem.menu_open() then
        return 'menu'
      else
        return 'overworld'
      end
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

