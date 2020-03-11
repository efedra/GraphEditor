# frozen_string_literal: true

class Api::NodesController < ApplicationController
  def index
    render json: graph.nodes.all
  end

  def show
    render json: graph.nodes.find(params[:id])
  end

  def create
    service = atom(graph, node_params: node_params)

    if service.success?
      render json: service.result, status: :created
    else
      render json: service.error, status: :unprocessable_entity
    end
  end

  def update
    service = atom(graph, node_id: params[:id], node_params: node_params)

    if service.success?
      render json: service.result, status: :ok
    else
      render json: service.error, status: :unprocessable_entity
    end
  end

  def destroy
    atom(graph, node_id: params[:id])
    head :no_content
  end

  private

  def graph
    Graph.find(params[:graph_id])
  end

  def node_params
    params.require(:node).permit(:name, text: nil)
  end
end
