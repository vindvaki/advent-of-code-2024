# frozen_string_literal: true

Day1 = Data.define(:xs, :ys)

class Day1
  EXAMPLE = <<~STRING
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
  STRING

  def self.parse(input)
    xs = []
    ys = []

    input.each_line do |line|
      x, y = line.split
      xs << x.to_i
      ys << y.to_i
    end

    new(xs, ys)
  end

  def part_1
    sum = 0
    xs.sort.lazy
      .zip(ys.sort)
      .sum(0) { |x, y| (x - y).abs }
  end

  def part_2
    counts = ys.each_with_object({}) do |y, h|
      h[y] ||= 0
      h[y] += 1
    end

    xs.sum do |x|
      x * counts.fetch(x, 0)
    end
  end
end
