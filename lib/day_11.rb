# frozen_string_literal: true

Day11 = Data.define(:zeros, :evens, :odds)

class Day11
  EXAMPLE = <<~EXAMPLE
    125 17
  EXAMPLE

  def self.parse(input)
    zeros = 0
    evens = Hash.new(0)
    odds = Hash.new(0)
    input.split(" ").each do |word|
      number = word.to_i
      length = digit_count(number)
      if number.zero?
        zeros += 1
      elsif length.even?
        evens[number] += 1
      else
        odds[number] += 1
      end
    end
    new(zeros, evens, odds)
  end

  def part_1
    data = self

    25.times do
      data = data.blink
    end

    data.stone_count
  end

  def part_2
    data = self

    75.times do
      data = data.blink
    end

    data.stone_count
  end

  def stone_count
    zeros + evens.values.sum + odds.values.sum
  end

  def self.digit_count(number)
    return 1 if number == 0

    Math.log10(number.abs).floor + 1
  end

  def blink
    next_zeros = 0
    next_evens = Hash.new(0)
    next_odds = Hash.new(0)

    next_odds[1] = zeros

    evens.each do |number, count|
      length = self.class.digit_count(number)
      lhs = number / 10**(length / 2)
      rhs = number % 10**(length / 2)
      [lhs, rhs].each do |part|
        if part.zero?
          next_zeros += count
        elsif self.class.digit_count(part).even?
          next_evens[part] += count
        else
          next_odds[part] += count
        end
      end
    end

    odds.each do |number, count|
      number *= 2024
      if self.class.digit_count(number).even?
        next_evens[number] += count
      else
        next_odds[number] += count
      end
    end

    self.class.new(next_zeros, next_evens, next_odds)
  end
end
