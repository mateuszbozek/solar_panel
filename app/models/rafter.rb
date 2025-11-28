class Rafter
  START_STEP = 2.freeze
  EDGE_GAP = 2.freeze
  VERTICAL_GAP = 16.freeze
  
  attr_accessor :verticals

  def initialize(max)
    @verticals = (START_STEP..max+VERTICAL_GAP).step(VERTICAL_GAP).to_a
  end
end