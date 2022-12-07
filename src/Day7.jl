module Day7

using AOC2022.Helpers
export day7

function day7()
  filename = getFilename(7)

  path = String[]
  sizeDict = Dict{String,Int}()

  for line in readlines(filename)
    parts = split(line)
    if parts[1] == "\$" && parts[2] == "cd"
      if parts[3] == ".."
        pop!(path)
      else
        push!(path, parts[3])
      end

      prefix = ""
      for folder in path
        prefix *= folder * "/"
        if !haskey(sizeDict, prefix)
          sizeDict[prefix] = 0
        end
      end

    elseif '0' <= parts[1][1] <= '9'
      size = parse(Int, parts[1])

      prefix = ""
      for folder in path
        prefix *= folder *= "/"
        sizeDict[prefix] += size
      end
    end
  end
  maxSize = 100000
  totalSize = 70000000
  neededSize = 30000000

  freeSize = totalSize - sizeDict["//"]
  extraSize = neededSize - freeSize

  sum = 0
  min = -1
  for (_, value) in sizeDict
    if value <= maxSize
      sum += value
    end

    if value >= extraSize
      if min == -1 || value <= min
        min = value
      end
    end
  end

  sum, min
end

end # module Day7

# 1118405
