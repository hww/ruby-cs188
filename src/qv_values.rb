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

def root
  {
    :a => { :p => 0, :b => 0  },
    :b => { :a => 0, :c => 0  },
    :c => { :b => 0, :d => -1 },
    
    :d => { :c => 0, :e => -1 },
    :e => { :d => 0, :f => 2  },
    :f => {          :g => 2  },
    :g => {          :j => 0  },
    
    :j => { :g => 0, :k => 0  },
    :k => { :j => 0, :l => 0  },
    :l => { :k => 0, :m => 0  },

    :m => { :l => 0, :n => 0  },
    :n => { :m => 0, :o => 0  },
    :o => { :n => 0, :p => 0  },
    :p => { :o => 0, :a => 0  }
  }
end

def v_value(nodes, gamma, alfa = 1, steps = 30)
  
  # sorted names of states
  states = nodes.map{|k,v| k.to_s}.sort.map{|s| s.to_sym}
  
  # initialize storyboard
  v_values_story = []
  q_values_story = []

  # initialize v-values
  v_values = Hash[nodes.map{|k,v| [k,0] }]
  v_values_story << v_values  # keep story for visualization

  steps.times do |step_num|

    new_v_values = {}
    new_q_values = {}
    
    states.each do |state|
      new_q_values[state] ||= {}
      nodes[state].each do |next_state, reward|
        q = reward + gamma * v_values[next_state]
        new_q_values[state][next_state] = q
      end
      v_value = new_q_values[state].map{|next_state,q_value| q_value}.max # get max q-value
      new_v_values[state] = ((1-alfa) * v_values[state]) + alfa * v_value
    end
    q_values_story << new_q_values  # keep story for visualization
    v_values_story << new_v_values  # keep story for visualization
    differences = states.map{|s,v| v_values[s]==new_v_values[s] ? nil : true }
    # print updates of the values
    puts differences.map{|d| d ? "1" : "0"}.join("")
    return v_values_story, q_values_story if differences.compact.empty?
    v_values = new_v_values
  end

  return v_values_story, q_values_story
end


def q_value(nodes, gamma, alfa = 1, steps = 30)

  # sorted names of states
  states = nodes.map{|k,v| k.to_s}.sort.map{|s| s.to_sym}
  
  # initialize storyboard
  q_values_story = []

  # initialize v-values
  q_values = {}
  nodes.each do |state, actions|
    actions.each do |next_state, reward|
      q_values[state] ||= {}
      q_values[state][next_state] = 0
    end
  end
  q_values_story << q_values  # keep story for visualization

  steps.times do |step_num|
    new_q_values = {}
    
    states.each do |state|
      new_q_values[state] ||= {}
      nodes[state].each do |next_state, reward|
        nextq = q_values[next_state].map{|k,v| v}
        q = reward + gamma * nextq.max
        new_q_values[state][next_state] =  ((1-alfa) * q_values[state][next_state]) + alfa * q
      end
    end
    q_values_story << new_q_values  # keep story for visualization
    differences = states.map{|s,v| q_values[s]==new_q_values[s] ? nil : true }
    # print updates of the values
    puts differences.map{|d| d ? "1" : "0"}.join("")
    return q_values_story if differences.compact.empty?
    q_values = new_q_values
  end
  return q_values_story
end


def debug_v(nodes, v_story)
  # sort state by names
  states = nodes.map{|k,v| k.to_s}.sort.map{|s| s.to_sym}
  v_story.each_with_index do |values, index|
    line = states.map{|state| sprintf("%s: %6.4f", state, values[state]) }
    puts index.to_s.rjust(3) + ": " + line.join('  ')
  end
end

def debug_q(nodes,q_story)
  # sort state by names
  states = nodes.map{|k,v| k.to_s}.sort.map{|s| s.to_sym}
  q_story.each_with_index do |values, index|
    max_lines = 0
    lines = {}
    states.each do |state|
      lines[state] ||= []
      states.each do |next_state|
        q_val = values[state][next_state]
        if q_val
          lines[state] << sprintf("%s%s: %6.3f", state, next_state, q_val) 
          max_lines = lines[state].size if max_lines<lines[state].size
        end
      end
    end
    s = ""
    max_lines.times do |i|
      s = index.to_s.rjust(3) + ": " + states.map{|state| lines[state][i] || sprintf("%s%s: %6s", " ", " ", " " )}.join('  ') 
      puts s
    end
    puts "-" * s.size
  end
end

#v_story, q_story = v_value(root, 1)
#debug_v(root, v_story)
q_story = q_value(root, 1, 0.5)
debug_q(root, q_story)
