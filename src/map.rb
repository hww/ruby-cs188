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