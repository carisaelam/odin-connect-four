# frozen_string_literal: true

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
    @player1.name = collect_input.strip.capitalize
    print 'Player Two Name: '
    @player2.name = collect_input.strip.capitalize
    puts "Hi #{@player1.name} and #{@player2.name}!\n\n"
  end

  # [x] assigns player symbols
  def assign_player_symbols
    print "#{player1.name}, type a symbol: "
    player1.symbol = collect_input[0]
    print "#{player2.name}, type a symbol: "
    player2.symbol = collect_input[0]
    puts "Great. #{player1.name} is #{player1.symbol} and #{player2.name} is #{player2.symbol}!\n\n"
    puts "Let's play some Connect Four!\n\n"
  end

  def restart
    new_game = Game.new
    new_game.start
  end

  def play_again
    puts '  '
    print 'Play again? Y/N: '
    gets.chomp.upcase == 'Y' ? restart : return
  end

  def start
    welcome_message
    assign_player_names
    assign_player_symbols
    board.game_loop
    p "Winner is: #{board.it_player.name}"
    play_again
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
  attr_accessor :row, :column, :board, :win, :it_player

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
    Array.new(row_count) { Array.new(column_count, '.') }
  end

  # [-] prints given array of arrays
  def print_board(array)
    puts ' '
    array.each do |row|
      puts row.join(' ')
    end
    puts (1..column).to_a.join(' ')
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
    return nil if @board[0][column_select - 1] != '.'

    i -= 1 until @board[i][column_select - 1] == '.' || i.zero?
    row_select = i
    @board[row_select][column_select - 1] = symbol
  end

  # [x] updates value of @win to true
  def declare_win
    @win = true
  end

  def increase_count(row)
    count = 0
    symbol = @it_player.symbol

    row.each_with_index do |_cell, idx|
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

  def validate_column_choice(integer)
    loop do
      return integer if integer.between?(1, column)

      puts "Pick a number between 1–#{column}"
      integer = collect_input.to_i
    end
  end

  def game_loop
    loop do
      if check_win?
        declare_win
        print_board(@board)
        break
      else
        switch_players
        print_board(@board)
        puts ' '
        print "#{it_player.name}, select a column: "
        column_choice = validate_column_choice(collect_input.to_i)
        puts "validated column choice is: #{column_choice}"
        falling_piece(column_choice, it_player.symbol)
      end
    end
  end
end

game = Game.new
game.start
