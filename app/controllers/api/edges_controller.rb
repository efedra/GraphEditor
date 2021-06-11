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

    graph = NeoGraph.find_by(uuid: params[:graph_id])
    graph.update(clock: graph.clock + 1)

    GraphsChannel.broadcast_to graph, type: 'edge_created', data:
      {edge: edge.view_model,
       clock: graph.clock}
    head :created
  end

  def update
    graph = NeoGraph.find_by(uuid: params[:graph_id])
    NeoEdge.where(uuid: params[:id]).each{ |x| x.update(edge_params) }
    graph.update(clock: graph.clock + 1)
    GraphsChannel.broadcast_to graph, type: 'edge_updated', data:
      {node: edge.view_model,
       clock: graph.clock}

    head :ok

  end

  def destroy
    # authorize edge
    # edge.destroy!
    # head :no_content
    NeoEdge.find_by(uuid: params[:id]).destroy

    graph = NeoGraph.find_by(uuid: params[:graph_id])
    graph.update(clock: graph.clock + 1)

    GraphsChannel.broadcast_to graph, type: 'edge_created', data:
      {edge: edge.view_model,
       clock: graph.clock}
    head :ok

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
