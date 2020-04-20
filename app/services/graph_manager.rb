require 'rgl/adjacency'
require 'rgl/connected_components'


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

end