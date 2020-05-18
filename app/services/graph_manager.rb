require 'rgl/adjacency'
require 'rgl/connected_components'
require 'rgl/traversal'


class GraphManager

  def count_components(nodes, edges)
    dg = RGL::DirectedAdjacencyGraph.new()
    nodes.each { |n| dg.add_vertex n }
    edges.each { |e| dg.add_edge e[0], e[1] }
    # to_do the thing
    dg1 = dg.to_undirected

    components = []

    dg1.each_connected_component { |c| components <<  c }

    a = components.size

    return dg.vertices.count, dg.edges.count, a

  end

  # no weights, not shortest by weight, just path from a to b
  def find_path (nodes, edges, node1, node2)
    dg = RGL::DirectedAdjacencyGraph.new()
    nodes.each { |n| dg.add_vertex n }
    edges.each { |e| dg.add_edge e[0], e[1] }

    path = []

    if node1 == node2
      path << node1
    else # different nodes
      tree = dg.bfs_search_tree_from(node1)

      tree = tree.reverse

      tmpv = node2

      # if there is no path node2 will not be present in the tree
      # if no path return nil
      if tree.has_vertex?(node2) == false
        path = nil
        return dg.vertices.count, dg.edges.count, path

      end

      until tmpv == node1 do
        path << tmpv
        tmpv = tree.adjacent_vertices(tmpv)[0]

      end

      path << tmpv

    end

    # reverse path?

    return dg.vertices.count, dg.edges.count, path
  end

end