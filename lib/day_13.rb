# frozen_string_literal: true

require "matrix"

Day13 = Data.define(:machines)

class Day13
  EXAMPLE = <<~EXAMPLE
    Button A: X+94, Y+34
    Button B: X+22, Y+67
    Prize: X=8400, Y=5400

    Button A: X+26, Y+66
    Button B: X+67, Y+21
    Prize: X=12748, Y=12176

    Button A: X+17, Y+86
    Button B: X+84, Y+37
    Prize: X=7870, Y=6450

    Button A: X+69, Y+23
    Button B: X+27, Y+71
    Prize: X=18641, Y=10279
  EXAMPLE

  Machine = Data.define(:a, :b, :prize)

  class Machine
    def solve
      m = Matrix[a, b].transpose
      m.inverse * prize
    end

    def solve_2
      m = Matrix[a, b].transpose
      m.inverse * (prize + Vector[10000000000000, 10000000000000])
    end
  end

  def self.parse(input)
    machines = input.split("\n\n").map do |machine_str|
      a_str, b_str, prize_str = machine_str.lines
      a = Vector[*a_str.scan(/\d+/).map(&:to_i)]
      b = Vector[*b_str.scan(/\d+/).map(&:to_i)]
      prize = Vector[*prize_str.scan(/\d+/).map(&:to_i)]
      Machine.new(a, b, prize)
    end

    new(machines)
  end

  def part_1
    machines.sum do |machine|
      solution = machine.solve
      next 0 unless solution.all? { |n| n.denominator.abs == 1 && n > 0 }

      solution.dot(Vector[3, 1]).to_i
    end
  end

  def part_2
    machines.sum do |machine|
      solution = machine.solve_2
      next 0 unless solution.all? { |n| n.denominator.abs == 1 && n > 0 }

      solution.dot(Vector[3, 1]).to_i
    end
  end
end
