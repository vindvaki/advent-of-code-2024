# frozen_string_literal: true

require_relative "test_helper"

class TestDay8 < Minitest::Test
  def test_day_8_part_1
    assert_equal 14, ::Day8.parse(::Day8::EXAMPLE).part_1
  end

  def test_day_8_part_2
    assert_equal 34, ::Day8.parse(::Day8::EXAMPLE).part_2
  end
end
