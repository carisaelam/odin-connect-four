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
      row = 0
      column = 1
      symbol = 'x'
      board_place.place_piece(0, 1, 'x')
      expect(board_place.board[0][1]).to eq(symbol)
    end
  end
end
