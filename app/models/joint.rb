class Joint
  attr_reader :x, :y
  
  def initialize(x:, y:)
    @x = Float(x)
    @y = Float(y)
  end

  def self.calculate_coordinates(gap_on_horizontal, gap_on_vertical, is_last_row, panel)
      # p "                   Wewnątrz calculate_joints - panel : #{panel.x}   -   #{is_next}-      #{gap_on_horizontal}-   #{gap_on_vertical}-    #{is_last_row}"
      if panel.is_right && !( panel.is_under || panel.is_diagonally )
        # p "                      Jest po prawej ale nie poniżej"
        return [ { x: panel.x+Panel::WIDTH+(gap_on_horizontal/2), y: panel.y },
                 { x: panel.x+Panel::WIDTH+(gap_on_horizontal/2), y: panel.y+Panel::HEIGHT } ] 
      elsif panel.is_right && ( panel.is_under || panel.is_diagonally )
        # p "                      Jest po prawej i poniżej"
        return [ { x: panel.x+Panel::WIDTH+(gap_on_horizontal/2), y: panel.y },
                 { x: panel.x+Panel::WIDTH+(gap_on_horizontal/2), y: panel.y+Panel::HEIGHT+(gap_on_vertical/2) } ]
      elsif !panel.is_right && panel.is_under && !panel.is_diagonally
        # p "                      Nie ma po prawej i ma poniżej i nie ma diagonalnie"
        return [ x: panel.x+Panel::WIDTH, y: panel.y+Panel::HEIGHT+(gap_on_vertical/2) ]
      elsif !panel.is_right && panel.is_diagonally
        # p "                      Nie ma po prawej i ma diagonalnie"
        return [ x: panel.x+Panel::WIDTH+(gap_on_horizontal/2), y: panel.y+Panel::HEIGHT+(gap_on_vertical/2) ]
      else
      end
  end
end
