ruby-cs188
==========

Ruby version of algorithms from the BerkeleyX's CS188.1X Introduction to Artificial Intelligence course 

I refereed to the book "Artificial Intelligence A Modern Approach" - Third Edition. My goal was make code which is looks as much more close to the pseudo-code definitions from this book.

Look at the search.rb file:

bfs() - Figure 3.11 Breadth-first search on a graph.

dfs() - Figure 3.17 A recursive implementation of depth-limited tree search. 
		
		> I found this pseudo code strange. As result I used pseudo-code from bfs with small changes
		
ucs() - Figure 3.14 Uniform-cost search on a graph. The algorithm is identical to the general graph search algorithm in Figure 3.7, except for the use of a priority queue and the addition of an extra check in case a shorter path to a frontier state is discovered. The data structure for frontier needs to support efficient membership testing, so it should combine the capabilities of a priority queue and a hash table.

rbfs() - Figure 3.26 The algorithm for recursive best-first search.
		 
		> It has problems with the memory requirement (Ruby's stack owerflow). As result it handle small maps

** Layouts and Maps **

The folder resources/layouts has layouts taken from cs188's Phyton code.

** How to run **

> ruby game.rb

** Prerequirements **

> gem install rubygame

** License **

Use it for your own risk just refer to this page if it possible
