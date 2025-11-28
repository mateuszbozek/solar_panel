class Mount
  EDGE_GAP = 2.freeze
  GAP_VERTICAL = 16.freeze
  SPAN_GAP = 48.freeze

  attr_reader :x, :y
  
  def initialize(x:, y:)
    @x = Float(x)
    @y = Float(y)
  end
end
