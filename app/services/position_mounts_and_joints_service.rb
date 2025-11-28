class PositionMountsAndJointsService

    def initialize(panel_position)
     @panel_position = convert_table(panel_position)
    end

    def call
      joints = []
      mounts = []

      panel = Panel.allocate
      right_panel = Panel.allocate

      @panel_position.each_with_index do |row, row_index|
        p "Dane panele w rzędzie #{row_index}  => #{row[1]}"
        size_of_row = row[1].size
        index = 0

        while index < size_of_row-1 do
          panel.send(:initialize, row[1][index])
          right_panel.send(:initialize, row[1][index+1])
          panel.check_on_right(right_panel)

          # is_under_act_panel = false
          # is_diagonally_to_act_panel = false 

          gap_on_horizontal = (right_panel.x-(panel.x+Panel::WIDTH)).abs
          gap_on_vertical = nil
          is_last_row = @panel_position[row_index+2].nil?
          
    
          panels_under_act_panel = @panel_position[row_index + 2]&.select do |point|
            point[:x].between?(panel.x, panel.x+Panel::WIDTH+1)
          end
                        
          case panels_under_act_panel&.size
          when 1
            if panel.x==panels_under_act_panel[0][:x]
              panel.check_under(panels_under_act_panel[0])
              gap_on_vertical = (panels_under_act_panel[0][:y]-(panel.y+Panel::HEIGHT))
            else
              # is_diagonally_to_act_panel = ((panels_under_act_panel[0][:x]-(panel.x+Panel::WIDTH)).abs<1)&&(panels_under_act_panel[0][:y]-(panel.y+Panel::HEIGHT).abs<1)
             panel.check_diagonally(panels_under_act_panel[0])

              
              gap_on_vertical = (panels_under_act_panel[0][:y]-(panel.y+Panel::HEIGHT))
              gap_on_horizontal = panels_under_act_panel[0][:x]-(panel.x+Panel::WIDTH)
            end
          when 2
            panel.check_under(panels_under_act_panel[0])
            # is_diagonally_to_act_panel = ((panels_under_act_panel[1][:x]-(panel.x+Panel::WIDTH)).abs<1)&&(panels_under_act_panel[1][:y]-(panel.y+Panel::HEIGHT).abs<1)
             panel.check_diagonally(panels_under_act_panel[1])

            gap_on_vertical = (panels_under_act_panel[0][:y]-(panel.y+Panel::HEIGHT))
            gap_on_horizontal = (panels_under_act_panel[1][:x]-(panel.x+Panel::WIDTH)).abs
          else
          end

          joints << Joint.calculate_joints( 
                                            gap_on_horizontal,
                                            gap_on_vertical,
                                            is_last_row,
                                            panel )

          index = index + 1
        end
      end
      p joints.flatten.size
      return joints.flatten
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
