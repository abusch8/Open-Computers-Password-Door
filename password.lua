local component = require("component")
local sides = require("sides")
local term = require("term")
local text = require("text")
local redstone = component.redstone
local attempts, input
local file = io.open("../mnt/c4e/log.txt", "a")

component.gpu.setResolution(32, 16)

if file == nil then
  term.clear()
  io.write("FLOPPY DISC NOT INSTERTED\n")
  os.sleep(1)
  return
end

local function reset()
  term.clear()
  io.write("\27[35m", "Welcome to Chambers Inc.\n", "\27[m")
  io.write("Failed attempts are recorded\n")
  redstone.setOutput(sides.down, 0)
  redstone.setOutput(sides.north, 0)
  attempts = 3
end

reset()

while true do
  io.write("Password: ")
  input = text.trim(term.read(nil, false, nil, "*"))
  if input == "6309" then
    io.write("\27[32m", "\nCorrect\n", "\27[m")
    io.write("Access Granted...\n")
    file:write(os.date(), " SUCCESS\n")
    file:flush()
    redstone.setOutput(sides.down, 15)
    os.sleep(1)
    reset()
  else
    io.write("\27[31m", "\nIncorrect\n", "\27[m")
    attempts = attempts - 1
    io.write("You have ", attempts, " attempts remaining\n")
    file:write(os.date(), " FAILED ", input, "\n")
    file:flush()
    if attempts == 0 then
      io.write("Locked for 60 seconds...\n")
      redstone.setOutput(sides.north, 15)
      os.sleep(10)
      redstone.setOutput(sides.north, 0)
      os.sleep(50)
      reset()
    end
  end
end