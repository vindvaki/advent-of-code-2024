# frozen_string_literal: true

require_relative "test_helper"

class TestDay22 < Minitest::Test
  def test_day_22_part_1
    assert_equal 37327623, ::Day22.parse(::Day22::EXAMPLE).part_1
  end

  def test_day_22_part_2
    assert_equal 23, ::Day22.parse(::Day22::EXAMPLE_2).part_2
  end
end
