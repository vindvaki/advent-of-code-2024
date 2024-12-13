# frozen_string_literal: true

require_relative "test_helper"

class TestDay12 < Minitest::Test
  def test_day_12_part_1
    assert_equal 1930, ::Day12.parse(::Day12::EXAMPLE).part_1
  end

  def test_day_12_part_2
    assert_equal 1206, ::Day12.parse(::Day12::EXAMPLE).part_2
  end
end
