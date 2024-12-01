# lib/fixture.rb

class Fixture
  def self.load(name)
    path = File.join(__dir__, '../fixtures', name)
    File.read(path)
  end
end
