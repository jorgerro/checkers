
class Game

  attr_reader :board

  def self.setup_game
    new_board = Board.new.setup_board
    puts "Please enter a name for player 1"
      player1 = HumanPlayer.new(gets.strip, :white, new_board)
    puts "Please enter a name for player 2"
      player2 = HumanPlayer.new(gets.strip, :black, new_board)
    Game.new(player1, player2, new_board)
  end

  def initialize(player1, player2, board)
    @player1, @player2, @board = player1, player2, board
  end

  def turn(curr_player, next_player, turn_color)
    puts "#{curr_player.name}'s turn:"
    curr_player.play_turn(turn_color)
    @board.render
  end

  def play
    puts "    Let the games begin!"
    puts
    @board.render

    loop do
      break if over?(@player1.color)
      turn(@player1, @player2, @player1.color)
      break if over?(@player2.color)
      turn(@player2, @player1, @player2.color)
    end

    #@board.checkmate?(@player1.color) ? win(@player2) : win(@player1)
  end

  def over?(color)
    false
  end

  def win(player)
    puts "#{player.name} wins!"
  end

end


class HumanPlayer

  attr_reader :name, :color

  def initialize(name, color, board)
    @name, @color, @board = name, color, board
  end

  def play_turn(turn_color)
    begin
      puts "Please choose the piece you want to move, i.e. row, col"
      user_start = gets.chomp

      unless user_start =~ /^[0-7],*[0-7]$/
        raise InvalidMove.new("Double check that input!")
      end

      start_pos = user_start.split(',').map(&:to_i)

      if @board.empty?(start_pos)
        raise InvalidMove.new("There's no piece there!")
      end

      puts "Please input the moves you would like to make,"
      puts "i.e. row number, col number / row number, col number"

      user_moves = gets.chomp.split('/')

      input_array = []
      user_moves.each do |string|
        input_array << string.strip.split(',').map(&:to_i)
      end
      #puts "Look at what your program is getting! start: #{start_pos}::#{input_array}"
      @board[start_pos].perform_moves(input_array, @color)
    rescue StandardError => e
        puts "Error: #{e.message}"
    retry
    end
    puts
  end



end