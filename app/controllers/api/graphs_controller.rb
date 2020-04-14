# frozen_string_literal: true

class Api::GraphsController < Api::BaseController
  def index
    render json: current_user.graphs.all
  end

  def show
    graph = current_user.graphs.find(params[:id])
    nodes = graph.nodes
    edges = graph.edges
    render json: { graph: graph, nodes: nodes, edges: edges }
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

  def validate
    return head :no_content if graph.valid?(:graph_structure)
    render json: { errors: graph.errors }
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
