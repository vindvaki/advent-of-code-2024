# frozen_string_literal: true

Day10 = Data.define(:map, :rows, :cols)

class Day10
  EXAMPLE = <<~EXAMPLE
    89010123
    78121874
    87430965
    96549874
    45678903
    32019012
    01329801
    10456732
  EXAMPLE

  def self.parse(input)
    map = input.lines.map { |line| line.strip.chars.map(&:to_i) }
    rows = map.length
    cols = map.first.length
    new(map, rows, cols)
  end

  def part_1
    cache = {}

    (0...rows).sum do |row|
      (0...cols).sum do |col|
        next 0 unless map[row][col] == 0

        score([row, col], 9, cache).size
      end
    end
  end

  def part_2
    cache = {}

    (0...rows).sum do |row|
      (0...cols).sum do |col|
        next 0 unless map[row][col] == 0

        rating([row, col], 9, cache)
      end
    end
  end

  private

  def in_bounds?(position)
    row, col = position
    row >= 0 && row < rows && col >= 0 && col < cols
  end

  def neighbors(position)
    [[-1, 0], [1, 0], [0, 1], [0, -1]].lazy.filter_map do |step|
      candidate = position.zip(step).map(&:sum)
      candidate if in_bounds?(candidate)
    end
  end

  def score(source, target_value, cache = {})
    cache[source] ||= begin
      source_value = map.dig(*source)
      if source_value == target_value
        Set[source]
      else
        neighbors(source).sum(Set[]) do |position|
          next Set[] if map.dig(*position) != source_value + 1

          score(position, target_value, cache)
        end
      end
    end
  end

  def rating(source, target_value, cache = {})
    cache[source] ||= begin
      source_value = map.dig(*source)
      if source_value == target_value
        1
      else
        neighbors(source).sum(0) do |position|
          next 0 if map.dig(*position) != source_value + 1

          rating(position, target_value, cache)
        end
      end
    end
  end
end
