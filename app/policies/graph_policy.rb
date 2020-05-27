# frozen_string_literal: true

class GraphPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    %i[owner admin editor viewer].include? graph_user.role.to_sym
  end

  def create?
    true
  end

  def update?
    %i[owner admin editor].include? graph_user.role.to_sym
  end

  def destroy?
    graph_user.owner?
  end

  def validate?
    %i[owner admin editor].include? graph_user.role.to_sym
  end

  protected

  def graph
    @graph ||= record
  end

  def graph_user
    @graph_user ||= graph.graphs_users.find_by(user: user)
  end
end
