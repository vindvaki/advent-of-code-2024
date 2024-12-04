# frozen_string_literal: true

Day4 = Data.define(:grid)

class Day4
  EXAMPLE = <<~EXAMPLE
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX
  EXAMPLE

  def self.parse(input)
    new(input.each_line.map { |line| line.strip.chars })
  end

  def part_1
    pattern = "XMAS"
    m = grid.size
    n = pattern.size

    count = 0

    (0...m).each do |i|
      (0...m).each do |j|
        # forward row
        if (0...n).all? { |k| pattern[k] == grid.dig(i, j + k) }
          count += 1
        end

        # backward row
        if (0...n).all? { |k| j >= k && pattern[k] == grid.dig(i, j - k) }
          count += 1
        end

        # forward column
        if (0...n).all? { |k| pattern[k] == grid.dig(i + k, j) }
          count += 1
        end

        # backward column
        if (0...n).all? { |k| i >= k && pattern[k] == grid.dig(i - k, j) }
          count += 1
        end

        # down right diagonal
        if (0...n).all? { |k| pattern[k] == grid.dig(i + k, j + k) }
          count += 1
        end

        # down left diagonal
        if (0...n).all? { |k| j >= k && pattern[k] == grid.dig(i + k, j - k) }
          count += 1
        end

        # up right diagonal
        if (0...n).all? { |k| i >= k && pattern[k] == grid.dig(i - k, j + k) }
          count += 1
        end

        # up left diagonal
        if (0...n).all? { |k| i >= k && j >= k && pattern[k] == grid.dig(i - k, j - k) }
          count += 1
        end
      end
    end

    count
  end

  def part_2
    count = 0
    m = grid.size

    (1...m - 1).each do |i|
      (1...m - 1).each do |j|
        if (
          grid[i - 1][j - 1] == "M" && grid[i][j] == "A" && grid[i + 1][j + 1] == "S" ||
          grid[i - 1][j - 1] == "S" && grid[i][j] == "A" && grid[i + 1][j + 1] == "M"
        ) &&
            (
              grid[i - 1][j + 1] == "M" && grid[i][j] == "A" && grid[i + 1][j - 1] == "S" ||
              grid[i - 1][j + 1] == "S" && grid[i][j] == "A" && grid[i + 1][j - 1] == "M"
            )

          count += 1
        end
      end
    end

    count
  end
end
