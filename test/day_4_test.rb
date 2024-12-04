# frozen_string_literal: true

require_relative "test_helper"

class TestDay4 < Minitest::Test
  def test_day_4_part_1
    assert_equal 18, ::Day4.parse(::Day4::EXAMPLE).part_1
  end

  def test_day_4_part_2
    assert_equal 9, ::Day4.parse(::Day4::EXAMPLE).part_2
  end
end
