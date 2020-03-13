# frozen_string_literal: true

class Api::EdgesController < Api::BaseController
  def index
    render json: graph.edges.distinct.all
  end

  def show
    render json: graph.edges.find(params[:id])
  end

  def create
    new_edge = graph.edges.create(edge_params)
    new_edge.save!
    render json: new_edge
  end

  def update
    edge.update!(edge_params)
    render json: edge
  end

  def destroy
    edge.destroy!
  end

  private

  def graph
    Graph.find(params[:graph_id])
  end

  def edge
    graph.edges.find(params[:id])
  end

  def edge_params
    params.permit(:id, :text, :weight, :start_id, :finish_id)
  end
end
