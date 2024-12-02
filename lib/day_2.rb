# frozen_string_literal: true

Day2 = Data.define(:reports)

class Day2
  EXAMPLE = <<~EXAMPLE
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
  EXAMPLE

  def self.parse(input)
    reports = input.each_line.map do |line|
      line.split.map(&:to_i)
    end

    new(reports)
  end

  def part_1
    reports.count do |report|
      safe?(report)
    end
  end

  def part_2
    reports.count do |report|
      next true if safe?(report)

      # the reports are so small we can just brute force
      n = report.length
      (0...n).any? do |i|
        safe?(report[0, i] + report[i + 1, n])
      end
    end
  end

  private

  def safe?(list)
    s = list[0] - list[1]

    list.lazy.each_cons(2).all? do |a, b|
      d = a - b
      d.positive? == s.positive? &&
        d.abs >= 1 &&
        d.abs <= 3
    end
  end
end
