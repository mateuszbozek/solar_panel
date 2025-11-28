module CalculateNeighbors
  def self.merge_neighbors_by_y(mounts)
  result = []

  mounts.group_by { |m| m[:x] }.each_value do |group|
    sorted = group.sort_by { |m| m[:y] }
    i = 0

    while i < sorted.length
      current = sorted[i]
      nxt = sorted[i + 1]

      if nxt && (nxt[:y] - current[:y]).abs < 1
        avg_y = (current[:y] + nxt[:y]) / 2.0
        result << { x: current[:x], y: avg_y }
        i += 2  
      else
        result << current
        i += 1
      end
    end
  end

  result
  end

end
