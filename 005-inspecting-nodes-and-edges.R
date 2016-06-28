# 005 # Inspecting Nodes and Edges

devtools::install_github("rich-iannone/DiagrammeR")
library(DiagrammeR)

#
# Part 1. Information on All Nodes and Edges
#

# When you have a graph object, sometimes you'll want
# to poke around and inspect some of the nodes, and
# some of the edges. There are very good reasons for
# doing so. There can be valuable information within
# the nodes and edges. Further graph construction may
# hinge on what's extant in the graph. Also, inspection
# is a good way to verify that a graph modification has
# indeed taken place in the correct manner.

# First, let's build a graph to use for examples:

nodes <-
  create_nodes(
    nodes = 1:4,
    type = "number",
    label = TRUE,
    data = c(3.5, 2.6, 9.4, 2.7))

edges <-
  create_edges(
    from = c(1, 2, 3, 4),
    to = c(4, 3, 1, 1),
    rel = c("P", "B", "L", "L"),
    color = c("pink", "blue", "red", "red"),
    weight = c(2.1, 5.7, 10.1, 3.9))

graph <-
  create_graph(
    nodes_df = nodes,
    edges_df = edges)

# Render the graph to see it in the RStudio Viewer

render_graph(graph, output = "visNetwork")

# The `get_nodes()` function simply returns a vector
# of node ID values. This is useful in many cases and
# is great when used as a sanity check.

get_nodes(graph)
#> [1] "1" "2" "3" "4"

# Using the `node_info()` function provides a data
# frame with detailed information on nodes and their
# interrelationships within a graph. It always returns
# the same columns, in the same order. It's useful
# when desiring a quick summary of the node ID values,
# their labels and `type` values, and their degrees
# of connectness with other nodes.

node_info(graph)
#>   node label   type deg indeg outdeg loops
#> 1    1     1 number   3     2      1     0
#> 2    2     2 number   1     0      1     0
#> 3    3     3 number   2     1      1     0
#> 4    4     4 number   2     1      1     0

# The `get_edges()` function returns all of the node ID
# values related to each edge in the graph:

get_edges(graph)
#> [1] "1 -> 4" "2 -> 3" "3 -> 1" "4 -> 1"

# The `edge_info()`, like the `node_info()` function,
# always returns a data frame with a set number of
# columns. In this case, it is the node ID values
# `from` and `to`, and, the relationship (`rel`) for
# the edges.

edge_info(graph)
#>   from to rel
#> 1    1  4   P
#> 2    2  3   B
#> 3    3  1   L
#> 4    4  1   L

#
# Part 2. Inspecting Nodes, Edges, and their Attributes
#

# A graph object's main components are its node data
# frame (ndf) and its edge data frame (edf). These can
# be viewed individually using the `get_node_df()` and
# `get_edge_df()` functions:

get_node_df(graph)
#>   nodes   type label data
#> 1     1 number     1  3.5
#> 2     2 number     2  2.6
#> 3     3 number     3  9.4
#> 4     4 number     4  2.7

get_edge_df(graph)
#>   from to rel color weight
#> 1    1  4   P  pink    2.1
#> 2    2  3   B  blue    5.7
#> 3    3  1   L   red   10.1
#> 4    4  1   L   red    3.9

# For the ndf, the `nodes`, `type`, and `label` columns
# are always present and they are always in that
# prescribed order. For the edf, it is the `from`,
# `to`, and `rel` columns that are always present. Any
# additional columns are either parameters recognized
# by the graph rendering engine (e.g., `color`,
# `fontname`, etc.) or are direct properties of the
# nodes or edges (e.g., a node data value or an edge
# weight).

#
# Part 3. Determining Existence of Nodes or Edges
#

# There may be cases where you need to verify that a
# certain node ID exists in the graph or that an 
# edge definition has been made. The `node_present()`
# and `edge_present()` will provide a TRUE or FALSE
# value.

# To demonstrate, get the node ID values present in
# the graph:

get_nodes(graph)
#> [1] "1" "2" "3" "4"

# Is node with ID `1` in the graph?

node_present(graph, 1)
#> TRUE

# Is node with ID `5` in the graph?

node_present(graph, 5)
#> FALSE

# To demonstrate, get the node ID values associated
# with the edges present in the graph:

get_edges(graph)
#> [1] "1 -> 4" "2 -> 3" "3 -> 1" "4 -> 1"

# Is the edge `1` -> `4` present?

edge_present(graph, 1, 4)
#> TRUE

# Is the edge `2` -> `4` present?

edge_present(graph, 2, 4)
#> FALSE
