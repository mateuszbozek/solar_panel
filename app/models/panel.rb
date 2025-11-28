class Panel
  WIDTH = 44.1.freeze
  HEIGHT = 71.1.freeze
  MAX_DISTANCE = 1.freeze

  attr_accessor :x, :y, :is_under, :is_diagonally, :is_right
      
  def initialize(panel)
    @x = Float(panel[:x])
    @y = Float(panel[:y])
    @is_under = false
    @is_diagonally = false
    @is_right = false
  end

  def is_right
    @is_right = next_panel[:x]-(panel.x+Panel::WIDTH) < 1
  end

end
