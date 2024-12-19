# frozen_string_literal: true

require_relative "test_helper"

class TestDay19 < Minitest::Test
  def test_day_19_part_1
    assert_equal 6, ::Day19.parse(::Day19::EXAMPLE).part_1
  end

  def test_day_19_part_2
    assert_equal 16, ::Day19.parse(::Day19::EXAMPLE).part_2
  end
end
