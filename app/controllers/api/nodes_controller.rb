# frozen_string_literal: true

class Api::NodesController < Api::BaseController
  def index
    render json: graph.nodes.all
  end

  def show
    render json: graph.nodes.find(params[:id])
  end

  def create
    atom(graph, node_params: node_params)
  end

  def update
    atom(graph, node_id: params[:id], node_params: node_params)
  end

  def destroy
    atom(graph, node_id: params[:id])
  end

  private

  def graph
    Graph.find(params[:graph_id])
  end

  def node_params
    params.require(:node).permit(:name, text: nil)
  end
end
