# frozen_string_literal: true

class Api::EdgesController < Api::BaseController
  def index
    render json: graph.edges.distinct.all
  end

  def show
    render json: graph.edges.find(params[:id])
  end

  def create
    @edge = graph.edges.create(edge_params)
    edge.save!
    render json: edge, status: :created
  end

  def update
    edge.update!(edge_params)
    render json: edge
  end

  def destroy
    edge.destroy!
    head :no_content
  end

  private

  def graph
    @graph ||= current_user.graphs.find(params[:graph_id])
  end

  def edge
    @edge ||= graph.edges.find(params[:id])
  end

  def edge_params
    params.require(:edge).permit(:text, :weight, :start_id, :finish_id)
  end
end
