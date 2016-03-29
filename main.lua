require "util"
require "battle"
require "navigator"
require "map"
require "ai"

function main()
  print(map.generate_tile_table())
	map.initialize_map()
  navigate_around()
end

function navigate_around()
  while 1 do
    follow_this_path = ai.return_path()
    --print(follow_this_path)
    x,y=map.get_current_coords()
    counter = 1
    while follow_this_path[y][x] do
      navigator.walk(follow_this_path[y][x])
      tempa,tempb = map.get_current_coords()
      if tempa == x and tempb == y then counter = counter + 1 end ---stop if you're stuck
      x,y=map.get_current_coords()
      if counter == 10 then
        break
      end
    end
  end
end

function test_battle()
  battle.complete_battle()
end

main()