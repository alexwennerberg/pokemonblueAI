require "util"
require "battle"
require "navigator"
require "map"
require "ai"

function main()
  --print(map.get_current_tile())
  navigate_around()
end

function navigate_around()
    map.initialize_world()
	x,y=map.get_current_coords()
    follow_this_path = ai.breadth_first_search(map.get_map(), {x, y}, {9,14})
    print(follow_this_path)
    stringified_coords = tostring(x) .. ' ' .. tostring(y)
    while 1 do
  	if follow_this_path[stringified_coords] ~= nil then
		    navigator.walk(follow_this_path[stringified_coords])
   	end
	x,y = map.get_current_coords()
	stringified_coords = tostring(x) .. ' ' .. tostring(y)

    end
end

function test_battle()
  battle.complete_battle()
end

function dumb_walker()
  map.initialize_world() 
  navigator.walk("up")
  navigator.walk("up")
  navigator.walk("up")
  navigator.walk("up")
  navigator.walk("up")
  navigator.walk("up")
  navigator.walk("up")
  navigator.walk("down")
  navigator.walk("down")
  navigator.walk("down")
  navigator.walk("down")
  navigator.walk("down")
  navigator.walk("down")
  navigator.walk("down")
  navigator.walk("up")
  navigator.walk("up")
  navigator.walk("up")
  navigator.walk("up")
  navigator.walk("up")
  navigator.walk("up")
  navigator.walk("up")
end

function test()
  dumb_walker()
end

main()
