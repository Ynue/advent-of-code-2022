module Day3

using AOC2022.Helpers
export day3

function priority(c)
  if 'a' <= c <= 'z'
    Int(c - 'a' + 1)
  else
    Int(c - 'A' + 27)
  end
end

function day3()
  filename = getFilename(3)

  compartments = zeros(Int, 52)
  Σcompartments = 0

  badges = ones(Int, 52)
  Σbadges = 0
  cycle = -1

  for line in readlines(filename)
    line = strip(line)
    N = length(line)
    n = div(N, 2)

    # Compartments
    # Mark item as seen once from the left side
    # If it is seen from the right side, we found which is repeated
    compartments .= 0

    # Left
    for i in 1:n
      item = line[i]
      p = priority(item)

      compartments[p] = 1
    end

    # Right
    for i in n+1:N
      item = line[i]
      p = priority(item)

      if (compartments[p] == 1)
        Σcompartments += p
        break
      end
    end

    # Badges
    cycle = mod(cycle + 1, 3)
    if cycle == 0
      badges .= 1
    end

    # Use prime decomposition to tag each item:
    # badges[i] = 2^a * 3^b * 5*c
    # Multiply by 2 for first person, 3 for second and 5 for third
    # An item is found three times whenever a, b, c > 0
    # Which is true whenever badges[i] is divisible by 30
    prime = 2
    if cycle == 1
      prime = 3
    elseif cycle == 2
      prime = 5
    end

    for i in 1:N
      item = line[i]
      p = priority(item)

      badges[p] *= prime

      if mod(badges[p], 30) == 0
        Σbadges += p
        break
      end
    end

  end

  Σcompartments, Σbadges
end

end # module Day3
