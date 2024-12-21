# frozen_string_literal: true

require_relative "test_helper"

class TestDay20 < Minitest::Test
  def test_day_20_part_1
    assert_equal 44, ::Day20.parse(::Day20::EXAMPLE).part_1(threshold: 2)
  end

  def test_day_20_part_2
    assert_equal 285, ::Day20.parse(::Day20::EXAMPLE).part_2(threshold: 50)
  end
end
