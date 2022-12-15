module Day14

using AOC2022.Helpers
export day14

function day14()
  filename = getFilename(14)

  blocks = Set{Tuple{Int,Int}}()
  floor = 0
  for line in eachline(filename)
    coords = Vector{Tuple{Int,Int}}()
    start = 1
    while true
      stop = findnext(" -> ", line, start)
      isnothing(stop) && break
      stop = stop.start

      idx = start
      while line[idx] != ','
        idx += 1
      end

      x = parse(Int, line[start:idx-1])
      y = parse(Int, line[idx+1:stop])
      push!(coords, (x, y))
      start = stop + 4
    end
    idx = start
    while line[idx] != ','
      idx += 1
    end
    x = parse(Int, line[start:idx-1])
    y = parse(Int, line[idx+1:end])
    push!(coords, (x, y))

    for i in 1:length(coords)-1
      x1, y1 = coords[i]
      x2, y2 = coords[i+1]
      x1, x2 = minmax(x1, x2)
      y1, y2 = minmax(y1, y2)
      floor = max(floor, y2)
      for x in x1:x2
        for y in y1:y2
          push!(blocks, (x, y))
        end
      end
    end
  end

  units1 = 0
  leaks = false
  while !leaks
    sx, sy = 500, 0
    while true
      if sy >= floor
        leaks = true
        break
      end

      if !((sx, sy + 1) in blocks)
        sx, sy = sx, sy + 1
        continue
      elseif !((sx - 1, sy + 1) in blocks)
        sx, sy = sx - 1, sy + 1
        continue
      elseif !((sx + 1, sy + 1) in blocks)
        sx, sy = sx + 1, sy + 1
        continue
      end

      push!(blocks, (sx, sy))
      units1 += 1
      break
    end
  end

  units2 = units1
  flows = true
  while flows
    sx, sy = 500, 0
    while true
      if !(sy + 1 == floor + 2 || (sx, sy + 1) in blocks)
        sx, sy = sx, sy + 1
        continue
      elseif !(sy + 1 == floor + 2 || (sx - 1, sy + 1) in blocks)
        sx, sy = sx - 1, sy + 1
        continue
      elseif !(sy + 1 == floor + 2 || (sx + 1, sy + 1) in blocks)
        sx, sy = sx + 1, sy + 1
        continue
      end

      push!(blocks, (sx, sy))
      units2 += 1
      break
    end

    if sx == 500 && sy == 0
      flows = false
      break
    end
  end

  units1, units2
end

end # module Day14
