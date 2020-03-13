# frozen_string_literal: true

class Api::GraphsController < Api::BaseController
  def index
    render json: Graph.all
  end

  def show
    render json: Graph.find(params[:id])
  end

  def create
    render json: Graph.create(graph_params)
  end

  def update
    render json: graph.update(graph_params)
  end

  def destroy
    graph.destroy
    render json: {}
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def graph_params
    params.require(:graph).permit(:name, :state)
  end

  def graph
    Graph.find(params[:id])
  end
end
