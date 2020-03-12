# frozen_string_literal: true

class Graph::Destroy < Graph::Base
  private

  def atom_perform
    graph.destroy
    @status = :successfully_destoyed
  end
end
