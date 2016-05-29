--module("ai", package.seeall)
--require "map"

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

test_map = {
		{'WALK', 'WALK', 'WALK'},
		{'WALK', 'NWLK', 'WALK'},
		{'WALK', 'NWLK', 'WALK'},
	}

function breadth_first_search(map, start, goal) -- from http://www.redblobgames.com/pathfinding/a-star/introduction.html
	frontier = List.new()
	List.push(frontier, start)
	came_from = {}
	came_from[start] = nil
	while not List.empty(frontier) do
		current = List.pop(frontier)
		neighbors = get_neighbors(map, current)
		for _,next_space in pairs(neighbors) do
			if not table.contains_pair(came_from,next_space) then
				List.push(frontier, next_space)
				came_from[next_space] = current
			end
		end
		
	end
	
	current[1] = goal[1]
	current[2] = goal[2]
	path = {current}
	while current[1] ~= start[1] or current[2] ~= start[2] do
		current = came_from[current]
		table.insert(path, current)
	end
	for _,element in pairs(path) do
		print(element[1] .. ' ' .. element[2])
	end
	convert_path(path)	
end

function convert_path(path)
	--reverse it
end

function table.contains_pair(table, element)
	for _,value in pairs(table) do
		if value[1] == element[1] and value[2] == element[2] then
			return true
		end
	end
	return false
end

function table.contains(table, element)
	for _,value in pairs(table) do
		if value == element then
			return true
		end
	end
	return false
end

function get_neighbors(map, node)
	print('getting neighbors')
	neighbor_table = {}
	local unwalkables = {'NWLK'}
	potential_neighbors = {right_of(map, node), left_of(node), above(node), below(map, node)}
	for _,potential_neighbor in pairs(potential_neighbors) do
		if potential_neighbor then
			if not table.contains(unwalkables, map[getY(potential_neighbor)][getX(potential_neighbor)]) then
				table.insert(neighbor_table, potential_neighbor)
			end
		end
	end

	for _,element in pairs(neighbor_table) do
		print(element[1] .. element[2])
	end
	return neighbor_table
end

function right_of(map, node)
	if getX(node) + 1 > #map[1] then return false end 
	return {getX(node) + 1, getY(node)}
end

function left_of(node)
	if getX(node) - 1 < 1 then return false end
	return {getX(node) - 1, getY(node)}
end

function above(node)
	if getY(node) - 1 < 1 then return false end
	return {getX(node), getY(node) - 1}
end

function below(map, node)
	if getY(node) + 1 > #map then return false end
	return {getX(node), getY(node) + 1}
end

function getX(node)
	return node[1]
end

function getY(node)
	return node[2]
end

List = {}
function List.new ()
	  return {first = 0, last = -1}
end

function List.push(list, value)
	local last = list.last + 1
	list.last = last
	list[last] = value
end

function List.pop(list)
	local last = list.last
	if list.first > last then error("list is empty") end
	local value = list[last]
	list[last] = nil
	list.last = last - 1
	return value
end

function List.empty(list)
	if list.first > list.last then return true
	else return false
	end
end

breadth_first_search(test_map, {1,2}, {3,2}) 
