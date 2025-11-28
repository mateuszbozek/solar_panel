class PositionMountsAndJointsService
  include CalculateNeighbors

  def initialize(panel_positions)
    @panel_positions = convert_table(panel_positions)
  end

  def call
    joints = []
    mounts = []

    panel = Panel.allocate
    right_panel = Panel.allocate

    x_max = @panel_positions.values.flatten.max_by { |p| p[:x] }[:x]

    @panel_positions.each_with_index do |row, row_index|
      size_of_row = row[1].size
      index = 0

      while index < size_of_row-1 do
        panel.send(:initialize, row[1][index])
        right_panel.send(:initialize, row[1][index+1])
        panel.check_on_right(right_panel)

        gap_on_horizontal = (right_panel.x-(panel.x+Panel::WIDTH)).abs
        gap_on_vertical = nil
        is_last_row = @panel_positions[row_index+2].nil?
          
        panels_under_act_panel = @panel_positions[row_index + 2]&.select do |point|
          point[:x].between?(panel.x, panel.x+Panel::WIDTH+1)
        end
                        
        case panels_under_act_panel&.size
        when 1
          if panel.x==panels_under_act_panel[0][:x]
            panel.check_under(panels_under_act_panel[0])
            gap_on_vertical = (panels_under_act_panel[0][:y]-(panel.y+Panel::HEIGHT))
          else
            panel.check_diagonally(panels_under_act_panel[0])
            gap_on_vertical = (panels_under_act_panel[0][:y]-(panel.y+Panel::HEIGHT))
            gap_on_horizontal = panels_under_act_panel[0][:x]-(panel.x+Panel::WIDTH)
          end
        when 2
          panel.check_under(panels_under_act_panel[0])
          panel.check_diagonally(panels_under_act_panel[1])

          gap_on_vertical = (panels_under_act_panel[0][:y]-(panel.y+Panel::HEIGHT))
          gap_on_horizontal = (panels_under_act_panel[1][:x]-(panel.x+Panel::WIDTH)).abs
        else
        end
          
        mounts << MountsPositionService.new(panel, x_max).call

        joints << Joint.calculate_joints( gap_on_horizontal, gap_on_vertical, panel )

        index = index + 1
      end

      panel.send(:initialize, row[1][index])
      mounts << MountsPositionService.new(panel, x_max).call
    end
    mounts = CalculateNeighbors::merge_neighbors_by_y(mounts.flatten)

    return {"Joints": joints.flatten, "Mounts": mounts.flatten }
  end

  def convert_table(array)
    grouped_positions = {}
    grouped = array.group_by { |p| p[:y] }
                   .transform_values { |group| group.sort_by { |p| p[:x] } }
    grouped.keys.sort.each_with_index do |y_value, index|
      grouped_positions[index + 1] = grouped[y_value]
    end
    grouped_positions
  end

end
