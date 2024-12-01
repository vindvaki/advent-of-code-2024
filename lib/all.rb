# frozen_string_literal: true

require "zeitwerk"

LOADER = Zeitwerk::Loader.new
LOADER.push_dir(__dir__)
LOADER.enable_reloading
LOADER.setup

def reload!
  LOADER.reload
end
