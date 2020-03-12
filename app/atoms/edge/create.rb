# frozen_string_literal: true

class Edge::Create < Edge::Base
  private

  def atom_perform
    @result = edges.new(edge_params)
    @result.save!
    @status = :successfully_created
  end
end
