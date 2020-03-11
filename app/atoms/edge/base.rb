# frozen_string_literal: true

class Edge::Base < BaseService
  attr_reader :params, :graph

  def initialize(graph, **params)
    @graph = graph
    @params = params
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
