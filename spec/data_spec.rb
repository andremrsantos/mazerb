require 'spec_helper'
require 'mazerb/data'

describe Mazerb::Data::Heap do
  let(:empty_heap) { Mazerb::Data::Heap.new }
  let(:full_heap)  { Mazerb::Data::Heap.new (1..10).map { rand(10) }}
  subject          { empty_heap }

  it "#size" do
    empty_heap.size.must_equal 0
    full_heap.size.must_equal 10
  end

  it "#empty?" do
    empty_heap.empty?.must_equal true
    full_heap.empty?.must_equal false
  end

  it "#push" do
    empty_heap.push(10)
    empty_heap.empty?.must_equal false
  end

  it "#pop" do
    val = Struct.new("Mock")
    empty_heap.push(val)
    empty_heap.pop.must_be_same_as val
    empty_heap.empty?.must_equal true
  end

  it "must pop in crescent order" do
    last = full_heap.pop
    until full_heap.empty?
      cur = full_heap.pop
      cur.must_be :>=, last
      last = cur
    end
  end

  it "must be enumerable" do
    Mazerb::Data::Heap.must_include Enumerable
    subject.must_respond_to :each
  end
end