module Day12

using AOC2022.Helpers
export day12

function day12()
  filename = getFilename(12)

  nrows = countlines(filename)
  ncols = length(readline(filename))
  heights = Matrix{Int}(undef, nrows, ncols)

  startr, startc = -1, -1
  stopr, stopc = -1, -1
  row = 1
  for line in eachline(filename)
    col = 1
    for char in line
      if char == 'S'
        c = 1
        startr, startc = row, col
      elseif char == 'E'
        c = 26
        stopr, stopc = row, col
      else
        c = Int(char - 'a' + 1)
      end
      heights[row, col] = c
      col += 1
    end
    row += 1
  end

  moves = ((-1, 0), (+1, 0), (0, -1), (0, +1))

  distances = fill(-1, (nrows, ncols))
  visited = fill(false, (nrows, ncols))
  candidates = Set{Tuple{Int,Int}}()

  distances[stopr, stopc] = 0
  push!(candidates, (stopr, stopc))

  while !isempty(candidates)
    bestr, bestc, bestd = -1, -1, -1
    for (destr, destc) in candidates
      d = distances[destr, destc]
      (d == -1) && continue
      if bestd == -1 || d < bestd
        bestr, bestc, bestd = destr, destc, d
      end
    end
    delete!(candidates, (bestr, bestc))
    visited[bestr, bestc] = true
    besth = heights[bestr, bestc]

    for (mover, movec) in moves
      destr = bestr + mover
      destc = bestc + movec
      !(1 <= destr <= nrows) && continue
      !(1 <= destc <= ncols) && continue
      visited[destr, destc] && continue
      (heights[destr, destc] < besth - 1) && continue

      d = distances[destr, destc]
      if (d == -1) || (bestd + 1 < d)
        distances[destr, destc] = bestd + 1
      end

      push!(candidates, (destr, destc))
    end
  end

  distStart = distances[startr, startc]
  minDist = -1
  for row in 1:nrows
    for col in 1:ncols
      if heights[row, col] == 1
        d = distances[row, col]
        (d == -1) && continue
        if minDist == -1 || distances[row, col] < minDist
          minDist = distances[row, col]
        end
      end
    end
  end

  distStart, minDist
end

end # module Day12
