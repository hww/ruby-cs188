class Food
  
	attr_accessor :x
	attr_accessor :y

  def initialize(x,y)
    @x = x
    @y = y
  end
  
  def is_at_position(x,y) 
    return (@x==x and @y==y)
  end
  
end