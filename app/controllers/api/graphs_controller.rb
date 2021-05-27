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
    state = {}

    edges = []
    while result.has_next?
      item = result.next[:d]
      nodes << item if item.labels.include? :NeoNode
      # state = item if item.labels.include? :NeoState
      # WARNING: Orc technologies.
      # extensively commented so  it makes at least some sense
      if item.labels.include? :NeoState
        tmp = item.properties[:stats]
        # that is a string. db gives us a butchered string instead of hash.
        # it looks like thi: "---\n:hp: 100\n:money: 66.6"
        tmparr = tmp.split("\n", -1)
        # we get arr, like this:  ["---", ":hp: 100", ":money: 66.6"]
        tmparr = tmparr.drop(1)# get first elem out of th way
        tmparr.pop
        res = "{"
        tmparr.each{|x| res += (x[1, x.length-1] + ", ")}
        #=> "{hp: 100, money: 66.6, " in res
        res = res[0, res.length-2]
        res+="}"
        statehash = eval(res)

        # same for inventory
        tmp = item.properties[:inventory]
        # that is a string. db gives us a butchered string instead of hash.
        # it looks like thi: "---\n:hp: 100\n:money: 66.6"
        tmparr = tmp.split("\n", -1)
        # we get arr, like this:  ["---", ":hp: 100", ":money: 66.6"]
        tmparr = tmparr.drop(1)# get first elem out of th way
        tmparr.pop
        res = "{"
        tmparr.each{|x| res += (x[1, x.length-1] + ", ")}
        #=> "{hp: 100, money: 66.6, " in res
        res = res[0, res.length-2]
        res+="}"
        invenhash = eval(res)

        # shove it all into the result

        final0 = item
        final0.properties[:stats] = statehash
        final0.properties[:inventory] = invenhash

        state = final0

      end

      # !!!!!!!!!!!!!!!!<EXCLAMATION MARK!>!!!!!!!!!!!!!!!!!!!!!!
      #
      item = result.next[:r]
      item.each do |it|
        if it.type == :NEO_EDGE


          # shove it all into the result

          final0 = it
          #if one needs to rename properties(start id to smth or smth else)
          # do it here

          edges << final0
        end
      end

      #       /\
      #       |
      #EDGES  |
      #
    end



    render json: {graph: graph, nodes: nodes, state: state, edges: edges}


  end

  def create
    return render status: 403 unless current_user.present?

    graph = NeoGraph.create(title: graph_params[:name], user_id: current_user.id)
    state = NeoState.create
    NeoGS.create(from_node: graph, to_node: state)

    render json: {graph: {name: graph.title}}
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
