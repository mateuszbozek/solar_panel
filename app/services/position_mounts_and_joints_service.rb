class PositionMountsAndJointsService

    def initialize(panel_position)
     @panel_position = convert_table(panel_position)
    end

    def call
      @panel_position.each_with_index do |row, row_index|
        p "Dane panele w rzędzie #{row_index}  => #{row[1]}"
        size_of_row = row[1].size
        index = 0

        while index < size_of_row-1 do
          act_panel = row[1][index]
          next_panel = row[1][index+1]
          is_next_to_act_panel = next_panel[:x]-(act_panel[:x]+Panel::WIDTH) < 1

          p "     =====     Aktualny panel : #{act_panel}    -    czy ma blisko po prawej ? #{is_next_to_act_panel}"
          unless @panel_position[row_index+2].nil?
  
            @panel_position[row_index+2].each do |under_act_panel|

              p "Panem rząd niżej : #{under_act_panel}"
              is_under_act_panel = ((under_act_panel[:x]==act_panel[:x])&&(under_act_panel[:y]-(act_panel[:y]+Panel::HEIGHT)).abs<1) 
              p "Czy pod panelem znajduję się kolejny panelu ? = #{is_under_act_panel}"

              unless is_under_act_panel
                is_diagonally_to_act_panel = ((under_act_panel[:x]-(act_panel[:x]+Panel::WIDTH)).abs<1)&&(under_act_panel[:y]-(act_panel[:y]+Panel::HEIGHT).abs<1)
                p "Czy znajduje się po przekągnej obecnego panelu ? = #{is_diagonally_to_act_panel}"
              end
            end


          end
          
        p "==============================================================================================================================="
          # if is_next_to_act_panel
            # p "MAMY ŁĄCZNIK GÓRNY W TYM MIEJSCU x:#{next_panel[:x]-(gap_horizontal/2)} y:#{next_panel[:y]}" # jeśli nie mamy rzędu poniżej !
            # p "MAMY ŁĄCZNIK DOLNY W TYM MIEJSCU x:#{next_panel[:x]-(gap_horizontal/2)} y:#{next_panel[:y]+Panel::HEIGHT}" # jeśli nie mamy rzędu poniżej !
          # end

          index = index + 1
        end       
      end
      
      return @panel_position
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
end
