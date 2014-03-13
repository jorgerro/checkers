

class Piece

  UP_MOVES = [
    [-1,-1],
    [-1, 1]
  ]

  DOWN_MOVES = [
    [1,-1],
    [1, 1]
  ]

  attr_reader :color, :king
  attr_accessor :position

  def initialize(position, color, board, king = false)
    @position, @color, @board = position, color, board
    @king = king
  end

  def on_board?(pos)
    pos.all? { |coord| coord.between?(0,7) }
  end

  def move_diffs
    directions = []
    if @color == :white
      directions.concat(UP_MOVES)
      directions.concat(DOWN_MOVES) if @king
    else
      directions.concat(DOWN_MOVES)
      directions.concat(UP_MOVES) if @king
    end
    directions
  end

  def find_adj(start_pos, jump_pos)
    row_s, col_s = start_pos
    row_j, col_j = jump_pos
    adj_pos = [(row_j + row_s) / 2.0, (col_j + col_s) / 2.0]
    [adj_pos, adj_pos[0] - row_s, adj_pos[1] - col_s]
  end

  def jump_possible?(start_pos, jump_pos)
    adj_pos, row_shift, col_shift = find_adj(start_pos, jump_pos)
    return false unless on_board?(adj_pos)
    return false unless on_board?(jump_pos)
    return false unless move_diffs.include?([row_shift, col_shift])
    return false unless @board[adj_pos] && @board[adj_pos].color != self.color
    return false unless @board.empty?(jump_pos)
    true
  end

  def perform_jump(start_pos, jump_pos)
    return false unless jump_possible?(start_pos, jump_pos)
    adj_pos = find_adj(start_pos, jump_pos)[0]
    @board[jump_pos] = @board[start_pos]
    @board[jump_pos].position = jump_pos
    @board[start_pos] = nil
    @board[adj_pos] = nil
  end

  def slide_possible?(start_pos, end_pos)
    row_shift = end_pos[0] - start_pos[0]
    col_shift = end_pos[1] - start_pos[1]
    return false unless on_board?(end_pos)
    return false unless move_diffs.include?([row_shift, col_shift])
    return false unless @board.empty?(end_pos)
    true
  end

  def perform_slide(start_pos, end_pos)
    return false unless slide_possible?(start_pos, end_pos)

    @board[end_pos] = @board[start_pos]
    @board[end_pos].position = end_pos
    @board[start_pos] = nil
  end

  def maybe_promote(piece)
    if piece.color == :white
      if piece.position[0] == 0
        piece.king = true
      end
    else
      if piece.position[7] == 0
        piece.king = true
      end
    end
  end

  # called like piece.perform_moves!
  # move_sequence should look something like [[4,2], [2,4]]
  def perform_moves!(move_sequence)

    if move_sequence.length < 2
      end_pos = move_sequence.first
      if slide_possible?(@position, end_pos)
        perform_slide(@position, end_pos)
      elsif jump_possible?(@position, end_pos)
        perform_jump(@position, end_pos)
      else
        raise InvalidMove.new("Invalid Slide Move: #{move_sequence.first}")
      end
    else
      start_pos ||= @position #is this right?
      move_sequence.each do |jump_pos|
        if jump_possible?(start_pos, jump_pos)
          perform_jump(start_pos, jump_pos)
          start_pos = jump_pos
        else
          raise InvalidMove.new("Invalid Jump Move: #{end_pos}")
        end
      end
    end
    true
  end

  def valid_move_seq?(move_sequence)
      @board.dup[@position].perform_moves!(move_sequence)
  end

  def perform_moves(move_sequence, color)
    raise InvalidMove.new("That's not yours to move.") if @color != color
      if valid_move_seq?(move_sequence)
        @board[@position].perform_moves!(move_sequence)
      end
  end


end















