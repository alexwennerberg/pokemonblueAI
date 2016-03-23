module("ai", package.seeall)

was_here = {}
correct_path = {}
default_test_map = {{'X', 'X', 'X', 'X', 'X'},
					{'X', 'NWLK', 'NWLK', 'NWLK', 'X'},
					{'X', 'NWLK', 'WALK', 'NWLK', 'X'},
					{'X', 'NWLK', 'NWLK', 'NWLK', 'X'},
					{'X', 'X', 'X', 'X', 'X'}}

function check_if_open(startx, starty) --funciton that checks if a given coord in a closed region
	for key,value in pairs(default_test_map) do
		was_here[key] = {}
		correct_path[key] = {}
		for subkey,subvalue in pairs(value) do
			was_here[key][subkey] = false
			correct_path[key][subkey] = false
		end
	end
	return recursive_solve(startx, starty)
end

function recursive_solve(x, y) --i copied this from https://en.wikipedia.org/wiki/Maze_solving_algorithm
	print('doing recursive solve', x, y)
	if default_test_map[x][y] == 'X' then return true end
	if default_test_map[x][y] == 'NWLK' or was_here[x][y] then return false end
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

print(check_if_open(3,3))

--learn unit testing!