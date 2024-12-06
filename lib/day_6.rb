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
        direction = \
          case map[row][col]
          when '^' then [-1, 0]
          when '>' then [0, 1]
          when 'v' then [1, 0]
          when '<' then [0, -1]
          end

        if direction
          position = [row, col]
          return new(map, position, direction)
        end
      end
    end

    raise ArgumentError, 'No guard found'
  end

  def part_1
    trace(map, position, direction)
  end

  def part_2
    count = 0
    map = self.map.clone

    (0...rows).each do |row|
      (0...cols).each do |col|
        if map[row][col] == '.'
          map[row][col] = '#'
          count += 1 if trace(map, position, direction).nil?
          map[row][col] = '.'
        end
      end
    end

    count
  end

  private

  def trace(map, position, direction)
    visited = {}

    loop do
      return if visited[position]&.include?(direction)

      visited[position] ||= Set[]
      visited[position] << direction

      maybe_next_position = position.zip(direction).map(&:sum)

      if !in_bounds?(maybe_next_position)
        return visited.size
      elsif map.dig(*maybe_next_position) != '#'
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
