module("battle", package.seeall)
require "util"

function complete_battle()
	while mem.battling() do
		util.button("A", 5)
	end
end