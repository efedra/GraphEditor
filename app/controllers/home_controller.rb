# frozen_string_literal: true

class HomeController < ApplicationController
  layout false
  def index; end

  # here some things are a lot different in master...

  def test_graph
    nodes = [1, 2, 3, 4, 5]
    edges = [[1, 2], [1, 3], [2, 3], [4, 5]]

    gm = GraphManager.new
    n, e, c = gm.count_components(nodes, edges)
    render json: {components: c, node_count: n, edge_count: e}
  end
end

