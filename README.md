ruby-cs188
==========

Ruby version of algorithms from the BerkeleyX's CS188.1X Introduction to Artificial Intelligence course 

I referred to the book "Artificial Intelligence A Modern Approach" - Third Edition. My goal was make code which is looks as much more close to the pseudo-code definitions from this book.

Look at the search.rb file:

* **bfs()** - Figure 3.11 Breadth-first search on a graph.

* **dfs()** - Figure 3.17 A recursive implementation of depth-limited tree search. _I found this pseudo code strange. As result I used pseudo-code from bfs with small changes._
		
* **ucs()** - Figure 3.14 Uniform-cost search on a graph. The algorithm is identical to the general graph search algorithm in Figure 3.7, except for the use of a priority queue and the addition of an extra check in case a shorter path to a frontier state is discovered. The data structure for frontier needs to support efficient membership testing, so it should combine the capabilities of a priority queue and a hash table.

* **rbfs()** - Figure 3.26 The algorithm for recursive best-first search. _It has problems with the memory requirement (Ruby's stack overflow). As result it handle small maps._

## Layouts and Maps

The folder resources/layouts has layouts taken from cs188's Python code.

## Pre Requirements 

``` bash
> gem install rubygame
```

## How to run 

For the functions: bfs, dfs, ucs and rbfs just run game

```bash
> ruby game.rb
```

Check the game initialization code, you can change search function: bfs, dfs, ucs, rbfs

For the alpha-beta pruning

```bash
> ruby ab_pruning.rb
```

Check code and setup your graph table

```ruby
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
```

The function _node_ gets params: 

* node type [:min|:max|value] 
* state name
* value of the node: _e_
* list of arcs, where every arch is the key value pair
	* key is the next state
	* value is [node|value]

There is also file qv_values.rb which has code for value evaluation or q-value evaluation function

## License 

Use it for your own risk just refer to this page if it possible
