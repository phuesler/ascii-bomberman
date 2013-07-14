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
    @board = setup_blocks(Array.new(height){Array.new(width, ' ')}, width, height)
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
      return if key.nil?
      @board[@player[:x]][@player[:y]] = ' '
      case key
        when :up
          @player[:y] = @player[:y] + 1
        when :down
          @player[:y] = @player[:y] - 1
        when :left
          @player[:x] = @player[:x] - 1
        when :right
          @player[:x] = @player[:x] + 1
        else
          raise "invalid key:#{key}"
      end
      @board[@player[:x]][@player[:y]] = 'X'
  end

  private

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

  def setup_blocks(board, width, height)
    # 0,0 is lower left corner
    board.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        if blocked_cell?(x, y, width, height)
          row[x] = STONE_BLOCK
        end
      end
    end
    board
  end

  def blocked_cell?(x, y, width, height)
    y > 0 && y < height - 1 &&
      (y + 1) % 2 == 0 &&
      x > 0 && x < width - 1 &&
      (x + 1) % 2 == 0
  end

end
