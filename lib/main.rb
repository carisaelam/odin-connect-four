class Game
  attr_accessor :player1, :player2, :board

  def initialize
    @player1 = Player.new
    @player2 = Player.new
  end

  # [x] displays welcome message
  def welcome_message
    puts 'Welcome to Connect Four!'
  end

  # [-] collects user input; returns string
  def collect_input
    gets.chomp
  end
end

class Player
  attr_accessor :name

  def initialize
    @name = nil
  end

  # [x] assigns player name
  def assign_name(name_input)
    @name = name_input
  end
end

class Board
  attr_accessor :row, :column, :board, :win

  def initialize
    @row = 6
    @column = 7
    @board = build_board
    @win = false
  end

  # [x] builds a grid according to row/column values
  def build_board(row_count = @row, column_count = @column)
    board = Array.new(row_count) { Array.new(column_count, '.') }
  end

  # [-] prints given array of arrays
  def print_board(array)
    array.each do |row|
      puts row.join(' ')
    end
  end

  # [x] updates @board with given array
  def update_board(array)
    @board = array
  end

  # [x] updates board array at specified cell
  def place_piece(row_choice, column_choice, symbol)
    @board[row_choice][column_choice] = symbol
  end

  # [x] drops a piece in the lowest available row of given column
  def falling_piece(column_select, symbol)
    i = @row - 1
    return nil if @board[0][column_select] != '.'

    i -= 1 until @board[i][column_select] == '.' || i.zero?
    row_select = i
    @board[row_select][column_select] = symbol
  end

  # [x] updates value of @win to true
  def declare_win
    @win = true
  end

  def increase_count(row)
    count = 0
    symbol = 'x'

    row.each_with_index do |cell, idx|
      if count == 3
        declare_win
        return true
      end
      count += 1 if row[idx] == symbol && row[idx + 1] == symbol
    end
  end

  # [x] checks for four like symbols horizontally or vertically
  def four_horizontal?
    rows = (0..@row - 1).to_a
    rows.each do |num|
      true if @win

      increase_count(@board[num])
    end
    @win
  end

  # [ ] checks for four like symbols in a column
  def four_vertical?
    @board = @board.transpose
    rows = (0..@row - 1).to_a
    rows.each do |num|
      true if @win

      increase_count(@board[num])
    end
    @win
  end

  def four_diagonal?
    count = 0
    symbol = 'x'

    @board.each_with_index do |r, idx| # row of board
      r.each_with_index do |c, i|
        cell = @board[idx][i]

        if count == 3
          declare_win
          return true
        end
        if @board[idx][i] == symbol && @board[idx - 1][i + 1] == symbol
          count += 1
        elsif @board[idx][i] == symbol && @board[idx + 1][i + 1] == symbol
          count += 1
        end
      end
    end
  end
end

# game = Board.new
# board = game.board
# game.place_piece(0, 0, 'x')
# game.place_piece(1, 1, 'x')
# game.place_piece(2, 2, 'x')
# game.place_piece(3, 3, 'x')

# # game.place_piece(5, 0, 'x')
# # game.place_piece(4, 1, 'x')
# # game.place_piece(3, 2, 'x')
# # game.place_piece(2, 3, 'x')

# printed = game.print_board(board)
# printed
# p game.four_diagonal?
