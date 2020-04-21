# frozen_string_literal: true

class GraphsUserPolicy < GraphPolicy
  class Scope < Scope
    def resolve
      scope.where.not(user: user)
    end
  end

  def index?
    %i[owner admin editor viewer].include? graph_user.role.to_sym
  end

  def create?
    graph_user.owner?
  end

  def update?
    graph_user.owner?
  end

  def destroy?
    true
  end

  def unsubscribe?
    %i[admin editor viewer].include? graph_user.role.to_sym
  end

  protected

  def graph_user
    @graph_user ||= record
  end
end
