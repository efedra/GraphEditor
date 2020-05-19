# frozen_string_literal: true

class Graph::DynamicValidator
  def initialize(graph)
    @graph = graph
  end

  def validate
    @dynamic_graph = DynamicGraph.new
    @graph.nodes.pluck(:id).each { |n| @dynamic_graph.add_vertex(n) }
    @graph.edges.select(:id, :start_id, :finish_id, :action, :condition).each do |e|
      @dynamic_graph.add_edge(e.start_id, e.finish_id, e.id,
        condition: e.condition,
        action: e.action)
    end

    @finishes = @graph.nodes.finish.pluck(:id)
    @start = @graph.nodes.start.first.id
    @dynamic_graph.bfs_search_tree_from(@start, @graph.state.deep_symbolize_keys)
    all_nodes_reachable?
    all_edges_used?
    terminal_non_finish?
    cycles?
    search_timeout?
  end

  private

  def all_nodes_reachable?
    nodes = @graph.nodes.pluck(:id)
    not_reachable_nodes = nodes.to_set - @dynamic_graph.nodes
    return if not_reachable_nodes.blank?
    @graph.api_error(:not_reachable_nodes,
      column: :dynamic,
      not_reachable_nodes: not_reachable_nodes)
  end

  def all_edges_used?
    not_used_edges = @graph.edges.where.not(id: @dynamic_graph.edges.to_a).pluck(:id)
    return if not_used_edges.blank?
    @graph.api_error(:not_used_edges,
      column: :dynamic,
      not_used_edges: not_used_edges)
  end

  def terminal_non_finish?
    edges = @graph.edges.where(id: @dynamic_graph.edges.to_a)
    terminals = @dynamic_graph.nodes - edges.map(&:start_id).uniq
    terminal_non_finish_nodes = terminals - @finishes
    return if terminal_non_finish_nodes.blank?
    @graph.api_error(:terminal_non_finish_nodes,
      column: :dynamic,
      terminal_non_finish_nodes: terminal_non_finish_nodes)
  end

  def cycles?
    cycles = @dynamic_graph.cycles
    return if cycles.blank?
    @graph.api_error(:cycles, column: :dynamic, cycles: cycles)
  end

  def search_timeout?
    return unless @dynamic_graph.status == :timeout
    @graph.api_error(:search_timeout, search_timeout: @dynamic_graph.config[:search_timeout])
  end
end
