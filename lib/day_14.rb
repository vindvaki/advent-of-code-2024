# frozen_string_literal: true

require "matrix"

Day14 = Data.define(:robots, :rows, :cols)

class Day14
  EXAMPLE = <<~EXAMPLE
    p=0,4 v=3,-3
    p=6,3 v=-1,-3
    p=10,3 v=-1,2
    p=2,0 v=2,-1
    p=0,0 v=1,3
    p=3,0 v=-2,-2
    p=7,6 v=-1,-3
    p=3,0 v=-1,-2
    p=9,3 v=2,3
    p=7,3 v=-1,2
    p=2,4 v=2,-3
    p=9,5 v=-3,-3
  EXAMPLE

  Robot = Data.define(:p, :v)

  class Robot
    def self.parse(str)
      re = /^p=(?<p>.*) v=(?<v>.*)$/
      match = re.match(str)
      p = Vector[*match[:p].split(",").map(&:to_i)]
      v = Vector[*match[:v].split(",").map(&:to_i)]
      new(p, v)
    end

    def advance(time, rows, cols)
      q = p + time * v
      q[0] %= cols
      q[1] %= rows
      self.class.new(q, v)
    end
  end

  def self.parse(input, rows: 103, cols: 101)
    robots = input.each_line.map { |line| Robot.parse(line) }
    new(robots, rows, cols)
  end

  def part_1(time: 100)
    moved = advance(time).map(&:p)

    quadrants = moved.group_by do |point|
      [2 * point[0] + 1 <=> cols, 2 * point[1] + 1 <=> rows]
    end

    quadrants.filter_map { |k, v| k[0] != 0 && k[1] != 0 && v.size }.reduce(&:*)
  end

  def part_2
    # There are only rows*cols possibilities, which is only about 10k.
    # In my input, there are only 500 robots. So computing all arrangements
    # is quite feasible. The problem is identifying the picture with a tree.
    # This is not defined in the statement, so we just have to guess. There
    # is not even a guarantee of connectedness! But my thinking is that
    # this arrangement will be the most "organized" one. One measure is
    # to say that points with similar coordinates should also be close
    # to each other.
    time = (rows * cols).times.min_by do |time|
      points = advance(time).map(&:p).uniq.sort_by(&:to_a)
      points.each_cons(2).sum do |p, q|
        (p - q).norm
      end
    end

    print_robots(advance(time))

    time
  end

  private

  def advance(time)
    robots.map { |r| r.advance(time, rows, cols) }
  end

  def print_robots(robots)
    by_position = Hash.new(0)
    robots.each do |robot|
      by_position[robot.p] += 1
    end

    rows.times do |row|
      cols.times do |col|
        if (c = by_position[Vector[col, row]]) > 0
          print c
        else
          print "."
        end
      end
      puts
    end
  end
end
