require "util"
require "battle"
require "navigator"
require "map"

function main()
	map.initialize_map()
    navigator.walk("up")
    navigator.walk("up")
    navigator.walk("up")
    navigator.walk("up")
    navigator.interact_object()
 end

main()


function find_events()--is there something happening other than walking around?
      if mem.battling() then
        return 'battle'
      elseif mem.menu_open() then
        return 'menu'
      else
        return 'overworld'
      end
end
