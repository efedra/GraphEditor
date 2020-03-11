# frozen_string_literal: true

class Edge::Update < Edge::Base
  private

  def perform
    @result = edge
    @result.assign_attributes(edge_params)
    @success = @result.save
    @error = @result.errors if fail?
  end
end
