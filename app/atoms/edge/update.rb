# frozen_string_literal: true

class Edge::Update < Edge::Base
  private

  def atom_perform
    @result = edge
    @result.update!(edge_params)
    @status = :success
  end
end
