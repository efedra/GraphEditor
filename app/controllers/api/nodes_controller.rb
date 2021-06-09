# frozen_string_literal: true

class Api::NodesController < Api::BaseController
  def index
    #fixme never used
    authorize graph, policy_class: NodePolicy
    render json: graph.nodes.all
  end

  def show
    authorize node
    render json: node
  end

  def create
    graph = NeoGraph.find_by(uuid: params[:graph_id])
    node = NeoNode.create(title: 'New Node', kind: :inbetween, x: 10, y: 10, graph_id: graph.id)
    graph.update(clock: graph.clock + 1)
    GraphsChannel.broadcast_to graph, type: 'node_created', data:
      {node: node.view_model,
       clock: graph.clock}
    head :created
  end

  def update
    #authorize node
    #node.update!(node_params)
    #render json: node
    #n = NeoNode.find_by( id: node_params[id] )
    # <IMPORTANT!> command line doesnt see <id> only <uuid>, even thou jsons have both. so here uuid is used.
    NeoNode.where(uuid: params[:id]).each{ |x| x.update(node_params) }

  end

  def destroy
    #authorize node
    #node.destroy!
    #head :no_content
    #
    NeoNode.where(uuid: params[:id]).each{ |x| x.destroy }
    graph = NeoGraph.find_by(uuid: params[:graph_id])
    graph.update(clock: graph.clock + 1)
    render json: {clock: graph.clock}
  end

  private


  def node
    @node ||= graph.nodes.find(params[:id])
  end

  def node_params
    params.require(:node).permit(:name, :x, :y, :kind, :text, :title, :fill, :strokeWidth, :stroke )
  end
end
