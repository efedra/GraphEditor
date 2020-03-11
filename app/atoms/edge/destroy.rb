# frozen_string_literal: true

class Edge::Destroy < Edge::Base
  private

  def perform
    edge.destroy
  end
end
