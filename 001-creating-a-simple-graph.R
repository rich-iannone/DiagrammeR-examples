# 001 # Creating a simple graph

library(DiagrammeR)

#
# Part 1. The Simplest of Simple Graphs
#

# For graph diagrams you need nodes and edges.
# Let's specify a collection of nodes and contain them
# in a data frame (a node data frame -- ndf):

the_nodes <- create_nodes(nodes = 1:3,
                          label = TRUE)

# The `nodes` argument is required here and it must
# contain a vector of node IDs, all distinct. The use
# of `label = TRUE` allows for copying of the node IDs
# as the node label. You can also specify of vector
# of text labels (you can use all manner of characters),
# but ensure that these vectors are the same length.

# Now, the edges, those connections between the nodes.
# The edge connections are also collected in a data
# frame (this time, an edge data frame -- edf)

the_edges <- create_edges(from = c(1, 1),
                          to   = c(2, 3))

# The `from` and `to` arguments specify which nodes the
# the edge is outgoing and incoming, respectively. Here,
# the edges are: "1" -> "2" and "1" -> "3". For directed
# graphs, the order is essential.

# We've got nodes, we've got edges... let's have a look
# at the objects, just so we know what we're dealing
# with.

the_nodes
#>   nodes type label
#> 1     1          1
#> 2     2          2
#> 3     3          3

the_edges
#>   from to rel
#> 1    1  2
#> 2    1  3

# If you have an ndf and an edf, you can combine those
# into a graph object

the_graph <- create_graph(nodes_df = the_nodes,
                          edges_df = the_edges)

# That graph object is then this (important parts are
# labeled):

the_graph
#> $nodes_df  #<-- the ndf
#>   nodes type label
#> 1     1          1
#> 2     2          2
#> 3     3          3
#> 
#> $edges_df  #<-- the edf
#>   from to rel
#> 1    1  2
#> 2    1  3
#> 
#> $graph_attrs  #<-- graph attributes (for entire graph)
#> NULL
#> 
#> $node_attrs   #<-- node attributes (styling for nodes)
#> NULL
#> 
#> $edge_attrs   #<-- edge attributes (styling for edges)
#> NULL
#> 
#> $directed     #<-- whether the graph is a directed graph
#> [1] TRUE           (this is an option; default is TRUE)
#> 
#> $dot_code     #<-- Graphviz DOT code for quick rendering
#> [1] " "digraph {\n\n  '1' [label = '1'] \n  '2'
#> [label = '2'] \n '3' [label = '3'] \n  '1'->'2' \n
#> '1'->'3' \n}"
#> 
#> attr(,"class")
#> [1] "dgr_graph" #<- This is a `dgr_graph` object

# Having a graph object is a great first step and you
# can do a lot with them (inspect, modify, join with
# other graph objects, etc.).

# Whenever you'd like to view the graph, use the
# `render_graph()` function. There are three renderers
# for graphs:

# (1) Graphviz

render_graph(graph = the_graph, output = "graph")

# (2) vivagraph

render_graph(graph = the_graph, output = "vivagraph")

# (3) visNetwork

render_graph(graph = the_graph, output = "visNetwork")

#
# Part 2. A Shortcut to the Same Graph
#

# You don't really need to have a node data frame in
# conjunction with the edge data frame to make a graph
# object. Really you could have either. You can even
# have neither (that would be an empty graph, a void...
# a field of nothingness). Have a look:

render_graph(graph = create_graph(),
             output = "visNetwork")

# If you wanted to make the same graph as in Part I but
# with one less step, just create the edf then use
# `create_graph()`

the_edges <- create_edges(from = c(1, 1),
                          to   = c(2, 3))

the_graph <- create_graph(edges_df = the_edges)

# The graph will be the same

render_graph(graph = the_graph, output = "visNetwork")


#
# Part 3. Just Nodes, No Edges
#

# We can just display nodes without edges (anything's
# possible).

the_nodes <- create_nodes(nodes = 1:3,
                          label = c("A", "B", "C"))

the_graph <- create_graph(nodes_df = the_nodes)

render_graph(graph = the_graph, output = "visNetwork")

# Here is an example with 26 nodes, this time
# wrapping up `create_nodes()`, `create_graph()`, and
# `render_graph()` function calls into one big statement.

render_graph(
  create_graph(nodes_df =
                 create_nodes(nodes = 1:26,
                              label = LETTERS)),
  output = "visNetwork")

# Unicode characters can also be used as labels (or node
# ID values):

render_graph(
  create_graph(nodes_df =
                 create_nodes(nodes = 1:3,
                              label = c("α", "β", "γ"))),
  output = "visNetwork")
