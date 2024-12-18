# frozen_string_literal: true

require_relative "test_helper"

class TestDay18 < Minitest::Test
  def test_day_18_part_1
    assert_equal 22, ::Day18.parse(::Day18::EXAMPLE, rows: 7, cols: 7).part_1(12)
  end

  def test_day_18_part_2
    assert_equal Vector[6, 1], ::Day18.parse(::Day18::EXAMPLE, rows: 7, cols: 7).part_2
  end
end
