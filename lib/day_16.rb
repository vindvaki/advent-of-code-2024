# frozen_string_literal: true

require "matrix"
require "sorted_set"

Day16 = Data.define(:walls, :source, :target)

class Day16
  EXAMPLE = <<~STRING
    ###############
    #.......#....E#
    #.#.###.#.###.#
    #.....#.#...#.#
    #.###.#####.#.#
    #.#.#.......#.#
    #.#.#####.###.#
    #...........#.#
    ###.#.#####.#.#
    #...#.....#.#.#
    #.#.#.###.#.#.#
    #.....#...#.#.#
    #.###.#.#.#.#.#
    #S..#.....#...#
    ###############
  STRING

  EXAMPLE_2 = <<~STRING
    #################
    #...#...#...#..E#
    #.#.#.#.#.#.#.#.#
    #.#.#.#...#...#.#
    #.#.#.#.###.#.#.#
    #...#.#.#.....#.#
    #.#.#.#.#.#####.#
    #.#...#.#.#.....#
    #.#.#####.#.###.#
    #.#.#.......#...#
    #.#.###.#####.###
    #.#.#...#.....#.#
    #.#.#.#####.###.#
    #.#.#.........#.#
    #.#.#.#########.#
    #S#.............#
    #################  
  STRING

  DIRECTIONS = 4.times.each_with_object([Vector[0, 1]]) do |_, acc|
    acc << acc.last.cross
  end

  def self.parse(input)
    walls = Set[]
    source = nil
    target = nil
    input.each_line.with_index do |line, row|
      line.each_char.with_index do |char, col|
        case char
        when "#"
          walls << Vector[row, col]
        when "E"
          target = Vector[row, col]
        when "S"
          source = Vector[row, col]
        end
      end
    end
    new(walls:, source:, target:)
  end

  Node = Data.define(:distance, :position, :direction) do
    def <=>(other)
      distance_cmp = distance <=> other.distance
      if distance_cmp == 0
        position_cmp = position.to_a <=> other.position.to_a
        if position_cmp == 0
          direction.to_a <=> other.direction.to_a
        else
          position_cmp
        end
      else
        distance_cmp
      end
    end
  end

  def part_1
    distance, _ = shortest_paths

    DIRECTIONS
      .map { |direction| distance[[target, direction]] }
      .min
  end

  def part_2
    distance, prev = shortest_paths

    min_distance = DIRECTIONS
      .map { |direction| distance[[target, direction]] }
      .min

    stack = DIRECTIONS
      .select { |direction| distance[[target, direction]] == min_distance }
      .map { |direction| [target, direction] }

    seen = Set[]
    until stack.empty?
      current = stack.pop
      seen << current
      prev[current]&.each do |predecessor|
        stack << predecessor unless seen.include?(predecessor)
      end
    end
    seen.map(&:first).uniq.size
  end

  def shortest_paths
    distance = Hash.new(Float::INFINITY)
    distance[[source, Vector[0, 1]]] = 0
    prev = {}
    queue = SortedSet[Node.new(0, source, Vector[0, 1])]

    until queue.empty?
      head = queue.first
      queue.delete(head)

      [
        [head.direction, 0],
        [head.direction.cross, 1],
        [-head.direction.cross, 1]
      ].each do |next_direction, rotations|
        [0, 1].each do |steps|
          next if steps == 0 && rotations == 0

          next_position = head.position + steps * next_direction
          next if walls.include?(next_position)

          neighbor = [next_position, next_direction]
          neighbor_distance = head.distance + steps + 1000 * rotations

          case neighbor_distance <=> distance[neighbor]
          when -1
            prev[neighbor] = Set[[head.position, head.direction]]
            distance[neighbor] = neighbor_distance
            queue << Node.new(neighbor_distance, next_position, next_direction)
          when 0
            prev[neighbor] << [head.position, head.direction]
          end
        end
      end
    end

    [distance, prev]
  end
end
