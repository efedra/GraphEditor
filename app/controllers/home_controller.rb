# frozen_string_literal: true

class HomeController < ApplicationController
  layout false
  def index; end


  # here some things are a lot different in master...

  def test_graph
    nodes = [1, 2, 3, 4, 5]
    edges = [[1, 2], [1, 3], [2, 3], [3, 4], [4, 5]]

    gm = GraphManager.new
    n, e, c = gm.count_components(nodes, edges)
    #render json: { components: c, node_count: n, edge_count: e }

    nodes1 = [1, 2, 3, 4, 5, 6, 7]
    edges1 = [[1, 2], [1, 4], [2, 3], [3, 4],[ 4, 5],  [5, 6], [5, 7]]

       n1, e1, p = gm.find_path(nodes1, edges1, 1, 7)
      # render json: { path: p, node_count: n1, edge_count: e1 }
  end

  def editor; end
  def player; end

  def new_graph
    render json: Graph.random_graph
  end

end

