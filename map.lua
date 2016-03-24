module("map", package.seeall)

require "util"
require "mem"

--[[Pokemon blue stores data in tilesets. Different areas have a different
	set of tiles that you can use. here, I break down each tile and give the
	program a little big of information about that tile, ie whether it is 
	walkable or has certain special properties. the number before each
	tileset is the tileset number as retrieved from memory.

	0: "Outside"
	1: "Ash's House (#1)"
	2: "Pokemon Center (#1)"
	3: "Viridian Forest"
	4: "Ash's House (#2)"
	5: "Gym (#1)"
	6: "Pokemon Center (#2)"
	7: "Gym (#2)"
	8: "House"
	9: "Museum (#1)"
	10: "Museum (#2)"
	11: "Underground Path"
	12: "Museum (#3)"
	13: "S.S. Anne"
	14: "Vermilion Port"
	15: "Pokemon Cemetery"
	16: "Silph Co."
	17: "Cave"
	18: "Celadon Mart"
	19: "Game Freak HQ"
	20: "Lab"
	21: "Bike Shop/Cable Center"
	22: "Cinnabar Mansion/Power Plant etc"
	23: "Indigo Plateau"]]

TILE_DATA = {
	{ --tileset 0
		WALK = {4444,4403,8282,5757,5735,3535,6060,9191}, --walkable
		NWLK = {8687,5859,2323,2425,2122,2626,2393,9223,2679,7826,1818,2156,5625,
				8585,1534,3434,7575,7531,8081,1575,9018,1890,1575,7474,3039,3939,
				1717,3636,3431}, --nowalkable
		WARP = {2728}, --warp
		WATR = {5020,2020,2084}, --water
		TREE = {6162}, -- tree
		COMP = {},
		LEDG = {5455,5555,5552}, --ledges
	},
	{--tileset 1
		WALK = {101,1819}, --walkable
		NWLK = {1616,0,5253,4849,5051,2223,5455,5657,6058,5859}, --nowalkable
		WARP = {2829,2020}, --warp. 2020 is doormat
		WATR = {}, --water
		TREE = {}, -- tree
		LEDG = {}, --add ledges. this info is in the second (currently ignored) row
	},
	{--pokemart
		WALK = {2627,1727}, --walkable
		NWLK = {2329,6263,0,8081,8183,2524,4040,1641,8485,8587}, --nowalkable
		WARP = {2828}, --warp.
		SHOP = {3031}, --shop here
		TREE = {}, -- tree
		LEDG = {}, --add ledges. this info is in the second (currently ignored) row
	},
	{--tileset 3 "viridian forest"
		WALK = {4848}, --walkable
		NWLK = {}, --nowalkable
		WARP = {}, --warp.
		SHOP = {}, --shop here
		TREE = {}, -- tree
		LEDG = {}, --add ledges. this info is in the second (currently ignored) row

	},
	{--tileset 4
		WALK = {101}, --walkable
		NWLK = {1616,0,5253,4849,2223,5455,5657,6058,5859,809,6162,3233,3839,
				3941,3031,809,6347,2425}, --nowalkable
		WARP = {2627}, --warp. 2020 is doormat
		TREE = {}, --tree
		COMP = {5051}, --pc computer
	},	
	{--tileset 5
		WALK = {1717}, --walkable
		NWLK = {1515,1616,8283,1314,2930,7857,5779,5455,8595,5757}, --nowalkable
		WARP = {2222}, --warp
		WATR = {}, --water
		TREE = {}, -- tree
		COMP = {},
		LEDG = {}, --add ledges. this info is in the second (currently ignored) row
	},
	{--tileset 6 "pokemon center" WRONG 
		WALK = {1727}, --walkable
		NWLK = {0,1631,4074,5051,4849,1641,}, --nowalkable
		WARP = {2828}, --warp
		WATR = {}, --water
		TREE = {}, -- tree
		COMP = {},
		HEAL = {}, -- heal pkmn
	},
	{--tileset 7
		WALK = {}, --walkable
		NWLK = {}, --nowalkable
		WARP = {}, --warp
		WATR = {}, --water
		TREE = {}, -- tree
		COMP = {},
		LEDG = {}, --add ledges. this info is in the second (currently ignored) row
	},
	{--tileset 8 "house"
		WALK = {101,1819}, --walkable
		NWLK = {1616,0,5253,4849,5051,2223,5455,5657,6058,5859,1415,6162,5252,3031,
				5447,4757,809,2425,8889,9091,7071}, --nowalkable
		WARP = {2829,2020}, --warp. 2020 is doormat
		WATR = {}, --water
		TREE = {}, -- tree
		LEDG = {}, --add ledges. this info is in the second (currently ignored) row
	},
	{--tileset 9
		WALK = {117}, --walkable
		NWLK = {1616,2122,7474,5434,5051,2324,5942,5354}, --nowalkable
		WARP = {2020,5492}, --warp. 2020 is doormat
		TREE = {}, --tree
		COMP = {}, --pc computer
	},	
	{--tileset 10
		WALK = {}, --walkable
		NWLK = {}, --nowalkable
		WARP = {}, --warp
		WATR = {}, --water
		TREE = {}, -- tree
		COMP = {},
		LEDG = {}, --add ledges. this info is in the second (currently ignored) row
	},
	{--tileset 11
		WALK = {}, --walkable
		NWLK = {}, --nowalkable
		WARP = {}, --warp
		WATR = {}, --water
		TREE = {}, -- tree
		COMP = {},
		LEDG = {}, --add ledges. this info is in the second (currently ignored) row
	},
	{--tileset 12
		WALK = {}, --walkable
		NWLK = {}, --nowalkable
		WARP = {}, --warp
		WATR = {}, --water
		TREE = {}, -- tree
		COMP = {},
		LEDG = {}, --add ledges. this info is in the second (currently ignored) row
	},
	{--tileset 13
		WALK = {}, --walkable
		NWLK = {}, --nowalkable
		WARP = {}, --warp
		WATR = {}, --water
		TREE = {}, -- tree
		COMP = {},
		LEDG = {}, --add ledges. this info is in the second (currently ignored) row
	},
	{--tileset 14
		WALK = {}, --walkable
		NWLK = {}, --nowalkable
		WARP = {}, --warp
		WATR = {}, --water
		TREE = {}, -- tree
		COMP = {},
		LEDG = {}, --add ledges. this info is in the second (currently ignored) row
	},
	{--tileset 15
		WALK = {}, --walkable
		NWLK = {}, --nowalkable
		WARP = {}, --warp
		WATR = {}, --water
		TREE = {}, -- tree
		COMP = {},
		LEDG = {}, --add ledges. this info is in the second (currently ignored) row
	},
	{--tileset 16
		WALK = {}, --walkable
		NWLK = {}, --nowalkable
		WARP = {}, --warp
		WATR = {}, --water
		TREE = {}, -- tree
		COMP = {},
		LEDG = {}, --add ledges. this info is in the second (currently ignored) row
	},
	{--tileset 17
		WALK = {}, --walkable
		NWLK = {}, --nowalkable
		WARP = {}, --warp
		WATR = {}, --water
		TREE = {}, -- tree
		COMP = {},
		LEDG = {}, --add ledges. this info is in the second (currently ignored) row
	},
	{--tileset 18
		WALK = {}, --walkable
		NWLK = {}, --nowalkable
		WARP = {}, --warp
		WATR = {}, --water
		TREE = {}, -- tree
		COMP = {},
		LEDG = {}, --add ledges. this info is in the second (currently ignored) row
	},
}

