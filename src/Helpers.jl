module Helpers

export @publishDay
export getFilename

macro publishDay(dayNumber)
  DayStr = "Day" * string(dayNumber)
  DaySym = Symbol(DayStr)
  daySym = Symbol(lowercase(DayStr))
  quote
    include($DayStr * ".jl")
    using AOC2022.$DaySym: $daySym
    export $daySym
  end |> esc
end

function getFilename(i::Int)
  joinpath(@__DIR__, "..", "assets", string(i) * ".txt")
end

end # module Helpers
