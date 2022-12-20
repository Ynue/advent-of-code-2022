module Day15

using AOC2022.Helpers
export day15

function distance(sx, sy, bx, by)
  abs(sx - bx) + abs(sy - by)
end

function day15()
  filename = getFilename(15)

  beacons = Set{NTuple{2,Int}}()
  coords = Vector{NTuple{4,Int}}()
  for line in eachline(filename)
    matches = match(r"Sensor at x=(?<sx>[^\s]+), y=(?<sy>[^\s]+): closest beacon is at x=(?<bx>[^\s]+), y=(?<by>[^\s]+)", line)
    sx, sy, bx, by = matches.captures
    sx = parse(Int, sx)
    sy = parse(Int, sy)
    bx = parse(Int, bx)
    by = parse(Int, by)
    push!(coords, (sx, sy, bx, by))
    push!(beacons, (bx, by))
  end

  H = 2000000

  intervals = Vector{UnitRange{Int}}()
  for (sx, sy, bx, by) in coords
    d = distance(sx, sy, bx, by)
    o = d - abs(sy - H)
    (o < 0) && continue
    push!(intervals, sx-o:sx+o)
  end
  sort!(intervals)

  mergedIntervals = Vector{UnitRange{Int}}()
  for interval in intervals
    if isempty(mergedIntervals)
      push!(mergedIntervals, interval)
      continue
    end

    lastInterval = mergedIntervals[end]
    lastStart = lastInterval.start
    lastStop = lastInterval.stop

    start = interval.start
    stop = interval.stop

    if start > lastStop + 1
      push!(mergedIntervals, interval)
    else
      mergedIntervals[end] = lastStart:max(stop, lastStop)
    end
  end

  impossible = 0
  for interval in mergedIntervals
    impossible += length(interval)
  end

  for (bx, by) in beacons
    !(by == H) && continue
    for interval in mergedIntervals
      if bx in interval
        impossible -= 1
        break
      end
    end
  end

  signal = -1
  H = 4000000

  l = length(coords)
  for k₁ in 1:l
    for k₂ in k₁+1:l
      x₁, y₁, bx₁, by₁ = coords[k₁]
      x₂, y₂, bx₂, by₂ = coords[k₂]
      d₁ = distance(x₁, y₁, bx₁, by₁) + 1
      d₂ = distance(x₂, y₂, bx₂, by₂) + 1

      # |x - x₁| + |y - y₁| = d₁
      # |x - x₂| + |y - y₂| = d₂

      # x = x̄ ε₁ d̄ ε₁ε₂ Δy
      # y = ȳ ε₂ Δd ε₁ε₂ Δx
      # OR
      # x = x̄ ε₁ Δd ε₁ε₂ Δy
      # y = ȳ ε₂ d̄ ε₁ε₂ Δx

      for ε₁ in (-1, +1)
        for ε₂ in (-1, +1)
          for (dx, dy) in ((d₁ + d₂, d₂ - d₁), (d₂ - d₁, d₁ + d₂))
            x = div(x₁ + x₂ + ε₁ * dx + ε₁ * ε₂ * (y₂ - y₁), 2)
            y = div(y₁ + y₂ + ε₂ * dy + ε₁ * ε₂ * (x₂ - x₁), 2)

            if (0 <= x <= H) && (0 <= y <= H)
              hold = true
              for (sx, sy, bx, by) in coords
                if distance(sx, sy, bx, by) >= distance(sx, sy, x, y)
                  hold = false
                  break
                end
              end
              if hold
                signal = x * H + y
                break
              end
            end
          end

          (signal != -1) && break
        end
        (signal != -1) && break
      end
    end
  end

  impossible, signal
end

end # module Day15
