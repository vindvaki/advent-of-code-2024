# frozen_string_literal: true

require "matrix"

Day12 = Data.define(:grid, :rows, :cols)

class Day12
  EXAMPLE = <<~EXAMPLE
    RRRRIICCFF
    RRRRIICCCF
    VVRRRCCFFF
    VVRCCCJFFF
    VVVVCJJCFE
    VVIVCCJJEE
    VVIIICJJEE
    MIIIIIJJEE
    MIIISIJEEE
    MMMISSJEEE
  EXAMPLE

  def self.parse(input)
    grid = input.each_line.map { |line| line.strip.chars }
    rows = grid.length
    cols = grid[0].length
    new(grid, rows, cols)
  end

  def part_1
    visited = Set[]
    price = 0

    (0...rows).each do |row|
      (0...cols).each do |col|
        next if visited.include?(Vector[row, col])

        area, edges = trace(Vector[row, col], visited)
        price += area * edges.values.sum(&:size)
      end
    end

    price
  end

  def part_2
    visited = Set[]
    price = 0

    (0...rows).each do |row|
      (0...cols).each do |col|
        next if visited.include?(Vector[row, col])

        area, edges = trace(Vector[row, col], visited)
        sides = edges.sum do |orientation, positions|
          step = orientation.cross
          positions.group_by { |position| position.dot(orientation) }.sum do |_, aligned|
            aligned
              .sort_by { |position| position.dot(step) }
              .slice_when { |before, after| before + step != after }
              .count
          end
        end

        price += area * sides
      end
    end

    price
  end

  def trace(source, visited = Set[])
    visited << source
    source_value = grid.dig(*source)

    area = 1
    edges = Hash.new do |h, k|
      h[k] = Set[]
    end

    [Vector[-1, 0], Vector[1, 0], Vector[0, 1], Vector[0, -1]].each do |step|
      neighbor = source + step
      if !in_bounds?(neighbor) || source_value != grid.dig(*neighbor)
        edges[step] << neighbor
        next
      else
        next if visited.include?(neighbor)
        next_area, next_edges = trace(neighbor, visited)
        area += next_area
        next_edges.each do |k, v|
          edges[k] |= v
        end
      end
    end

    [area, edges]
  end

  def in_bounds?(position)
    row, col = *position
    row >= 0 && row < rows && col >= 0 && col < cols
  end
end
