require 'curses'

class Game

  PLAYER = 'X'
  BOMB = '$'
  POWER_UP_BOMB = 'PB'
  POWER_UP_FIRE = 'BF'
  STONE_BLOCK = '#'
  MUD = '='
  ROW_SEPARATOR = '-'

  def initialize(width, height)
    @width = width
    @height = height
    @board = setup_blocks(Array.new(height){Array.new(width, ' ')})
    @player = {x: 0, y: 0}
    @board[0][0] = PLAYER
  end

  # we need to draw from top to bottom
  # however 0,0 is on the lower, left
  # reverse the row indices
  def display
    data = []
    data << "\n"
    data << row_border

    y = @height - 1
    until y < 0 do
      data << draw_row(@board[y])
      data << row_border
      y -= 1
    end
    data << Time.now.to_s
    Curses.setpos(0, 0)
    Curses.addstr(data.join("\n"));
    Curses.refresh
  end

  def update(key)
    apply_player_actions(key)
  end

  private

  def apply_player_actions(key)
      new_position = case key
        when :up
          {x: @player[:x], y: @player[:y] + 1}
        when :down
          {x: @player[:x], y: @player[:y] - 1}
        when :left
          {x: @player[:x] - 1, y: @player[:y]}
        when :right
          {x: @player[:x] + 1, y: @player[:y]}
        else
          @player
        end
      if valid_move?(new_position)
        @board[@player[:y]][@player[:x]] = ' '
        @board[new_position[:y]][new_position[:x]] = 'X'
        @player = new_position
      end
  end

  def valid_move?(position)
      x = position[:x]
      y = position[:y]
      x >= 0 && x < @width && y >= 0 && y < @height && !blocked_cell?(x,y)
  end

  def draw_row(cols)
    s = "|"
    cols.each do |cell|
      s << " #{cell.rjust(2," ")} |"
    end
    s
  end

  def row_border
    "".rjust(@width * 5 + 1, "-")
  end

  def setup_blocks(board)
    # 0,0 is lower left corner
    board.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        if blocked_cell?(x, y)
          row[x] = STONE_BLOCK
        end
      end
    end
    board
  end

  def blocked_cell?(x, y)
    y > 0 && y < @height - 1 &&
      (y + 1) % 2 == 0 &&
      x > 0 && x < @width - 1 &&
      (x + 1) % 2 == 0
  end

end
