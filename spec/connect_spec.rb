require 'connect'

describe ConnectFour do
  
  describe 'attributes' do 
    it { is_expected.to respond_to(:board) }
    it { is_expected.to respond_to(:bool_turn) }
  end

  describe '#put_piece' do

    context 'bad inputs' do
      
      before do
        @before = []
        @before.replace(subject.board)
      end
      context 'given empty string' do
        it 'no pieces added' do
          subject.put_piece
          expect(subject.board).to eq(@before)
        end
      end
      context 'given out of bounds' do
        it 'no pieces added' do
          subject.put_piece(20)
          expect(subject.board).to eq(@before)
        end
      end
    end

    context 'given empty row' do
      it 'add marker to bottom' do
        subject.put_piece(4)
        expect(subject.board[4][0]).to eq(subject.bool_turn)
      end
    end

    context 'given occupied row' do
      before do
        @before_row = [false, false, false]
        subject.board[3] = [false, false, false]
        subject.put_piece(3)
      end
      it "doesn't change occupied pieces" do
        expect(subject.board[3][0 .. 2]).to eq(@before_row)
      end
      it "add piece above occupied" do
        expect(subject.board[3][3]).to eq(subject.bool_turn)
      end
      it "leaves spots above empty" do 
        expect(subject.board[3][4]).to be_nil
      end
      context 'given maxed row' do
        before do 
          @before_row = [false,false,false,false,false,false]
          subject.board[3] = [false,false,false,false,false,false]
          subject.put_piece(3)
        end
        it 'no pieces added' do
          expect(subject.board[3]).to eq(@before_row)
        end
      end
    end

    context 'confirmation returns' do 
      it 'false when fail' do 
        bool_1 = subject.put_piece
        bool_2 = subject.put_piece(-3)
        subject.board[5] = [true, true, true, true, true, true]
        bool_3 = subject.put_piece(5)
        expect(bool_1 || bool_2 || bool_3).to be false
      end
      it 'true when success' do ##rspec test limit???
        expect(subject.put_piece(1)).to be true
      end
    end
  end

  describe '#play_round' do 
    context 'player' do 
      before do 
        @before_player = subject.bool_turn
      end
      it 'switches after valid play' do 
        allow(subject).to receive(:put_piece).and_return(true)
        subject.play_round
        expect(subject.bool_turn).not_to eq(@before_player)
      end
      it 'stays after failed play' do
        allow(subject).to receive(:put_piece).and_return(false)
        subject.play_round
        expect(subject.bool_turn).to eq(@before_player)
      end
    end
  end

  describe '#check_end' do 
    context 'win the game' do 
      it 'when 4 across' do 
        subject.board = [[true],[false,false],[true,true],[false,true],[true,true],[true,true],[false,false]]
        expect(subject.check_end).to eql(1)
      end
      it 'when 4 down' do 
        subject.board = [[],[],[],[],[false, true, true, true, true, false],[],[]]
        expect(subject.check_end).to eql(1)
      end
      it 'when 4 across "\"' do
        subject.board = [[],[],[true,false,true,true],[true, false, true],[false, true],[true],[]]
        expect(subject.check_end).to eql(1)
      end
      it 'when 4 across "/"' do 
        subject.board = [[],[],[true],[false, true],[true, false, true],[true,false,true,true],[]]
        expect(subject.check_end).to eql(1)
      end
    end

    context 'draw the game' do 
      it 'when all full' do
        subject.board = [[true,true,false,true,false,true],[true,true,false,true,false,true],[false,false,true,false,false,true],[false,false,true,false,true,false],[true,true,false,false,false,true],[false,true,false,true,false,true],[true,false,true,false,false,true]]
        expect(subject.check_end).to eql(2)
      end
    end
    context 'continues the game' do 
      it 'when nothing else' do 
        subject.board = [[true,true,false,true,false],[true,true,false,true,false,true],[false,false,true,false,false,true],[false,false,true,false,true,false],[true,true,false,false,false,true],[false,true,false,true,false,true],[true,false,true,false,false,true]]
        expect(subject.check_end).to eql(0)
      end
    end
  end

  describe '#game_end' do
    it 'starts new game' do 
      expect(subject).to receive(:new_game)
      subject.game_end
    end
  end

  describe '#new_game' do 
    it 'reset board' do 
      subject.board = [[],[],[true,false,true,true],[true, false, true],[false, true],[true],[]]
      subject.new_game
      expect(subject.board).to eql([[],[],[],[],[],[],[]])
    end
  end

end