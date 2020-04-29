# frozen_string_literal: true

class Api::NodesController < Api::BaseController
  def index
    authorize graph, policy_class: NodePolicy
    render json: graph.nodes.all
  end

  def show
    authorize node
    render json: node
  end

  def create
    @node = authorize graph.nodes.new(node_params)
    node.save!
    render json: node, status: :created
  end

  def update
    authorize node
    node.update!(node_params)
    render json: node
  end

  def destroy
    authorize node
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
    params.require(:node).permit(:name, :html_x, :html_y, :kind, text: nil, html_color: nil)
  end
end
