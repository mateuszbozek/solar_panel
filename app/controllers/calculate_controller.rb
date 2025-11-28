class CalculateController < ActionController::API
  def get_coordinates_joints_and_mounts
    begin
      data = params.require(:data)
      return render(json: { Error: 'Data must be an array' }, status: :unprocessable_entity) unless data.is_a?(Array)
    rescue ActionController::ParameterMissing
      return render(json: { Error: 'Missing data' }, status: :bad_request)
    end

    invalid = validate_data(data)

    if invalid.any?
      return render json: { Error: 'Invalid coordinate(s)', invalid: invalid }, status: :unprocessable_entity
    end
    
    output = AnalyseJointsAndMountsService.new(params[:data]).call
    render json: output
  end

  private

  def validate_data(array)
    invalid = []

    array.each_with_index do |item, idx|
      x_raw = item['x'].nil? ? item[:x] : item['x']
      y_raw = item['y'].nil? ? item[:y] : item['y']

      x = to_numeric(x_raw)
      y = to_numeric(y_raw)

      invalid << { index: idx, raw: item } if x.nil? || y.nil?
    end

    invalid
  end

  def to_numeric(value)
    return value if value.is_a?(Numeric)
  rescue ArgumentError, TypeError
    nil
  end
  
end
