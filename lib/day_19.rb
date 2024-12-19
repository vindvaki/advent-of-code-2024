# frozen_string_literal: true

require "matrix"

Day19 = Data.define(:patterns, :strings)

class Day19
  EXAMPLE = <<~STRING
    r, wr, b, g, bwu, rb, gb, br

    brwrr
    bggr
    gbbr
    rrbgbr
    ubwu
    bwurrg
    brgr
    bbrgwb
  STRING

  def self.parse(input)
    patterns_str, strings_str = input.split("\n\n")
    patterns = patterns_str.split(", ")
    strings = strings_str.lines.map(&:strip)
    new(patterns:, strings:)
  end

  def part_1
    regexp = /^(#{Regexp.union(patterns.map { Regexp.quote(_1) })})*$/
    strings.count { _1 =~ regexp }
  end

  def part_2
    cache = {}
    regexp = /^(#{Regexp.union(patterns.map { Regexp.quote(_1) })})*$/
    strings.grep(regexp).sum { count_combinations(_1, regexp, cache) }
  end

  private

  def count_combinations(string, regexp, cache = {})
    cache[string] ||= if string.empty?
      1
    else
      patterns.sum do |pattern|
        next 0 unless string.start_with?(pattern)
        suffix = string.delete_prefix(pattern)

        next 0 unless suffix&.match?(regexp)
        count_combinations(suffix, regexp, cache)
      end
    end
  end
end
