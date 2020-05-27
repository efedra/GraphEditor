# frozen_string_literal: true

class Api::MembersController < Api::BaseController
  def index
    authorize graph_user
    render json: policy_scope(graph.graphs_users).all
  end

  def show
    authorize graph_user
    render json: member
  end

  def create
    authorize graph_user
    @member = graph.graphs_users.new(member_params)
    @member.validate!(:sharing)
    member.save!
    render json: member, status: :created
  end

  def update
    authorize graph_user
    # TODO: move this to best place
    raise Pundit::NotAuthorizedError, 'not allowed to update owner' if member.role.to_sym == :owner
    member.assign_attributes(member_params.except(:user_id))
    member.validate!(:sharing)
    member.save!
    render json: member
  end

  def destroy
    authorize graph_user
    # TODO: move this to best place
    raise Pundit::NotAuthorizedError, 'not allowed to destroy owner' if member.role.to_sym == :owner
    member.destroy!
    head :no_content
  end

  def unsubscribe
    authorize graph_user
    graph_user.destroy!
    head :no_content
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def member_params
    params.require(:member).permit(:user_id, :role)
  end

  def member
    @member ||= policy_scope(graph.graphs_users).find(params[:id])
  end

  def graph_user
    @graph_user ||= current_user.graphs_users.find_by(graph: graph)
  end

  def graph
    @graph ||= current_user.graphs.find(params[:graph_id])
  end
end
