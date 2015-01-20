module Mazerb::Data

  class Heap
    include Enumerable

    def initialize(*arr)
      @arr = []
      Array.new(*arr).each { |val| self.push val }
    end

    def size
      @arr.size
    end

    def empty?
      size == 0
    end

    def push(value)
      @arr << value
      bubble_up
      self
    end

    def pop
      switch(0, size - 1)
      val = @arr.pop
      sink_down
      val
    end

    def each(&block)
      arr = @arr.copy
      block.call(self.pop) until self.empty?
      @arr = arr
      self
    end

    def to_s
      "<Heap [#{@arr.join(',')}]>"
    end

    private

    def bubble_up(child = size-1)
      parent = (child/2).floor
      if less_than(child, parent)
        switch(child, parent)
        bubble_up(parent)
      end
    end

    def sink_down(index = 0)
      child = smallest_child(index)
      if !child.nil? && less_than(child, index)
        switch(child, index)
        sink_down(child)
      end
    end

    def smallest_child(index)
      child_a = index * 2 + 1
      child_b = child_a + 1
      less = less_than(child_a, child_b)

      if less.nil? && exists?(child_a)
        child_a
      elsif less.nil? && exists?(child_b)
        child_b
      else
        less ? child_a : child_b
      end
    end

    def switch(from, to)
      @arr[from], @arr[to] = @arr[to], @arr[from]
    end

    def less_than(it, that)
      return @arr[it] < @arr[that] if exists?(it) && exists?(that)
      nil
    end

    def exists?(index)
      index >= 0 && index < size
    end
  end

end