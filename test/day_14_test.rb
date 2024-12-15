# frozen_string_literal: true

require_relative "test_helper"

class TestDay14 < Minitest::Test
  def test_day_14_part_1
    assert_equal 12, ::Day14.parse(::Day14::EXAMPLE, rows: 7, cols: 11).part_1
  end
end
