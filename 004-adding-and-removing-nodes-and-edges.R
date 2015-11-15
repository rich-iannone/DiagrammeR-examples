# 004 # Adding and Removing Nodes and Edges

library(DiagrammeR)

#
# Part 1. Adding Nodes and Edges
#

# First, create an empty graph. It's sometimes good to
# start with an empty slate:

graph <- create_graph()

# You can individual nodes to a graph by using the
# `add_node()` function. Let's add two nodes with IDs
# "1" and "2":

graph <- add_node(graph, node = 1, type = "number")
graph <- add_node(graph, node = 2, type = "number")

# To prove that the nodes are in the graph, we can use
# the `get_nodes()` function:

get_nodes(graph)
#> [1] "1" "2"

# Likewise, to prove that there are no edges in the
# graph, we can use the `get_edges()` function:

get_edges(graph)
#> [1] NA

# A graph can indeed have no edges but it's silly.
# Add a single edge with the `add_edge()` function:

graph <- add_edge(graph,
                  from = 1, to = 2,
                  rel = "to_number")

# Now verify that the edge has been added by using
# `get_edges()` again:

get_edges(graph)
#> [[1]]
#> [1] "1"
#> 
#> [[2]]
#> [1] "2"

# The `get_edges()` function can output the pairs
# of nodes in edges either as a list (as above, it's
# the default), as a data frame, or as a vector. Here
# are examples of the latter two output types:

get_edges(graph, return_type = "df")
#>   from to
#> 1    1  2

get_edges(graph, return_type = "vector")
#> [1] "1 -> 2"

# Nodes can also be added while specifying edges. This
# is best shown through several examples:

graph <- add_node(graph,
                  node = 3,
                  type = "number",
                  from = 2)

get_edges(graph, return_type = "vector")
#> [1] "1 -> 2" "2 -> 3"

graph <- add_node(graph,
                  node = 4,
                  type = "number",
                  to = 3)

get_edges(graph, return_type = "vector")
#> [1] "1 -> 2" "2 -> 3" "4 -> 3"

graph <- add_node(graph,
                  node = 5,
                  type = "number",
                  from = 1, to = 2)

get_edges(graph, return_type = "vector")
#> [1] "1 -> 2" "2 -> 3" "4 -> 3" "1 -> 5" "5 -> 2"

# There may be even multiple edges set 'to' and/or
# 'from' the new node:

graph <- add_node(graph,
                  node = 6,
                  type = "number",
                  from = 1:3)

get_edges(graph, return_type = "vector")
#> [1] "1 -> 2" "2 -> 3" "4 -> 3" "1 -> 5" "5 -> 2"
#> [6] "1 -> 6" "2 -> 6" "3 -> 6"

graph <- add_node(graph,
                  node = 7,
                  type = "number",
                  to = 4:6)

get_edges(graph, return_type = "vector")
#> [1] "1 -> 2" "2 -> 3" "4 -> 3" "1 -> 5" "5 -> 2"
#> [6] "1 -> 6" "2 -> 6" "3 -> 6" "7 -> 4" "7 -> 5"
#> [11] "7 -> 6"

get_nodes(graph)
#> [1] "1" "2" "3" "4" "5" "6" "7"

# Have a look at the final graph in the RStudio Viewer
# by using the `render_graph()` function

render_graph(graph, output = "visNetwork")

# Notice that the edge relationship value has only been
# added to the "1" -> "2" edge as "to_number". While
# using `add_node()` to specify nodes and edges is
# convenient, you cannot specify edge relationships as
# with `add_edges()`. However, you do want to specify
# all the rel values for all edges as "to_number". This
# can be done with the `set_edge_attr()` function. To
# do this unconditionally to all edges in the graph:

graph <- set_edge_attr(graph,
                       edge_attr = "rel",
                       values = "to_number")

# How to check if applied? Use the `get_edge_attr()`
# function:

get_edge_attr(graph)
#>    from to       rel
#> 1     1  2 to_number
#> 2     2  3 to_number
#> 3     4  3 to_number
#> 4     1  5 to_number
#> 5     5  2 to_number
#> 6     1  6 to_number
#> 7     2  6 to_number
#> 8     3  6 to_number
#> 9     7  4 to_number
#> 10    7  5 to_number
#> 11    7  6 to_number

# Now view the final product:

render_graph(graph, output = "visNetwork")

# It should be noted that there are also analogous
# `set_node_attr()` and `get_node_attr()` functions
# that allow for setting and getting attributes for
# nodes in a graph (or, node data frame).

#
# Part 2. Removing Nodes and Edges
#

# Just as you can produce nodes and edges, they can
# be easily taken away. The key functions here are
# `delete_node()` and `delete_edge()`. Removing a node
# also removes all edges to and from that node. For
# sake of example, let's remove node "f" which is one
# of the more highly connected nodes in the graph.

# The number of edges before node removal:

edge_count(graph)
#> [1] 11

# The node removal:

graph <- delete_node(graph, node = 6)

# The number of edges after node removal:

edge_count(graph)
#> [1] 7

# A view the revised graph:

render_graph(graph, output = "visNetwork")

# Now to remove an edge. By removing "5" -> "2" we are
# left with a circular graph. Here is the statement:

graph <- delete_edge(graph, from = 5, to = 2)

edge_count(graph)
#> [1] 6

# View the graph again and note that no nodes were
# removed. The `delete_edge()` function never removes
# nodes.

render_graph(graph, output = "visNetwork")
