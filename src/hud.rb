require 'rubygame'

# for convenience/readability.
include Rubygame
include Rubygame::Events

# A class representing the HUD
class Hud

  # construct the HUD
  def initialize options
    @screen = options[:screen]  # need that to blit on it

    # TTF.setup must be called before any font object is created
    TTF.setup

    # point to the TTF file
    filename = File.join(File.dirname(__FILE__), '..', 'resources', 'fonts', 'ProFontWindows.ttf')

    # creates the font object, which is used for drawing text
    @cosmic_font = TTF.new filename, 24

    # initialize options that are displayed, here time
    @map = []
    @expansions = []
  end
  
  # called from the game class in each loop. updates options that are displayed
  def update options
    @time = options[:time]
    @map = options[:map]
    @player = options[:player]
    @search = options[:search]
    @problem = options[:problem]
  end
  
  # called from the game class in the draw method. render any options 
  # and blit the surface on the screen
  def draw
    c = @cosmic_font.render " ", true, [0,0,0], [80,80,128]
    w,h = c.w, c.h
    # render expansions
    @search.expansions.each_with_index do |row, rown|
      row.each_with_index do |col, coln|
        cost = 0
        #state = @player.dup
        #state.x, state.y = coln, rown
        #cost = @problem.f(:stop, state) * 3
        char = @cosmic_font.render " ", true, [0,0,0], [col || 0, cost,0]
        char.blit @screen, [w*coln, h*rown]
      end
    end

    # render walls
    @map.walls.each_with_index do |row, rown|
      row.each_with_index do |col, coln|
        if col
          char = @cosmic_font.render " ", true, [0,0,0], [80,80,128]
          char.blit @screen, [w*coln, h*rown] 
        end
      end
    end
    # render food
    @player.data.each_with_index do |f,idx|
      if f
        food = @map.foods[idx]
        char = @cosmic_font.render ".", true, [255,255,255]
        char.blit @screen, [w*food.x, h*food.y]
      end
    end
    
    # render start and goal
    state = @map.initial_state
    char = @cosmic_font.render "S", true, [255,255,255]
    char.blit @screen, [w*state.x, h*state.y]
    
    # render player
    char = @cosmic_font.render "X", true, [255,255,255]
    char.blit @screen, [w*@player.x, h*@player.y]

    
  end

end