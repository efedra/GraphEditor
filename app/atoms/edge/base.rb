# frozen_string_literal: true

class Edge::Base < AtomBase
  attr_reader :graph

  def initialize(graph, **params)
    super(params)
    @graph = graph
  end

  private

  def edges
    graph.edges
  end

  def edge
    edges.find(params[:edge_id])
  end

  def edge_params
    params[:edge_params]
  end
end
