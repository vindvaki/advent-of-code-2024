# frozen_string_literal: true

Day5 = Data.define(:rules, :updates)

class Day5
  EXAMPLE = <<~EXAMPLE
    47|53
    97|13
    97|61
    97|47
    75|29
    61|13
    75|53
    29|13
    97|29
    53|29
    61|53
    97|53
    61|29
    47|13
    75|47
    97|75
    47|61
    75|61
    47|29
    75|13
    53|13
    
    75,47,61,53,29
    97,61,53,29,13
    75,29,13
    75,97,47,61,53
    61,13,29
    97,13,75,29,47
  EXAMPLE

  def self.parse(input)
    rules_s, updates_s = input.split("\n\n")

    rules = {}
    rules_s.each_line do |line|
      a, b = line.split("|").map(&:to_i)
      rules[[a, b]] = -1
      rules[[b, a]] = 1
    end

    updates = updates_s.each_line.map { |line| line.split(",").map(&:to_i) }

    new(rules, updates)
  end

  def part_1
    updates.sum do |update|
      sorted = update.sort do |a, b|
        rules[[a, b]] || 0
      end

      if sorted == update
        update[update.length / 2]
      else
        0
      end
    end
  end

  def part_2
    updates.sum do |update|
      sorted = update.sort do |a, b|
        rules[[a, b]] || 0
      end

      if sorted == update
        0
      else
        sorted[update.length / 2]
      end
    end
  end
end
