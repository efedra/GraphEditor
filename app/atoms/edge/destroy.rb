# frozen_string_literal: true

class Edge::Destroy < Edge::Base
  private

  def atom_perform
    edge.destroy
    @status = :successfully_destoyed
  end
end
