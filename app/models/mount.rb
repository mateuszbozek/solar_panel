class Mount
  SPAN_GAP = 48.freeze
  attr_reader :x, :y
  
  def initialize(x:, y:)
    @x = Float(x)
    @y = Float(y)
  end
end
