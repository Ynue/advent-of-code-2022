module Day10

using AOC2022.Helpers
export day10

mutable struct Register
  cycle::Int
  value::Int
  strength::Int
  screen::Matrix{Char}

  function Register()
    screen = fill('.', (6, 40))
    new(0, 1, 0, screen)
  end
end

function updateRegister!(register::Register, increment::Int=0)
  register.cycle += 1

  if mod(register.cycle, 40) == 20
    register.strength += register.cycle * register.value
  end

  register.value += increment

  cursor = mod(register.cycle, 40)
  if register.value - 1 <= cursor <= register.value + 1
    row = div(register.cycle, 40) + 1
    col = cursor + 1
    register.screen[row, col] = '#'
  end
end

function showRegister(register::Register)
  for row in axes(register.screen, 1)
    println(join(register.screen[row, 1:end], ""))
  end
end

function day10()
  filename = getFilename(10)

  register = Register()

  for line in eachline(filename)
    updateRegister!(register)
    if startswith(line, "addx")
      increment = parse(Int, line[6:end])
      updateRegister!(register, increment)
    end
  end

  showRegister(register)
  register.strength
end

end # module Day10
