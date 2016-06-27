# 006 # Graph Traversals

devtools::install_github("rich-iannone/DiagrammeR")
library(DiagrammeR)
library(magrittr)

# Graph traversals can be performed and they're useful
# for getting the particular data you need from a
# property graph (a graph with labeled nodes and
# edges using the `type` and `rel` attributes,
# respectively).

#
# Part 1. Loading in the Example Graph
#

# The example graph to be used is a fake dataset with
# contributors to software projects on a platform not
# unlike GitHub. First, get paths to the CSV files
# available in the package

# This is a CSV file containing contributors to
# software projects:

contributors_csv <-
  system.file("examples/contributors.csv",
              package = "DiagrammeR")

colnames(read.csv(contributors_csv,
                  stringsAsFactors = FALSE))
#> [1] "name"  "age"  "join_date"  "email"  "follower_count"
#> [6] "following_count"  "starred_count"

# This is a CSV file containing information about
# the software projects:

projects_csv <-
  system.file("examples/projects.csv",
              package = "DiagrammeR")

colnames(read.csv(projects_csv,
                  stringsAsFactors = FALSE))
#> [1] "project"  "start_date"  "stars"  "language"

# This is a CSV file with information about the
# relationships between the projects and their
# contributors:

projects_and_contributors_csv <-
  system.file("examples/projects_and_contributors.csv",
              package = "DiagrammeR")

colnames(read.csv(projects_and_contributors_csv,
                  stringsAsFactors = FALSE))
#> [1] "project_name"  "contributor_name"  "contributor_role"
#> [4] "commits"

# Create the property graph by adding the CSV data to a
# new graph; the `add_nodes_from_csv()` and
# `add_edges_from_csv()` functions are used to create
# nodes and edges in the graph.

graph <-
  create_graph() %>%
  set_graph_name("software_projects") %>%
  set_global_graph_attr(
    "graph", "output", "visNetwork") %>%
  add_nodes_from_table(
    contributors_csv,
    set_type = "person",
    label_col = "name") %>%
  add_nodes_from_table(
    projects_csv,
    set_type = "project",
    label_col = "project") %>%
  add_edges_from_table(
    projects_and_contributors_csv,
    from_col = "contributor_name",
    from_mapping = "name",
    to_col = "project_name",
    to_mapping = "project",
    rel_col = "contributor_role")

# Render the graph in the RStudio Viewer:

render_graph(graph)

#
# Part 2. Using Traversals to Get Answers
#

# Now that there is a property graph, we can find out
# bits of information without directly inspecting
# such information. This will be important when a
# property graph becomes quite large since manually
# inspecting the data gets difficult and impractical.

# Get the average age of all the contributors:

graph %>% 
  select_nodes("type", "person") %>%
  cache_node_attr_ws("age", "numeric") %>%
  get_cache %>% mean
#> [1] 33.6

# Get the total number of commits to all software
# projects:

graph %>% 
  select_edges %>%
  cache_edge_attr_ws("commits", "numeric") %>%
  get_cache %>% 
  sum
#> [1] 5182

# Get total number of commits from Josh as a maintainer
# and a contributor:

graph %>% 
  select_nodes("name", "Josh") %>%
  trav_out_edge(c("maintainer", "contributer")) %>%
  cache_edge_attr_ws("commits", "numeric") %>%
  get_cache %>% 
  sum
#> [1] 227

# Get total number of commits from Louisa:

graph %>% 
  select_nodes("name", "Louisa") %>%
  trav_out_edge %>%
  cache_edge_attr_ws("commits", "numeric") %>%
  get_cache %>% 
  sum
#> [1] 615

# As a bit of an aside, we can use selections and
# rescale values to a styling attribute such as
# edge width, node size, or color.

# Select all edges and apply an edge `width` attribute
# scaled by the edge attribute `commits` to a range
# of 0.5 to 3.0:

graph_scale_width_edges <-
  graph %>% 
  select_edges %>%
  rescale_edge_attr_ws(
    "commits", "width", 0.5, 3.0)

# Get the edge data frame to inspect:

get_edge_df(graph_scale_width_edges)
#>   from to         rel commits width
#> 1    2 11  maintainer     236  0.75
#> 2    1 11 contributor     121 0.627
#> 3    3 11 contributor      32 0.532
#> 4    2 12 contributor      92 0.596
#> 5    4 12 contributor     124  0.63
#> 6    5 12  maintainer    1460 2.059
#> 7    4 13  maintainer     103 0.608
#> 8    6 13 contributor     236  0.75
#> 9    7 13 contributor     126 0.633
#> 10   8 13 contributor    2340     3
#> 11   9 13 contributor       2   0.5
#> 12  10 13 contributor      23 0.522
#> 13   2 13 contributor     287 0.805

