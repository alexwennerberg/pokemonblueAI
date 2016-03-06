module("mem", package.seeall)

local memoryNames = {
	current_tileset = 0xD367,
	----player
	player_x_coord = 0xD362,
	player_y_coord = 0xD361,
	player_move_direction = 0xD528,
	movement_disabled = 0xCFC4,
	--counts down from 3
	----pokemon
	pokemon_1_level = 0xD18C,
	pokemon_2_level = 0xD1B8,
	pokemon_3_level = 0xD1E4,
  	pokemon_4_level = 0xD210,
    pokemon_5_level = 0xD23C,
  	pokemon_6_leve1 = 0xD268,
  	number_pokemon = 0xD163,
  	--battle
  	battle_type = 0xD057, -- 1 is wild 2 is trainer -1 is lost battle
}

function value(key)
	return memory.readbyte(memoryNames[key])
end

function getmoney()
  return memory.readbyte(0xD349) + memory.readbyte(0xD348)*100
end

function pkmnhealth(num)
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

function menuopen()
--returns a boolean representative of whether a 
--menu is open
  if memory.readbyte(0xCFC4) == 1 then
    return true
  else return false
end
end