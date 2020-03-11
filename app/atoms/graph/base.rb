# frozen_string_literal: true

class Graph::Base < BaseService
  attr_reader :params

  def initialize(**params)
    @params = params
  end

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
