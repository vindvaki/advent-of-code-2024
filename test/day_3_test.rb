# frozen_string_literal: true

require_relative "test_helper"

class TestDay3 < Minitest::Test
  def test_day_3_part_1
    assert_equal 161, ::Day3.parse(::Day3::EXAMPLE).part_1
  end

  def test_day_3_part_2
    assert_equal 48, ::Day3.parse(::Day3::EXAMPLE_2).part_2
  end
end
