# frozen_string_literal: true

require_relative "test_helper"

class TestDay5 < Minitest::Test
  def test_day_5_part_1
    assert_equal 143, ::Day5.parse(::Day5::EXAMPLE).part_1
  end

  def test_day_5_part_2
    assert_equal 123, ::Day5.parse(::Day5::EXAMPLE).part_2
  end
end
