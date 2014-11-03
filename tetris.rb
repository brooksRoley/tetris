#!/usr/bin/env ruby
require "./tetrislib"

include TetrisLib
setup_tetris_board()

draw_board()

while(@game_active)
  draw_new_piece
  while (@active_piece[0]+4)<=9
    key = get_input()
    case(key.inspect)
    when ":up"
      # Automatic down
    when ":down"
      move(0)
    when ":left"
      move("left")
    when ":right"
      move("right")
    end
    draw_board
  end
end