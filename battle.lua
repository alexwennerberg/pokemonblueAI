module("battle", package.seeall)
require "util"

function complete_battle()
	fainted = false
	while mem.battling() do
		util.button("A",5)
	end
	if mem.check_blackout() then
		fainted = true --i don't like this
	end
	util.skipframes(100) --buffer to return to real world
	if fainted then return 'fainted' end
end
