module Day4

using AOC2022.Helpers
export day4

function day4()
  filename = getFilename(4)

  inclusions = 0
  overlaps = 0

  for line in eachline(filename)
    dash1 = findfirst('-', line)
    dash2 = findlast('-', line)
    comma = findfirst(',', line)
    a = parse(Int, line[1:dash1-1])
    b = parse(Int, line[dash1+1:comma-1])
    c = parse(Int, line[comma+1:dash2-1])
    d = parse(Int, line[dash2+1:end])

    if (a <= c <= d <= b) || (c <= a <= b <= d)
      inclusions += 1
    end
    if !(b < c || d < a)
      overlaps += 1
    end
  end

  inclusions, overlaps
end

end # module Day4
