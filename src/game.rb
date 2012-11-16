#!/bin/env ruby

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

    # Set up autoload directories for Surface, Sound, and Music.
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
    #@map = Map["smallMaze.lay"]
    @map = Map["tinySearch.lay"]
    @problem = CornersProblem.new(@map)
    @search = Search.new(@map)
    @solution = @search.ucs(@problem)
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