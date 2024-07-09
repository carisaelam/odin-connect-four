module GameLogic
  # [-] collects user input; returns string
  def collect_input
    input = gets.chomp
    if input.strip.empty?
      puts 'Waiting for input...'
      collect_input
    else
      input
    end
  end
end

class Game
  attr_accessor :player1, :player2, :board

  include GameLogic

  def initialize
    @player1 = Player.new
    @player2 = Player.new
    @board = Board.new
    @board.game = self
  end

  # [x] displays welcome message
  def welcome_message
    puts "Welcome to Connect Four!\n\n"
  end

  # [x] assigns player names
  def assign_player_names
    print 'Player One Name: '
    @player1.name = collect_input
    print 'Player Two Name: '
    @player2.name = collect_input
    puts "Hi #{@player1.name} and #{@player2.name}!\n\n"
  end

  # [x] assigns player symbols
  def assign_player_symbols
    print 'Player One, type a symbol: '
    @player1.symbol = collect_input[0]
    print 'Player Two, type a symbol: '
    @player2.symbol = collect_input[0]
    puts "Great. #{@player1.name} is #{@player1.symbol} and #{@player2.name} is #{@player2.symbol}!\n\n"
    puts "Let's play some Connect Four!\n\n"
  end

  def start
    welcome_message
    assign_player_names
    assign_player_symbols
    @board.game_loop
    p "Winner is: #{@board.it_player.name}"
  end
end

class Player
  attr_accessor :name, :symbol

  include GameLogic

  def initialize
    @name = nil
    @symbol = nil
  end

  # [x] assigns player name
  def assign_name(name_input)
    @name = name_input
  end
end

class Board
  attr_accessor :row, :column, :board, :win, :game, :it_player

  include GameLogic

  def initialize
    @row = 6
    @column = 7
    @board = build_board
    @win = false
    @game = nil
    @it_player = nil
  end

  # Setter for game instance
  def game=(game_instance)
    @game = game_instance
    @it_player = @game.player2 if @game
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
    symbol = @it_player.symbol

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
    @win = false
    rows = (0..@row - 1).to_a
    rows.each do |num|
      true if @win

      increase_count(@board[num])
    end
    @win
  end

  # [x] checks for four like symbols in a column
  def four_vertical?
    @win = false
    vert_board = @board.transpose
    rows = (0..@row - 1).to_a
    rows.each do |num|
      true if @win

      increase_count(vert_board[num])
    end
    @win
  end

  # [x] checks for four like symbols diagonal
  def four_diagonal?
    symbol = @it_player.symbol
    rows = board.size
    cols = board[0].size

    rows.times do |row|
      cols.times do |col|
        if row <= rows - 4 && col <= cols - 4 && (0..3).all? { |i| board[row + i][col + i] == symbol }
          declare_win
          return true
        end
        if row >= 3 && col <= cols - 4 && (0..3).all? { |i| board[row - i][col + i] == symbol }
          declare_win
          return true
        end
      end
    end
  end

  # [ ] checks for any winning conditions
  def check_win?
    if four_horizontal? == true
      p 'hori win'
      true
    elsif four_vertical? == true
      p 'vert win'
      true
    elsif four_diagonal? == true
      p 'diag win'
      true
    else
      p 'false'
      false
    end
  end

  # [-] switches players
  def switch_players
    @it_player = if @it_player.nil? || @it_player == @game.player1
                   @game.player2
                 else
                   @game.player1
                 end
  end

  def game_loop
    p "loop about to begin. it player is #{it_player.name}"
    loop do
      if check_win?
        'GAME OVER....TRIGGER GAME OVER METHOD'
        declare_win
        print_board(@board)
        break
      else
        switch_players
        print_board(@board)
        print "#{it_player.name}, select a column: "
        column_choice = collect_input.to_i
        falling_piece(column_choice, it_player.symbol)
        # print_board(@board)
      end
    end
  end
end

# printed
# p game.four_diagonal?

# game = Game.new
# game.start

# # # horizontal win
# board.place_piece(0, 0, 'x')
# board.place_piece(0, 1, 'x')
# board.place_piece(0, 2, 'x')
# board.place_piece(0, 3, 'x')

# # vertical win
# board.place_piece(1, 3, 'x')
# board.place_piece(2, 3, 'x')
# board.place_piece(3, 3, 'x')
# board.place_piece(4, 3, 'x')

# diagonal win
# board.place_piece(1, 2, 'x')
# board.place_piece(2, 3, 'x')
# board.place_piece(3, 4, 'x')
# board.place_piece(4, 5, 'x')

# printed = board.print_board(board.board)
# p printed

# # p board.four_horizontal?
# # p board.four_vertical?
# # p board.four_diagonal?

# p board.check_win?
