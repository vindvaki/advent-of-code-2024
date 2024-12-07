# frozen_string_literal: true

require_relative "test_helper"

class TestDay7 < Minitest::Test
  def test_day_7_part_1
    assert_equal 3749, ::Day7.parse(::Day7::EXAMPLE).part_1
  end

  def test_day_7_part_2
    assert_equal 11387, ::Day7.parse(::Day7::EXAMPLE).part_2
  end
end
