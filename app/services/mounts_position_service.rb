class MountsPositionService

  def initialize(panel, x_max)
    @panel = panel
    @rafter = Rafter.new(x_max+Panel::WIDTH)
  end

  def call
    mounts = []
    panel_x_start = @panel.x
    panel_x_end = @panel.x+Panel::WIDTH

    result = @rafter.x_verticals.select { |x| x.between?(panel_x_start, panel_x_end) }
    result << result.last+Mount::GAP_VERTICAL if @panel.is_right

    result.each do |x_ver|
      if (x_ver-panel_x_start).abs >= Mount::EDGE_GAP && (x_ver-panel_x_end).abs >= Mount::EDGE_GAP
        mounts << {x: x_ver, y: @panel.y }
        mounts << {x: x_ver, y: @panel.y+Panel::HEIGHT }
      end
    end
    
    mounts
  end
end