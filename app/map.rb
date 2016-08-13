require './app/global_random.rb'
require './app/wall.rb'

# Handles a lot of walls around the player.
class Map
  SPEED = 1
  def initialize
    @ceiling = []
    @floor = []

    create_ceiling! while need_wall? @ceiling
    create_floor! while need_wall? @floor
  end

  def update
    create_ceiling! if need_wall? @ceiling
    create_floor! if need_wall? @floor
    [@ceiling, @floor].each do |list|
      list.delete_if do |wall|
        wall.point1[0] -= SPEED
        wall.point2[0] -= SPEED
        wall.point2[0] < 0
      end
    end
  end

  def draw
    [@ceiling, @floor].each do |list|
      list.each do |wall|
        wall.draw
      end
    end
  end

  private
  def need_wall?(wall_list)
    return true if wall_list.empty?
    wall_list.last.point2[0] < ApplicationWindow::WINDOW_WIDTH
  end

  def create_ceiling!
    create_wall @ceiling, 0, 100
  end

  def create_floor!
    create_wall @floor,
                ApplicationWindow::WINDOW_HEIGHT - 100,
                ApplicationWindow::WINDOW_HEIGHT
  end

  def create_wall(wall_list, min_height, max_height)
    if wall_list.empty?
      first_point = [0, GlobalRandom::between(min_height, max_height)]
    else
      first_point = wall_list.last.point2
    end
    wall_list << Wall.new(first_point,
                          [first_point[0] + GlobalRandom::between(50, 100),
                           GlobalRandom::between(min_height, max_height)])
                           
  end
end