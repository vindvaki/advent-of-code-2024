# frozen_string_literal: true

require_relative "test_helper"

class TestDay23 < Minitest::Test
  def test_day_23_part_1
    assert_equal 7, ::Day23.parse(::Day23::EXAMPLE).part_1
  end

  def test_day_23_part_2
    assert_equal "co,de,ka,ta", ::Day23.parse(::Day23::EXAMPLE).part_2
  end
end
