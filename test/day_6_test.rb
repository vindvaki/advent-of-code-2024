# frozen_string_literal: true

require_relative "test_helper"

class TestDay6 < Minitest::Test
  def test_day_6_part_1
    assert_equal 41, ::Day6.parse(::Day6::EXAMPLE).part_1
  end

  def test_day_6_part_2
    assert_equal 6, ::Day6.parse(::Day6::EXAMPLE).part_2
  end
end
