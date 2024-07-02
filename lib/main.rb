class Game
  attr_accessor :player1, :player2, :board

  def initialize
    @player1 = Player.new
    @player2 = Player.new
    @board = Board.new
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
  end

  # [x] builds a grid according to row/column values
  def build_board(row_count = @row, column_count = @column)
    board = Array.new(row_count) { Array.new(column_count, '.') }
    board.each do |row|
      puts row.join(' ')
    end
  end

  def access_square(x, y)
  end
end

# new_game = Game.new
# new_game.player1.assign_name('ruby')
# new_game.player2.assign_name('java')
# p "Player one's name: #{new_game.player1.name}"
# p "Player two's name: #{new_game.player2.name}"

# new_game.board.print_board

# board_testing = Game.new
# board_testing.board.build_board
