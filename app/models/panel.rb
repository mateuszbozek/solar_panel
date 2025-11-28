class Panel
  WIDTH = 44.1.freeze
  HEIGHT = 71.1.freeze
  MAX_DISTANCE = 1.freeze

  attr_accessor :x, 
                :y, 
                :is_under, 
                :is_diagonally, 
                :is_right,
                :gap_on_horizonal
                :gap_on_vertical

      
  def initialize(panel)
    @x = Float(panel[:x])
    @y = Float(panel[:y])
    @is_diagonally = false
    @is_right = false
    @is_under = false
    @gap_on_horizonal = nil
    @gap_on_vertical = nil
  end

  def check_on_right(other_panel)
    @is_right = (other_panel.x - (self.x + WIDTH)).abs < MAX_DISTANCE
  end

  def check_under(other_panel)
    @is_under = ((other_panel[:x]==self.x)&&(other_panel[:y]-(self.y+HEIGHT)).abs<MAX_DISTANCE) 
  end
  
  def check_diagonally(other_panel)
    @is_diagonally = ((other_panel[:x]-(self.x+WIDTH)).abs<MAX_DISTANCE)&&(other_panel[:y]-(self.y+HEIGHT).abs<MAX_DISTANCE)
  end
end
