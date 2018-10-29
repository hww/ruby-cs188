#!/bin/env ruby

# =============================================================================
# MIT License
# 
# Copyright (c) [2018] [Valeriya Pudova]
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# =============================================================================

require 'rubygems'
require 'rubygame'

require './hud'
require './map'
require './search'
require './corners_problem'

class Game
  def initialize
    # Get the absolute path to the directory that this script is in.
    this_dir = File.dirname( File.expand_path(__FILE__) )
    # Set up auto load directories for Surface, Sound, and Music.
    # Surfaces (images) will be loaded from the "images" directory,
    # Sounds from "sfx", and Music from "music".
    Surface.autoload_dirs << File.join(this_dir, "../resources/images")
    Sound.autoload_dirs   << File.join(this_dir, "../resources/sfx")
    Music.autoload_dirs   << File.join(this_dir, "../resources/music")
    Map.autoload_dirs     << File.join(this_dir, "../resources/layouts")

    @screen = Rubygame::Screen.new [640,480], 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF]
    @screen.title = "Generic Game!"
    @queue = Rubygame::EventQueue.new
    @clock = Rubygame::Clock.new
    @clock.target_framerate = 30

    # to create the hud
    @hud = Hud.new :screen => @screen
    
    # load layout
    @map = Map["tinyCorners.lay"]
    @problem = CornersProblem.new(@map)
    @search = Search.new(@map)
    @solution = @search.rbfs(@problem)
    puts "Solution size: #{@solution.size}"
    @player_state = @map.initial_state
    @speed = 20
    @timer = 0
  end
  
  def run
    loop do
      update
      draw
      @clock.tick
    end
  end
  
  def update
    @queue.each do |ev|
      case ev
        when Rubygame::QuitEvent
          Rubygame.quit
          exit
      end
    end
    # to update contents
    @timer += 1
    @hud.update :map => @map, :player => @player_state, :search => @search, :problem => @problem
    if (@timer>@speed)
      @timer = 0
      if (action = @solution.shift) 
        @player_state = @problem.next_state(@player_state, action)
      end  
    end
  end
  
  def draw
    # to draw
    @screen.fill :black
    @hud.draw
    @screen.update
  end
end

game = Game.new
game.run