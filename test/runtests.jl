using AOC2022
using Printf

for i in 1:7
  s = @sprintf("# Day %2i #", i)
  l = length(s)
  println("#"^l)
  println(s)
  println("#"^l)
  println(getfield(AOC2022, Symbol("day$i"))())
  println()
end
