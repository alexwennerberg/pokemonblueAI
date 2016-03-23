module("ai", package.seeall)

function check_if_open(map, startx, starty) --funciton that checks if a given coord in an open region
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
	return recursive_solve(startx, starty)
end

function recursive_solve(x, y) --i copied this from https://en.wikipedia.org/wiki/Maze_solving_algorithm
	print('doing recursive solve', x, y)
	if map_to_check[x][y] == 'X' then return true end
	if map_to_check[x][y] == 'NWLK' or was_here[x][y] then return false end
	was_here[x][y] = true
	if recursive_solve(x-1, y) then
		--correct_path[x][y] = true;
		return true
	end
	if recursive_solve(x+1, y) then
		--correct_path[x][y] = true;
		return true
	end
	if recursive_solve(x, y-1) then
		--correct_path[x][y] = true;
		return true
	end
	if recursive_solve(x, y+1) then
		--correct_path[x][y] = true;
		return true
	end
	return false
end
