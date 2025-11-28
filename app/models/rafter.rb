class Rafter
  START_STEP = 2.freeze
  EDGE_GAP = 2.frezee
  VERTICAL_GAP = 16.freeze
  SPAN_GAP = 48.freeze

  def initialize(max)
    @x = (START_STEP..max+VERTICAL_GAP).step(GAP_VERTICAL).to_a
  end
end