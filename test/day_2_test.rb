# frozen_string_literal: true

require_relative "test_helper"

class TestDay2 < Minitest::Test
  def test_day_2_part_1
    assert_equal 2, ::Day2.parse(::Day2::EXAMPLE).part_1
  end

  def test_day_2_part_2
    assert_equal 4, ::Day2.parse(::Day2::EXAMPLE).part_2
  end
end
