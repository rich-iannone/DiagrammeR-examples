# 003 # Node Type and Edge Rel

library(DiagrammeR)

#
# Part 1. The Node Type
#

# Sometimes, you want some collection of nodes in your
# graph to be part of a group. In such a case,specify
# a node `type`. This is easily done when creating a
# node data frame (ndf) by using the `type` argument. 

# Create a node data frame

nodes_with_types <- 
  create_nodes(nodes = c("a", "b", "c", "d",
                         "e", "f", "g", "h"),
               type = c("X", "X", "X", "X",
                        "Y", "Y", "Z", "Z"),
               label = TRUE)

# Create a graph with just the nodes (no edges)

graph_nodes <-
  create_graph(nodes_df = nodes_with_types)

# View the graph in the Viewer

render_graph(graph = graph_nodes,
             output = "visNetwork")

# By including type values for each of the nodes, they
# are colored when rendered by `visNetwork` (in this
# case blue, yellow, and red for types 'X', 'Y', and
# 'Z') -- this is pretty convenient.

# There is a function that allows you to get a count
# of all nodes or counts of certain types. It's the
# `node_count()` function. To get a count of all
# nodes:

node_count(graph_nodes)
#> [1] 8

# To get a count of nodes, grouped by type in a named
# vector, use `type = TRUE`:

node_count(graph_nodes, type = TRUE)
#> X Y Z 
#> 4 2 2 

# To get a count of nodes of a specific type:

node_count(graph_nodes, type = "X")
#> [1] 4

# Or a combined count of several types:

node_count(graph_nodes, type = c("X", "Y"))
#> [1] 6

# To identify which nodes are of a specific type, use
# the `get_nodes()` function with the `type` supplied:

get_nodes(graph_nodes, type = "X")
#> [1] "a" "b" "c" "d"

# As before, you can also return the node IDs for nodes
# of several `types`:

get_nodes(graph_nodes, type = c("X", "Y"))
#> [1] "a" "b" "c" "d" "e" "f"

#
# Part 2. The Edge Relationship
#

# Edges can be provided with a grouping name as well.
# This is the `rel` value (which short for
# 'relationship'). Here is an example of an edf where
# relationship values are provided for all edges.

# Create an edge data frame

edges_with_rels <- 
  create_edges(from = c("a", "b", "e", "g", "f",
                        "h", "d", "d"),
               to =   c("b", "e", "h", "h", "h",
                        "c", "c", "a"),
               rel = c("rel_a", "rel_a", "rel_b",
                       "rel_c", "rel_b", "rel_a",
                       "rel_b", "rel_c"))

# Create a graph with both nodes (with types) and
# edges (with rels)

graph_nodes_edges <-
  create_graph(nodes_df = nodes_with_types,
               edges_df = edges_with_rels)

# View the graph in the Viewer

render_graph(graph = graph_nodes_edges,
             output = "visNetwork")

# All the edges have relationships as labels!

# The edge analogue to `node_count()` is `edge_count()`
# and it allows you to get counts of all edges or those
# edges by relationship. To get a count of all edges:

edge_count(graph_nodes_edges)
#> [1] 8

# By default, the `rel` argument is set to `FALSE` (and
# that provides a total count) but setting it to `TRUE`
# yields a named vector of edge counts by relationship:

edge_count(graph_nodes_edges, rel = TRUE)
#> rel_a rel_b rel_c 
#>     3     3     2

# Again, as with `node_count()`, one or more specified
# `rel` values can be used to determine the number
# of matching edges:

edge_count(graph_nodes_edges, rel = c("rel_a"))
#> [1] 3 

edge_count(graph_nodes_edges,
           rel = c("rel_a", "rel_b"))
#> [1] 6

# To identify which edges are of a particular rel, use
# the `get_edges()` function with the `rel` supplied.
# This function allows you have the edges returned in
# multiple ways by use of the `return_type` argument.
# Output can either be as a `list` (the default), as a
# data frame (`df`), or as a `vector`.

get_edges(graph_nodes_edges, rel = "rel_a",
          return_type = "list")
#> [[1]]
#> [1] "a" "b" "h"
#> 
#> [[2]]
#> [1] "b" "e" "c"

get_edges(graph_nodes_edges, rel = "rel_a",
          return_type = "df")
#>   from to
#> 1    a  b
#> 2    b  e
#> 3    h  c

get_edges(graph_nodes_edges, rel = "rel_a",
          return_type = "vector")
#> [1] "a -> b" "b -> e" "h -> c"

# Either way, you can indeed isolate those edges that
# have certain `rel` values attached.
