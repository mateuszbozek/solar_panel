class PositionMountsAndJointsService

    def initialize(panel_position)
     @panel_position = convert_table(panel_position)
    end

    def call
      joints = []
      mounts = []
      @panel_position.each_with_index do |row, row_index|
        p "Dane panele w rzędzie #{row_index}  => #{row[1]}"
        size_of_row = row[1].size
        index = 0

        while index < size_of_row-1 do

          

          act_panel = row[1][index]
          next_panel = row[1][index+1]
          is_under_act_panel = false
          is_diagonally_to_act_panel = false 
          gap_on_horizontal = (next_panel[:x]-(act_panel[:x]+Panel::WIDTH)).abs
          gap_on_vertical = nil
          is_next_to_act_panel = next_panel[:x]-(act_panel[:x]+Panel::WIDTH) < 1
          is_last_row = @panel_position[row_index+2].nil?
          
          # p "     =====     Aktualny panel : #{act_panel}    -    czy ma blisko po prawej ? #{is_next_to_act_panel}"
    
          panels_under_act_panel = @panel_position[row_index + 2]&.select do |point|
            point[:x].between?(act_panel[:x], act_panel[:x]+Panel::WIDTH+1)
          end
            
          p " Dla aktualnego panelu pokaż te poniżej : #{panels_under_act_panel}"
            
          case panels_under_act_panel&.size
          when 1
            if act_panel[:x]==panels_under_act_panel[0][:x]
              p "   Pierwszy panel rząd niżej : #{panels_under_act_panel[0]}"
              is_under_act_panel = ((panels_under_act_panel[0][:x]==act_panel[:x])&&(panels_under_act_panel[0][:y]-(act_panel[:y]+Panel::HEIGHT)).abs<1)
              gap_on_vertical = (panels_under_act_panel[0][:y]-(act_panel[:y]+Panel::HEIGHT))
              p "       Czy pod panelem znajduję się kolejny panel ? = #{is_under_act_panel}"
            else
              p "   Pierwszy panel rząd niżej : #{panels_under_act_panel[0]}"
              is_diagonally_to_act_panel = ((panels_under_act_panel[0][:x]-(act_panel[:x]+Panel::WIDTH)).abs<1)&&(panels_under_act_panel[0][:y]-(act_panel[:y]+Panel::HEIGHT).abs<1)
              gap_on_vertical = (panels_under_act_panel[0][:y]-(act_panel[:y]+Panel::HEIGHT))
              gap_on_horizontal = panels_under_act_panel[0][:x]-(act_panel[:x]+Panel::WIDTH)
              p "     Czy znajduje się po przekągnej obecnego panelu ? = #{is_diagonally_to_act_panel}"
            end
          when 2
            p "   Pierwszy panel rząd niżej : #{panels_under_act_panel[0]}"
            is_under_act_panel = ((panels_under_act_panel[0][:x]==act_panel[:x])&&(panels_under_act_panel[0][:y]-(act_panel[:y]+Panel::HEIGHT)).abs<1)
            gap_on_vertical = (panels_under_act_panel[0][:y]-(act_panel[:y]+Panel::HEIGHT))
            p "       Czy pod panelem znajduję się kolejny panel ? = #{is_under_act_panel}"
            p "   Pierwszy panel rząd niżej : #{panels_under_act_panel[1]}"
            is_diagonally_to_act_panel = ((panels_under_act_panel[1][:x]-(act_panel[:x]+Panel::WIDTH)).abs<1)&&(panels_under_act_panel[1][:y]-(act_panel[:y]+Panel::HEIGHT).abs<1)
            gap_on_horizontal = (panels_under_act_panel[1][:x]-(act_panel[:x]+Panel::WIDTH)).abs
            p "     Czy znajduje się po przekągnej obecnego panelu ? = #{is_diagonally_to_act_panel}"
          else
          end
          # p "                =======                  Czy jest to ostatni wiersz ? #{is_last_row}"

          joints << calculate_joints( is_next_to_act_panel, 
                                      is_under_act_panel,
                                      is_diagonally_to_act_panel ,
                                      gap_on_horizontal,
                                      gap_on_vertical,
                                      is_last_row,
                                      act_panel )

          # p "               =-=-=-=-               =-=-=-=             =-=-=- PO SPRAWDZENIU RZĘDU    =-=-=-=-=       =-=-=-=-=      =-=-=-=-="
          # p joints
          index = index + 1
        end


      end
      p joints.flatten.size
      return joints.flatten
    end

    def convert_table(array)
      renamed = {}
      grouped = array.group_by { |p| p[:y] }
                    .transform_values { |group| group.sort_by { |p| p[:x] } }
      grouped.keys.sort.each_with_index do |y_value, index|
         renamed[index + 1] = grouped[y_value]
      end
      renamed
    end

    def calculate_joints(is_next, is_under_act_panel, is_diagonally, gap_on_horizontal, gap_on_vertical, is_last_row, act_panel)
      # p "                   Wewnątrz calculate_joints - panel : #{act_panel}   -   #{is_next}-      #{gap_on_horizontal}-   #{gap_on_vertical}-    #{is_last_row}"
      is_under = ( is_under_act_panel || is_diagonally )
      if is_next && !is_under
        p "                      Jest po prawej ale nie poniżej"
        return [ { x: act_panel[:x]+Panel::WIDTH+(gap_on_horizontal/2), y: act_panel[:y] },
                 { x: act_panel[:x]+Panel::WIDTH+(gap_on_horizontal/2), y: act_panel[:y]+Panel::HEIGHT } ] 
      elsif is_next && is_under
        p "                      Jest po prawej i poniżej"
        return [ { x: act_panel[:x]+Panel::WIDTH+(gap_on_horizontal/2), y: act_panel[:y] },
                 { x: act_panel[:x]+Panel::WIDTH+(gap_on_horizontal/2), y: act_panel[:y]+Panel::HEIGHT+(gap_on_vertical/2) } ]
      elsif !is_next && is_under && !is_diagonally
        p "                      Nie ma po prawej i ma poniżej i nie ma diagonalnie"
        return [ x: act_panel[:x]+Panel::WIDTH, y: act_panel[:y]+Panel::HEIGHT+(gap_on_vertical/2) ]
      elsif !is_next && is_diagonally
        p "                      Nie ma po prawej i ma diagonalnie"
        return [ x: act_panel[:x]+Panel::WIDTH+(gap_on_horizontal/2), y: act_panel[:y]+Panel::HEIGHT+(gap_on_vertical/2) ]
      else
      end
    end
end
