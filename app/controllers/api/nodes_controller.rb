# frozen_string_literal: true

class Api::NodesController < Api::BaseController
  def index
    render json: graph.nodes.all
  end

  def show
    render json: graph.nodes.find(params[:id])
  end

  def create
    new_node = graph.nodes.create(node_params)
    new_node.save!
    render json: new_node, status: :created
  end

  def update
    node.update!(node_params)
    render json: node
  end

  def destroy
    node.destroy!
    head :no_content
  end

  private

  def graph
    @graph ||= current_user.graphs.find(params[:graph_id])
  end

  def node
    @node ||= graph.nodes.find(params[:id])
  end

  def node_params
    params.require(:node).permit(:name, :html_x, :html_y, text: nil, html_color: nil)
  end
end
