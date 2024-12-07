# frozen_string_literal: true

Day6 = Data.define(:map, :position, :direction)

class Day6
  EXAMPLE = <<~EXAMPLE
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
  EXAMPLE

  def self.parse(input)
    map = input.lines.map(&:chars)
    rows = map.length
    cols = map[0].length
    position = nil

    (0...rows).each do |row|
      (0...cols).each do |col|
        direction =
          case map[row][col]
          when "^" then [-1, 0]
          when ">" then [0, 1]
          when "v" then [1, 0]
          when "<" then [0, -1]
          end

        if direction
          position = [row, col]
          return new(map, position, direction)
        end
      end
    end

    raise ArgumentError, "No guard found"
  end

  def part_1
    path = trace(map, position, direction)
    path.keys.map(&:first).uniq.count
  end

  def part_2
    count = 0
    map = self.map.clone
    path_hash = trace(map, position, direction)
    path_array = path_hash.keys.sort_by { |k| path_hash[k] }
    seen = Set[]

    path_array.each_cons(2) do |(position_1, direction_1), (position_2, direction_2)|
      # can't place on # or starting position
      next if position_1 == position_2
      # position_2 needs to be clear in order to reach it from this direction
      next if seen.include?(position_2)
      seen << position_2
      row, col = position_2
      map[row][col] = "O"
      count += 1 if trace(map, position_1, direction_1, path_hash).nil?
      map[row][col] = "."
    end

    count
  end

  private

  def trace(map, source_position, source_direction, reference = {})
    visited = {}

    position = source_position
    direction = source_direction
    source_index = reference[[source_position, source_direction]] || 0

    (source_index..).each do |index|
      key = [position, direction]
      break if visited.key?(key) # new loop?

      visited[key] = index

      # known loop?
      break if reference[key]&.< source_index

      maybe_next_position = position.zip(direction).map(&:sum)

      if !in_bounds?(maybe_next_position)
        break visited
      elsif !["#", "O"].include?(map.dig(*maybe_next_position))
        position = maybe_next_position
      else
        direction = rotate_90_right(direction)
      end
    end
  end

  def in_bounds?(pos)
    row, col = pos

    row >= 0 && row < rows &&
      col >= 0 && col < cols
  end

  def rotate_90_right(direction)
    case direction
    in [1, 0] then [0, -1]
    in [0, -1] then [-1, 0]
    in [-1, 0] then [0, 1]
    in [0, 1] then [1, 0]
    end
  end

  def rows
    map.length
  end

  def cols
    map.first.length
  end
end
