# frozen_string_literal: true

class GraphValidationJob < ApplicationJob
  queue_as :default

  def perform(graph)
    graph.processing_status!
    status = graph.valid?(:graph_structure) ? :valid : :invalid
    graph.update(status: status,
      validated_at: Time.zone.now,
      validation_errors: graph.errors)
  end
end
