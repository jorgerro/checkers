require 'colorize'
require_relative 'piece'
require_relative 'board'
require_relative 'game'
require_relative 'exceptions'


#
# b = Board.new
# b.setup_board
# b[[5,2]].perform_slide([5,2],[4,3])
# b.render
# b[[4,3]].perform_slide([4,3],[3,2])
# b.render
# b[[2,1]].perform_jump([2,1],[4,3])
# b.render
# b[[5,4]].perform_jump([5,4],[3,2])
# b.render
#
# b[[3,2]].perform_slide([3,2],[4,3]) # => returns false
#
 # game = Game.setup_game.play