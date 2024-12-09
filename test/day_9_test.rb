# frozen_string_literal: true

require_relative "test_helper"

class TestDay9 < Minitest::Test
  def test_day_9_part_1
    assert_equal 1928, ::Day9.parse(::Day9::EXAMPLE).part_1
  end

  def test_day_9_part_2
    assert_equal 2858, ::Day9.parse(::Day9::EXAMPLE).part_2
  end
end
