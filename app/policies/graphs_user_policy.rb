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
    %i[owner admin].include? graph_user.role.to_sym
  end

  def update?
    %i[owner admin].include? graph_user.role.to_sym
  end

  def destroy?
    %i[owner admin].include? graph_user.role.to_sym
  end

  def unsubscribe?
    %i[admin editor viewer].include? graph_user.role.to_sym
  end

  protected

  def graph_user
    @graph_user ||= record
  end
end
