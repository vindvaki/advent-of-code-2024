# frozen_string_literal: true

require_relative "test_helper"

class TestDay15 < Minitest::Test
  def test_day_15_part_1
    assert_equal 2028, ::Day15.parse(::Day15::SMALL).part_1
    assert_equal 10092, ::Day15.parse(::Day15::EXAMPLE).part_1
  end

  def test_day_15_part_2
    assert_equal 9021, ::Day15.parse(::Day15::EXAMPLE).part_2
  end
end
