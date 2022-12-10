module Day7

using AOC2022.Helpers
export day7

mutable struct Folder
  size::Int
  parent::Union{Folder,Nothing}
  subfolders::Dict{String,Folder}

  function Folder(parent::Union{Folder,Nothing}=nothing)
    new(0, parent, Dict{String,Folder}())
  end
end

Base.size(folder::Folder) = folder.size
subfolders(folder::Folder) = values(folder.subfolders)
addSize!(folder::Folder, size::Int) = folder.size += size

function cd(pwd::Folder, subfolder::AbstractString)
  if subfolder == ".."
    pwd.parent
  else
    if !haskey(pwd.subfolders, subfolder)
      newFolder = Folder(pwd)
      pwd.subfolders[subfolder] = newFolder
    end

    pwd.subfolders[subfolder]
  end
end

function propagateSize!(folder::Folder)
  for subfolder in subfolders(folder)
    propagateSize!(subfolder)
    addSize!(folder, size(subfolder))
  end
end

function sumLEQ(folder::Folder, bound::Int)
  sum = 0
  if size(folder) <= bound
    sum += size(folder)
  end

  for subfolder in subfolders(folder)
    sum += sumLEQ(subfolder, bound)
  end

  sum
end

function minGEQ(folder::Folder, bound::Int)
  min = -1
  if size(folder) >= bound
    min = size(folder)
  end

  for subfolder in subfolders(folder)
    m = minGEQ(subfolder, bound)
    if m > -1 && m < min
      min = m
    end
  end

  min
end

function day7()
  filename = getFilename(7)

  root = Folder()
  pwd = root

  for line in eachline(filename)
    parts = split(line)

    if parts[1][1] == '$' && parts[2] == "cd"
      subfolder = parts[3]
      pwd = cd(pwd, subfolder)
    elseif '0' <= parts[1][1] <= '9'
      size = parse(Int, parts[1])
      addSize!(pwd, size)
    end
  end

  propagateSize!(root)

  maxSize = 100000
  totalSize = 70000000
  neededSize = 30000000

  freeSize = totalSize - size(root)
  extraSize = neededSize - freeSize

  sumLEQ(root, maxSize), minGEQ(root, extraSize)
end

end # module Day7
