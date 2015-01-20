require 'mazerb'

include Java

import javax.swing.JFrame
import javax.swing.JPanel
import javax.swing.Timer
import java.awt.Color

class Example < JFrame
  def initialize
    super "Simple"

    self.initUI
  end

  def initUI
    @panel = MazePanel.new
    self.getContentPane.add @panel

    self.setSize 500, 500
    self.setDefaultCloseOperation JFrame::EXIT_ON_CLOSE
    self.setLocationRelativeTo nil
    self.setVisible true

    @timer = Timer.new(0.05) do |e|
      @panel.connect
      @timer.restart unless @panel.endend?
    end
    @timer.start
  end
end

class MazePanel < JPanel
  def initialize(maze_width = 25, maze_height = 25)
    @base_margin = 5
    @maze = Mazerb::Maze.new(maze_width, maze_height)
    @it = Mazerb::Iterator::GrowingTree.new(@maze)
  end

  def connect
    if @it.has_next?
      @it.next
      @maze.link(@it.move.from, @it.move.direction)
      self.repaint()
    end
  end

  def endend?
    !@it.has_next?
  end

  def paintComponent(g)
    g.setColor(Color::BLACK)
    g.drawRect(0, 0, width, height)

    g.setColor(Color::WHITE)
    (0...@maze.height).each do |y|
      (0...@maze.width).each do |x|
        paintCell(g, x, y)
        paintWallLeft(g,x,y) if @maze.linked?([x, y], Mazerb::Direction::RIGHT)
        paintWallDown(g,x,y) if @maze.linked?([x, y], Mazerb::Direction::DOWN)
      end
    end

    g.setColor(Color::GREEN)
    paintCell(g, *@it.move.to)
  end

  private

  def paintCell(g, x, y)
    position = cellPosition(x,y)
    g.fillRect position[0], position[1], cellWidth, cellHeight
  end

  def paintWallLeft(g, x, y)
    position = cellPosition(x,y)
    g.fillRect position[0], position[1], 2*cellWidth, cellHeight
  end

  def paintWallDown(g, x, y)
    position = cellPosition(x,y)
    g.fillRect position[0], position[1], cellWidth, 2*cellHeight
  end

  def width
    getSize.width
  end

  def height
    getSize.height
  end

  def cellWidth
    @cell_width ||= ((width - 2*@base_margin) / (1.2 * @maze.width)).floor
  end

  def cellHeight
    @cell_height ||=((height - 2*@base_margin)/ (1.2 * @maze.height)).floor
  end

  def cellUpperMargin
    @cell_upper_margin ||= (0.2 * cellHeight).floor
  end

  def cellSideMargin
    @cell_side_margin ||=(0.2 * cellWidth).floor
  end

  def sideMargin
    ((width - @maze.width * (cellWidth + cellSideMargin))/2).floor
  end

  def upperMargin
    ((height - @maze.height * (cellHeight + cellUpperMargin))/2).floor
  end

  def cellPosition(x, y)
    [
        sideMargin + x * (cellWidth + cellSideMargin),
        upperMargin+ y * (cellHeight+ cellUpperMargin)
    ]
  end

end

Example.new