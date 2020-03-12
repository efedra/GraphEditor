# frozen_string_literal: true

class Graph::Create < Graph::Base
  private

  def atom_perform
    @result = graphs.new(graph_params)
    @result.save!
    @status = :successfully_created
  end
end
