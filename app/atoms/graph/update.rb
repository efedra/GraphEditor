# frozen_string_literal: true

class Graph::Update < Graph::Base
  private

  def atom_perform
    @result = graph
    @result.update!(graph_params)
    @status = :success
  end
end
