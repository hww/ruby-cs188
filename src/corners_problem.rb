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

require "./node"
require "./problem_base"

# =========================================
# IMPLEMENTATIONS
# =========================================

class CornersProblem < ProblemBase
  
  attr_accessor :map

  def initialize(map)
    @map = map
  end
  
  # get initial state
  def initial_state
    state = @map.initial_state
    state.data = @map.foods.map{|food| true} # each food has true
    return state
  end
  
  # check if this state is goal
  def is_goal(state)
    @map.foods.each_with_index do |food, idx|
      return false if state.data[idx] and (state.x!=food.x or state.y!=food.y)
    end
    return true
  end 

  # return all available actions
  def available_actions()
    return [:left, :up, :right, :down] 
  end
  
  # return next position if we will do action. ignore walls
  def next_position(state,action)
    dx, dy = {:stop => [0,0], :left => [-1,0], :up => [0,-1], :right => [1,0], :down => [0,1]}[action]
    return state.x + dx, state.y + dy    
  end
  
  # return next state if we will do action. ignore walls
  def next_state(state,action)
    x,y = next_position(state,action)
    if @map.walls[y][x]
      new_state = state.dup
      new_state.g = 1
    else
      new_state = State.new(x,y,state.data.dup)
      state.data.each_with_index do |f,idx|
        if f and @map.foods[idx].is_at_position(x,y)
          new_state.data[idx] = false
        end
      end
      new_state.g = 1                         # g_cost - arc cost
      new_state.h = h_cost(action, new_state) # g_cost - arc cost
    end
    return new_state
  end
  
  # get actions per state  
  def actions(state)
    acts = []
    available_actions.each do |action|
      x,y = next_position(state, action)
      acts << action unless @map.walls[y][x]
    end
    return acts
  end

  def h_cost(action, state_after)
    # --------------------------
    @h_cost_cache ||= {} 
    cache_key = state_after.to_hash
    return @h_cost_cache[cache_key] if @h_cost_cache[cache_key]
    # --------------------------
    max_dist = -9999999
    state_after.data.each_with_index do |f,idx|
      if f
        food = @map.foods[idx]
        dist = (food.x-state_after.x).abs + (food.y-state_after.y).abs 
        max_dist = max_dist>dist ? max_dist : dist
      end
    end
    # --------------------------
    @h_cost_cache[cache_key] = max_dist
    # --------------------------
    return max_dist
  end
  
end
