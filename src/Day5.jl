module Day5

using AOC2022.Helpers
export day5

function day5()
  filename = getFilename(5)

  header = String[]
  stacksOne = Vector{Vector{Char}}()
  stacksAll = Vector{Vector{Char}}()
  finishedHeader = false

  for line in readlines(filename)
    if !finishedHeader
      push!(header, line)

      if isempty(line)
        finishedHeader = true

        nrows = length(header) - 2
        ncols = div(length(header[end-1]) + 1, 4)

        for col in 1:ncols
          push!(stacksOne, Vector{Char}())
          idx = 4 * (col - 1) + 2
          for row in 1:nrows
            letter = header[row][idx]
            if letter != ' '
              push!(stacksOne[col], letter)
            end
          end

          reverse!(stacksOne[col])
          push!(stacksAll, copy(stacksOne[col]))
        end
      end
    else
      matches = match(r"move (?<quantity>\d+) from (?<src>\d+) to (?<dst>\d+)", line)
      quantity, src, dst = matches.captures
      quantity = parse(Int, quantity)
      src = parse(Int, src)
      dst = parse(Int, dst)

      for _ in 1:quantity
        letter = pop!(stacksOne[src])
        push!(stacksOne[dst], letter)
      end

      l = length(stacksAll[src])
      list = splice!(stacksAll[src], l-quantity+1:l)
      append!(stacksAll[dst], list)
    end
  end

  sOne, sAll = "", ""
  for (stackOne, stackAll) in zip(stacksOne, stacksAll)
    sOne *= stackOne[end]
    sAll *= stackAll[end]
  end
  sOne, sAll
end

end
