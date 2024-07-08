require_relative '../lib/main'

# GAME CLASS TESTS
RSpec.describe Game do
  describe '#welcome_message' do
    subject(:game_welcome) { described_class.new }
    it 'displays welcome message' do
      expect { game_welcome.welcome_message }.to output("Welcome to Connect Four!\n\n").to_stdout
    end
  end

  describe '#assign_player_names' do
    subject(:game_names) { described_class.new }
    it 'assigns @player1 collected name' do
      allow(game_names).to receive(:collect_input).and_return('Ruby', 'Java')
      game_names.assign_player_names
      expect(game_names.player1.name).to eq('Ruby')
    end

    it 'assigns @player2 collected name' do
      allow(game_names).to receive(:collect_input).and_return('Ruby', 'Java')
      game_names.assign_player_names
      expect(game_names.player2.name).to eq('Java')
    end
  end

  describe '#assign_player_symbols' do
    subject(:game_symbols) { described_class.new }
    it 'assigns @player1 collected symbol' do
      allow(game_symbols).to receive(:collect_input).and_return('1', '2')
      game_symbols.assign_player_symbols
      expect(game_symbols.player1.symbol).to eq('1')
    end

    it 'assigns @player2 collected symbol' do
      allow(game_symbols).to receive(:collect_input).and_return('1', '2')
      game_symbols.assign_player_symbols
      expect(game_symbols.player2.symbol).to eq('2')
    end

    context 'when user types more than one character' do
      subject(:game_long_symbol) { described_class.new }
      it 'assigns player the first character they typed' do
        allow(game_long_symbol).to receive(:collect_input).and_return('a;slkdj;flkasj;fsdf', '43234lkjlskjdf;lk')
        game_long_symbol.assign_player_symbols
        expect(game_long_symbol.player1.symbol).to eq('a')
      end
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

  describe '#declare_win' do
    subject(:board_declared) { described_class.new }
    before do
      board_declared.win = false
    end
    it 'updates value of @win to true' do
      result = board_declared.declare_win
      expect(board_declared.win).to be true
    end
  end

  describe '#four_horizontal?' do
    let(:board) { described_class.new }

    context 'when four like symbols are in line on the top row' do
      before do
        board.board[0][0] = 'x'
        board.board[0][1] = 'x'
        board.board[0][2] = 'x'
        board.board[0][3] = 'x'
        board.it_player = double('Player', symbol: 'x')
      end

      it 'returns true' do
        expect(board.four_horizontal?).to eq(true)
      end
    end

    context 'when four like symbols are in line on the top row at the end' do
      before do
        board.board[0][3] = 'x'
        board.board[0][4] = 'x'
        board.board[0][5] = 'x'
        board.board[0][6] = 'x'
        board.it_player = double('Player', symbol: 'x')
      end

      it 'returns true' do
        expect(board.four_horizontal?).to eq(true)
      end
    end

    context 'when four like symbols are in line on the bottom row' do
      before do
        board.board[5][0] = 'x'
        board.board[5][1] = 'x'
        board.board[5][2] = 'x'
        board.board[5][3] = 'x'
        board.it_player = double('Player', symbol: 'x')
      end

      it 'returns true' do
        expect(board.four_horizontal?).to eq(true)
      end
    end
  end

  describe '#four_vertical?' do
    context 'when four like symbols are in first column' do
      subject(:board_vert) { described_class.new }
      before do
        board_vert.board[0][0] = 'x'
        board_vert.board[1][0] = 'x'
        board_vert.board[2][0] = 'x'
        board_vert.board[3][0] = 'x'
        board_vert.it_player = double('Player', symbol: 'x')
      end
      it 'returns true' do
        expect(board_vert.four_vertical?).to eq(true)
      end
    end

    context 'when four in first column at end' do
      subject(:board_vert) { described_class.new }
      before do
        board_vert.board[2][0] = 'x'
        board_vert.board[3][0] = 'x'
        board_vert.board[4][0] = 'x'
        board_vert.board[5][0] = 'x'
        board_vert.it_player = double('Player', symbol: 'x')
      end
      it 'returns true' do
        expect(board_vert.four_vertical?).to eq(true)
      end
    end

    context 'when four like symbols are in last column' do
      subject(:board_vert) { described_class.new }
      before do
        board_vert.board[0][5] = 'x'
        board_vert.board[1][5] = 'x'
        board_vert.board[2][5] = 'x'
        board_vert.board[3][5] = 'x'
        board_vert.it_player = double('Player', symbol: 'x')
      end
      it 'returns true' do
        expect(board_vert.four_vertical?).to be(true)
      end
    end
  end

  describe '#four_diagonal?' do
    context 'when four are up and to the right' do
      subject(:board_diag) { described_class.new }
      before do
        board_diag.board[5][0] = 'x'
        board_diag.board[4][1] = 'x'
        board_diag.board[3][2] = 'x'
        board_diag.board[2][3] = 'x'
        board_diag.it_player = double('Player', symbol: 'x')
      end
      it 'returns true' do
        expect(board_diag.four_diagonal?).to be true
      end
    end
    context 'when four are down and to the right' do
      subject(:board_diag_down) { described_class.new }
      before do
        board_diag_down.board[0][0] = 'x'
        board_diag_down.board[1][1] = 'x'
        board_diag_down.board[2][2] = 'x'
        board_diag_down.board[3][3] = 'x'
        board_diag_down.it_player = double('Player', symbol: 'x')
      end
      it 'returns true' do
        expect(board_diag_down.four_diagonal?).to be true
      end
    end

    context 'when four are down and right at bottom' do
      subject(:board_diag_bottom) { described_class.new }
      before do
        board_diag_bottom.board[2][3] = 'x'
        board_diag_bottom.board[3][4] = 'x'
        board_diag_bottom.board[4][5] = 'x'
        board_diag_bottom.board[5][6] = 'x'
        board_diag_bottom.it_player = double('Player', symbol: 'x')
      end
      it 'returns true' do
        expect(board_diag_bottom.four_diagonal?).to be true
      end
    end
  end

  # describe '#check_win?' do
  #   context 'if horizontal win' do
  #     subject(:board_h_win) { described_class.new }
  #     before do
  #       board_h_win.four_horizontal? == true
  #     end
  #     it 'checks for any winning condition' do
  #       expect(board_h_win.check_win?).to be true
  #     end
  #   end
  #   context 'if vertical win' do
  #     subject(:board_v_win) { described_class.new }

  #     before do
  #       board_v_win.four_vertical? == true
  #     end
  #     it 'checks for any winning condition' do
  #       expect(board_v_win.check_win?).to be true
  #     end
  #   end
  #   context 'if diagonal win' do
  #     subject(:board_d_win) { described_class.new }

  #     before do
  #       board_d_win.four_diagonal? == true
  #     end
  #     it 'checks for any winning condition' do
  #       expect(board_d_win.check_win?).to be true
  #     end
  #   end
  #   context 'if no win' do
  #     subject(:board_no_win) { described_class.new }

  #     before do
  #       board_no_win.four_horizontal? == false &&
  #         board_no_win.four_vertical? == false &&
  #         board_no_win.four_diagonal? == false
  #     end
  #     it 'checks for any winning condition' do
  #       expect(board_no_win.check_win?).to be false
  #     end
  #   end
  # end
end
