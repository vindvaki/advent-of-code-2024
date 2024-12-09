# frozen_string_literal: true

Day9 = Data.define(:files, :blanks)

class Day9
  EXAMPLE = <<~EXAMPLE
    2333133121414131402
  EXAMPLE

  def self.parse(input)
    files = {}
    blanks = []
    cursor = 0
    id = 0

    input.chars.map(&:to_i).each_slice(2) do |file_size, blank_size|
      files[id] = [[cursor, file_size]]
      cursor += file_size

      if blank_size > 0
        blanks << [cursor, blank_size]
        cursor += blank_size
      end

      id += 1
    end

    new(files, blanks)
  end

  def part_1
    last_id = files.keys.max
    blanks_stack = blanks.reverse
    compacted = {}
    id = last_id

    while !blanks_stack.empty? && id >= 0
      blank_cursor, blank_size = blanks_stack.pop
      compacted[id] ||= files[id].clone
      file_cursor, file_size = compacted[id].pop

      if blank_cursor >= file_cursor
        compacted[id].push([file_cursor, file_size])
        break
      end

      compacted_size = [blank_size, file_size].min
      blank_remaining = blank_size - compacted_size
      file_remaining = file_size - compacted_size

      compacted[id].push([blank_cursor, compacted_size])

      if file_remaining > 0
        compacted[id].push([file_cursor, file_remaining])
      else
        id -= 1
      end

      if blank_remaining > 0
        blanks_stack.push([blank_cursor + compacted_size, blank_remaining])
      end
    end

    id -= 1

    while id >= 0
      compacted[id] = files[id].clone
      id -= 1
    end

    compacted.sum do |id, blocks|
      blocks.sum do |cursor, size|
        (cursor...cursor + size).sum do |index|
          id * index
        end
      end
    end
  end

  def part_2
    last_id = files.keys.max
    blanks = self.blanks.clone
    compacted = {}

    last_id.downto(0) do |id|
      file_cursor, file_size = files[id].first

      blank, index = blanks.each_with_index.find do |(blank_cursor, blank_size), blank_index|
        blank_size >= file_size && blank_cursor < file_cursor
      end

      if blank
        # using a linked list and deleting empty blanks would be the most efficient,
        # but this is fast enough
        blank_cursor, blank_size = blank
        blanks[index] = [blank_cursor + file_size, blank_size - file_size]
        compacted[id] = [blank_cursor, file_size]
      else
        compacted[id] = [file_cursor, file_size]
      end
    end

    compacted.sum do |id, (cursor, size)|
      (cursor...cursor + size).sum do |index|
        id * index
      end
    end
  end
end
