class PositionMountsAndJointsService

    def initialize(panel_positions)
     @panel_positions = group_coordinates(panel_positions)
    end

    def call
      joints = []
      mounts = []
      
      @panel_positions.each_with_index do |row, row_index|

        size_of_row = row[1].size
        index = 0

        # panel = Panel.new(row[1][index])
        # right_panel = Panel.new(row[1][index+1])

        while index < size_of_row-1 do

          panel = Panel.new(row[1][index])
          right_panel = Panel.new(row[1][index+1])
          
          # Część odpowiedzialna za obliczenie mounts
          

          # Część odpowiedzialna za obliczanie joints
          panels_under_act_panel = @panel_positions[row_index + 2]&.select do |point|
            point[:x].between?(panel.x, panel.x+Panel::WIDTH+1)
          end
          gap_on_vertical = nil
          gap_on_horizontal = (right_panel.x-(panel.x+Panel::WIDTH)).abs
          is_next_to_act_panel = right_panel.x-(panel.x+Panel::WIDTH) < 1
          is_last_row = @panel_positions[row_index+2].nil?
  
          case panels_under_act_panel&.size
          when 1
            if panel.x==panels_under_act_panel[0][:x]
              panel.is_under = ((panels_under_act_panel[0][:x]==panel.x)&&(panels_under_act_panel[0][:y]-(panel.y+Panel::HEIGHT)).abs<1)
              gap_on_vertical = (panels_under_act_panel[0][:y]-(panel.y+Panel::HEIGHT))
            else
              panel.is_diagonally = ((panels_under_act_panel[0][:x]-(panel.x+Panel::WIDTH)).abs<1)&&(panels_under_act_panel[0][:y]-(panel.y+Panel::HEIGHT).abs<1)
              gap_on_vertical = (panels_under_act_panel[0][:y]-(panel.y+Panel::HEIGHT))
              gap_on_horizontal = panels_under_act_panel[0][:x]-(panel.x+Panel::WIDTH)
            end
          when 2
            panel.is_under = ((panels_under_act_panel[0][:x]==panel.x)&&(panels_under_act_panel[0][:y]-(panel.y+Panel::HEIGHT)).abs<1)
            gap_on_vertical = (panels_under_act_panel[0][:y]-(panel.y+Panel::HEIGHT))
            panel.is_diagonally = ((panels_under_act_panel[1][:x]-(panel.x+Panel::WIDTH)).abs<1)&&(panels_under_act_panel[1][:y]-(panel.y+Panel::HEIGHT).abs<1)
            gap_on_horizontal = (panels_under_act_panel[1][:x]-(panel.x+Panel::WIDTH)).abs
          else
          end

          joints << Joint.calculate_coordinates( is_next_to_act_panel, 
                                             gap_on_horizontal,
                                             gap_on_vertical,
                                             is_last_row,
                                             panel )

          index = index + 1
        end

        # możliwość sprawdzenia ostatniego elementu

      end
      p joints.flatten
      p joints.flatten.size
      return { 
                # "Joints": joints.flatten,
                "Mounts": mounts.flatten 
             }
    end

    def group_coordinates(array)
      grouped_coordinates = {}
      grouped = array.group_by { |p| p[:y] }
                    .transform_values { |group| group.sort_by { |p| p[:x] } }
      grouped.keys.sort.each_with_index do |y_value, index|
         grouped_coordinates[index + 1] = grouped[y_value]
      end
      grouped_coordinates
    end
end
