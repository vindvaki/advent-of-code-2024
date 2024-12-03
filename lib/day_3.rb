# frozen_string_literal: true

Day3 = Data.define(:input)

class Day3
  EXAMPLE = <<~EXAMPLE
    xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
  EXAMPLE

  EXAMPLE_2 = <<~EXAMPLE
    xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
  EXAMPLE

  def self.parse(input)
    new(input)
  end

  def part_1
    re = /mul\((\d{1,3}),(\d{1,3})\)/
    result = 0
    input.scan(re) do |x, y|
      result += x.to_i * y.to_i
    end
    result
  end

  def part_2
    re = /
       (?<ins>do) \( \) |
       (?<ins>don't) \( \) |
       (?<ins>mul) \( (?<lhs>\d{1,3}) , (?<rhs>\d{1,3}) \)
    /x
    enabled = true
    result = 0
    input.scan(re) do
      m = Regexp.last_match
      case m["ins"]
      when "do"
        enabled = true
      when "don't"
        enabled = false
      when "mul"
        if enabled
          x = m["lhs"].to_i
          y = m["rhs"].to_i
          result += x * y
        end
      end
    end
    result
  end
end
