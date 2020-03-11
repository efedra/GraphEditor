# frozen_string_literal: true

class Node::Base < BaseService
  attr_reader :params, :graph

  def initialize(graph, **params)
    @graph = graph
    @params = params
  end

  private

  def nodes
    graph.nodes
  end

  def node
    nodes.find(params[:node_id])
  end

  def node_params
    params[:node_params]
  end
end
