# frozen_string_literal: true

class Edge::Create < Edge::Base
  private

  def perform
    @result = edges.new(edge_params)

    @success = @result.save
    @error = @result.errors if fail?
  end
end