--CONSTANTS
PLAYER_OFFSET = 4 --distance from 1,1 to center (where sprite is)
SCREEN_HEIGHT = 9
SCREEN_WIDTH = 10
BASE = 0xc3a0+0x14

MAP_X_BUFFER = 40
MAP_Y_BUFFER = 40
x_current = MAP_X_BUFFER+1
y_current = MAP_Y_BUFFER+1

--MAPS
map = {}
last_tile_table = {} --what the tile table looked like last time update_map() was called

function get_current_coords()
	return x_current+PLAYER_OFFSET, y_current+PLAYER_OFFSET
end

function get_map()
	return map
end

function initialize_map()
	local current_tile_table = generate_tile_table()
	for i=1,2*MAP_Y_BUFFER+SCREEN_HEIGHT do
		map[i] = {}
		for j=1,2*MAP_X_BUFFER+SCREEN_WIDTH do
			map[i][j] = 'X'
		end
	end
	for i=1,SCREEN_HEIGHT do
		for j=1,SCREEN_WIDTH do
			map[MAP_Y_BUFFER+i][MAP_X_BUFFER+j] = current_tile_table[i][j]
		end
	end
	last_tile_table = generate_tile_table()
end

function print_map()
	print(map)
end

function update_map()
	local current_tile_table = generate_tile_table()
	result = compare_tile_tables(last_tile_table, current_tile_table)
	last_tile_table = generate_tile_table()
	print("moved", result)
	if result == 'same' then print('same')
	elseif result == 'up' then 
		y_current = y_current - 1
		for i=1,SCREEN_WIDTH do
			map[y_current][x_current+i-1] = current_tile_table[1][i]
		end
	elseif result == 'down' then 
		y_current = y_current + 1
		for i=1,SCREEN_WIDTH do
			map[y_current+SCREEN_HEIGHT-1][x_current+i-1] = current_tile_table[SCREEN_HEIGHT][i]
		end
	elseif result == 'right' then 
		x_current = x_current + 1
		for i=1,SCREEN_HEIGHT do
			map[y_current+i-1][x_current+SCREEN_WIDTH-1] = current_tile_table[i][SCREEN_WIDTH]
		end
	elseif result == 'left' then 
		x_current = x_current - 1
		for i=1,SCREEN_HEIGHT do
			map[y_current+i-1][x_current] = current_tile_table[i][1]
		end
	end
	print(x_current, y_current)
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
	bank = TILE_DATA[mem.value('current_tileset')+1]
	for k,v in pairs(bank) do
		for kk,vv in pairs(v) do
			if vv == tile_value then return k end
		end
	end
	return tile_value
end