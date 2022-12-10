module Day9

using AOC2022.Helpers
export day9

function moveHead!(direction, knots)
  if direction == 'L'
    knots[1] -= 1
  elseif direction == 'R'
    knots[1] += 1
  elseif direction == 'U'
    knots[2] += 1
  elseif direction == 'D'
    knots[2] -= 1
  end
end

function moveTail!(knots, k)
  xh, yh = knots[2*k-1], knots[2*k]
  xt, yt = knots[2*(k+1)-1], knots[2*(k+1)]
  dx, dy = abs(xt - xh), abs(yt - yh)

  if dx == 2 && dy == 2
    knots[2*(k+1)-1] = div(xt + xh, 2)
    knots[2*(k+1)] = div(yt + yh, 2)
  elseif dx == 2
    knots[2*(k+1)-1] = div(xt + xh, 2)
    knots[2*(k+1)] = knots[2*k]
  elseif dy == 2
    knots[2*(k+1)-1] = knots[2*k-1]
    knots[2*(k+1)] = div(yt + yh, 2)
  end
end

function simulate(filename, nknots)
  knots = zeros(Int, 2 * nknots)
  visited = Set{Tuple{Int,Int}}()

  for line in eachline(filename)
    direction = line[1]
    steps = parse(Int, line[3:end])

    for _ in 1:steps
      moveHead!(direction, knots)

      for k in 1:nknots-1
        moveTail!(knots, k)
      end

      push!(visited, (knots[end-1], knots[end]))
    end
  end

  length(visited)
end

function day9()
  filename = getFilename(9)

  simulate(filename, 2), simulate(filename, 10)
end

end # module Day9
