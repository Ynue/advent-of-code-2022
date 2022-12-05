module Day1

using AOC2022.Helpers
export day1

function updateState!(state, current)
  idx = searchsortedfirst(state, current)
  if idx > 1
    insert!(state, idx, current)
    popfirst!(state)
  end
end

function day1()
  filename = getFilename(1)
  topn = 3

  state = zeros(Int, topn)
  current = 0

  for line in readlines(filename)
    line = strip(line)
    if isempty(line)
      updateState!(state, current)
      current = 0
    else
      current += parse(Int, line)
    end
  end
  updateState!(state, current)

  state[end], sum(state[end-topn+1:end])
end

end # module Day1
