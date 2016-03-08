require "movement"

function random_walking()
	table = {'up', 'down', 'left', 'right'}
	while 1 do
		movement.walk(table[math.random(4)])
	end
end

--map.initialize_map()
while 1 do
	print(map.generate_tile_table())
	util.skipframes(100)
end