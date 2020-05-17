#!/usr/bin/env lua

function sort_by_grade(names, grades)
  table.sort(names, function(n1, n2)
    return grades[n1] > grades[n2] -- compare the grades
  end)
end

names = {"Peter", "Paul", "Mary"}
grades = {Mary = 10, Paul = 7, Peter = 8}

sort_by_grade(names, grades)

for _, name in ipairs(names) do
  print(name)
end
