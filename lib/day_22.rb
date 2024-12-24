# frozen_string_literal: true

require "matrix"

Day22 = Data.define(:numbers)

class Day22
  EXAMPLE = <<~STRING
    1
    10
    100
    2024
  STRING

  def self.parse(input)
    new(input.each_line.map(&:to_i))
  end

  def part_1
    numbers.sum do |number|
      2000.times do
        number = next_secret(number)
      end

      number
    end
  end

  private

  def next_secret(number)
    number ^= (number << 6)
    number %= 2**24

    number ^= (number >> 5)
    number %= 2**24

    number ^= (number << 11)
    number %= 2**24

    number
  end
end
