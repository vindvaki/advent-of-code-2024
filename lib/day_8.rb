# frozen_string_literal: true

Day8 = Data.define(:map, :rows, :cols)

class Day8
  EXAMPLE = <<~EXAMPLE
    ............
    ........0...
    .....0......
    .......0....
    ....0.......
    ......A.....
    ............
    ............
    ........A...
    .........A..
    ............
    ............
  EXAMPLE

  def self.parse(input)
    map = {}
    rows = 0
    cols = 0

    input.each_line.with_index do |line, i|
      rows = i
      line.chars.each_with_index do |c, j|
        cols = j
        unless [".", "\n"].include?(c)
          map[[i, j]] = c
        end
      end
    end

    new(map, rows + 1, cols)
  end

  def part_1
    antinodes = Set[]
    map.group_by { |k, v| v }.each do |kind, group|
      group.combination(2).each do |(a, _), (b, _)|
        d = a.zip(b).map { |x, y| x - y }
        da = a.zip(d).map { |x, y| x + y }
        db = b.zip(d).map { |x, y| x - y }
        antinodes << da if in_bounds?(da)
        antinodes << db if in_bounds?(db)
      end
    end
    antinodes.size
  end

  def part_2
    antinodes = Set[]
    map.group_by { |k, v| v }.each do |kind, group|
      group.combination(2).each do |(a, _), (b, _)|
        d = a.zip(b).map { |x, y| x - y }
        da = a
        while in_bounds?(da)
          antinodes << da
          da = da.zip(d).map { |x, y| x + y }
        end
        db = b
        while in_bounds?(db)
          antinodes << db
          db = db.zip(d).map { |x, y| x - y }
        end
      end
    end
    antinodes.size
  end

  private

  def in_bounds?(point)
    row, col = point
    row >= 0 && row < rows && col >= 0 && col < cols
  end
end
