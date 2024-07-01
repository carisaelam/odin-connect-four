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
  describe '#print_board' do
    subject(:game_board) { described_class.new }
    context 'when given row and column values' do
      it 'prints a grid according to row and column values' do
        expected_print = <<~GRID
          . . .
          . . .
        GRID
        expect { game_board.print_board(2, 3) }.to output(expected_print).to_stdout
      end
    end

    context 'when given no row and column values' do
      it 'prints a grid according to default values' do
        expected_print = <<~GRID
          . . . . . . .
          . . . . . . .
          . . . . . . .
          . . . . . . .
          . . . . . . .
          . . . . . . .
        GRID
        expect { game_board.print_board(6, 7) }.to output(expected_print).to_stdout
      end
    end
  end
end
