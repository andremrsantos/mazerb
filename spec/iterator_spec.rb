require 'spec_helper'
require 'mazerb/iterator'

module MazeIteratorSpecs
  before do
    @maze = Mazerb::Maze.new(5,5)
  end

  it "must visit all cells once" do
    subject.each { |c| c.visited = c.visited.nil? ? 1 : c.visited + 1 }
    @maze.each { |c| c.visited.must_equal 1 }
  end

  it("#has_next?") do
    subject.has_next?.must_equal true
    subject.each { |c| c.visited = true }
    subject.has_next?.must_equal false
  end

  it("#next") do
    subject.next.must_be_instance_of(Mazerb::Cell) while subject.has_next?
    subject.next.must_equal nil
  end
end

describe Mazerb::Iterator::RandomPrim do
  subject { Mazerb::Iterator::RandomPrim.new(@maze) }

  include MazeIteratorSpecs
end

describe Mazerb::Iterator::GrowingTree do
  subject { Mazerb::Iterator::GrowingTree.new(@maze) }

  include MazeIteratorSpecs
end

