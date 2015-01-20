module Mazerb::Iterator; end

require 'mazerb/movement'
require 'mazerb/data'

## Maze builder that uses the maze iterator to construct the maze passages
class Mazerb::MazeBuilder < Struct.new(:width, :height, :iterator)
  def build
    maze = Mazerb::Maze.new(width, height)
    it = iterator.new(maze).each do |_|
      maze.link(it.move.from, it.move.direction)
    end
    maze
  end
end

class Mazerb::Iterator::MazeIterator
  include Enumerable

  attr_reader :maze, :move
  def initialize(maze, move_structure)
    @maze = maze
    @move_structure = move_structure
    reset
  end

  def reset
    @moves = @move_structure.new
    @move  = build_move([0,0], Mazerb::Direction::DOWN)
    @visited = {}
  end

  def has_next?
    @move = @moves.pop while visited?(move.to) && !@moves.empty?
    !visited?(move.to)
  end

  def next
    return nil unless has_next?

    visit
    current
  end

  def current
    return nil if move.nil?
    maze.get(*move.to)
  end

  def each(&block)
    block.call(self.next) while has_next?
    self
  end

  protected
  def visited?(cell)
    @visited.has_key? maze.get(*cell)
  end

  def visit
    @visited[current] = true

    source = move.to
    each_movement do |direction|
      destiny = direction.move(*source)
      if maze.exists?(*destiny) && !visited?(destiny)
        @moves.push build_move(source, direction)
      end
    end
  end

  def each_movement(&block)
    Mazerb::Direction::ALL.shuffle.each(&block)
  end

  def build_move(source, direction)
    Mazerb::Iterator::Movement.new(source, direction)
  end
end

class Mazerb::Iterator::RandomPrim < Mazerb::Iterator::MazeIterator
  def initialize(maze)
    super(maze, Mazerb::Data::Heap)
  end

  protected
  def build_move(source, direction)
    Mazerb::Iterator::WeightedMovement.new(source, direction)
  end
end

class Mazerb::Iterator::GrowingTree < Mazerb::Iterator::MazeIterator
  def initialize(maze)
    super(maze, Array)
  end
end