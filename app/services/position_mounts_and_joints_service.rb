class PositionMountsAndJointsService

    def initialize(panel_positions)
     @panel_positions = group_coordinates(panel_positions)
    end

    def call
      joints = []
      mounts = []
      
      @panel_positions.each_with_index do |row, row_index|

        # p "Dane panele w rzędzie #{row_index}  => #{row[1]}"
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
          gap_on_horizontal = (next_panel[:x]-(panel.x+Panel::WIDTH)).abs
          is_next_to_act_panel = next_panel[:x]-(panel.x+Panel::WIDTH) < 1
          is_last_row = @panel_positions[row_index+2].nil?
          # p "     =====     Aktualny panel : #{panel}    -    czy ma blisko po prawej ? #{is_next_to_act_panel}"
  
          # p " Dla aktualnego panelu pokaż te poniżej : #{panels_under_act_panel}"
          case panels_under_act_panel&.size
          when 1
            if panel.x==panels_under_act_panel[0][:x]
              # p "   Pierwszy panel rząd niżej : #{panels_under_act_panel[0]}"
              panel.is_under = ((panels_under_act_panel[0][:x]==panel.x)&&(panels_under_act_panel[0][:y]-(panel.y+Panel::HEIGHT)).abs<1)
              gap_on_vertical = (panels_under_act_panel[0][:y]-(panel.y+Panel::HEIGHT))
              # p "       Czy pod panelem znajduję się kolejny panel ? = #{panel.is_under}"
            else
              # p "   Pierwszy panel rząd niżej : #{panels_under_act_panel[0]}"
              panel.is_diagonally = ((panels_under_act_panel[0][:x]-(panel.x+Panel::WIDTH)).abs<1)&&(panels_under_act_panel[0][:y]-(panel.y+Panel::HEIGHT).abs<1)
              gap_on_vertical = (panels_under_act_panel[0][:y]-(panel.y+Panel::HEIGHT))
              gap_on_horizontal = panels_under_act_panel[0][:x]-(panel.x+Panel::WIDTH)
              # p "     Czy znajduje się po przekągnej obecnego panelu ? = #{panel.is_diagonally}"
            end
          when 2
            # p "   Pierwszy panel rząd niżej : #{panels_under_act_panel[0]}"
            panel.is_under = ((panels_under_act_panel[0][:x]==panel.x)&&(panels_under_act_panel[0][:y]-(panel.y+Panel::HEIGHT)).abs<1)
            gap_on_vertical = (panels_under_act_panel[0][:y]-(panel.y+Panel::HEIGHT))
            # p "       Czy pod panelem znajduję się kolejny panel ? = #{panel.is_under}"
            # p "   Pierwszy panel rząd niżej : #{panels_under_act_panel[1]}"
            panel.is_diagonally = ((panels_under_act_panel[1][:x]-(panel.x+Panel::WIDTH)).abs<1)&&(panels_under_act_panel[1][:y]-(panel.y+Panel::HEIGHT).abs<1)
            gap_on_horizontal = (panels_under_act_panel[1][:x]-(panel.x+Panel::WIDTH)).abs
            # p "     Czy znajduje się po przekągnej obecnego panelu ? = #{panel.s_diagonally}"
          else
          end
          # p "                =======                  Czy jest to ostatni wiersz ? #{is_last_row}"
          joints << Joint.calculate_coordinates( is_next_to_act_panel, 
                                             gap_on_horizontal,
                                             gap_on_vertical,
                                             is_last_row,
                                             panel )

          index = index + 1
        end
        
        #możliwość sprawdzenia ostatniego elementu ?
        p 

      end
      p joints.flatten
      p joints.flatten.size
      return { 
                # "Joints": joints.flatten,
                "Mounts": mounts.flatten 
             }
    end

    def group_coordinates(array)
      grouped_coordinated = {}
      grouped = array.group_by { |p| p[:y] }
                    .transform_values { |group| group.sort_by { |p| p[:x] } }
      grouped.keys.sort.each_with_index do |y_value, index|
         grouped_coordinated[index + 1] = grouped[y_value]
      end
      grouped_coordinated
    end
end
