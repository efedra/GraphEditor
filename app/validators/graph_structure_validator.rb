# frozen_string_literal: true

require 'rgl/adjacency'
require 'rgl/bidirectional'
require 'rgl/connected_components'
require 'rgl/traversal'

class GraphStructureValidator
  def initialize(graph)
    @graph = graph
  end

  def validate
    @directed_graph = RGL::DirectedAdjacencyGraph.new
    @directed_graph.add_vertices(*@graph.nodes.pluck(:id))
    # Right now there no support multigraph: cant add
    # two edges from n1 to n2 nodes.
    # Also there no bijective one-to-one mapping
    # from rgl.edge(pair source-target) to our Edge model.
    @directed_graph.add_edges(*@graph.edges.pluck(:start_id, :finish_id))

    @finishes = @graph.nodes.finish.pluck(:id)
    @start = @graph.nodes.start.first.id
    @bfs_tree = @directed_graph.bfs_search_tree_from(@start)
    all_nodes_reachable?
    terminal_non_finish?
    cycles?
  end

  private

  def all_nodes_reachable?
    nodes = @graph.nodes.pluck(:id)
    not_reachable_nodes = nodes - @bfs_tree.vertices
    return if not_reachable_nodes.blank?
    @graph.api_error(:not_reachable_nodes,
      not_reachable_nodes: not_reachable_nodes)
  end

  def terminal_non_finish?
    terminals = @bfs_tree.vertices - @directed_graph.edges.map(&:source).uniq
    terminal_non_finish_nodes = terminals - @finishes
    return if terminal_non_finish_nodes.blank?
    @graph.api_error(:terminal_non_finish_nodes,
      terminal_non_finish_nodes: terminal_non_finish_nodes)
  end

  def cycles?
    cycles = @directed_graph.cycles
    return if cycles.blank?
    @graph.api_error(:cycles, cycle_nodes: cycles)
  end
end
