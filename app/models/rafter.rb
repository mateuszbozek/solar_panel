class Rafter
  START_STEP = 2.freeze
  GAP_VERTICAL = 16.freeze

  attr_accessor :x_verticals

  def initialize(max)
    @x_verticals = (START_STEP..max+GAP_VERTICAL).step(GAP_VERTICAL).to_a
  end
end