module("movement", package.seeall)
require "util"
require "battle"
require "mem"


function walk(direction)
    util.button(direction, 0, 4)
    util.skipframes(12)
end

function interact_object()
    while(mem.value("movement_disabled") == 0) do
      util.button("A")
    end
    while(mem.value("movement_disabled") == 1) do
      util.button("A")
      util.skipframes(100)
    end
end