# Render the graph, larger edges and arrows indicate
# higher numbers of `commits`:

render_graph(graph_scale_width_edges)

# Select all edges and apply a color attribute based
# on another edge attribute:

graph_scale_color_edges <-
  graph %>% 
  select_edges %>%
  rescale_edge_attr_ws(
    "commits", "color", "gray95", "gray5")

# Render the graph, darker edges represent higher
# commits:

render_graph(graph_scale_color_edges)

# Get the names of people in graph above age 32:

graph %>% 
  select_nodes("type", "person") %>%
  select_nodes("age", ">32", "intersect") %>%
  cache_node_attr_ws("name") %>%
  get_cache
#> [1] "Jack"   "Sheryl" "Roger"  "Kim"    "Jon"

# Get the total number of commits from all people to
# the `supercalc` project:

graph %>% 
  select_nodes("project", "supercalc") %>%
  trav_in_edge %>%
  cache_edge_attr_ws("commits", "numeric") %>%
  get_cache %>% 
  sum
#> [1] 1676

# Who committed the most to the `supercalc` project?

graph %>% 
  select_nodes("project", "supercalc") %>%
  trav_in_edge %>%
  cache_edge_attr_ws("commits", "numeric") %>%
  trav_in_node %>%
  trav_in_edge("commits", max(get_cache(.))) %>%
  trav_out_node %>%
  cache_node_attr_ws("name") %>%
  get_cache
#> [1] "Sheryl"

# What is the email address of the individual that
# contributed the least to the `randomizer` project?

graph %>% 
  select_nodes("project", "randomizer") %>%
  trav_in_edge %>%
  cache_edge_attr_ws("commits", "numeric") %>%
  trav_in_node %>%
  trav_in_edge("commits", min(get_cache(.))) %>%
  trav_out_node %>%
  cache_node_attr_ws("email") %>%
  get_cache
#> [1] "the_will@graphymail.com"

# Update the graph, because, it has come to our attention
# that Kim is now a contributor to `stringbuildeR` and
# has made 15 new commits to that project:

graph %<>% 
  add_edge(
    get_nodes(.,
              "name", "Kim"),
    get_nodes(.,
              "project", "stringbuildeR"),
    "contributor") %>%
  select_last_edge %>%
  set_edge_attr_ws("commits", 15) %>%
  clear_selection

# View the graph's edf, the newest edge is at the
# bottom:

get_edge_df(graph)
#>    from to         rel commits
#> 1     2 11  maintainer     236
#> 2     1 11 contributor     121
#> 3     3 11 contributor      32
#> 4     2 12 contributor      92
#> 5     4 12 contributor     124
#> 6     5 12  maintainer    1460
#> 7     4 13  maintainer     103
#> 8     6 13 contributor     236
#> 9     7 13 contributor     126
#> 10    8 13 contributor    2340
#> 11    9 13 contributor       2
#> 12   10 13 contributor      23
#> 13    2 13 contributor     287
#> 14    8 11 contributor      15

# Render the graph to see the new edge:

render_graph(graph)

# Get all email addresses to contributors (but not
# maintainers) of the `randomizer` and `supercalc`
# projects:

graph %>% 
  select_nodes("project", "randomizer") %>%
  select_nodes("project", "supercalc") %>%
  trav_in_edge("rel", "contributor") %>%
  trav_out_node %>%
  cache_node_attr_ws("email", "character") %>%
  get_cache
#> [1] "lhe99@mailing-fun.com"  "josh_ch@megamail.kn"
#> [3] "roger_that@whalemail.net"  "the_simone@a-q-w-o.net"
#> [5] "kim_3251323@ohhh.ai"  "the_will@graphymail.com"
#> [7] "j_2000@ultramail.io"

# Which committer to the `randomizer` project has the
# highest number of followers?

graph %>% 
  select_nodes("project", "randomizer") %>%
  trav_in %>%
  cache_node_attr_ws(
    "follower_count", "numeric") %>%
  select_nodes("project", "randomizer") %>%
  trav_in("follower_count", max(get_cache(.))) %>%
  cache_node_attr_ws("name") %>%
  get_cache
#> [1] "Kim"

# Which people have committed to more than one
# project?

graph %>%
  select_nodes_by_degree("out", ">1") %>%
  cache_node_attr_ws("name") %>%
  get_cache
#> [1] "Louisa"  "Josh"  "Kim"
