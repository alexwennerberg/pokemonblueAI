module("walkable_tiles", package.seeall)

require "util"

tile_data = {
	bank_0 = {
		walkable = {3535,5757,4444,344},
		non_walk = {506, 707, 809,3738,1034,
						1010,4041,1534,3431,4243,
						7071,1534,1112,1414,4444,
						2156,8383,1414,1818,1510},
		warp = {1112},
	},
	bank_1 = {},
}

SCREEN_HEIGHT = 9
SCREEN_WIDTH = 10
BASE = 0xc3a0

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