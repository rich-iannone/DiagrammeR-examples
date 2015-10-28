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
# "a" and "b":

graph <- add_node(graph, node = "a", type = "letter")
graph <- add_node(graph, node = "b", type = "letter")

# To prove that the nodes are in the graph, we can use
# the `get_nodes()` function:

get_nodes(graph)
#> [1] "a" "b"

# Likewise, to prove that there are no edges in the
# graph, we can use the `get_edges()` function:

get_edges(graph)
#> [1] NA

# A graph can indeed have no edges but it's silly.
# Add a single edge with the `add_edges()` function:

graph <- add_edges(graph,
                   from = "a", to = "b",
                   rel = "to_letter")

# Now verify that the edge has been added by using
# `get_edges()` again:

get_edges(graph)
#> [[1]]
#> [1] "a"
#> 
#> [[2]]
#> [1] "b"

# The `get_edges()` function can output the pairs
# of nodes in edges either as a list (as above, it's
# the default), as a data frame, or as a vector. Here
# are examples of the latter two output types:

get_edges(graph, return_type = "df")
#>   from to
#> 1    a  b

get_edges(graph, return_type = "vector")
#> [1] "a -> b"

# Nodes can also be added while specifying edges. This
# is best shown through several examples:

graph <- add_node(graph, node = "c",
                  type = "letter",
                  from = "b")

get_edges(graph, return_type = "vector")
#> [1] "a -> b" "b -> c"

graph <- add_node(graph, node = "d",
                  type = "letter",
                  to = "c")

get_edges(graph, return_type = "vector")
#> [1] "a -> b" "b -> c" "d -> c"

graph <- add_node(graph, node = "e",
                  type = "letter",
                  from = "a", to = "b")

get_edges(graph, return_type = "vector")
#> [1] "a -> b" "b -> c" "d -> c" "a -> e" "e -> b"

# There may be even multiple edges set 'to' and/or
# 'from' the new node:

graph <- add_node(graph, node = "f",
                  type = "letter",
                  from = c("a", "b", "c"))

get_edges(graph, return_type = "vector")
#> [1] "a -> b" "b -> c" "d -> c" "a -> e" "e -> b"
#> [6] "a -> f" "b -> f" "c -> f"

graph <- add_node(graph, node = "g",
                  type = "letter",
                  to = c("d", "e", "f"))

get_edges(graph, return_type = "vector")
#> [1] "a -> b" "b -> c" "d -> c" "a -> e" "e -> b"
#> [6] "a -> f" "b -> f" "c -> f" "g -> d" "g -> e"
#> [11] "g -> f"

get_nodes(graph)
#> [1] "a" "b" "c" "d" "e" "f" "g"

# Have a look at the final graph in the RStudio Viewer
# by using the `render_graph()` function

render_graph(graph, output = "visNetwork")

# Notice that the edge relationship value has only been
# added to the "a" -> "b" edge as "to_letter". While
# using `add_node()` to specify nodes and edges is
# convenient, you cannot specify edge relationships as
# with `add_edges()`. However, you do want to specify
# all the rel values for all edges as "to_letter". This
# can be done with the `set_edge_attr()` function. To
# do this unconditionally to all edges in the graph:

graph <- set_edge_attr(graph,
                       attr = "rel",
                       value = "to_letter")

# How to check if applied? Use the `get_edge_attr()`
# function:

get_edge_attr(graph)
#>    from to       rel
#> 1     a  b to_letter
#> 2     b  c to_letter
#> 3     d  c to_letter
#> 4     a  e to_letter
#> 5     e  b to_letter
#> 6     a  f to_letter
#> 7     b  f to_letter
#> 8     c  f to_letter
#> 9     g  d to_letter
#> 10    g  e to_letter
#> 11    g  f to_letter

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

graph <- delete_node(graph, node = "f")

# The number of edges after node removal:

edge_count(graph)
#> [1] 7

# A view the revised graph:

render_graph(graph, output = "visNetwork")

# Now to remove an edge. By removing "e" -> "b" we are
# left with a circular graph. Here is the statement:

graph <- delete_edge(graph, from = "e", to = "b")

edge_count(graph)
#> [1] 6

# View the graph again and note that no nodes were
# removed. The `delete_edge()` function never removes
# nodes.

render_graph(graph, output = "visNetwork")

