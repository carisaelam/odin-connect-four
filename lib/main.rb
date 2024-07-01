class Game
  attr_accessor :player1, :player2, :board

  def initialize
    @player1 = Player.new
    @player2 = Player.new
    @board = Board.new
  end

  # ✅ displays welcome message
  def welcome_message
    puts 'Welcome to Connect Four!'
  end

  # no test needed
  def collect_input
    gets.chomp
  end
end

class Player
  attr_accessor :name

  def initialize
    @name = nil
  end

  # ✅ assigns name
  def assign_name(name_input)
    @name = name_input
  end
end

class Board
  attr_accessor :row, :column

  def initialize
    @row = 6
    @column = 7
  end

  def print_board(row_count = @row, column_count = @column)
    row_count.times do
      puts Array.new(column_count, '.').join(' ')
    end
  end
end

# new_game = Game.new
# new_game.player1.assign_name('ruby')
# new_game.player2.assign_name('java')
# p "Player one's name: #{new_game.player1.name}"
# p "Player two's name: #{new_game.player2.name}"

# new_game.board.print_board
