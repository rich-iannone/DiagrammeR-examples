# 002 # Random Graphs

library(DiagrammeR)

#
# Part 1. Random Graphs with `create_random_graph()`
#

# Creating a random graph is actually quite useful.
# Seeing these graphs with specified numbers of nodes
# and edges will allow you to quickly get a sense of
# how connected graphs can be at different sizes.

# The `create_random_graph()` function is provided with
# several options for creating random graphs. In all
# the examples, the function will be wrapped in
# `render_graph()` (with `output = "visNetwork"`) to
# quickly inspect the graph upon creation.

# We can create a not-so-random graph with 2 nodes
# and 1 edge (by default, the graphs produced are
# undirected graphs).

render_graph(
  create_random_graph(n = 2, m = 1),
  output = "visNetwork")

# It's better with more nodes and edges. Try 15
# nodes, and 30 edges:

render_graph(
  create_random_graph(n = 15, m = 30),
  output = "visNetwork")

# Notice that only one edge is possible between a
# pair of nodes (i.e., no multiple edges created).

# What if you specify a number of edges that exceeds
# the number in a fully-connected graph of size `n`?
# You get an error. It's an informative error
# (providing the maximum number of edges `m` for the
# given `n`) but an error nonetheless.

render_graph(
  create_random_graph(n = 15, m = 200),
  output = "visNetwork")

# --------------------------------------------------------
# Error in create_random_graph(n = 15, m = 200) : 
#   The number of edges exceeds the maximum possible (105) 
# --------------------------------------------------------

# So, using `n = 15` and `m = 105` will yield a fully-
# connected graph with 15 nodes:

render_graph(
  create_random_graph(n = 15, m = 105),
  output = "visNetwork")

# Going the opposite way, you don't need to have edges.
# Simply specify `m = 0` for any number of nodes n:

render_graph(
  create_random_graph(n = 512, m = 0),
  output = "visNetwork")

#
# Part 2. Random Yet Reproducible
#

# Setting a seed a great way to create something random
# yet reproduce that random something for many reasons.
# This can be done with the `create_random_graph()`
# function by specifying a seed number with the argument
# `set_seed`. Here's an example

render_graph(
  create_random_graph(n = 5, m = 4,
                      set_seed = 30),
  output = "visNetwork")

# Upon repeat runs, the connections in the graph will
# be the same each and every time ("3" is a free node,
# "1" is connected to "2" and "5", etc.).

#
# Part 3. Directed/Undirected Randomness
#

# By default, the random graphs generated are
# undirected. To produce directed graphs, simply include
# `directed = TRUE` in the `create_random_graph()`
# statement.

render_graph(
  create_random_graph(n = 15, m = 22,
                      directed = TRUE),
  output = "visNetwork")
