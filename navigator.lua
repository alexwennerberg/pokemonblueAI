module("navigator", package.seeall)
require "util"
require "battle"
require "mem"
require "map"


function walk(direction)
    util.button(direction, 0, 4)
    util.skipframes(14)
    if mem.battling() then
      if battle.complete_battle() == 'fainted'
        then map.just_fainted()
      end
    elseif mem.menu_open() then
      interact_object()
    end 
    map.update_map()
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
  while mem.menu_open() do
      util.button("A")
      util.skipframes(100)
  end
end

