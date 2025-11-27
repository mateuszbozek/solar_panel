class AliveController < ActionController::API
  def index
    output = { 'solar_panel' => 'Is alive!' }.to_json
    render json: output
  end
end
