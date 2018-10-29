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

class AB_Pruning
  
  def initialize
    @expanded = []
  end
  
  def node(type, name, e=0, actions={})
    acts = {}
    actions.each do |k,v| 
      acts[k.to_s] = v
    end
    {:type=>type, :name=>name, :e=>e, :actions=>acts }
  end

  def root 
    @root ||= node(:max, :x1, 0, 
      :a => node(:min, :x2, 0, :b => 8, :c => 6, :d => 7, :e => 5),
      :f => node(:min, :x3, 0, 
        :g => node(:max, :x4, 0, :h => 9, :i => 2),
        :j => node(:max, :x5, 0, :k => 8, :l => 10, :m => 2),
        :n => node(:max, :x6, 0, :o => 3, :p => 2,  :q => 4),
        :r => node(:max, :x7, 0, :s => 0, :t => 5,  :u => 6)
        )
    )
  end

  def max(a,b) 
    return a>b ? a : b
  end

  def min(a,b) 
    return a<b ? a : b
  end

  def terminal_state?(state)
    return state.is_a?(Fixnum)
  end

  def utility(state)
    return state
  end

  def find_action_with_value(state, value)
    if state.is_a?(Hash)
      state[:actions].each do |arc, v|
        return arc if terminal_state?(v) and utility(v)==value # return terminatl value
        return arc if v[:v]==value # return value of node  
      end
    end
  end

  def result(state, action)
    return state[:actions][action]
  end

  def max_value(state, a, b)
    return utility(state) if terminal_state?(state) 
    v = -999999
    state[:actions].keys.sort.each do |action|
      child = state[:actions][action]
      @expanded << action # prunning info
      v = max(v, min_value(result(state,action), a, b)) 
      return state[:v]=v if v >= b
      a = max(a,v)  
    end
    return state[:v]=v
  end

  def min_value(state, a, b)
    return utility(state) if terminal_state?(state) 
    v = 999999
    state[:actions].keys.sort.each do |action|
      child = state[:actions][action]
      @expanded << action # prunning info
      v = min(v, max_value(result(state,action), a, b)) 
      return state[:v]=v if v <= a
      b = min(b,v)  
    end
    return state[:v]=v
  end

  def search(state)
    # returns an action
    value = max_value(state, -999999, 999999)
    puts "Result value is #{value}"
    action = find_action_with_value(state, value)
    puts "Result action is #{action}"
    return action
  end

  def debug(action, state, offset="")
    # display whole tree
    # puts @expanded.inspect
    expanded = @expanded.include?(action)
    if terminal_state?(state)
        puts offset + "#{action} = #{state.to_s} #{expanded ? '' : '-'}"
      return 
    end
    puts offset + "#{action} -> #{state[:name]} = #{state[:v]} #{expanded ? '' : '-'}"
    offset = offset + "  "
    state[:actions].each do |action, child|
      debug(action, child, offset + "  ")
    end
  end
end

alpha_beta = AB_Pruning.new
result = alpha_beta.search(alpha_beta.root)
alpha_beta.debug(nil, alpha_beta.root)