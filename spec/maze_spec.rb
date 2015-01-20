require 'spec_helper'
require 'mazerb/maze'
require 'ostruct'

describe Mazerb::Direction do
  let(:up) { Mazerb::Direction::UP }

  it "must not create new" do
    proc { Mazerb::Direction.new(0,1) }.must_raise NoMethodError
  end

  it("#move") { up.move(0,0).must_equal [0,-1] }
  it("#flag") { up.flag.wont_equal 0 }
  it("#reverse") { up.reverse.move(0,0).must_equal [0,1] }
end

describe Mazerb::Cell do
  let(:up) { Mazerb::Direction::UP }

  subject { Mazerb::Cell.new }

  it "must keep values" do
    val = OpenStruct.new
    subject.val = val
    subject.val.must_be_same_as val
  end

  it("#open?") { subject.open?(up).must_equal false }
  it("#open")  { subject.open(up).open?(up).must_equal true }
  it("#close") { subject.open(up).close(up).open?(up).must_equal false }

end

describe Mazerb::Maze do
  let(:right) { Mazerb::Direction::RIGHT }
  let(:start) { [0,0] }
  let(:linked) { subject.link(start, right) }

  subject { Mazerb::Maze.new(5, 5) }

  it("#get") { subject.get(*start).must_be_instance_of Mazerb::Cell }

  it("#exists?") { subject.exists?(0,-1).must_equal false }

  it("#linked?") do
    subject.linked?(start, right).must_equal false
  end

  it("#link") do
    linked.linked?(start, right).must_equal true
    linked.linked?(right.move(*start), right.reverse).must_equal true
  end

  it("#unlink") do
    linked.unlink(start, right)
    linked.linked?(start, right).must_equal false
    linked.linked?(right.move(*start), right.reverse).must_equal false
  end

  it("must be Enumerable") do
    Mazerb::Maze.must_include Enumerable
    subject.must_respond_to :each
  end
end