# frozen_string_literal: true

require "matrix"

Day18 = Data.define(:bytes, :rows, :cols)

class Day18
  EXAMPLE = <<~STRING
    5,4
    4,2
    4,5
    3,0
    2,1
    6,3
    2,4
    1,5
    0,6
    3,3
    2,6
    5,1
    1,2
    5,5
    2,5
    6,5
    1,4
    0,4
    6,4
    1,1
    6,1
    1,0
    0,5
    1,6
    2,0
  STRING

  DIRECTIONS = [Vector[0, 1], Vector[0, -1], Vector[1, 0], Vector[-1, 0]].freeze

  def self.parse(input, rows: 71, cols: 71)
    bytes = input.each_line.map { |line| Vector[*line.split(",").map(&:to_i)] }
    new(bytes:, rows:, cols:)
  end

  def part_1(count = 1024)
    bfs(bytes.first(count).to_set)
  end

  def part_2
    obstacles = bytes.to_set
    remaining_bytes = bytes.clone
    visited = Set[]

    # pre-fill visited map, and return early if no byte needs to fall
    return if bfs(obstacles, visited:)

    until remaining_bytes.empty?
      byte = remaining_bytes.pop
      obstacles.delete(byte)
      exit_reachable = bfs(obstacles, source: byte)
      byte_reachable = bfs(obstacles, source: byte, targets: visited.clone)
      return byte if byte_reachable && exit_reachable
    end
  end

  private

  def bfs(obstacles, source: Vector[0, 0], targets: Set[Vector[rows - 1, cols - 1]], visited: Set[])
    queue = Thread::Queue.new
    queue << [0, source]
    until queue.empty?
      steps, current = queue.pop
      return steps if targets.include?(current)
      next if visited.include?(current)
      visited << current
      DIRECTIONS.each do |direction|
        neighbor = current + direction
        next unless in_bounds?(neighbor)
        next if visited.include?(neighbor)
        next if obstacles.include?(neighbor)
        queue << [steps + 1, neighbor]
      end
    end
  end

  def in_bounds?(point)
    row, col = *point

    row >= 0 && row < rows && col >= 0 && col < cols
  end
end
