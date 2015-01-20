require 'mazerb'

include Java

import javax.swing.JFrame
import javax.swing.JPanel
import java.awt.Color

class Example < JFrame
  def initialize
    super "Simple"

    self.initUI
  end

  def initUI

    self.setSize 500, 500
    self.setDefaultCloseOperation JFrame::EXIT_ON_CLOSE
    self.setLocationRelativeTo nil
    self.setVisible true
    self.getContentPane.add MazePanel.new
  end
end

class MazePanel < JPanel
  def initialize(maze_width = 50, maze_height = 50, margin = 5)
    @margin = 5
    @cell_margin = margin
    @maze = Mazerb::Iterator::MazeBuilder.new(
        maze_width, maze_height, Mazerb::Iterator::GrowingTree).build
  end

  def paintComponent(g)
    g.setColor(Color::BLACK);
    g.drawRect(0, 0, width, height);

    g.setColor(Color::WHITE)
    (0...@maze.height).each do |y|
      (0...@maze.width).each do |x|
        paintCell(g, x, y)
        paintWallLeft(g,x,y) if @maze.linked?([x, y], Mazerb::Direction::RIGHT)
        paintWallDown(g,x,y) if @maze.linked?([x, y], Mazerb::Direction::DOWN)
      end
    end
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
    (width - 2*@margin - @maze.width*@cell_margin) / @maze.width
  end

  def cellHeight
    (height - 2*@margin - @maze.height*@cell_margin) / @maze.height
  end

  def cellPosition(x, y)
    [
        @margin + cellWidth * x + @cell_margin * x,
        @margin + cellHeight* y + @cell_margin * y
    ]
  end

end

Example.new