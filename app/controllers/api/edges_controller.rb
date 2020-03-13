# frozen_string_literal: true

class Api::EdgesController < Api::BaseController
  def index
    render json: graph.edges.distinct.all
  end

  def show
    render json: graph.edges.find(params[:id])
  end

  def create
    atom(graph, edge_params: edge_params)
  end

  def update
    atom(graph, edge_id: params[:id], edge_params: edge_params)
  end

  def destroy
    atom(graph, edge_id: params[:id])
  end

  private

  def edge_params
    params.require(:edge).permit(:text, :weight, :start_id, :finish_id)
  end
end
