require "util"
require "battle"
require "navigator"
require "map"
require "ai"

function main()
	map.initialize_world()
  print(map.generate_tile_table())
	while not mem.have_brock_badge() do
		navigate_around()
	end
end

function navigate_around()
	x,y = map.get_current_coords_pathfinding()
	while 1 do 
    follow_this_path = ai.breadth_first_search(map.get_map_pathfinding(), {x, y}, 'X')
		print(x .. y)
		print(follow_this_path)
    if ai.has_solution() then
  		follow_path(follow_this_path)
    else
      print('searching for warp')
      follow_this_path = ai.breadth_first_search(map.get_map_pathfinding(), {x, y}, 'WARP')
      follow_path(follow_this_path)
    end
	end
end

function follow_path(path)
 	while 1 do
		x,y = map.get_current_coords_pathfinding()
		map_temp = map.get_map_number()
		old_map_locations = map.get_map_pathfinding()
		stringified_coords = tostring(x) .. ' ' .. tostring(y)
  		if follow_this_path[stringified_coords] ~= nil then
			navigator.walk(follow_this_path[stringified_coords])
   		end
		xtemp,ytemp = map.get_current_coords_pathfinding()
		if xtemp == x and ytemp == y then break --we arent moving
		end
	end
	vba.frameadvance()
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
