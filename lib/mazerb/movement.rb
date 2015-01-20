class Mazerb::Iterator::Movement
  include Comparable

  attr_reader :from, :direction
  def initialize(from, direction)
    @from, @direction = from, direction
  end

  def <=> (other)
    self.weight <=> other.weight
  end

  def to
    direction.move(*from)
  end
end

class Mazerb::Iterator::WeightedMovement < Mazerb::Iterator::Movement
  attr_reader :weight

  def initialize(from, direction, weight = Random.rand())
    super(from, direction)
    @weight = weight
  end
end