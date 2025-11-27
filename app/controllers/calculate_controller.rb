class CalculateController < ActionController::API
  def temp_method
    panel_position = [
                                                {"x": 0, "y": 0}, {"x": 45.05, "y": 0}, {"x": 90.1, "y": 0},
                                                {"x": 0, "y": 71.6}, {"x": 135.15, "y": 0}, {"x": 135.15, "y": 71.6},
                                                {"x": 0, "y": 143.2}, {"x": 45.05, "y": 143.2}, {"x": 135.15, "y": 143.2},
                                                {"x": 90.1, "y": 143.2}
                                               ]
    output = PositionMountsAndJointsService.new(panel_position).call
    render json: output
  end
end
