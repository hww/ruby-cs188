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

# =============================================================================
# PROPER TAIL RECURSION 
# =============================================================================
#
# Ruby doesn’t do tail call optimization. That sucks. However, 
# quite a few month ago I managed to fake it:
#  
# use in your class as helper: 
#
#   class Foo
#
#      tailcall_optimize :your_function
#
#   end
#
# =============================================================================

class Class
  # Sweet stuff!
  def tailcall_optimize( *methods )
    methods.each do |meth|
      org = instance_method( meth )
      define_method( meth ) do |*args|
        if Thread.current[ meth ]
          throw( :recurse, args )
        else
          Thread.current[ meth ] = org.bind( self )
          result = catch( :done ) do
            loop do
              args = catch( :recurse ) do
                throw( :done, Thread.current[ meth ].call( *args ) )
              end
            end
          end
          Thread.current[ meth ] = nil
          result
        end
      end
    end
  end
end

# =============================================================================
# SEARCH ALGIRITM
# =============================================================================

class Search

  # =========================================
  # debugging 
  # =========================================
  
  attr_accessor :expansions
  attr_accessor :expansion_time
  
  def initialize(map)
    # initialize expansions
    @expansions = map.walls.map{|row| row.map{|col| 0}}
    @expansion_time = 0
  end
  
  def expand(state)
    x, y = state.x, state.y
    @expansions[y][x] = @expansion_time
    @expansion_time += 1
  end
 
  def expansions
    if @expansion_time>0
      k = 220/@expansion_time
      @expansions = @expansions.map{|row| row.map{|col| col>0 ? col * k + 30 : 0}}
      @expansion_time = 0
    end
    return @expansions 
  end
 
  # =========================================
  # SEARCH UTILS
  # =========================================
 
  # get child node of for node and action
  def child_node(problem, node, action)
      state = node.state
      expand(state)
      next_state = problem.next_state(state,action)
      return Node.new(node, action, next_state) 
  end
  
  # build solution
  def solution(node)
    solution = []
    while (node)
      solution.unshift(node.action) if node.action
      node = node.parent
    end
    return solution
  end
  
  def max(a,b) ; a>=b ? a : b ; end
  def min(a,b) ; a<=b ? a : b ; end
  def infinity ; 99999999 ; end
    
  # =========================================
  # SEARCH 
  # =========================================
  
  def bfs(problem) # returns a solution, or failure

    node = Node.new(nil, nil, problem.initial_state)

    return solution(node) if problem.is_goal(node.state) 

    frontier = [node]                       # a FIFO queue with node as the only element
    explored = {}                           # an empty set

    while true do
      return nil if frontier.empty?         # failure
      node = frontier.shift                 # chooses the shallowest node in frontier 
      explored[node.state.to_hash] = true   # add state to explored
      problem.actions(node.state).each do |action|
        child = child_node(problem,node,action)
        if not (explored.include?(child.state.to_hash) or frontier.find{|e| e == child})
          if problem.is_goal(child.state) 
              return solution(child) 
          else
              frontier.push(child) # will be expanded last
          end
        end
      end
    end
  end


  def dfs(problem) # returns a solution, or failure

    node =  Node.new(nil, nil, problem.initial_state)

    return solution(node) if problem.is_goal(node.state) 

    frontier = [node]                       # a FIFO queue with node as the only element
    explored = {}                           # an empty set

    while true do
      return nil if frontier.empty?         # failure
      node = frontier.shift                 # chooses the shallowest node in frontier 
      explored[node.state.to_hash] = true   # add state to explored
      problem.actions(node.state).each do |action|
        child = child_node(problem,node,action)
        if not (explored.include?(child.state.to_hash) or frontier.find{|e| e == child})
          if problem.is_goal(child.state) 
              return solution(child) 
          else
              frontier.unshift(child) # next will be expanded this node
          end
        end
      end
    end
  end
  
  def ucs(problem)                  # returns a solution, or failure
    node = Node.new(nil, nil, problem.initial_state)
    frontier = [node]               # a priority queue ordered by PATH-COST, with node as the only element
    explored = {}                   # an empty set

    while true do
      return nil if frontier.empty? # failure

      node = frontier.shift         # chooses the shallowest node in frontier 
      
      return solution(node) if problem.is_goal(node.state) 

      explored[node.state.to_hash] = true   # add state to explored
      do_order = false # speed
      problem.actions(node.state).each do |action|
        child = child_node(problem,node,action)
        child.state.f = node.state.f + child.state.g
        frontier_has_index = frontier.index{|e| e == child}

        if not (explored.include?(child.state.to_hash) or frontier_has_index)
          frontier.push(child)
          do_order = true # speed
        elsif frontier_has_index and frontier[frontier_has_index].state.f > child.state.f
          frontier[frontier_has_index] = child 
          do_order = true # speed
        end
      end
      frontier = frontier.sort{|a,b| a.state.f<=>b.state.f } if do_order
    end
  end
      

  def rbfs(problem) # returns a solution, or failure return
    @explored = {}
    result, tmp = rbfs_recursive(problem, Node.new(nil, nil, problem.initial_state), infinity)
    puts result.inspect
    return result
  end
  
  def rbfs_recursive(problem, node, f_limit) # returns a solution, or failure
    return solution(node), node.f if problem.is_goal(node.state) 
    @explored[node.state.to_hash] = true   # add state to explored
    successors = problem.actions(node.state).map{|action| child_node(problem,node,action) }
    # next line needed to eliminate bunch of additional expansions
    successors = successors.find_all{|sucessor| @explored[sucessor.state.to_hash].nil? }
    return nil, infinity if successors.empty? # failure because no successors
    # update f with value from previous search, if any 
    successors.each do |sucessor| 
      s = sucessor.state
      sucessor.f = max(s.g + s.h, node.f)
    end
    while true do
      # sort successors
      successors = successors.sort{|a,b| a.f<=>b.f }
      # get first and second best values
      best, alternative = successors[0..1]
      # terminate if f-cost more limit or equal infinity
      return nil, best.f if best.f>f_limit or best.f==infinity
      # make new limit according to best second alternative
      # no reasons expand more then second alternative
      new_f_limit = alternative ? min(f_limit,alternative.f) : f_limit
      # get result of expansion and update the best.f value
      result, best.f = rbfs_recursive(problem, best, new_f_limit)
      return result, 0 unless result.nil?
    end
  end
  
  # TODO make proper tail recursion
  #tailcall_optimize :rbfs_recursive

end 