module("map", package.seeall)

require "util"
require "mem"

tile_data = {
	bank_0 = {
		w = {3535,5757,4444,344,8282},
		n = {506, 707, 809,3738,1034, 1075, 7510,
						1010,4041,1534,3431,4243,
						7071,1534,1112,1414,4444,
						2156,8383,1414,1818,1510,
						5625,1031,6465,7683,9018},
		a = {1112},
		l = {}, --add ledges. this info is in the second (currently ignored) row
	},
	bank_1 = {},
}

PLAYER_OFFSET = 4 --distance from 1,1
SCREEN_HEIGHT = 9
SCREEN_WIDTH = 10
BASE = 0xc3a0

MAP_X_BUFFER = 20
MAP_Y_BUFFER = 20
x_current = MAP_X_BUFFER+1
y_current = MAP_Y_BUFFER+1

map = {}


function initialize_map()
	local temp = generate_tile_table()
	for i=1,2*MAP_Y_BUFFER+SCREEN_HEIGHT do
		map[i] = {}
		for j=1,2*MAP_X_BUFFER+SCREEN_WIDTH do
			map[i][j] = 'X'
		end
	end
	for i=1,SCREEN_HEIGHT do
		for j=1,SCREEN_WIDTH do
			map[MAP_Y_BUFFER+i][MAP_X_BUFFER+j] = temp[i][j]
		end
	end
end

function update_map(old_tile_table)
	local temp = generate_tile_table()
	result = compare_tile_tables(old_tile_table, temp)
	print("moved", result)
	if result == 'same' then print('same')
	elseif result == 'up' then 
		y_current = y_current - 1
		for i=1,SCREEN_WIDTH do
			map[y_current][x_current+i-1] = temp[1][i]
		end
	elseif result == 'down' then 
		y_current = y_current + 1
		for i=1,SCREEN_WIDTH do
			map[y_current+SCREEN_HEIGHT-1][x_current+i-1] = temp[SCREEN_HEIGHT][i]
		end
	elseif result == 'right' then 
		x_current = x_current + 1
		for i=1,SCREEN_HEIGHT do
			map[y_current+i-1][x_current+SCREEN_WIDTH-1] = temp[i][SCREEN_WIDTH]
		end
	elseif result == 'left' then 
		x_current = x_current - 1
		for i=1,SCREEN_HEIGHT do
			map[y_current+i-1][x_current] = temp[i][1]
		end
	end
	print(x_current, y_current)
	print(temp)
end

function compare_tile_tables(old, new)
	result = 'same'
	for i=1,SCREEN_HEIGHT do
		if not table_compare(old[i], new[i]) then
			result = 'not same'
		end
	end
	if result == 'same' then return result
	elseif check_up(old,new) then
		return 'up'
	elseif check_down(old,new) then
		return 'down'
	elseif check_right(old,new) then
		return 'right'
	elseif check_left(old,new) then
		return 'left'
	else return 'crap' end
end	

function table_compare(a,b) --compares two tables of the same length, return bool
	for key,value in pairs(a) do
		if b[key] ~= value then
			return false
		end
	end
	return true
end

function check_up(old,new)
	for i=2,SCREEN_HEIGHT do
		if not table_compare(new[i],old[i-1]) then
			return false
		end
	end
	return true
end

function check_down(old,new)
	for i=2,SCREEN_HEIGHT do
		if not table_compare(new[i-1],old[i]) then
			return false
		end
	end
	return true
end

function check_right(old,new)--wrong
	for i=1,SCREEN_HEIGHT do
		for j=2,SCREEN_WIDTH do
			if old[i][j] ~= new[i][j-1] then
				return false
			end
		end
	end
	return true
end

function check_left(old,new)--wrong
	for i=1,SCREEN_HEIGHT do
		for j=2,SCREEN_WIDTH do
			if old[i][j-1] ~= new[i][j] then
				return false
			end
		end
	end
	return true
end

function generate_tile_table()
	local tile_table = {}
	for i=1,SCREEN_HEIGHT do
		tile_table[i] = {}
		for j=1,SCREEN_WIDTH do
			tile_table[i][j] = convert_tile(find_tile_value(j,i))
		end
	end
	return tile_table
end

function generate_raw_tile_table() --for debugging
	local tile_table = {}
	for i=1,SCREEN_HEIGHT do
		tile_table[i] = {}
		for j=1,SCREEN_WIDTH do
			tile_table[i][j] = find_tile_value(j,i)
		end
	end
	return tile_table
end

function find_tile_value(x,y)
	--coords start from 1,1 as upper left corner
	tile_value = memory.readbyte(BASE+((y-1)*SCREEN_WIDTH*4+(x-1)*2))*100 + 
				memory.readbyte(BASE+1+((y-1)*SCREEN_WIDTH*4+(x-1)*2))
	return tile_value
end

function convert_tile(tile_value)
	bank = tile_data['bank_0']
	for k,v in pairs(bank) do
		for kk,vv in pairs(v) do
			if vv == tile_value then return k end
		end
	end
	return tile_value
end