

class Board

  attr_accessor :grid

  def initialize(grid = nil)
    @grid = new_board
  end

  def new_board
    Array.new(8) { Array.new(8) }
  end

  def [](pos)
    row, col = pos
    self.grid[row][col]
  end

  def []=(position, object)
    row, col = position
    self.grid[row][col] = object
  end

  def empty?(pos)
    self[pos].nil?
  end

  def dup
    new_board = Board.new
    self.grid.flatten.compact.each do |piece|
      new_board[piece.position] = Piece.new(piece.position.dup, piece.color, new_board, piece.king)
    end
    new_board
  end

  def setup_board
    square_counter = 0
    @grid.each_with_index do |array, row|
      next if row == 3 || row == 4
      square_counter += 1
      array.each_with_index do |square, col|
        piece_color = row < 3 ? :black : :white
          if square_counter % 2 == 0 && piece_color == :black
            self[[row,col]] = Piece.new([row,col], piece_color, self)
          elsif square_counter % 2 == 0 && piece_color == :white
            self[[row,col]] = Piece.new([row,col], piece_color, self)
          end
        square_counter +=1
      end
    end
    self
  end

  def piece_color(square, unicode, bg_color, piece_color)
    print " #{unicode} ".colorize(:color => piece_color, :background => bg_color)
  end

  def square_color(square, bg_color)
    if square.nil?
      print "   ".colorize(:background => bg_color)
    else
      if square.color == :black
        piece_color(square, "\u25ef", bg_color, :white)
      else
        piece_color(square, "\u25Cd", bg_color, :white)
      end
    end
  end

  def render
    puts
    print "   0  1  2  3  4  5  6  7 \n"
    color_counter = 0
    row_counter = 0
    self.grid.each_with_index do |array, row|
      print "#{row_counter} "
      color_counter += 1
      array.each_with_index do |square, col|
        if color_counter.even?
          square_color(square, :black)
        else
          square_color(square, :light_red)
        end
        color_counter += 1
      end
      puts
      row_counter += 1
    end
    puts
  end

  # !! Still need to make kings look different from pawns
  # Still need a win condition
  # Need to test multiple jumping move functionality
  # Needs some healthy refactoring



end





















