module("util", package.seeall)

function button(name, spacing, num) -- presses button and prints input
  local n, m
  if num ~= nil then n = num else n = 1 end
  if spacing ~= nil then m = spacing else m = 0 end
  repeat
  ta = {A=false, B=false, select=false, right=false, left=false, R=false, start=false, L=false, down=false, up=false}
  ta[name] = true
  joypad.set(1, ta)
  --print(name)
  vba.frameadvance()
  vba.message(name)
  n = n - 1
  skipframes(m)
  until n == 0
end

function skipframes(frames)
  --pauses the program for frames frames
j = vba.framecount();
i = 0;
while i<frames do
  i = vba.framecount()-j;
  vba.frameadvance();
end
end

function table.contains(table, element)
  
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end
