module Day13

using AOC2022.Helpers
export day13

function parseLine(line, start=1, stop=length(line))
  list = []

  start += 1
  stop -= 1

  while start <= stop
    idxSep = findnext(',', line, start)
    idxOpen = findnext('[', line, start)

    goto = 'N'
    if isnothing(idxSep) && isnothing(idxOpen)
      goto = 'I'
    elseif isnothing(idxSep)
      goto = 'L'
    elseif isnothing(idxOpen)
      goto = 'I'
    else
      if idxSep < idxOpen
        goto = 'I'
      else
        goto = 'L'
      end
    end

    if goto == 'L'
      idxClose = idxOpen
      indent = 1
      while indent > 0
        idxClose += 1
        if line[idxClose] == '['
          indent += 1
        elseif line[idxClose] == ']'
          indent -= 1
        end
      end
      push!(list, parseLine(line, idxOpen, idxClose))
      start = idxClose + 1
    elseif goto == 'I'
      if isnothing(idxSep) || idxSep >= stop
        push!(list, parse(Int, line[start:stop]))
        start = stop + 1
      elseif idxSep == start
        start = idxSep + 1
      else
        push!(list, parse(Int, line[start:idxSep-1]))
        start = idxSep + 1
      end
    end
  end

  list
end

compare(left::Int, right::Int) = left - right
compare(left::Int, right::Vector) = compare([left], right)
compare(left::Vector, right::Int) = compare(left, [right])

function compare(left::Vector, right::Vector)
  for (x, y) in zip(left, right)
    c = compare(x, y)
    if c != 0
      return c
    end
  end

  return length(left) - length(right)
end

function day13()
  filename = getFilename(13)

  sep1, row1 = [[2]], 1
  sep2, row2 = [[6]], 2

  left, right = [], []
  sum = 0
  index = 0
  row = 0

  for line in eachline(filename)
    row += 1
    if row == 1
      left = parseLine(line)
    elseif row == 2
      right = parseLine(line)
    else
      row = 0
      index += 1

      if compare(left, right) < 0
        sum += index
      end

      for list in (left, right)
        if compare(list, sep1) < 0
          row1 += 1
          row2 += 1
        elseif compare(list, sep2) < 0
          row2 += 1
        end
      end
    end
  end

  index += 1
  if compare(left, right) < 0
    sum += index
  end

  for list in (left, right)
    if compare(list, sep1) < 0
      row1 += 1
      row2 += 1
    elseif compare(list, sep2) < 0
      row2 += 1
    end
  end

  sum, row1 * row2
end

end # module Day13
