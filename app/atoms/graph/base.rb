# frozen_string_literal: true

class Graph::Base < AtomBase
  private

  def graphs
    Graph
  end

  def graph
    graphs.find(params[:graph_id])
  end

  def graph_params
    params[:graph_params]
  end
end
