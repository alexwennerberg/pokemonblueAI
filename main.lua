require "util"
require "battle"
require "navigator"
require "map"
require "ai"

function main()
	map.initialize_map()
  while 1 do
    follow_this_path = ai.return_path()
    --print(follow_this_path)
    x,y=map.get_current_coords()
    while follow_this_path[y][x] do
      navigator.walk(follow_this_path[y][x])
      x,y=map.get_current_coords()
    end
  end
end


main()