class State

	attr_accessor :x
	attr_accessor :y
	attr_accessor :data
	
	attr_accessor :f # total cost
  attr_accessor :g # g_cost - arc cost
  attr_accessor :h # h_cost - heurestics
  
  def initialize(x,y,d=nil)
    @x = x
	  @y = y
	  @data = d
	  @f =  @g =  @h = 0
  end

  def to_hash
    {:x => @x, :y => @y, :data => @data}
  end

  def ==(other)
    return to_hash == other.to_hash
  end
  
end