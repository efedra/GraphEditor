# frozen_string_literal: true

class Api::GraphsController < Api::BaseController
  def index
    render json: current_user.graphs.all
  end

  def show
    render json: current_user.graphs.find(params[:id])
  end

  def create
    @graph = current_user.graphs.create(graph_params)
    graph.save!
    render json: graph, status: :created
  end

  def update
    graph.update!(graph_params)
    render json: graph
  end

  def destroy
    graph.destroy!
    head :no_content
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def graph_params
    params.require(:graph).permit(:name, :state)
  end

  def graph
    @graph ||= current_user.graphs.find(params[:id])
  end
end
