# frozen_string_literal: true

require "matrix"

Day15 = Struct.new(:robot, :boxes, :walls, :rows, :cols, :moves, :expanded)

class Day15
  SMALL = <<~SMALL
    ########
    #..O.O.#
    ##@.O..#
    #...O..#
    #.#.O..#
    #...O..#
    #......#
    ########

    <^^>>>vv<v>>v<<
  SMALL

  EXAMPLE = <<~EXAMPLE
    ##########
    #..O..O.O#
    #......O.#
    #.OO..O.O#
    #..O@..O.#
    #O#..O...#
    #O..O..O.#
    #.OO.O.OO#
    #....O...#
    ##########

    <vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
    vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
    ><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
    <<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
    ^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
    ^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
    >^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
    <><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
    ^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
    v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
  EXAMPLE

  def self.parse(input)
    grid_s, moves_s = input.split("\n\n")
    robot = nil
    boxes = Set[]
    walls = Set[]
    rows = 0
    cols = 0

    grid_s.each_line.with_index do |line, row|
      rows = row
      line.chars.each_with_index do |c, col|
        cols = col
        case c
        when "@"
          robot = Vector[row, col]
        when "O"
          boxes << Vector[row, col]
        when "#"
          walls << Vector[row, col]
        end
      end
    end
    rows += 1
    cols += 1

    moves = moves_s.chars.filter_map do |c|
      case c
      when "<" then Vector[0, -1]
      when ">" then Vector[0, 1]
      when "^" then Vector[-1, 0]
      when "v" then Vector[1, 0]
      end
    end.reverse # moves will be a stack

    new(robot:, walls:, boxes:, moves:, rows:, cols:)
  end

  def part_1
    until moves.empty?
      move!
    end

    boxes.sum do |box|
      box.dot(Vector[100, 1])
    end
  end

  def part_2
    expand!

    until moves.empty?
      move_2!
    end

    boxes.sum do |box|
      box.dot(Vector[100, 1])
    end
  end

  def to_s
    (+"").tap do |s|
      rows.times do |row|
        cols.times do |col|
          pos = Vector[row, col]
          s << if pos == robot
            "@"
          elsif walls.include?(pos)
            "#"
          elsif boxes.include?(pos)
            if expanded
              "["
            else
              "O"
            end
          elsif expanded && boxes.include?(pos + Vector[0, -1])
            "]"
          else
            "."
          end
        end
        s << "\n"
      end
    end
  end

  def expand!
    self.expanded = true
    self.cols *= 2
    robot[1] *= 2

    self.walls = walls.flat_map do |wall|
      wall[1] = wall[1] * 2
      [wall, wall + Vector[0, 1]]
    end

    # only record the starting positions of boxes; they have an implied
    # width of 2
    self.boxes = boxes.map do |box|
      box[1] = box[1] * 2
      box
    end.to_set
  end

  def move!
    move = moves.pop
    next_robot = robot + move

    if wall?(next_robot)
      return
    end

    if box?(next_robot)
      iter = next_robot
      while box?(iter)
        iter += move
      end

      unless wall?(iter)
        boxes.delete(next_robot)
        boxes << iter
      end
    end

    unless box?(next_robot)
      self.robot = next_robot
    end
  end

  def box?(p)
    if expanded
      !box_2(p).nil?
    else
      boxes.include?(p)
    end
  end

  def wall?(p)
    walls.include?(p)
  end

  def box_2(p)
    [p, p + Vector[0, -1]].find do |q|
      boxes.include?(q)
    end
  end

  def move_2!
    move = moves.pop
    next_robot = robot + move

    if wall?(next_robot)
      return
    end

    if box?(next_robot)
      blocking_boxes = Set[]
      moved_boxes = Set[]
      stack = [next_robot]
      wall = false

      until wall || stack.empty?
        pos = stack.pop
        box = box_2(pos)
        next if blocking_boxes.include?(box)
        moved_box = box + move
        blocking_boxes << box
        moved_boxes << moved_box
        [moved_box, moved_box + Vector[0, 1]].each do |moved_box_pos|
          if box?(moved_box_pos)
            stack << moved_box_pos
          elsif wall?(moved_box_pos)
            wall = true
            break
          end
        end
      end

      unless wall
        boxes.subtract(blocking_boxes)
        boxes.merge(moved_boxes)
      end
    end

    unless box?(next_robot)
      self.robot = next_robot
    end
  end
end
