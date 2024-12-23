# frozen_string_literal: true

require "matrix"

Day21 = Data.define(:codes)

class Day21
  EXAMPLE = <<~STRING
    029A
    980A
    179A
    456A
    379A
  STRING

  def self.parse(input)
    new(codes: input.lines.map(&:strip))
  end

  ARROWS = {
    Vector[0, 2] => :activate,
    Vector[0, 1] => Vector[-1, 0], # up
    Vector[1, 0] => Vector[0, -1], # left
    Vector[1, 1] => Vector[1, 0], # down
    Vector[1, 2] => Vector[0, 1] # right
  }.freeze

  NUMPAD = {
    Vector[0, 0] => "7", Vector[0, 1] => "8", Vector[0, 2] => "9",
    Vector[1, 0] => "4", Vector[1, 1] => "5", Vector[1, 2] => "6",
    Vector[2, 0] => "1", Vector[2, 1] => "2", Vector[2, 2] => "3",
    Vector[3, 1] => "0", Vector[3, 2] => "A"
  }.freeze

  ACTIONS = ARROWS.values.freeze

  Robot = Data.define(:position, :activated) do
    def apply(action)
      return with(activated: true) if action == :activate

      next_position = position + action
      return unless position_hash.key?(next_position)

      with(position: next_position, activated: false)
    end

    def value
      position_hash[position]
    end

    def <=>(other)
      comparison_key <=> other.comparison_key
    end

    def comparison_key
      [position.to_a, activated ? 1 : 0]
    end
  end

  ArrowsRobot = Class.new(Robot) do
    def position_hash
      ARROWS
    end
  end

  NumpadRobot = Class.new(Robot) do
    def position_hash
      NUMPAD
    end
  end

  # An adapter to use with the `Graph` utility class
  class GraphAdapter
    Vertex = Data.define(:robots) do
      def <=>(other)
        comparison_key <=> other.comparison_key
      end

      def comparison_key
        robots.map(&:comparison_key)
      end
    end

    def edges_out(u)
      @edges_out ||= {}
      @edges_out[u] ||= ACTIONS.filter_map do |action|
        activate = true
        next_robots = u.robots.map do |robot|
          next_robot = activate ? robot.apply(action) : robot.with(activated: false)
          break unless next_robot

          activate = next_robot.activated
          action = next_robot.value
          next_robot
        end

        if next_robots
          Graph::Edge.new(
            source: u,
            target: Vertex.new(robots: next_robots),
            weight: 1
          )
        end
      end
    end
  end

  def part_1
    solve([
      ArrowsRobot.new(position: Vector[0, 2], activated: false),
      ArrowsRobot.new(position: Vector[0, 2], activated: false),
      NumpadRobot.new(position: Vector[3, 2], activated: false)
    ])
  end

  def part_2
    solve([
      *[ArrowsRobot.new(position: Vector[0, 2], activated: false)] * 25,
      NumpadRobot.new(position: Vector[3, 2], activated: false)
    ])
  end

  private

  def solve(robots)
    adapter = GraphAdapter.new
    graph = Graph.new do |vertex|
      adapter.edges_out(vertex)
    end

    codes.sum do |code|
      input_length = 0
      position = GraphAdapter::Vertex.new(robots:)

      code.each_char do |numpad_target|
        next_position = nil

        graph.shortest_paths(source: position) do |distance, vertex|
          numpad = vertex.robots.last
          if numpad.activated && numpad.value == numpad_target
            next_position = vertex
            input_length += distance
            true
          else
            false
          end
        end

        raise "Unable to find path" unless next_position

        position = next_position
      end

      input_length * code.to_i
    end
  end
end
