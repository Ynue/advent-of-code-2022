module Day2

using AOC2022.Helpers
export day2

const letter2figure = Dict(
  'A' => 1,
  'B' => 2,
  'C' => 3,
  'X' => 1,
  'Y' => 2,
  'Z' => 3,
)

const figure2score = Dict(
  1 => 1,
  2 => 2,
  3 => 3,
)

const winner2score = Dict(
  -1 => 0,
  0 => 3,
  +1 => 6
)

function _score1(p, q)
  figure = q
  winner = mod(q - p + 1, 3) - 1
  figure2score[figure] + winner2score[winner]
end

function _score2(p, q)
  figure = mod(p + q, 3) + 1
  winner = q - 2
  figure2score[figure] + winner2score[winner]
end

function day2()
  filename = getFilename(2)
  score1, score2 = 0, 0

  for line in readlines(filename)
    p = letter2figure[line[1]]
    q = letter2figure[line[3]]

    score1 += _score1(p, q)
    score2 += _score2(p, q)
  end

  score1, score2
end

end # module Day2
