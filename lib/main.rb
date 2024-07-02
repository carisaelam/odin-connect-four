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
    # board.each do |row|
    #   puts row.join(' ')
    # end
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
end

instance = Board.new
instance.place_piece(5, 1, 'x')
current_board = instance.board
instance.print_board(current_board)

