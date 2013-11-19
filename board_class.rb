
class Board
  attr_accessor :tiles, :num_mines

  def initialize(size)

    case size
    when "small"
      @num_mines = 10
      @dimension = 9
    when "big"
      @num_mines = 40
      @dimension = 16
    end

    populate_board
    set_neighbors_all
    place_bombs
    mark_fringe_squares
  end

  def populate_board
     @tiles = []
     @dimension.times do |row|
       @tiles << []
       @dimension.times do |tile|
         @tiles[row] << make_tile([row, tile])
       end
     end
  end

  def make_tile(position)
    tile = Tile.new(position)
    tile.board = self
    tile
  end

  def set_neighbors_all
    @tiles.each do |row|
      row.each do |tile|
        set_neighors_one_tile(tile)
      end
    end
  end

  def set_neighors_one_tile(tile)
    tile_row = tile.position[0]
    tile_column = tile.position[1]


    (-1).upto(1) do |row|
      (-1).upto(1) do |column|
        next if (tile_row + row) < 0 || (tile_row + row) >= @dimension
        next if (tile_column + column) < 0 || (tile_column + column) >= @dimension

        next if @tiles[tile_row + row][tile_column + column] == tile #equality method for tile class?
        tile.neighbors << @tiles[(tile_row + row)][(tile_column + column)]
      end
    end
  end

  def place_bombs
    bomb_tiles = []
    @num_mines.times do
      rand_tile = nil

      while bomb_tiles.include?(rand_tile) || rand_tile.nil?
        rand_row = rand(9)
        rand_col = rand(9)
        rand_tile = @tiles[rand_row][rand_col]
      end

      rand_tile.bomb = true
      bomb_tiles << rand_tile
    end
  end

  def mark_fringe_squares
    @tiles.each do |row|
      row.each do |tile|
        tile.check_neighboring_bombs
      end
    end
  end

  def render
    print "      "
    (0...@dimension).each do |i|
      print "#{i.to_s.rjust(3, " ")}"
    end
    puts
    @tiles.each_with_index do |row, row_idx|
      print "row: #{row_idx.to_s.rjust(2, " ")} " #fix digits
      row.each do |tile|
        print "#{tile.display}  "
      end
      puts
    end
  end

  def final_render
    print "      "
    (0...@dimension).each do |i|
      print "#{i.to_s.rjust(3, " ")}"
    end
    puts
    @tiles.each_with_index do |row, row_idx|
      print "row: #{row_idx.to_s.rjust(2, " ")} " #fix digits
      row.each do |tile|
        print "#{tile.display_bombs}  "
      end
      puts
    end

  end

  def num_explored
    tiles_explored = 0
    @tiles.each do |row|
      row.each do |tile|
        tiles_explored += 1 if tile.explored
      end
    end
    tiles_explored
  end

  def num_flagged
    tiles_flagged = 0
    @tiles.each do |row|
      row.each do |tile|
        tiles_flagged += 1 if tile.flagged
      end
    end
    tiles_flagged
  end

  def player_wins?
   (num_explored + num_flagged) == @dimension ** 2
  end

end
