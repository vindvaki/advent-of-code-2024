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

  EXAMPLE_2 = <<~STRING
    1
    2
    3
    2024
  STRING

  def self.parse(input)
    new(input.each_line.map(&:to_i))
  end

  def part_1
    numbers.sum do |number|
      secret_sequence(number)
        .with_index.find { |secret, i| i == 2000 }
        .first
    end
  end

  def part_2
    bananas = Hash.new(0)

    numbers.each do |number|
      diff_sequences(number, 2000).each do |sequence, price|
        bananas[sequence] += price
      end
    end

    bananas.values.max
  end

  def next_secret(number)
    number ^= (number << 6)
    number %= 2**24

    number ^= (number >> 5)
    number %= 2**24

    number ^= (number << 11)
    number %= 2**24

    number
  end

  def diff_sequences(number, limit)
    prices = secret_sequence(number)
      .take(limit + 1)
      .map { |a| a % 10 }

    prices
      .lazy
      .each_cons(2)
      .map { |a, b| b - a }
      .each_cons(4)
      .with_index
      .map { |cons, i| [cons, prices[i + 4]] }
      .uniq(&:first)
      .to_a
  end

  def secret_sequence(number)
    Enumerator.new do |yielder|
      loop do
        yielder << number
        number = next_secret(number)
      end
    end
  end
end
