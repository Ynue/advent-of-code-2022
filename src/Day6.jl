module Day6

using AOC2022.Helpers
using DataStructures
export day6

function countUnique(dict)
  sum(el -> el[2] > 0 ? 1 : 0, dict)
end

function day6()
  filename = getFilename(6)
  file = open(filename, "r")

  idx = 0

  # Represent a word as
  # * size (Int)
  # * index where it starts (Int)
  # * content of the word (Queue)
  # * count of each letter (Dict)
  # Using a dict to count the number of unique characters
  # is more efficient than creating the set of unique chars at each iteration
  # (would replace countUnique(counts) by length(Set(word)))

  size1 = 4
  index1 = -1
  word1 = Queue{Char}()
  for _ in 1:size1
    enqueue!(word1, ' ')
  end
  count1 = Dict{Char,Int}()
  count1[' '] = size1
  for i in 0:25
    count1['a'+i] = 0
  end

  size2 = 14
  index2 = -1
  word2 = Queue{Char}()
  for _ in 1:size2
    enqueue!(word2, ' ')
  end
  count2 = Dict{Char,Int}()
  count2[' '] = size2
  for i in 0:25
    count2['a'+i] = 0
  end

  while !eof(file)
    n = read(file, Char)
    n == '\n' && continue
    idx += 1

    l = dequeue!(word1)
    enqueue!(word1, n)
    count1[l] -= 1
    count1[n] += 1

    l = dequeue!(word2)
    enqueue!(word2, n)
    count2[l] -= 1
    count2[n] += 1

    if idx >= size1 && index1 == -1 && countUnique(count1) == size1
      index1 = idx
    end
    (index1 == -1) && continue

    if idx >= size2 && index2 == -1 && countUnique(count2) == size2
      index2 = idx
      break
    end
  end
  close(file)
  index1, index2
end

end # module Day6
