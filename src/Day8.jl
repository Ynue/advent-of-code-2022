module Day8

using AOC2022.Helpers
export day8

function visibilityScore(heights)
  nrows, ncols = size(heights)
  visibles = map(_ -> false, heights)

  # Top
  visibles[1, 1:end] .= true
  for col in 1:ncols
    highest = heights[1, col]
    for row in 2:nrows-1
      if heights[row, col] > highest
        highest = heights[row, col]
        visibles[row, col] = true
      end
    end
  end
  # Bottom
  visibles[end, 1:end] .= true
  for col in 1:ncols
    highest = heights[end, col]
    for row in nrows-1:-1:2
      if heights[row, col] > highest
        highest = heights[row, col]
        visibles[row, col] = true
      end
    end
  end

  # Left
  visibles[1:end, 1] .= true
  for row in 1:nrows
    highest = heights[row, 1]
    for col in 2:ncols-1
      if heights[row, col] > highest
        highest = heights[row, col]
        visibles[row, col] = true
      end
    end
  end
  # Right
  visibles[1:end, end] .= true
  for row in 1:nrows
    highest = heights[row, end]
    for col in ncols-1:-1:2
      if heights[row, col] > highest
        highest = heights[row, col]
        visibles[row, col] = true
      end
    end
  end

  count(visibles)
end

function scenicScore(heights, nrows, ncols, row, col)
  height = heights[row, col]

  left = 1
  while col - left > 1 && heights[row, col-left] < height
    left += 1
  end

  top = 1
  while row - top > 1 && heights[row-top, col] < height
    top += 1
  end

  right = 1
  while col + right < ncols && heights[row, col+right] < height
    right += 1
  end

  bottom = 1
  while row + bottom < nrows && heights[row+bottom, col] < height
    bottom += 1
  end

  left * top * right * bottom
end

function maxScenicScore(heights)
  nrows, ncols = size(heights)

  maxScore = 0
  for row in 2:nrows-1
    for col in 2:ncols-1
      score = scenicScore(heights, nrows, ncols, row, col)
      if score > maxScore
        maxScore = score
      end
    end
  end

  maxScore
end

function day8()
  filename = getFilename(8)
  nrows = countlines(filename)
  ncols = length(readline(filename))
  heights = Matrix{Int8}(undef, nrows, ncols)

  for (row, line) in enumerate(eachline(filename))
    for (col, height) in enumerate(line)
      heights[row, col] = parse(Int8, height)
    end
  end

  visibilityScore(heights), maxScenicScore(heights)
end

end # module Day8
