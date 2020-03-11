# frozen_string_literal: true

class Graph::Update < Graph::Base
  private

  def perform
    @result = graph
    @result.assign_attributes(graph_params)
    @success = @result.save
    @error = @result.errors if fail?
  end
end
