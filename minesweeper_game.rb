require 'yaml'
require './board_class.rb'
require './tile_class.rb'

class MinesweeperGame
  
  def initialize
    puts "What size board? (small/big)"
    board_size = gets.chomp.downcase
    @board = Board.new(board_size)
    
    play
  end

  def is_bomb?(tile)
    tile.bomb #true or false value
  end

  def reveal(tile)
    tile.explore
    tile.flagged = false
  end

  def flag(tile)
    if @board.num_flagged >= @board.num_mines
      puts "You're out of flags!"
    else
      tile.flagged = true
    end
  end

  def winning?
    @board.player_wins?
  end
  
  def save_game
    puts "Save as? (enter file name)"
    filename = gets.chomp.downcase
    
    File.write(filename, YAML.dump(self))
    
    puts "Now hit ctrl-c"
    while true
      loop_gives_time_to_quit = true
    end
  end

  def play
    game_over = false
    until game_over
      @board.render
      
      # puts "Save here? (y/n)"
      # save_game if gets.chomp.downcase == "y"
      
      puts "Which tile? (row, tile)"
      tile_position = gets.chomp.split(", ")
      tile_position.map! {|el| el.to_i }
      tile = @board.tiles[tile_position[0]][tile_position[1]]

      puts "Flag or reveal? (f/r)"
      action = gets.chomp.downcase
        case action
        when "f"
          flag(tile)
        when "r"
          game_over = true if is_bomb?(tile)
          reveal(tile)
        end
      if winning?
        @board.final_render
        return "You win!"
      end
    end
    
    @board.final_render
    puts "BOMB!"
    puts "Game over."
  end

end


if $PROGRAM_NAME == __FILE__
  #running this as a script
  
  if ARGV[0].nil?
    new_game = MinesweeperGame.new
  else
    YAML.load_file(ARGV[0]).play
  end
  
end
