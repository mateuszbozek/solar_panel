class Joint
  attr_reader :x, :y
  
  def initialize(x:, y:)
    @x = Float(x)
    @y = Float(y)
  end

    def self.calculate_joints( gap_on_horizontal, gap_on_vertical, panel)
      is_under = ( panel.is_under || panel.is_diagonally )
      if panel.is_right && !is_under
        return [ { x: panel.x+Panel::WIDTH+(gap_on_horizontal/2), y: panel.y },
                 { x: panel.x+Panel::WIDTH+(gap_on_horizontal/2), y: panel.y+Panel::HEIGHT } ] 
      elsif panel.is_right && is_under
        return [ { x: panel.x+Panel::WIDTH+(gap_on_horizontal/2), y: panel.y },
                 { x: panel.x+Panel::WIDTH+(gap_on_horizontal/2), y: panel.y+Panel::HEIGHT+(gap_on_vertical/2) } ]
      elsif !panel.is_right && is_under && !panel.is_diagonally
        return [ x: panel.x+Panel::WIDTH, y: panel.y+Panel::HEIGHT+(gap_on_vertical/2) ]
      elsif !panel.is_right && panel.is_diagonally
        return [ x: panel.x+Panel::WIDTH+(gap_on_horizontal/2), y: panel.y+Panel::HEIGHT+(gap_on_vertical/2) ]
      else
      end
    end
end
