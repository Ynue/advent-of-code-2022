module Day11

using AOC2022.Helpers
export day11

abstract type Operation end

struct Add <: Operation
  quantity::Int
end
function operate(add::Add, x::Int)
  x + add.quantity
end

struct Mul <: Operation
  quantity::Int
end
function operate(mul::Mul, x::Int)
  if mul.quantity == -1
    abs2(x)
  else
    x * mul.quantity
  end
end

mutable struct Monkey
  items::Vector{Int}
  operation::Operation
  divisor::Int
  success::Int
  failure::Int
  activity::Int
end

function doRound!(monkeys::Vector{Monkey}, bigmod::Int=-1)
  for monkey in monkeys
    while !isempty(monkey.items)
      item = popfirst!(monkey.items)
      monkey.activity += 1

      worriness = operate(monkey.operation, item)
      if bigmod == -1
        worriness = div(worriness, 3)
      else
        worriness = mod(worriness, bigmod)
      end

      if mod(worriness, monkey.divisor) == 0
        push!(monkeys[monkey.success].items, worriness)
      else
        push!(monkeys[monkey.failure].items, worriness)
      end
    end
  end
end

function business(monkeys)
  firstMax, secondMax = -1, -1
  for monkey in monkeys
    if monkey.activity > firstMax
      firstMax, secondMax = monkey.activity, firstMax
    elseif monkey.activity > secondMax
      secondMax = monkey.activity
    end
  end

  firstMax * secondMax
end

function day11()
  filename = getFilename(11)

  monkeys = Vector{Monkey}()
  items = Vector{Int}()
  operation = nothing
  divisor = -1
  success = -1
  failure = -1
  step = 0

  for line in eachline(filename)
    step += 1
    if step == 2
      idx = 19
      append!(items, parse.(Int, split(line[idx:end], ", ")))
    elseif step == 3
      idx = 24
      optype = line[idx]
      quantity = line[idx+2:end]
      if quantity == "old"
        quantity = -1
      else
        quantity = parse(Int, quantity)
      end
      if optype == '+'
        operation = Add(quantity)
      elseif optype == '*'
        operation = Mul(quantity)
      end
    elseif step == 4
      idx = 22
      divisor = parse(Int, line[idx:end])
    elseif step == 5
      idx = 30
      success = parse(Int, line[idx:end]) + 1
    elseif step == 6
      idx = 30
      failure = parse(Int, line[idx:end]) + 1
    elseif step == 7
      push!(monkeys, Monkey(items, operation, divisor, success, failure, 0))
      items = Vector{Int}()
      operation = nothing
      divisor = -1
      success = -1
      failure = -1
      step = 0
    end
  end
  push!(monkeys, Monkey(items, operation, divisor, success, failure, 0))

  initialItemLists = [copy(monkey.items) for monkey in monkeys]

  for _ in 1:20
    doRound!(monkeys)
  end
  business1 = business(monkeys)

  for (monkey, initialItemList) in zip(monkeys, initialItemLists)
    empty!(monkey.items)
    append!(monkey.items, initialItemList)
    monkey.activity = 0
  end

  bigmod = prod(monkey.divisor for monkey in monkeys)
  for _ in 1:10000
    doRound!(monkeys, bigmod)
  end
  business2 = business(monkeys)

  business1, business2
end

end # module Day11
