# frozen_string_literal: true

require "matrix"

Day20 = Data.define(:source, :target, :walls, :rows, :cols)

class Day20
  EXAMPLE = <<~STRING
    ###############
    #...#...#.....#
    #.#.#.#.#.###.#
    #S#...#.#.#...#
    #######.#.#.###
    #######.#.#...#
    #######.#.###.#
    ###..E#...#...#
    ###.#######.###
    #...###...#...#
    #.#####.#.###.#
    #.#...#.#.#...#
    #.#.#.#.#.#.###
    #...#...#...###
    ###############
  STRING

  DIRECTIONS = [Vector[0, 1], Vector[0, -1], Vector[1, 0], Vector[-1, 0]].freeze
  JUMPS = DIRECTIONS.each_with_object([]) do |first, jumps|
    DIRECTIONS.each do |second|
      if second != -first
        jumps << first + second
      end
    end
  end.uniq.freeze

  def self.parse(input)
    source = nil
    target = nil
    walls = Set[]
    rows = nil
    cols = nil
    input.each_line.with_index do |line, row|
      rows = row
      line.each_char.with_index do |c, col|
        cols = col

        case c
        when "#"
          walls << Vector[row, col]
        when "S"
          source = Vector[row, col]
        when "E"
          target = Vector[row, col]
        end
      end
    end
    new(source:, target:, walls:, rows: rows + 1, cols:)
  end

  def part_1(threshold: 100)
    path, dist = trace
    cheats = {}

    path.each do |cheat_begin|
      JUMPS.each do |jump|
        cheat_end = cheat_begin + jump
        next if walls.include?(cheat_end)
        next if out_of_bounds?(cheat_end)
        next if dist[cheat_end] <= dist[cheat_begin]
        cheat = [cheat_begin, cheat_end]
        cheats[cheat] = dist[cheat_end] - dist[cheat_begin] - 2
      end
    end

    cheats.count do |_, savings|
      savings >= threshold
    end
  end

  def part_2(threshold: 100)
    path, dist = trace
    cheats = {}

    path.each do |cheat_begin|
      (-20..20).each do |row_offset|
        (row_offset.abs - 20..(20 - row_offset.abs)).each do |col_offset|
          jump = Vector[row_offset, col_offset]
          cheat_end = cheat_begin + jump
          next if walls.include?(cheat_end)
          next if out_of_bounds?(cheat_end)
          next if dist[cheat_end] <= dist[cheat_begin]
          cheat = [cheat_begin, cheat_end]
          cheats[cheat] = dist[cheat_end] - dist[cheat_begin] - row_offset.abs - col_offset.abs
        end
      end
    end

    cheats.count do |_, savings|
      savings >= threshold
    end
  end

  def trace
    path = []
    dist = {}
    stack = [source]
    steps = 0
    until stack.empty?
      position = stack.pop
      path << position
      dist[position] = steps
      steps += 1
      DIRECTIONS.each do |step|
        neighbor = position + step
        next if walls.include?(neighbor)
        next if dist.key?(neighbor)

        stack << neighbor
      end
    end

    [path, dist]
  end

  def out_of_bounds?(position)
    row, col = *position
    row < 0 || row >= rows || col < 0 || col >= cols
  end
end
