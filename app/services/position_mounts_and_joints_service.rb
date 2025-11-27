class PositionMountsAndJointsService

    def initialize(panel_position)
     @panel_position = convert_table(panel_position)
    end

    def call
      @panel_position.each_with_index do |row, row_index|
        p "Dane panele w rzędzie ( poziom ) : #{row[1]} rząd: #{row_index}"
        size_of_row = row[1].size
        index = 0

        while index < size_of_row-1 do
          act_panel = row[1][index]
          next_panel = row[1][index+1]
          gap_horizontal = next_panel[:x]-(act_panel[:x]+Panel::WIDTH)
          
          unless @panel_position[row_index+2].nil?
            @panel_position[row_index+2].each do |under_act_panel|
              p " ====== Mamy panel poniżej obecnego" if under_act_panel[:y]-(act_panel[:y]+Panel::HEIGHT) < 1
            end
          end
          

          if gap_horizontal < 1
            # p "MAMY ŁĄCZNIK GÓRNY W TYM MIEJSCU x:#{next_panel[:x]-(gap_horizontal/2)} y:#{next_panel[:y]}" # jeśli nie mamy rzędu poniżej !
            # p "MAMY ŁĄCZNIK DOLNY W TYM MIEJSCU x:#{next_panel[:x]-(gap_horizontal/2)} y:#{next_panel[:y]+Panel::HEIGHT}" # jeśli nie mamy rzędu poniżej !
          end

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
