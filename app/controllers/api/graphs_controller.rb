# frozen_string_literal: true

class Api::GraphsController < Api::BaseController
  def index
    authorize Graph
    render json: {graphs: current_user.graphs.all, userId: current_user.id}
  end

  def show
    #authorize graph
    #render_graph

    graph = NeoGraph.find_by(uuid: params[:id])
    result = ActiveGraph::Base.query("MATCH (n)-[r*]->(d) WHERE n.uuid = '#{params[:id]}' RETURN r, d")
    nodes = []
    state = {}
    while result.has_next?
      item = result.next[:d]
      nodes << item if item.labels.include? :NeoNode
      state = item if item.labels.include? :NeoState
    end
    #TODO fix json in state
    render json: {graph: graph, nodes: nodes, state: state}
  end

  def create
    authorize Graph
    start_node = Node.new(name: 'start',
                          text: 'Старт!',
                          kind: Node::KIND_START,
                          html_x: 100,
                          html_y: 100)
    end_node = Node.new(name: 'end',
                         text: 'Победа!',
                         kind: Node::KIND_END,
                         html_x: 200,
                         html_y: 100)
    graph = Graph.create!(name: graph_params[:name],
                          users: [current_user],
                          nodes: [start_node, end_node]
                         )
    graph.edges.create

    graph.save
    render_graph status: :created
  end

  def update
    authorize graph
    graph.update!(graph_params)
    render json: graph
  end

  def destroy
    authorize graph
    graph.destroy!
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
