module("battle", package.seeall)
require "util"

button_spacing = 20

function complete_battle()
	fainted = false
	while mem.battling() do
		go_through_battle_prompts()
		select_random_move()
		go_through_battle_prompts()
	end
	util.skipframes(100) --buffer to return to real world
end

function select_random_move()
	select_move(math.random(4))
end

function select_move(move_number)
	select_fight()
	while mem.get_current_menu_item() ~= move_number do
		util.button("down", button_spacing)
	end
	util.button("A", button_spacing)
end

function go_through_battle_prompts()
	cursor_location = mem.get_menu_cursor_location()
	while mem.get_menu_cursor_location() == cursor_location do
		if mem.battling() then
			util.button("A", button_spacing)
		else
			break
		end
	end
end

function select_fight()
	util.button("up", button_spacing)
	util.button("left", button_spacing)
	util.button("A", button_spacing)
end

