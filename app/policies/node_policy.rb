# frozen_string_literal: true

class NodePolicy < GraphPolicy
  def index?
    %i[owner admin editor viewer].include? graph_user.role.to_sym
  end

  def create?
    %i[owner admin editor].include? graph_user.role.to_sym
  end

  def destroy?
    %i[owner admin editor].include? graph_user.role.to_sym
  end

  protected

  def graph
    @graph ||= record.is_a?(Graph) ? record : record&.graph
  end
end
