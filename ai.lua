module("ai", package.seeall)

require "map"

found_solution = false

function has_solution()
	return found_solution
end

function pair_compare(a, b)
	if a[1] == b[1] and a[2] == b[2] then return true end
	return false
end

function breadth_first_search(in_map, start, goal) -- from http://www.redblobgames.com/pathfinding/a-star/introduction.html
	frontier = List.new()
	List.push(frontier, start)
	came_from = {}
	came_from[start] = nil
	found_solution = false
	while not List.empty(frontier) do
		current = List.pop(frontier)
		if not pair_compare(current, start) then
			if in_map[getY(current)][getX(current)] == 'X'
			or unvisited_warp(current, in_map) then 
				found_solution = true
				print("found a solution!") 
				break 
			end
		end
		neighbors = get_neighbors(in_map, current)
		for _,next_space in pairs(neighbors) do
			if came_from[util.coordinate_to_string(next_space)] == nil then
				List.push(frontier, next_space)
				came_from[util.coordinate_to_string(next_space)] = current
			end
		end
		
	end
	path = {current}
	print('getting path...')
	while current[1] ~= start[1] or current[2] ~= start[2] do
		current = came_from[util.coordinate_to_string(current)]
		table.insert(path, current)
	end
	print('printing path...')
	for _,element in pairs(path) do
		print(element[1] .. ' ' .. element[2])
	end
	return convert_path(path)	
end

function unvisited_warp(coordinate, in_map)
	if in_map[getY(coordinate)][getX(coordinate)] == "WARP" then
		warp_table = map.get_warp_data()
		map_number = map.get_map_number()
		if warp_table[map_number .. ' ' .. tostring(coordinate[2]) .. ' ' .. tostring(coordinate[1])] == nil then
			return true
		end
	end
	return false
end	


function convert_path(path) --i got confused on this so the variables may be whack. still works
	converted_path = {}
	print("converting...")
	for i = #path, 1, -1 do
		if i==1 then
			return converted_path
		end
		step = path[i]
		previous_step = path[i-1]
		directions = {left = right_of(previous_step),
				right = left_of(previous_step), 
				down = above(previous_step), 
				up = below(previous_step)}
		for key,value in pairs(directions) do
			if value then
				if value[1] == step[1] and value[2] == step[2] then
					converted_path[tostring(getX(step)) .. " " .. tostring(getY(step))] = key
				end
			end
		end
	end
	return converted_path
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

function get_neighbors(in_map, node)
	neighbor_table = {}
	local unwalkables = {'NWLK', 'WATR', 'LEDG', 'TREE'}
	potential_neighbors = {right_of(node, in_map), left_of(node), above(node), below(node, in_map)}
	for _,potential_neighbor in pairs(potential_neighbors) do
		if potential_neighbor then
			if not table.contains(unwalkables, in_map[getY(potential_neighbor)][getX(potential_neighbor)]) then
				if not check_for_warp(potential_neighbor, in_map) then
					table.insert(neighbor_table, potential_neighbor)
				end
			end
		end
	end
	return neighbor_table
end

function check_for_warp(coordinate, in_map)
	if in_map[getY(coordinate)][getX(coordinate)] == "WARP" and found_solution then
		return true
	end
	warp_table = map.get_warp_data()
	map_number = map.get_map_number()
	if warp_table[map_number .. ' ' .. tostring(coordinate[2]) .. ' ' .. tostring(coordinate[1])] ~= nil then
		return true
	end
	return false
end

function right_of(node, in_map)
	if in_map ~= nil then
		if getX(node) + 1 > #in_map[1] then return false end 
	end
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

function below(node, in_map)
	if in_map ~= nil then
		if getY(node) + 1 > #in_map then return false end
	end
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
	local first = list.first
	if first  > list.last then error("list is empty") end
	local value = list[first]
	list[first] = nil
	list.first = first + 1
	return value
end

function List.empty(list)
	if list.first > list.last then return true
	else return false
	end
end

