# frozen_string_literal: true

require_relative "test_helper"

class TestDay10 < Minitest::Test
  def test_day_10_part_1
    assert_equal 36, ::Day10.parse(::Day10::EXAMPLE).part_1
  end

  def test_day_10_part_2
    assert_equal 81, ::Day10.parse(::Day10::EXAMPLE).part_2
  end
end
