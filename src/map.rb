require './food'
require './state'

class Map
  
  include Rubygame::NamedResource

     
  attr_accessor :map
  attr_accessor :w
  attr_accessor :h
  attr_accessor :walls
  attr_accessor :foods
  attr_accessor :initial_state
  attr_accessor :ghosts
  
  class << self
    
    def autoload( name )
      # Searches autoload_dirs for the file
      path = find_file( name )
      if( path )
        return load_map( path )
      else
        return nil
      end
    end
  
    def load_map( path )
      map = Map.new
      map.load_map( path )
      return map
    end
    
  end

  def initialize
    @map = []
    @w = @h = 0
    @walls = []
    @foods = []
    @initial_state = nil
  end
  
  def load_map( path )
    @map = []

    # read file
    File.readlines(path).each do |line|
      @map.push(line.strip.chars.to_a)
    end

    # calculate size
    @h = map.size
    @w = map.map{|line| line.size}.max

    # build walls
    @walls = map.map{|line| line.map{|c| c=='%'}}

    # collect food & initial position
    @foods = []
    @ghosts = []
    @map.each_with_index do |row, rown|
      row.each_with_index do |col, coln|
        case map[rown][coln]
        when '.'
          @foods << Food.new(coln, rown)
        when 'P'
          @initial_state = State.new(coln, rown)
        when 'G'
          @ghosts = State.new(coln, rown) 
        end
      end
    end


  end

  
end