require_relative '../lib/main'

# GAME CLASS TESTS
RSpec.describe Game do
  describe '#welcome_message' do
    subject(:game_welcome) { described_class.new }
    it 'displays welcome message' do
      expect { game_welcome.welcome_message }.to output("Welcome to Connect Four!\n").to_stdout
    end
  end
end

# PLAYER CLASS TESTS
RSpec.describe Player do
  describe '#assign_name' do
    let(:player1) { described_class.new }
    it 'updates player1 name' do
      input = 'Ruby'
      player1.assign_name(input)
      expect(player1.name).to eq('Ruby')
    end

    let(:player2) { described_class.new }
    it 'updates player2 name' do
      input = 'Java'
      player2.assign_name(input)
      expect(player2.name).to eq('Java')
    end
  end
end

# BOARD CLASS TESTS
RSpec.describe Board do
  describe '#build_board' do
    subject(:game_board) { described_class.new }
    context 'when given row and column values' do
      it 'builds a grid according to row and column values' do
        grid = Array.new(2) { Array.new(3, '.') }
        expect(game_board.build_board(2, 3)).to eq(grid)
      end
    end

    context 'when given no row and column values' do
      it 'builds a grid according to default values' do
        grid = Array.new(6) { Array.new(7, '.') }
        expect(game_board.build_board).to eq(grid)
      end
    end
  end

  describe '#update_board' do
    subject(:board_update) { described_class.new }
    it 'updates board instance variable with given array' do
      test_array = [['.', '.'], ['.', '.']]
      board_update.update_board(test_array)
      expect(board_update.board).to eq(test_array)
    end
  end

  describe '#place_piece' do
    subject(:board_place) { described_class.new }
    it 'updates board array at specified cell' do
      symbol = 'x'
      board_place.place_piece(0, 1, 'x')
      expect(board_place.board[0][1]).to eq(symbol)
    end
  end

  describe '#falling_piece' do
    subject(:board_fall) { described_class.new }
    context 'when the column is empty' do
      it 'drops a piece into the lowest row' do
        symbol = 'x'
        board_fall.falling_piece(0, 'x')
        expect(board_fall.board[5][0]).to eq(symbol)
      end
    end

    context 'when the column has one piece already' do
      before do
        board_fall.board[5][0] = 'x'
      end
      it 'drops a piece into the second lowest row' do
        symbol = 'x'
        board_fall.falling_piece(0, 'x')
        expect(board_fall.board[4][0]).to eq(symbol)
      end
    end

    context 'when the column is full' do
      before do
        board_fall.board[0][0] = 'x'
      end
      it 'returns nil' do
        symbol = 'x'
        result = board_fall.falling_piece(0, 'x')
        expect(result).to be(nil)
      end
    end
  end

  describe '#check_win' do
    subject(:board_win) { described_class.new }
    before do
      board_win.win = true
    end
    it 'returns a win when @win is true' do
      p "board win status; #{board_win.win}"
      win_status = board_win.win
      expect(win_status).to be true
    end
  end

  describe '#four_in_a_row?' do
    context 'when four like symbols are in line top row' do
      subject(:board_four) { described_class.new }
      before do
        board_four.board[0][0] = 'x'
        board_four.board[0][1] = 'x'
        board_four.board[0][2] = 'x'
        board_four.board[0][3] = 'x'
      end
      it 'returns true' do
        expect(board_four.four_in_a_row?).to eq(true)
      end
    end

    context 'when four like symbols are in line bottom row' do
      subject(:board_bottom) { described_class.new }
      before do
        board_bottom.board[5][0] = 'x'
        board_bottom.board[5][1] = 'x'
        board_bottom.board[5][2] = 'x'
        board_bottom.board[5][3] = 'x'
      end
      it 'returns true' do
        expect(board_bottom.four_in_a_row?).to eq(true)
      end
    end
  end
end
