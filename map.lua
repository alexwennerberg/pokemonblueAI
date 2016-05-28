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

--CONSTANTS
PLAYER_OFFSET = 4 --distance from 1,1 to center (where sprite is)
SCREEN_HEIGHT = 9
SCREEN_WIDTH = 10
BASE = 0xc3a0+0x14

MAP_X_BUFFER = 5
MAP_Y_BUFFER = 5
x_current = mem.get_x_coord()
y_current = mem.get_y_coord()
map_current = mem.get_map()

--MAPS
world = {}

warp_data = {--warp[map_number][y_value][x_value] = {destination zone, # of visits}
}

TILE_DATA = {
	{ --tileset 0
		WALK = {4444,4403,8282,5757,5735,3535,6060,9191}, --walkable
		NWLK = {8687,5859,2323,2425,2122,2626,2393,9223,2679,7826,1818,2156,5625,
				8585,1534,3434,7575,7531,8081,1575,9018,1890,1575,7474,3039,3939,
				1717,3636,3431,3602}, --nowalkable
		WARP = {2728}, --warp
		WATR = {5020,2020,2084}, --water
		TREE = {6162}, -- tree
		COMP = {},
		LEDG = {5455,5555,5552}, --ledges
	},
	{--tileset 1
		WALK = {101,1819}, --walkable
		NWLK = {1616,0,5253,4849,5051,2223,5455,5657,6058,5859}, --nowalkable
		WARP = {2829},
		DMAT = {2020}, --warp. 2020 is doormat
		WATR = {}, --water
		TREE = {}, -- tree
		LEDG = {}, --add ledges. this info is in the second (currently ignored) row
	},
	{--pokemart
		WALK = {2627,1727}, --walkable
		NWLK = {2329,6263,0,8081,8183,2524,4040,1641,8485,8587}, --nowalkable
		DMAT = {2828}, --warp.
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
	{--tileset 5 "GYM 1"
		WALK = {1717}, --walkable
		NWLK = {1515,1616,8283,1314,2930,7857,5779,5455,8595,5757}, --nowalkable
		DMAT = {2222}, --warp
		WATR = {}, --water
		TREE = {}, -- tree
		COMP = {},
		LEDG = {}, --add ledges. this info is in the second (currently ignored) row
	},
	{--tileset 6 "pokemon center" WRONG 
		WALK = {1727}, --walkable
		NWLK = {0,1631,4074,5051,4849,1641,}, --nowalkable
		DMAT = {2828}, --warp
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
		WARP = {2829},
		DMAT = {2020}, --warp. 2020 is doormat
		WATR = {}, --water
		TREE = {}, -- tree
		LEDG = {}, --add ledges. this info is in the second (currently ignored) row
	},
	{--tileset 9
		WALK = {117}, --walkable
		NWLK = {1616,2122,7474,5434,5051,2324,5354}, --nowalkable
		WARP = {5942},
		DMAT = {2020}, --warp. 2020 is doormat
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

function get_current_coords()
	return x_current+PLAYER_OFFSET, y_current+PLAYER_OFFSET
end

function get_map()
	return world[map_current]
end

function get_world()
	return world
end

function initialize_world()
	x_current = mem.get_x_coord()
	y_current = mem.get_y_coord()
	map_current = mem.get_map()
	world[map_current] = {}
	local current_tile_table = generate_tile_table()
	for i=1,mem.get_map_height() do
		world[map_current][i] = {}
		for j=1,mem.get_map_width() do
			world[map_current][i][j] = 'X'
		end
	end
	for i=1,SCREEN_HEIGHT do
		for j=1,SCREEN_WIDTH do			
				world[map_current][y_current+i-1][x_current+j-1] = current_tile_table[i][j]
		end
	end
	last_tile_table = generate_tile_table()
end

function print_world()
	print(world[map_current])
end

function get_current_tile() --debugger
	return world[map_current][y_current][x_current]
end

function update_position()
	if mem.get_map() == map_current then
		update_view_of_map()
	else
		update_map_number()
	end
	print(x_current, y_current)
	current_tile_value = world[map_current][y_current+PLAYER_OFFSET][x_current+PLAYER_OFFSET]
	if current_tile_valuue == 'NWLK' then
		print("ERROR, MAP IS MESSED UP")
	end
end

function update_view_of_map()
	local current_tile_table = generate_tile_table()
	if mem.get_x_coord() ~= x_current or mem.get_y_coord() ~= y_current then
		if mem.get_x_coord() == x_current + 1 then
			update_coords()
			for i=1,SCREEN_HEIGHT do
				world[map_current][y_current+i-1][x_current+SCREEN_WIDTH-1] = current_tile_table[i][SCREEN_WIDTH]
			end
		elseif mem.get_x_coord() == x_current - 1 then
			update_coords()
			for i=1,SCREEN_HEIGHT do
				world[map_current][y_current+i-1][x_current] = current_tile_table[i][1]
			end
		elseif mem.get_y_coord() == y_current + 1 then
			update_coords()
			for i=1,SCREEN_WIDTH do
				world[map_current][y_current+SCREEN_HEIGHT-1][x_current+i-1] = current_tile_table[SCREEN_HEIGHT][i]
			end
		elseif mem.get_y_coord() == y_current - 1 then
			update_coords()
			for i=1,SCREEN_WIDTH do
				world[map_current][y_current][x_current+i-1] = current_tile_table[1][i]
			end
		end
	end
	x_current = mem.get_x_coord()
	y_current = mem.get_y_coord()
end

function update_map_number()
	print("UPDATING MAP NUMBER...")
	x_current = mem.get_x_coord()
	y_current = mem.get_y_coord()
	check_and_update_warp()
	map_current = mem.get_map()
	if world[map_current] ~= nil then
		print("FAMILIAR MAP")
	else
		print("NEW MAP")
		world[map_current] = {}
		local current_tile_table = generate_tile_table()
		for i=1,mem.get_map_height() do
			world[map_current][i] = {}
			for j=1,mem.get_map_width() do
				world[map_current][i][j] = 'X'
			end
		end
		for i=1,SCREEN_HEIGHT do
			for j=1,SCREEN_WIDTH do			
					world[map_current][y_current+i-1][x_current+j-1] = current_tile_table[i][j]
			end
		end
	end
end

function check_and_update_warp()
	string_of_warp_point = tostring(map_current) .. ' ' .. tostring(y_current) .. ' ' .. tostring(x_current)
	if warp_data[string_of_warp_point] ~= nil then
		warp_data[string_of_warp_point][2] = warp_data[string_of_warp_point][2] + 1
	else
		warp_data[string_of_warp_point] = {mem.get_map(), 1}
	end
	print("updated warp")
	print(warp_data)

end

function update_coords()
	map_current = mem.get_map()

end


function table_compare(a,b) --compares two tables of the same length, return bool
	for key,value in pairs(a) do
		if b[key] ~= value then
			return false
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
	for i=1,SCREEN_HEIGHT-1 do
		for j=1,SCREEN_WIDTH do
			if tile_table[i][j] == 'DMAT'
				then tile_table[i+1][j] = 'WARP'
			end
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
