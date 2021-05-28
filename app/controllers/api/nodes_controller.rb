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
    node = NeoNode.create(title: 'New Node', kind: :inbetween, x: 10, y: 10, graph_id: graph.id)

    render json: {node: node.view_model}, status: :created
  end

  def update
    #authorize node
    #node.update!(node_params)
    #render json: node
    #n = NeoNode.find_by( id: node_params[id] )
    # <IMPORTANT!> command line doesnt see <id> only <uuid>, even thou jsons have both. so here uuid is used.
    NeoNode.where(uuid: node_params[uuid]).each{ |x| x.update(fill: node_params[fill], kind: node_params[kind], stroke: node_params[stroke], strokeWidth: node_params[strokeWidth], text: node_params[text], title: node_params[title], x: node_params[x], y: node_params[y]) }

  end

  def destroy
    #authorize node
    #node.destroy!
    #head :no_content
    #
    NeoNode.where(uuid: node_params[uuid]).each{ |x| x.destroy }
  end

  private

  def graph
    #todo Fix graph<->user connection
    @graph ||= NeoGraph.find_by(uuid: params[:graph_id])
  end

  def node
    @node ||= graph.nodes.find(params[:id])
  end

  def node_params
    params.require(:node).permit(:name, :html_x, :html_y, :kind, text: nil, html_color: nil)
  end
end
