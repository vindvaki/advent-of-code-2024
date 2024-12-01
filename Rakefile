# frozen_string_literal: true

require "minitest/test_task"
require_relative "lib/all"

task :run, [:day, :part] do |_t, args|
  input = Fixture.load("day_#{args.day}.input")
  klass = Object.const_get("Day#{args.day}")
  instance = klass.parse(input)
  puts instance.public_send(:"part_#{args.part}").inspect
end

Minitest::TestTask.create(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.warning = false
  t.test_globs = ["test/**/*_test.rb"]
end

task default: :test
