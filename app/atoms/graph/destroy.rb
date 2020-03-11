# frozen_string_literal: true

class Graph::Destroy < Graph::Base
  private

  def perform
    graph.destroy
  end
end
