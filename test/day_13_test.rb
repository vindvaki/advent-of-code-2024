# frozen_string_literal: true

require_relative "test_helper"

class TestDay13 < Minitest::Test
  def test_day_13_part_1
    assert_equal 480, ::Day13.parse(::Day13::EXAMPLE).part_1
  end
end
