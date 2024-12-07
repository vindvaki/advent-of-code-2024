# frozen_string_literal: true

Day7 = Data.define(:equations)

class Day7
  EXAMPLE = <<~EXAMPLE
    190: 10 19
    3267: 81 40 27
    83: 17 5
    156: 15 6
    7290: 6 8 6 15
    161011: 16 10 13
    192: 17 8 14
    21037: 9 7 18 13
    292: 11 6 16 20
  EXAMPLE

  def self.parse(input)
    new(input.each_line.map { |line| line.split(/[: ]/).map(&:to_i) })
  end

  def part_1
    equations.sum do |lhs, *rhs|
      if match_1(lhs, rhs[1..], rhs[0])
        lhs
      else
        0
      end
    end
  end

  def part_2
    equations.sum do |lhs, *rhs|
      if match_2(lhs, rhs[1..], rhs[0])
        lhs
      else
        0
      end
    end
  end

  private

  def match_1(lhs, rhs, acc)
    return lhs == acc if rhs.empty?
    return false if lhs < acc

    x = rhs[0]
    rhs = rhs[1..]
    match_1(lhs, rhs, acc + x) || match_1(lhs, rhs, acc * x)
  end


  def match_2(lhs, rhs, acc)
    return lhs == acc if rhs.empty?
    return false if lhs < acc

    x = rhs[0]
    rhs = rhs[1..]
    match_2(lhs, rhs, acc + x) ||
      match_2(lhs, rhs, acc * x) ||
      match_2(lhs, rhs, (acc.to_s + x.to_s).to_i)
  end
end
