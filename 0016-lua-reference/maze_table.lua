#!/usr/bin/env lua

maze = {
  room1 = {
    south = "room3",
    east = "room2",
  },
  room2 = {
    south = "room4",
  },
  room3 = {
    east = "room4",
  },
  room4 = {
    is_end = true,
  },
}

opposites = {
  north = "south",
  south = "north",
  west = "east",
  east = "west",
  up = "down",
  down = "up",
}

-- ensure rooms join both ways
function join(maze)
  for key, room in pairs(maze) do
    for direction, other_room in pairs(room) do
      if direction ~= "is_end" then
        maze[other_room][opposites[direction]] = key
      end
    end
  end
end

function visit(maze, room)
  if maze[room].is_end then
    print("congratulations")
    return
  end

  print("You are in " .. room)
  print("You can go:")
  for key, _ in pairs(maze[room]) do
    print(" * " .. key)
  end

  local move = io.read()

  local next_room = maze[room][move]
  if not maze[room][move] then
    print("invalid move")
    next_room = room
  end
  return visit(maze, next_room)
end

join(maze)
visit(maze, "room1")
