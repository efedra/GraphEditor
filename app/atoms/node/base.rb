# frozen_string_literal: true

class Node::Base < AtomBase
  attr_reader :graph

  def initialize(graph, **params)
    super(params)
    @graph = graph
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
