# frozen_string_literal: true

require_relative "test_helper"

class TestDay16 < Minitest::Test
  def test_day_16_part_1
    assert_equal 7036, ::Day16.parse(::Day16::EXAMPLE).part_1
  end

  def test_day_16_part_2
    assert_equal 45, ::Day16.parse(::Day16::EXAMPLE).part_2
    assert_equal 64, ::Day16.parse(::Day16::EXAMPLE_2).part_2
  end
end
