
class Tile
  attr_accessor :board, :position, :neighbors, :bomb, :flagged, :adjacent_bombs, :explored

  def initialize(position)
    @position = position
    @neighbors = []
    @bomb = false
    @flagged = false
    @explored = false
  end

  def explore
    self.explored = true unless @bomb
    check_neighboring_bombs

    if @adjacent_bombs == '_'
      neighbors.each do |neighbor|
        next if neighbor.explored
        next if neighbor.flagged
        neighbor.explore
      end
    else
      display
    end
  end

  def display
    if @flagged
      "F"
    elsif @explored == false
      "*"
    elsif !@bomb
      @adjacent_bombs
    end
  end

  def display_bombs
    if @bomb
      "B"
    elsif @flagged
      "F"
    elsif @explored == false
      "*"
    elsif !@bomb
      @adjacent_bombs
    end
  end

  def check_neighboring_bombs
    num_bombs = 0
    @neighbors[0].position
    @neighbors.each do |neighbor|
      num_bombs += 1 if neighbor.bomb
    end
    if num_bombs == 0
      @adjacent_bombs = '_'
    else
      @adjacent_bombs = num_bombs.to_s
    end
  end

end