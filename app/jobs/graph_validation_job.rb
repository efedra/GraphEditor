# frozen_string_literal: true

class GraphValidationJob < ApplicationJob
  queue_as :default

  def perform(graph, validation_types)
    graph.processing_status!
    graph.clear_validation_info
    status = graph.valid?(validation_types) ? :valid : :invalid
    graph.update(status: status,
      validated_at: Time.zone.now,
      validation_errors: graph.errors)
  end
end
