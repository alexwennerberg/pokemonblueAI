require "movement"

function random_walking()
	table = {'up', 'down', 'left', 'right'}
	while 1 do
		movement.walk(table[math.random(4)])
	end
end

--map.initialize_map()
print(map.generate_raw_tile_table())