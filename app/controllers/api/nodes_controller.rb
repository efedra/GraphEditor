# frozen_string_literal: true

class Api::NodesController < Api::BaseController
  def index
    render json: graph.nodes.all
  end

  def show
    render json: graph.nodes.find(params[:id])
  end

  def create
    node = graph.nodes.create(node_params)
    node.save!
    render json: node
  end

  def update
    node.update!(node_params)
    render json: node
  end

  def destroy
    node.destroy!
  end

  private

  def graph
    Graph.find(params[:graph_id])
  end

  def node
    graph.nodes.find(params[:id])
  end

  def node_params
    params.permit(:name, text: nil)
  end
end
