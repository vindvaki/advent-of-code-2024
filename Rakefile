# frozen_string_literal: true

require "minitest/test_task"
require_relative "lib/all"

task :run, [:day, :part] do |_t, args|
  if args.part
    parts = [args.part]
  else
    parts = [1, 2]
  end

  if args.day
    days = [args.day]
  else
    days = 1..25
  end

  days.each do |day|
    begin
      input = Fixture.load("day_#{day}.input")
    rescue Errno::ENOENT
      puts "No fixture for day #{day}"
      next
    end

    parts.each do |part|
      solution = begin
        klass = Object.const_get("Day#{day}")
        instance = klass.parse(input)
        instance.public_send(:"part_#{part}")
      rescue NameError
        # nil
      end

      puts "Day #{day}, part #{part}: #{solution.inspect}"
    end
  end
end

Minitest::TestTask.create(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.warning = false
  t.test_globs = ["test/**/*_test.rb"]
end

task default: :test
