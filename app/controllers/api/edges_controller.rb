# frozen_string_literal: true

class Api::EdgesController < ApplicationController
  def index
    render json: graph.edges.distinct.all
  end

  def show
    render json: graph.edges.find(params[:id])
  end

  def create
    service = atom(graph, edge_params: edge_params)

    if service.success?
      render json: service.result, status: :created
    else
      render json: service.error, status: :unprocessable_entity
    end
  end

  def update
    service = atom(graph, edge_id: params[:id], edge_params: edge_params)

    if service.success?
      render json: service.result, status: :ok
    else
      render json: service.error, status: :unprocessable_entity
    end
  end

  def destroy
    atom(graph, edge_id: params[:id])
    head :no_content
  end

  private

  def graph
    Graph.find(params[:graph_id])
  end

  def edge_params
    params.require(:edge).permit(:text, :weight, :start_id, :finish_id)
  end
end
