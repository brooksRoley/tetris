#!/usr/bin/env ruby

module TetrisLib
  # The board is represented as an array of arrays, with 10 rows and 10 columns.
  attr_accessor :board
  attr_accessor :board_size
  attr_accessor :active_piece

  def setup_tetris_board
    self.board_size = { :x => 10, :y => 10 }
    blank_row = [0] * board_size[:x]
    self.board = board_size[:y].times.map { blank_row.dup }
    @game_active = true
  end

  # Prints the board to stdout.
  def draw_board
    puts "*" * (board.first.size + 2)
    board.each do |row|
      puts "|" + row.map { |column_value| column_value == 0 ? " " : "#" }.join + "|"
    end
    puts "*" * (board.first.size + 2)
  end

  # Returns the key that was read from stdin. Either :left, :right, :down, :up, or :unknown.
  def get_input
    begin
      original_terminal_state = `stty -g`
      # Put the terminal in raw mode so we can capture one keypress at a time instead of waiting for enter.
      `stty raw -echo`
      input = STDIN.getc
      exit if input == (ctrl_c = "\003")

      # The arrow keys are read as escaped sequences of 3 characters. If the first character we read is the
      # beginning of an escape sequence, read until we have the full escape sequence.
      input += (STDIN.getc + STDIN.getc) if input == "\e"

      recognized_keys = { "\e[D" => :left, "\e[B" => :down, "\e[C" => :right, "\e[A" => :up }
      return recognized_keys[input] || :unknown
    ensure
      system `stty #{original_terminal_state}`
      print "\n"
    end
  end

  # Brooks' Functions
  def draw_new_piece
    @shape = Shapes::COLLECTION.sample
    @active_piece = [0, 3]
    4.times{|row|
      board[row][3..6] = @shape[row]
    }
  end

  def clear_piece
    x = @active_piece[0]
    y = @active_piece[1]
    (x..x+3).each{|row|
      (y..y+3).each{|col|
        board[row][col] = 0
      }
    }
  end

  def draw_piece()
    x = @active_piece[0]
    y = @active_piece[1]
    (x..x+3).each{|row|
      (y..y+3).each{|col|
        board[row][col] = @shape[row-x][col-y]
      }
    }

    p @active_piece
  end

  def move(direction)
    clear_piece

    if direction == "right"
      if(@active_piece[1]<6)
        next_col = @active_piece[1]+1
        @active_piece[1] = next_col
      end
    end

    if direction == "left"
      if(@active_piece[1]>0)
        next_col = @active_piece[1]-1
        @active_piece[1]=next_col
      end
    end

    move_down
    draw_piece
  end

  def move_down
    @active_piece[0]+=1
  end

  def vertical_collission_detection(next_col)
    # If the Board piece below the active piece == "#", There was Collision and move to the next iteration of the outer while loop(Next Piece)
  end

  def horizontal_collission_detection(next_col)
    # If the piece to either side of HCD is "#", return true, there was a collision, and the Move function will continue to move down but NOT to the side.
    false
  end

  def clear_complete_row
  end

  def increment_score
  end

  def rotate_piece
  end

  def game_over
  end

end

module Shapes
  SQUARE =
  [[0, 0, 0, 0],
  [0, 1, 1, 0],
  [0, 1, 1, 0],
  [0, 0, 0, 0]]

  J =
  [[0, 0, 0, 0],
  [1, 1, 1, 0],
  [0, 0, 1zzzzz, 0],
  [0, 0, 0, 0]]

  I =
  [[0, 1, 0, 0],
  [0, 1, 0, 0],
  [0, 1, 0, 0],
  [0, 1, 0, 0]]

  L =
  [[0, 0, 0, 0],
  [1, 1, 1, 0],
  [1, 0, 0, 0],
  [0, 0, 0, 0]]

  S =
  [[0, 0, 0, 0],
  [0, 0, 0, 0],
  [1, 1, 0, 0],
  [0, 0, 1, 1]]

  Z =
  [[0, 0, 0, 0],
  [0, 0, 0, 0],
  [0, 0, 1, 1],
  [1, 1, 0, 0]]

  T =
  [[0, 0, 0, 0],
  [0, 0, 0, 0],
  [0, 1, 0, 0],
  [1, 1, 1, 0]]


  COLLECTION = [SQUARE, L, I, J, S, T, Z]

end


