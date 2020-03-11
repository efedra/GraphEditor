# frozen_string_literal: true

class Graph::Create < Graph::Base
  private

  def perform
    @result = graphs.new(graph_params)

    @success = @result.save
    @error = @result.errors if fail?
  end
end
