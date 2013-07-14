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
  end

  def game_over
    Curses.setpos(0, 0)
    Curses.addstr("GAME OVER");
    Curses.refresh
  end

  # we need to drow from top to bottom
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

  def update(state = {})
    clean_board
    update_bombs(state[:bombs] || [])
    update_powerups(state[:power_ups] || [])
    update_boxes(state[:boxes] || [])
    update_players(state[:players] || [])
    display
  end

  private

  def update_bombs(bombs)
    bombs.each do |bomb|
      @board[bomb[:y]][bomb[:x]] = BOMB
    end
  end

  def update_powerups(power_ups)
    power_ups.each do |power_up|
      if(power_up[:type] == "bomb")
        @board[power_up[:y]][power_up[:x]] = POWER_UP_BOMB
      else
        @board[power_up[:y]][power_up[:x]] = POWER_UP_FIRE
      end
    end
  end

  def update_players(players)
    players.each_with_index do |player, index|
      if player[:state] == 'alive'
        @board[player[:y]][player[:x]] = "#{PLAYER}#{index}"
      else
        @board[player[:y]][player[:x]] = ' '
      end
    end
  end

  def update_boxes(boxes)
    boxes.each do |box|
      @board[box[:y]][box[:x]] = MUD
    end
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

  def clean_board
    @board.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        unless cell == STONE_BLOCK
          row[x] = ' '
        end
      end
    end
  end

end
