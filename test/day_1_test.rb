require_relative 'test_helper'

class TestDay1 < Minitest::Test
  def test_day_1_part_1
    assert_equal 11, ::Day1.parse(::Day1::EXAMPLE).part_1
  end

  def test_day_1_part_2
    assert_equal 31, ::Day1.parse(::Day1::EXAMPLE).part_2
  end
end
