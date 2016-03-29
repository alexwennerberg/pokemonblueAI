module("mem", package.seeall)

local memory_names = {
	current_tileset = 0xD367,
	----player
	player_x_coord = 0xD362,
	player_y_coord = 0xD361,
	player_move_direction = 0xD528,
	movement_disabled = 0xCFC4,
  warp_info = 0xd736,
	--counts down from 3
	--pokemon
	pokemon_1_level = 0xD18C,
	pokemon_2_level = 0xD1B8,
	pokemon_3_level = 0xD1E4,
	pokemon_4_level = 0xD210,
  pokemon_5_level = 0xD23C,
	pokemon_6_leve1 = 0xD268,
	number_pokemon = 0xD163,
	--battle
  pokemon_1_hp_byte_1 = 0xD015,
  pokemon_1_hp_byte_2 = 0xD016,
	battle_type = 0xD057, --also 255 if battle lost
  menu_y = 0xCC24,
  menu_x = 0xCC25,
  menu_item = 0xCC26
}

function check_blackout() --return true if you just lost a battle 
  if value('battle_type') == 255 then
    print("BLACKED OUT")
    return true
  end
  return false
end

function leaving_room()
  if value('warp_info') == 4 then
    return true
  else
    return false
  end
end

function value(key)
	return memory.readbyte(memory_names[key])
end

function get_money()
  return memory.readbyte(0xD349) + memory.readbyte(0xD348)*100
end

function battling()
  if value('battle_type') > 0 and value('battle_type') ~= 255 then
    return true
  end
  return false
end

function menu_open() --DOES NOT WORK CORRECTLY. ONLY CHECKS RESTRICTED MOVEMENT.
  if memory.readbyte(0xCFC4) == 1 then
    return true
  else return false
  end
end

function pkmn_health(num)
  if num == 1 then
    return memory.readbyte(0xD16D) / memory.readbyte(0xD18E)
  elseif num == 2 then
    return memory.readbyte(0xD199) / memory.readbyte(0xD1BA)
  elseif num == 3 then
    return memory.readbyte(0xD1C5) / memory.readbyte(0xD1E6)
  elseif num == 4 then
    return memory.readbyte(0xD1F1) / memory.readbyte(0xD212)
  elseif num == 5 then
    return memory.readbyte(0xD21D) / memory.readbyte(0xD23E)
  elseif num == 6 then
    return memory.readbyte(0xD249) / memory.readbyte(0xD26A)
  end
end

