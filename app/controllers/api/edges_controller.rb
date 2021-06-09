# frozen_string_literal: true

class Api::EdgesController < Api::BaseController
  def index
    authorize graph, policy_class: EdgePolicy
    render json: graph.edges.distinct.all
  end

  def show
    authorize edge
    render json: edge
  end

  def create
    #@edge = authorize graph.edges.new(edge_params)
    #edge.save!
    #render json: edge, status: :created
    #
    NeoEdge.create(title: "", text: "", you_need: "", you_get: "", from_node: edge_params[from_node], to_node: edge_params[to_node] )
    # How do I parse id, is that a string or tuple, or what?
    # And additional params are strange
  end

  def update


  end

  def destroy
    # authorize edge
    # edge.destroy!
    # head :no_content
    NeoEdge.find_by(uuid: params[:id]).destroy
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
    params.require(:edge).permit(:text, :weight, :start_id, :finish_id, :action, :condition)
  end
end
