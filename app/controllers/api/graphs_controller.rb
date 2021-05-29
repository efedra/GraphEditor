# frozen_string_literal: true

class Api::GraphsController < Api::BaseController
  def index
    #authorize Graph
    graphs = NeoGraph.where(user_id: current_user.id).map do |g|
      {name: g.title,
       id: g.uuid
      }
    end
    render json: {graphs: graphs, userId: current_user.id}
  end

  def show
    #authorize graph
    #render_graph

    graph = NeoGraph.find_by(uuid: params[:id])
    #to graph model
    #   |
    #  \/
    result = ActiveGraph::Base.query("MATCH (n)-[r*]->(d) WHERE n.uuid = '#{params[:id]}' RETURN r, d")
    nodes = []

    edges = []
    while result.has_next?
      item = result.next
      d = item[:d]
      nodes << d if d.labels.include? :NeoNode
      # state = item if item.labels.include? :NeoState
      # WARNING: Orc technologies.
      # extensively commented so  it makes at least some sense
      next if d.labels.include? :NeoState

      r = item[:r]
      r.each do |it|
        if it.type == :NEO_EDGE
          final0 = it
          edges << final0
        end
      end

      #       /\
      #       |
      #EDGES  |
      #
    end


    render json: {nodes: NeoNode.where(graph_id: graph.id).map{|x| x.view_model},
                  state: graph.neostate.stats,
                  clock: graph.clock,
                  links: edges.map{|edge| {
                    source: edge.from_node,
                    target: edge.to_node
                  }}}


  end

  def create
    return render status: 403 unless current_user.present?

    graph = NeoGraph.create(title: graph_params[:name], user_id: current_user.id)
    state = NeoState.create
    NeoGS.create(from_node: graph, to_node: state)
    start_node = NeoNode.create(title: 'Start Node',
                                text: 'This is default start node',
                                kind: :start,
                                graph_id: graph.id,
                                fill: 'red')
    NeoFirst.create(from_node: graph, to_node: start_node)
    render json: {graph: {name: graph.title, id: graph.uuid}}
  end

  def update
    authorize graph
    graph.update!(graph_params)
    render json: graph
  end

  def destroy
    NeoGraph.find_by(uuid: params[:id]).destroy
    head :no_content
  end

  def validate
    authorize graph
    if %i[pending processing].include? graph.status.to_sym
      error = {
        type: :graph_locked,
        message: I18n.t("errors.graph.validation_#{graph.status}"),
        graph_status: graph.status
      }
      return handle_error error, :locked
    end
    validation_types = Array(params[:validation_types]).map(&:to_sym)
    validation_types = Graph::VALIDATION_TYPES if validation_types.blank?
    unless validation_types.to_set <= Graph::VALIDATION_TYPES.to_set
      unallowed_types = validation_types.to_set - Graph::VALIDATION_TYPES.to_set
      error = {
        type: :unallowed_types,
        message: I18n.t('errors.graph.unallowed_types'),
        unallowed_types: unallowed_types,
        allowed_types: Graph::VALIDATION_TYPES
      }
      return handle_error error, :bad_request
    end
    graph.pending_status!
    GraphValidationJob.perform_later graph, validation_types
    head :no_content
  end

  #TODO not implemented
  def reserve
    authorize graph
    render json: {message:"reserved"}

  end

  private

  def render_graph(**kwargs)
    render json: { graph: graph }, **kwargs
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def graph_params
    allowed_columns = %i[name state]
    disallowed_columns = Graph.column_names.map(&:to_sym) - allowed_columns
    # I cant permit :state because this is a hash/json object
    # so i must expect all unallowed columns
    params.require(:graph).except(*disallowed_columns).permit!
  end

  def graph
    @graph ||= current_user.graphs.find(params[:id])
  end


end
