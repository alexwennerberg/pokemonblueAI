module("ai", package.seeall)

function wander(map) --funciton that explores and tries to expand viewable area
	for y,value in map do
		for x,map_data in value do
			if map_data == 'NWLK' then
				coordinates = {y,x}
				break
			end
		end
	end
end

--learn unit testing!