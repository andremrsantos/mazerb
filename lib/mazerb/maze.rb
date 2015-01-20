require 'ostruct'

class Mazerb::Direction
  def initialize(x, y)
    @x, @y = x, y
  end

  def move(x, y)
    [x + @x, y + @y]
  end

  def reverse
    Mazerb::Direction.send(:new, -@x, -@y)
  end

  def flag
    1 << (2*(@x*@x) + @x + (@y*@y) + @y)
  end

  ALL = [
      UP    = Mazerb::Direction.new( 0,-1),
      DOWN  = Mazerb::Direction.new( 0, 1),
      LEFT  = Mazerb::Direction.new(-1, 0),
      RIGHT = Mazerb::Direction.new( 1, 0)
  ]

  private_class_method :new
end

class Mazerb::Cell < OpenStruct
  def initialize(*args)
    @flag = 0
    super
  end

  def open(direction)
    @flag |= direction.flag
    self
  end

  def close(direction)
    @flag &= ~direction.flag
    self
  end

  def open?(direction)
    (@flag & direction.flag) != 0
  end
end

class Mazerb::Maze
  include Enumerable

  attr_reader :width, :height

  def initialize(width, height)
    @width, @height = width, height
    @cells = Array.new(width * height) { Mazerb::Cell.new }
  end

  def get(x, y)
    return nil unless exists?(x,y)
    @cells[to_index(x, y)]
  end

  def exists?(x, y)
    (x >= 0 && x < width) && (y >= 0 && y < height)
  end

  def link(from, direction)
    execute_on_pair(:open, from, direction)
    self
  end

  def unlink(from, direction)
    execute_on_pair(:close, from, direction)
    self
  end

  def linked?(from, direction)
    to = direction.move(*from)
    return false unless exists?(*from) && exists?(*to)
    get(*from).open?(direction) && get(*to).open?(direction.reverse)
  end

  def each(&block)
    @cells.each(&block)
  end

  def to_s
    maze = "#" * (width * 2 + 1)
    (0...height).each do |y|
      cell = "#"
      floor = "#"
      (0...width).each do |x|
        cell << " #{get(x,y).open?(Mazerb::Direction::RIGHT) ? " " : "#"}"
        floor << "#{get(x,y).open?(Mazerb::Direction::DOWN) ? " " : "#"}#"
      end
      maze << "\n" << cell << "\n" << floor
    end
    maze
  end

  private

  def to_index(x,y)
    y * width + x
  end

  def execute_on_pair(command, from, direction)
    to = direction.move(*from)
    if exists?(*from) && exists?(*to)
      get(*from).send(command, direction)
      get(*to).send(command, direction.reverse)
    end
  end
end