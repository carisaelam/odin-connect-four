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
  attr_accessor :row, :column, :board

  def initialize
    @row = 6
    @column = 7
    @board = build_board
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

  # [ ] checks for win
  def check_win
    four_in_a_row? ? 'win' : nil
  end

  # [ ] checks for four like symbols in a row
  def four_in_a_row?
    symbol = 'x'
    row0 = @board[0]
    count = 0
    rows = [0..@row - 1]

    row0.each_with_index do |cell, i|
      return true if count == 3

      count += 1 if row0[i] == symbol && row0[i + 1] == symbol
    end
  end
end

game = Board.new
board = game.board
game.place_piece(0, 0, 'S')
game.place_piece(0, 1, 'S')
game.place_piece(0, 2, 'S')
game.place_piece(0, 3, 'S')
game.falling_piece(0, 'x')
game.falling_piece(1, 'x')
game.falling_piece(2, 'x')
game.falling_piece(3, 'x')
printed = game.print_board(board)
printed
game.four_in_a_row?
