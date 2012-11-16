class Node 
  
  attr_accessor :parent
  attr_accessor :action
  attr_accessor :state



  def initialize(parent, action, state)
    @parent = parent
    @action = action
    @state = state
    @f_limit = 99999999
  end
  
  def to_hash
    state.to_hash
  end
  
  def ==(other)
    return state == other.state
  end

  
end