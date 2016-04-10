module("ai", package.seeall)
require "map"

function return_path()
	return find_path_out(map.get_map(), map.get_current_coords())
end

function find_path_out(map, startx, starty) --finds a path to something new. returns false if not possible
	was_here = {}
	correct_path = {}
	map_to_check = {} 
	for key,value in pairs(map) do
		was_here[key] = {}
		correct_path[key] = {}
		map_to_check[key] = {}
		for subkey,subvalue in pairs(value) do
			was_here[key][subkey] = false
			correct_path[key][subkey] = false
			map_to_check[key][subkey] = map[key][subkey] --copies input map
		end
	end
	if not recursive_solve(startx, starty) then return false
	else return correct_path end
end

function recursive_solve(x, y) --i copied this from https://en.wikipedia.org/wiki/Maze_solving_algorithm
	if map_to_check[y][x] == 'X' or map_to_check[y][x] == 'WARP' then return true end
	if map_to_check[y][x] == 'NWLK' or 
	   map_to_check[y][x] == 'WATR' or 
	   map_to_check[y][x] == 'LEDG' or
	   map_to_check[y][x] == 'TREE' or was_here[y][x] then return false end --here is where nuance gets added
	was_here[y][x] = true
	if recursive_solve(x-1, y) then
		correct_path[y][x] = 'left';
		return true
	end
	if recursive_solve(x+1, y) then
		correct_path[y][x] = 'right';
		return true
	end
	if recursive_solve(x, y-1) then
		correct_path[y][x] = 'up';
		return true
	end
	if recursive_solve(x, y+1) then
		correct_path[y][x] = 'down';
		return true
	end
	return false
end