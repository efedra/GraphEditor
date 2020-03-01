# frozen_string_literal: true

class Api::GraphsController < ApplicationController
  before_action :set_graph, only: %i[show update destroy]

  def index
    @graphs = Node.all
    render json: @graphs
  end

  def show
    render json: @graph
  end

  def create
    @graph = Graph.new(graph_params)

    if @graph.save
      render json: @graph
    else
      render json: @graph.errors, status: :unprocessable_entity
    end
  end

  def update
    if @graph.update(node_params)
      render :show, status: :ok, location: @graph
    else
      render json: @graph.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @graph.destroy
    head :no_content
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_graph
    @graph = Graph.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def graph_params
    params.require(:graph).permit(:name, :state)
  end
end
