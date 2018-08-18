require 'io/console'

class ConnectFour 
  attr_accessor :board, :bool_turn

  def initialize
    @board = [[],[],[],[],[],[],[]]
    @bool_turn = true
  end

  def put_piece(row = -1)
    if row.between?(0, 6) && @board[row].size < 6
      @board[row] << @bool_turn 
      true
    else
      false
    end
  end

  def play_round(row = -1)
    is_valid = put_piece(row)
    @bool_turn = is_valid ? !@bool_turn : @bool_turn
  end

  def check_end #returns 0 to continue, 1 if a win, 2 if a draw
    (0..3).each do |x|
      (0..5).each do |y|
        unless @board[x][y].nil?
          return 1 if [@board[x][y], @board[x+1][y], @board[x+2][y], @board[x+3][y]].uniq.length == 1

          if y - 3 >= 0
            return 1 if [@board[x][y], @board[x+1][y-1], @board[x+2][y-2], @board[x+3][y-3]].uniq.length == 1
          end
        end
      end
    end
    (0..6).each do |x|
      (0..2).each do |y|
        unless @board[x][y].nil?
           return 1 if [@board[x][y], @board[x][y+1], @board[x][y+2], @board[x][y+3]].uniq.length == 1

          if x + 3 <= 6
            return 1 if [@board[x][y], @board[x+1][y+1], @board[x+2][y+2], @board[x+3][y+3]].uniq.length == 1
          end
        end
      end
    end
    b = @board
    total = b[0].length + b[1].length + b[2].length + b[3].length + b[4].length + b[5].length + b[6].length
    if total == 42 
      2
    else
      0
    end
  end

  def game_end(result)
    system 'clr' or system 'clear'
    display_board
    if result == 2
      puts "DRAW GAME!"
    else
      @bool_turn = !@bool_turn # play_round changed players
      winner = @bool_turn ? "Player 1" : "Player 2"
      puts "#{winner} WINS!"
    end
    6.times do 
      sleep 0.5
      print '.'
    end
    new_game
  end

  def new_game
    system 'clr' or system 'clear'
    @board = [[],[],[],[],[],[],[]]
    @bool_turn = true
    puts "Press any key to start a new game, press CTRL+C to quit"
    input = STDIN.getch
    exit(1) if input == "\u0003"
    play_game
  end

  def play_game
    result = 0
    loop do
      system 'clr' or system 'clear'
      display_board
      player = @bool_turn ? "Player 1" : "Player 2"
      puts "#{player}, it's your turn! Input a valid spot"
      input = STDIN.getch
      exit(1) if input == "\u0003"
      if(input.to_i.between?(1,7))
        input = input.to_i - 1
      else
        input = -1
      end
      play_round(input) # switches the PLAYER!
      result = check_end
      break unless result == 0
    end
    game_end(result)
  end

  def display_board #TODO
    string = ''
    (0..5).to_a.reverse.each do |y|
      string += "#{y}|"
      (0..6).each do |x|
        if @board[x][y].nil?
          string += " - "
        elsif @board[x][y]
          string += " \u25CF "
        else
          string += " \u25CB "
        end
        string += "|"
      end
      string += "\n"
    end
    string +="*  1   2   3   4   5   6   7"

    puts string
  end
end
