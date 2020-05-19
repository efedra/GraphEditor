# frozen_string_literal: true

class Api::GraphsController < Api::BaseController
  def index
    authorize Graph
    render json: current_user.graphs.all
    render json: Graph.all
  end

  def show
    authorize graph
    render_graph
  end

  def create
    authorize Graph
    @graph = current_user.graphs.create_simple!(graph_params)
    graph.graphs_users.create!(user: current_user)
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

  private

  def render_graph(**kwargs)
    render json: { graph: graph}, **kwargs
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def graph_params
    allowed_columns = %i[name state]
    disallowed_columns = Graph.column_names.map(&:to_sym) - allowed_columns
    # I cant permit :state becouse this is a hash/json object
    # so i must expect all unallowed columns
    params.require(:graph).except(*disallowed_columns).permit!
  end

  def graph
    @graph ||= current_user.graphs.find(params[:id])
  end
end
